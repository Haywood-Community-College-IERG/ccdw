import sys
import yaml
import urllib
import pyodbc
import pandas as pd
import numpy as np
import os
import shutil
from os import path
from string import Template
import sqlalchemy
from sqlalchemy import exc

with open("config.yml","r") as ymlfile:
    export_cfg = yaml.load(ymlfile)

# executeSQL_INSERT - attempts to create SQL code from csv files and push it to the SQL server
def executeSQL_INSERT(engine, inputFrame, sqlName, dTyper, log):
    
    #attempt to push a blank data frame in order to make sure the table exists on the server
    blankFrame = pd.DataFrame(columns=inputFrame.columns)
    try:
        blankFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema'], if_exists='fail',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)
    except ValueError as er:
        pass
    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print ("-Error Creating Table ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise

    print('_______________________________________________________________________')
    #create SQL string and read matching Table on the server
    sqlStrings = "SELECT * FROM {0}.{1}".format(export_cfg['sql']['schema'],sqlName)
    sqlRead = pd.read_sql(sqlStrings, engine)
    print('--Diff:')
    #attemp to create a dataframe and string of columns that need to be added to SQL Server
    try:
        updateList = list(set(list(sqlRead)).symmetric_difference(set(list(inputFrame))))
        updateFrame = pd.DataFrame(columns=updateList)
        updateColumns= list(updateFrame.columns)
        updateColumns1 = ',\n\t'.join("{0} {1}".format(c,dTyper[c]) for c in reversed(updateColumns))
    except:
        print('ERROR!!!!')
    print(updateColumns1)
    
    #create SQL File based on tempalte to ALTER current SQL Table and append new Columns
    flds = {'TableSchema'          : 'input', 
        'TableName'            : sqlName,
        'updateColumns'         : updateColumns1
        }
    filein = open(export_cfg['sql']['add_Columns'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)
    print('_______________________________________________________________________')
    
    #if there are added Columns attempt to push them to the SQL Table
    try:
        if(updateColumns):
            engine.execute(result)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print ("-Error Updating Columns in SQL Table - ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise

    #Attempt to push the new data to the existing SQL Table.
    try:
        print(".creating SQL from inputFrame")
        inputFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema'], if_exists='append',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print ("-creating SQL from inputFrame - skippeSd SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise
    

# executeSQL_MERGE - Creates SQL Code based on current Table/Dataframe by using a Template then pushes to History
def executeSQL_MERGE(engine, inputFrame, sqlName, dTyper,kLister, log):
    # Create and push a blankFrame with no data to SQL Database for History Tables
    blankFrame = pd.DataFrame(columns=inputFrame.columns)
    del blankFrame['DataDatetime']

    # Add three History columns to blankFrame
    # Add three History column types to dTyper
    blankFrame['EffectiveDatetime'] = ""
    blankFrame['ExpirationDatetime'] = ""
    blankFrame['CurrentFlag'] = ""

    blankTyper = dTyper
    blankTyper['EffectiveDatetime'] = sqlalchemy.types.DateTime()
    blankTyper['ExpirationDatetime'] = sqlalchemy.types.DateTime()
    blankTyper['CurrentFlag'] = sqlalchemy.types.String(1)
    blankFrame.to_sql(sqlName+"_History", engine, flavor=None, schema=export_cfg['sql']['schema'], if_exists='append',
                         index=False, index_label=None, chunksize=None, dtype=blankTyper)

    print("..wrote to table")
    #print("PRESS ENTER TO CONTINUE.")
    #wait = input()

    # Create String to pass to Template file to generate SQL Code
    TableKeys= list(kLister.keys()) 
    TableColumns= list(inputFrame.columns) 
    TableColumns.remove('DataDatetime') 
    
    # We are treating all non-key columns as Type 2 SCD at this time (20170721)
    TableColumns2= TableColumns 
    TableDefaultDate = min(inputFrame['DataDatetime'])

    flds = {'TableSchema'          : 'input', 
            'TableName'            : sqlName,
            'TableKeys'            : ', '.join("[{0}]".format(k) for k in TableKeys),
            'TableColumns'         : ', '.join("[{0}]".format(c) for c in TableColumns),
            'TableKeys_CMP'        : ' AND '.join("DEST.[{0}] = SRC.[{0}]".format(k) for k in TableKeys),
            'TableKeys_SRC'        : ', '.join("SRC.[{0}]".format(k) for k in TableKeys),
            'TableColumns_SRC'     : ', '.join("SRC.[{0}]".format(c) for c in TableColumns),
            'TableColumns1_SRC'    : ', '.join([]),
            'TableColumns1_DEST'   : ', '.join([]),
            'TableColumns1_UPDATE' : ', '.join([]),
            'TableColumns2_SRC'    : ', '.join("SRC.[{0}]".format(c) for c in TableColumns2),
            'TableColumns2_DEST'   : ', '.join("DEST.[{0}]".format(c) for c in TableColumns2),
            'TableDefaultDate'     : TableDefaultDate
            }
    filein = open(export_cfg['sql']['merge_scd2'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)

    # Attempt to execute generated SQL MERGE code
    try:
        print("...executing sql command")
        rtn = engine.execute(result)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError, pyodbc.Error, pyodbc.ProgrammingError) as er:
        print ("---executing sql command - skipped SQL ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise

    # Deletes Tables from SQL Database if coppied to the history table
    try:
       print("...executing delete command")
       rtn = engine.execute("DELETE FROM [{0}].[{1}]\n\nCOMMIT".format(export_cfg['sql']['schema'],sqlName))

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError, pyodbc.Error, pyodbc.ProgrammingError) as er:
        print ("---executing DELETE command - skipped SQL ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise
    print('....wrote to history')


# executeSQL_UPDATE - calls both executeSQL_INSERT and executeSQL_MERGE in attempt to update the SQL Tables 
def executeSQL_UPDATE(engine, inputFrame, sqlName, dTyper, kLister, log):
    try:
        executeSQL_INSERT(engine, inputFrame, sqlName, dTyper, log)
    except:
        print('XXXXXXX failed on executeSQL_INSERT XXXXXXX')
        raise
    try:
        executeSQL_MERGE(engine, inputFrame, sqlName, dTyper, kLister, log)
        pass
    except:
        print('XXXXXXX failed on executeSQL_MERGE XXXXXXX')
        raise


# ig_f - Used to find files to be ignored when copying the dir tree
def ig_f(dir, files):
    return [f for f in files if os.path.isfile(os.path.join(dir, f))]


# archive - Archives files after they are processed
def archive(head, file, exportPath, archivePath):
    if not os.path.isdir(os.path.join(archivePath, head)):
        shutil.copytree(os.path.join(exportPath, head),os.path.join(archivePath,head), ignore=ig_f)
    if not os.path.isfile(os.path.join(archivePath, head, file)):
        shutil.move(os.path.join(exportPath, head, file), os.path.join(archivePath, head, file))


# engine - creates an engine to be used to interact with the SQL Server
def engine(driver,server,db,schema):
    conn_details =  """
      DRIVER={{{0}}};SERVER={1};DATABASE={2};SCHEMA={3};Trusted_Connection=Yes;
    """.format( driver, 
                server,
                db,
                schema)

    params = urllib.parse.quote_plus(conn_details)

    engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)
    return engine



def sendEmail(emailFrom, emailTo, emailSubject, file):
    # Import smtplib for the actual sending function
    import smtplib

    # Import the email modules we'll need
    from email.mime.text import MIMEText

    # Open a plain text file for reading.  For this example, assume that
    # the text file contains only ASCII characters.
    with open(file, 'rb') as fp:
        # Create a text/plain message
        msg = MIMEText(fp.read())

    # me == the sender's email address
    # you == the recipient's email address
    msg['Subject'] = 'The contents of %s' % file
    msg['From'] = emailFrom
    msg['To'] = emailTo

    # Send the message via our own SMTP server, but don't include the
    # envelope header.
    s = smtplib.SMTP('localhost')
    s.sendmail(me, [you], msg.as_string())
    s.quit()