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
import zipfile
import re
import smtplib
from email.header    import Header
from email.mime.text import MIMEText
from getpass         import getpass
import ssl
global newColumnCheck

with open("config.yml","r") as ymlfile:
    export_cfg = yaml.load(ymlfile)

# executeSQL_INSERT() - attempts to create SQL code from csv files and push it to the SQL server
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

    #Attempt to push the new data to the existing SQL Table.
    executeSQLAppend(engine, blankFrame, sqlName, dTyper, log, export_cfg['sql']['schema'])
    try:
        print(".creating SQL from inputFrame")
        inputFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema'], if_exists='append',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print (".creating SQL from inputFrame - skippeSd SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        # log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        sys.stdout.flush()
        log.write("Error in File: \t %s \n\n Error: %s \n DataTypes: %s \n\n\n" % (sqlName,er, dTyper))
        sys.stdout.flush()
        raise
    

# executeSQL_MERGE() - Creates SQL Code based on current Table/Dataframe by using a Template then pushes to History
def executeSQL_MERGE(engine, inputFrame, sqlName, dTyper,kLister, aTypes, aNames, typers, log):
    # Create String to pass to Template file to generate SQL Code
    TableKeys= list(kLister.keys()) 
    
    # Create and push a blankFrame with no data to SQL Database for History Tables
    blankFrame = pd.DataFrame(columns=inputFrame.columns)
    del blankFrame['DataDatetime']

    TableColumns= list(blankFrame.columns) 
    
    # Add three History columns to blankFrame
    blankFrame['EffectiveDatetime'] = ""
    blankFrame['ExpirationDatetime'] = ""
    blankFrame['CurrentFlag'] = ""
    
    # Add three History column types to dTyper
    blankTyper = dTyper
    blankTyper['EffectiveDatetime'] = sqlalchemy.types.DateTime()
    blankTyper['ExpirationDatetime'] = sqlalchemy.types.DateTime()
    blankTyper['CurrentFlag'] = sqlalchemy.types.String(1)

    viewColumns= list(blankFrame.columns) 
    
     # We are treating all non-key columns as Type 2 SCD at this time (20170721)
    TableColumns2= TableColumns 
    TableDefaultDate = min(inputFrame['DataDatetime'])
    
    flds = {'TableSchema_SRC'      : export_cfg['sql']['schema'], 
            'TableSchema_DEST'     : export_cfg['sql']['schema_history'],
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
            'TableDefaultDate'     : TableDefaultDate,
            'viewSchema'           : export_cfg['sql']['schema_history'],
            'viewName'             : sqlName + '_Current',
            'viewName2'            : sqlName + '_test',
            'pkName'               : 'pk_' + sqlName,
            'primaryKeys'          : ', '.join("[{0}]".format(c) for c in kLister),
            'viewColumns'          : ', '.join("[{0}]".format(c) for c in viewColumns)
    }
    
    filein = open(export_cfg['sql']['create_view'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)
    fileinKeys = open(export_cfg['sql']['create_keys'],"r")
    srcKeys = Template( fileinKeys.read() )
    resultKeys = srcKeys.substitute(flds)
    #code for first time creation of history table only
    for num in range(1):
        try:
            blankFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema_history'], if_exists='fail',
                             index=False, index_label=None, chunksize=None, dtype=blankTyper)
        except:
            print('--History created skipping key and view creation--')
            break
        else:
            #if it is the first time the history table is created then create a view as well
            try:
                print('--Creating History Keys')
                #set keys to not null
                for i in kLister:
                    if type(dTyper[i]) == sqlalchemy.sql.sqltypes.String:
                        data = 'VARCHAR(%s)' % dTyper[i].length
                    elif type(dTyper[i]) == sqlalchemy.sql.sqltypes.Numeric:
                        data = 'NUMERIC'
                    elif type(dTyper[i]) == sqlalchemy.sql.sqltypes.Date:
                        data = 'DATE'
                    notNull = 'ALTER TABLE {0}.{1}\n ALTER COLUMN [{2}] {3} NOT NULL'.format(export_cfg['sql']['schema_history'],sqlName,i,data)
                    engine.execute(notNull)
                notNull = 'ALTER TABLE {0}.{1}\n ALTER COLUMN [{2}] {3} NOT NULL'.format(export_cfg['sql']['schema_history'],sqlName,'EffectiveDatetime','DATETIME')
                engine.execute(notNull)
                #create keys for history table
                engine.execute(resultKeys)
            except:
                print ("-Error Creating History Keys for SQL Table" )
                print(notNull)
                print(resultKeys)
                raise
            try:
                dropView = 'DROP VIEW IF EXISTS %s' % (flds['viewName'])
                print('--Creating History View')
                #drop sql view if exits
                engine.execute(dropView)
                #create new sql view
                engine.execute(result)
            except:
                print ("-Error Creating View of SQL Table" )
                print(dropView)
                print(result)
                raise
            try:
                # !!!!
                # !!!! This does not work on subsequent tables after a fail
                # !!!! DMO 2017-08-30 Should be fixed now, was deleting from global value

                print('trying this')
                print(aNames)
                s = set( val for dic in [aNames] for val in dic.values())
                print(s)
                for x in s: 
                    str1 = ''
                    str2 = ''
                    str3 = ''
                    counter = 0
                    print(counter)
                    for i, k in enumerate(list(aNames)):
                        print(x)
                        print(aNames[k])
                        if(aNames[k] == x):
                            # associationGroup = aNames[]
                            str1 += '\n, CAST(LTRIM(RTRIM(CA{0}.Item)) AS {1}) AS [{2}]'.format(counter+1,typers[k],k)
                            print(str1)
                            str2 += '\n CROSS APPLY dbo.DelimitedSplit8K([{0}],\', \') CA{1}'.format(k,counter+1)
                            print(str2)
                            print(counter)
                            print(aTypes[k])

                            if(counter+1 >= 2):
                                #if(counter+1 > 2):
                                # Need to move AND to follow
                                str3 += '\nCA1.ItemNumber=CA{0}.ItemNumber AND'.format(counter+1)
                                # str3 += '\nAND CA1.ItemNumber=CA{0}.ItemNumber'.format(counter+1)

                            # If single MV is not a key, need to force it to be one
                            if(aTypes[k] == 'K'):
                                associationKey = k
                                view_Name = aNames[k]
                                print(view_Name,k,associationKey)
                            print("yeah")
                            counter += 1

                    flds2 = {
                            'TableName'            : sqlName,
                            'viewSchema'           : export_cfg['sql']['schema_history'],
                            'viewName2'            : view_Name.replace('.', '_'),
                            'primaryKeys'          : ', '.join("[{0}]".format(c) for c in kLister),
                            'str1'                 : str1,
                            'str2'                 : str2,
                            'str3'                 : str3,
                            'associationKeys'      : associationKey
                    }
                    print(flds2)
                    filein2 = open(export_cfg['sql']['create_view2'],"r")
                    src2 = Template( filein2.read() )
                    result2 = src2.substitute(flds2)
                    print(result2)
                    dropView = 'DROP VIEW IF EXISTS %s' % (flds2['viewName2'])
                    print('--Creating History View2')
                    #drop sql view if exits
                    engine.execute(dropView)
                    engine.execute(result2)
            except:
                print('fail')
                input()
    try:
        print("..creating History Table")
        blankFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema_history'], if_exists='append',
                         index=False, index_label=None, chunksize=None, dtype=blankTyper)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print ("-creating SQL from inputFrame - skippeSd SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n DataTypes: %s \n\n\n" % (sqlName,er, dTyper))
        raise

    print("..wrote to table")

    #Attempt to push the Column data to the existing SQL Table if there are new Columns to be added.
    try:
        executeSQLAppend(engine, blankFrame, sqlName, dTyper, log, export_cfg['sql']['schema_history'])
    except:
        print('append didnt work')
        raise
    #print("PRESS ENTER TO CONTINUE.")
    #wait = input()

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


# executeSQL_UPDATE() - calls both executeSQL_INSERT and executeSQL_MERGE in attempt to update the SQL Tables 
def executeSQL_UPDATE(engine, inputFrame, sqlName, dTyper, kLister, aTypes, aNames, typers, log):
    try:
        executeSQL_INSERT(engine, inputFrame, sqlName, dTyper, log)
    except:
        print('XXXXXXX failed on executeSQL_INSERT XXXXXXX')
        raise
    try:
        executeSQL_MERGE(engine, inputFrame, sqlName, dTyper, kLister, aTypes, aNames, typers, log)
        pass
    except:
        print('XXXXXXX failed on executeSQL_MERGE XXXXXXX')
        raise


# ig_f() - Used to find files to be ignored when copying the dir tree
def ig_f(dir, files):
    return [f for f in files if os.path.isfile(os.path.join(dir, f))]


# archive() - Archives files after they are processed
def archive(head, file, exportPath, archivePath):
    # Create the path in the archive based on the location of the CSV
    if not os.path.isdir(os.path.join(archivePath, head)):
        shutil.copytree(os.path.join(exportPath, head),os.path.join(archivePath,head), ignore=ig_f)

    if not os.path.isfile(os.path.join(archivePath, head, file)):
        try:
            # Create a zip'd version of the CSV
            zFi = zipfile.ZipFile(os.path.join(exportPath,head,(file[:-4]+'.zip')), 'w', zipfile.ZIP_DEFLATED)
            zFi.write(os.path.join(exportPath, head, file), file)
            zFi.close()

            # Move the zip file to the archive location
            shutil.move(os.path.join(exportPath, head, (file[:-4]+'.zip')), os.path.join(archivePath, head, (file[:-4]+'.zip')))

            # Remove the CSV file from the export folder
            os.remove(os.path.join(exportPath, head, file)) # comment this out if you want to keep files
        except:
            raise
        # shutil.move(os.path.join(exportPath, head, file), os.path.join(archivePath, head, file))



# engine() - creates an engine to be used to interact with the SQL Server
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



# sendEmail() - Is used to send Log files to an email of choice with a custom message
def sendEmail(emailFrom, emailTo, emailSubject, file):
    login, password = emailFrom, getpass('Gmail password:') # 'persiden.smith@gmail.com', 'mqknmbbjsqzzjhyj' #
    recipients = [emailTo]

    # create message
    with open(file) as fp:     
        msg = MIMEText(fp.read(),'plain','utf-8')
    # msg = MIMEText('message body…', 'plain', 'utf-8')
    msg['Subject'] = Header(emailSubject, 'utf-8')
    msg['From'] = login
    msg['To'] = ", ".join(recipients)

    # send it via gmail
    # s = SMTP_SSL('webmail.haywood.edu', 443, timeout=100)
    s =  smtplib.SMTP('smtp.office365.com', 587)
    # s = SMTP_SSL('smtp.gmail.com', 465, timeout=10)
    s.set_debuglevel(1)
    try:
        context = ssl.create_default_context()
        s.starttls(context)
        s.login(login, password)
        s.sendmail(msg['From'], recipients, msg.as_string())
    except smtplib.SMTPHeloError:
        print('this didnt work')
    finally:
        s.quit()



# executeSQLAppend() - Attempts to execute an Append statement to the SQL Database with new Columns
def executeSQLAppend(engine, inputFrame, sqlName, dTyper, log, schema):
    TableColumns= list(inputFrame.columns) 
    newColumnCheck = False
    print('_______________________________________________________________________')
    #create SQL string and read matching Table on the server
    sqlStrings = "SELECT * FROM {0}.{1}".format(schema,sqlName)
    sqlRead = pd.read_sql(sqlStrings, engine)
    print('--Diff:')
    #attemp to create a dataframe and string of columns that need to be added to SQL Server
    try:
        updateList = list(set(list(sqlRead)).symmetric_difference(set(list(inputFrame))))
        updateFrame = pd.DataFrame(columns=updateList)
        updateColumns= list(updateFrame.columns)
        updateColumns1 = ',\n\t'.join("[{0}] {1}".format(c,dTyper[c]) for c in reversed(updateColumns))
    except:
        print('ERROR!!!!')
    print(updateColumns1)
    
    #create SQL File based on tempalte to ALTER current SQL Table and append new Columns
    flds = {'TableSchema'          : schema, 
            'TableName'            : sqlName,
            'TableColumns'         : ', '.join("[{0}]".format(c) for c in TableColumns),
            'updateColumns'        : updateColumns1,
            'viewName'             : sqlName + '_Current',
            'viewSchema'           : export_cfg['sql']['schema_history']
        }
    filein = open(export_cfg['sql']['add_Columns'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)
    print('_______________________________________________________________________')
    
    #if there are added Columns attempt to push them to the SQL Table
    try:
        if(updateColumns):
            engine.execute(result)
            newColumnCheck = True

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        print ("-Error Updating Columns in SQL Table - ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
        raise
    if (updateColumns):
        filein = open(export_cfg['sql']['create_view'],"r")
        src = Template( filein.read() )
        result = src.substitute(flds)
        dropView = 'DROP VIEW IF EXISTS %s' % (flds['viewName'])
        try:
            print('----Creating Current View')
            #drop sql view if exits
            engine.execute(dropView)
            #create new sql view
            engine.execute(result)

        except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
            print ("-Error Creating View of SQL Table - ["+str(er.args[0])+"]" )
            log.write("Error in Table: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
            raise

# numericalSort() - Is used to properly sort files based on numbers correctly
def numericalSort(value):
    numbers = re.compile(r'(\d+)')
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts
