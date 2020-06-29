import sys
import yaml
import urllib
import pyodbc
import pandas as pd
import numpy as np
import os
import shutil
from os import path
import glob
from string import Template
import sqlalchemy
from sqlalchemy import exc
import zipfile
import re
#import smtplib
#from email.header    import Header
#from email.mime.text import MIMEText
#from getpass         import getpass
#import ssl
import numpy as np
from loguru import logger

import functools
print = functools.partial(print, flush=True)

global newColumnCheck
global cfg
global error_path

import config
cfg = config.cfg

#with open("config.yml","r") as ymlfile:
#    cfg = yaml.load(ymlfile)

sql_schema = cfg['sql']['schema']
sql_schema_history = cfg['sql']['schema_history']

# executeSQL_INSERT() - attempts to create SQL code from csv files and push it to the SQL server
# @ logger.catch
def executeSQL_INSERT(engine, df, sqlName, dTyper, typers):
    
    try:
        logger.debug( "Create blank dataframe to create SQL table {0}".format( sqlName ) )    

        #attempt to push a blank data frame in order to make sure the table exists on the server
        blankFrame = pd.DataFrame(columns=df.columns)
    except:
        logger.exception("Error creating blankFrame: ",sys.exc_info()[0])
        raise

    try:
        logger.debug( "Push blank dataframe to SQL table {0}".format( sqlName ) )    

        blankFrame.to_sql(sqlName, engine, schema=sql_schema, if_exists='fail',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)
    except ValueError as er:
        # TODO: Add code to check for any errors other than the table exists and raise those.
        logger.error("ValueError: Either the table {0}.{1} already exists or another error occured [{2}]".format(sql_schema,sqlName,er))
        pass
    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        logger.exception("Error in File: \t %s \n\n Error: %s \n\n" % (sqlName,er))
        raise

    try:
        logger.debug("Fix all non-string columns, replace blanks with NAs which become NULLs in DB, and remove commas")

        nonstring_columns = [key for key, value in dTyper.items() if type(dTyper[key]) != sqlalchemy.sql.sqltypes.String]
        df[nonstring_columns] = df[nonstring_columns].replace({'':np.nan, ',':''}, regex=True) # 2018-06-18 C DMO
    except:
        logger.exception("Unknown error while converting numeric columns ",sys.exc_info()[0]) # 2019-12-13 C DMO
        raise

    #Attempt to push the new data to the existing SQL Table.
    try:
        logger.debug( "Push {0} data to SQL schema {1}".format( sqlName, sql_schema ) )

        executeSQLAppend(engine, blankFrame, sqlName, dTyper, sql_schema)
    except:
        logger.exception("Unknown error in executeSQLAppend: ",sys.exc_info()[0])
        #logger.exception("Writing SQL and CSV to %s\n" % (error_path))
        #ef = open('%sMergeError_%s.sql' % (error_path,sqlName), 'w')
        #ef.write(result)
        #ef.close()
        #df.to_csv( os.path.join(error_path, 'MergeError_%s.csv' % (sqlName)), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        df.to_csv( 'MergeError_%s.csv' % (sqlName), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        raise
#        pass

    try:
        logger.debug("Make sure input table is empty")
        rtn = engine.execute(f"DELETE FROM [{sql_schema}].[{sqlName}]\n\nCOMMIT")
    except:
        logger.exception("Unknown error while converting numeric columns ",sys.exc_info()[0]) # 2019-12-13 C DMO
        raise

    try:
        logger.debug(".creating SQL from df")

        df.to_sql(sqlName, engine, schema=sql_schema, if_exists='append',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        logger.debug(".creating SQL from df - skipped SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        logger.exception("Error in File: \t %s \n\n Error: %s \n DataTypes: %s \n\n" % (sqlName,er, dTyper))
        #logger.exception("Writing CSV to %s\n" % (error_path))
        #df.to_csv( os.path.join(error_path, 'MergeError_%s.csv' % (sqlName)), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        df.to_csv( 'InsertError_%s.csv' % (sqlName), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        raise
    except:
        logger.exception("Unknown error in executeSQL_INSERT: ",sys.exc_info()[0])
        #logger.exception("Writing CSV to %s\n" % (error_path))
        #df.to_csv( os.path.join(error_path, 'MergeError_%s.csv' % (sqlName)), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        df.to_csv( 'InsertError_%s.csv' % (sqlName), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        raise    

# executeSQL_MERGE() - Creates SQL Code based on current Table/Dataframe by using a Template then pushes to History
# @ logger.catch
def executeSQL_MERGE(engine, df, sqlName, dTyper,kLister, aTypes, aNames, typers):
    # Create String to pass to Template file to generate SQL Code
    TableKeys= list(kLister.keys()) 

    logger.debug( "Create blank dataframe for output\n" )    

    # Create and push a blankFrame with no data to SQL Database for History Tables
    blankFrame = pd.DataFrame(columns=df.columns)
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
    TableDefaultDate = min(df['DataDatetime'])
    
    flds = {'TableSchema_SRC'      : sql_schema, 
            'TableSchema_DEST'     : sql_schema_history,
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
            'viewSchema'           : sql_schema_history,
            'viewName'             : sqlName + '_Current',
            'viewName2'            : sqlName + '_test',
            'pkName'               : 'pk_' + sqlName,
            'primaryKeys'          : ', '.join("[{0}]".format(c) for c in kLister),
            'viewColumns'          : ', '.join("[{0}]".format(c) for c in viewColumns)
    }
    
    filein = open(cfg['sql']['create_view'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)
    fileinKeys = open(cfg['sql']['create_keys'],"r")
    srcKeys = Template( fileinKeys.read() )
    resultKeys = srcKeys.substitute(flds)

    #code for first time creation of history table only
    for num in range(1):
        try:
            blankFrame.to_sql(sqlName, engine, schema=sql_schema_history, if_exists='fail',
                             index=False, index_label=None, chunksize=None, dtype=blankTyper)

        except:
            logger.debug('--History created skipping key and view creation--')
            break

        else:
            #if it is the first time the history table is created then create a view as well
            try:
                logger.debug('--Creating History Keys')
                #set keys to not null
                for i in kLister:
                    if type(dTyper[i]) == sqlalchemy.sql.sqltypes.String:
                        data = 'VARCHAR(%s)' % dTyper[i].length
                    elif type(dTyper[i]) == sqlalchemy.sql.sqltypes.Numeric:
                        data = 'NUMERIC'
                    elif type(dTyper[i]) == sqlalchemy.sql.sqltypes.Date:
                        data = 'DATE'

                    notNull = 'ALTER TABLE {0}.{1}\n ALTER COLUMN [{2}] {3} NOT NULL; COMMIT'.format(sql_schema_history,sqlName,i,data)
                    logger.trace(f"notNull: {notNull}")
                    engine.execute(notNull)

                notNull = 'ALTER TABLE {0}.{1}\n ALTER COLUMN [{2}] {3} NOT NULL; COMMIT'.format(sql_schema_history,sqlName,'EffectiveDatetime','DATETIME')
                logger.trace(f"notNull: {notNull}")
                engine.execute(notNull)
                #create keys for history table
                logger.trace(f"resultKeys: {resultKeys}")
                engine.execute(resultKeys)

            except:
                logger.debug("-Error Creating History Keys for SQL Table" )
                logger.debug(notNull)
                logger.debug(resultKeys)
                raise


            try:
                dropView = 'DROP VIEW IF EXISTS {0}.{1}'.format(sql_schema_history, flds['viewName'])
                logger.debug('--Creating History View {0}.{1} (dropping if exists)'.format(sql_schema_history, flds['viewName']))
                #drop sql view if exits
                logger.trace(f"dropView: {dropView}")
                engine.execute(dropView)

                logger.debug("View {0}.{1} DDL:".format(sql_schema_history, flds['viewName']))
                logger.debug(result)

                #create new sql view
                logger.trace(f"result: {result}")
                engine.execute(result)

            except:
                logger.exception ("-Error Creating View of SQL Table" )
                logger.debug(dropView)
                logger.debug(result)
                raise


            try:
                # !!!!
                # !!!! This does not work on subsequent tables after a fail
                # !!!! DMO 2017-08-30 Should be fixed now, was deleting from global value

                s = set( val for dic in [aNames] for val in dic.values())
                for x in s: 
                    logger.debug("Processing association {0}".format(x))
                    associationKey = ''
                    lastelement = ''
                    str1 = ''
                    str2 = ''
                    str3 = ''
                    counter = 0

                    for i, k in enumerate(list(aNames)):
                        if (aNames[k] == x):
                            logger.debug("Found element of association: {0}".format(k))
                            counter += 1

                            # associationGroup = aNames[]
                            str1 += '\n, CAST(LTRIM(RTRIM(CA{0}.Item)) AS {1}) AS [{2}]'.format(counter, typers[k], k)
                            str2 += '\n CROSS APPLY dbo.DelimitedSplit8K([{0}],\', \') CA{1}'.format(k, counter)

                            if(counter > 1):
                                logger.debug("Counter > 1, adding comparison of 1 and {0}".format(counter))
                                str3 += 'AND CA1.ItemNumber=CA{0}.ItemNumber\n'.format(counter)

                            # If single MV is not a key, need to force it to be one
                            lastelement = k

                            if (aTypes[k] == 'K'):
                                associationKey = k
                                view_Name = aNames[k]
                                logger.debug("Add key {0} to association {1}".format(k, view_Name.replace('.', '_')))

                    if (associationKey == ''):
                        if (lastelement != ''):
                            associationKey = lastelement
                            view_Name = aNames[associationKey]
                            logger.debug("Setting associationKey to {0} for association {1}".format(lastelement, view_Name.replace('.', '_')))

                        else:
                            logger.debug("No associationKey to set for association {1}".format(x))
                            raise(AssertionError)

                    flds2 = {
                            'TableName'            : sqlName,
                            'viewSchema'           : sql_schema_history,
                            'viewName2'            : view_Name.replace('.', '_'),
                            'primaryKeys'          : ', '.join("[{0}]".format(c) for c in kLister),
                            'str1'                 : str1,
                            'str2'                 : str2,
                            'str3'                 : str3,
                            'associationKeys'      : associationKey
                    }

                    filein2 = open(cfg['sql']['create_view2'],"r")
                    src2 = Template( filein2.read() )
                    result2 = src2.substitute(flds2)

                    logger.debug("View {0} DDL:".format(view_Name.replace('.', '_')))
                    logger.debug(result2)

                    dropView = 'DROP VIEW IF EXISTS {0}.{1}'.format(sql_schema_history, view_Name.replace('.', '_'))
                    logger.debug('--Creating History View2 {0}.{1} (dropping if exists)'.format(sql_schema_history, view_Name.replace('.', '_')))
                    #drop sql view if exits
                    logger.trace(f"dropView: {dropView}")
                    engine.execute(dropView)
                    logger.trace(f"result2: {result2}")
                    engine.execute(result2)

            except:
                logger.exception('Creating View2 failed')
                raise
                break

    try:
        logger.debug("..creating History Table")
        blankFrame.to_sql(sqlName, engine, schema=sql_schema_history, if_exists='append',
                         index=False, index_label=None, chunksize=None, dtype=blankTyper)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        logger.error ("-creating SQL from df - skippeSd SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        logger.exception("Error in File: \t %s \n\n Error: %s \n DataTypes: %s \n\n" % (sqlName, er, dTyper))
        raise

    logger.debug("..wrote to table")

    #Attempt to push the Column data to the existing SQL Table if there are new Columns to be added.
    try:
        executeSQLAppend(engine, blankFrame, sqlName, dTyper, sql_schema_history)
    except:
        logger.exception('append didnt work')
        raise

    filein = open(cfg['sql']['merge_scd2'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)

    # Attempt to execute generated SQL MERGE code
    try:
        logger.debug("...executing sql command")
        logger.trace(f"result: {result}")
        rtn = engine.execute(result)

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError, pyodbc.Error, pyodbc.ProgrammingError) as er:
        logger.error("---executing sql command - skipped SQL ERROR ["+str(er.args[0])+"]" )
        logger.exception("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName, er))
        ef = open('MergeError_%s.sql' % (sqlName), 'w')
        ef.write(result)
        ef.close()
        df.to_csv( 'MergeError_%s.csv' % (sqlName), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )
        raise

    # Deletes Tables from SQL Database if coppied to the history table
    try:
       logger.debug("...executing delete command")
       logger.trace("DELETE FROM [{0}].[{1}]\n\nCOMMIT".format(sql_schema,sqlName))
       rtn = engine.execute("DELETE FROM [{0}].[{1}]\n\nCOMMIT".format(sql_schema,sqlName))

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError, pyodbc.Error, pyodbc.ProgrammingError) as er:
        logger.error("---executing DELETE command - skipped SQL ERROR ["+str(er.args[0])+"]" )
        logger.exception("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName, er))
        raise
    logger.debug('....wrote to history')


# executeSQL_UPDATE() - calls both executeSQL_INSERT and executeSQL_MERGE in attempt to update the SQL Tables 
# @ logger.catch
def executeSQL_UPDATE(engine, df, sqlName, dTyper, kLister, aTypes, aNames, typers):
    try:
        executeSQL_INSERT(engine, df, sqlName, dTyper, typers)
    except:
        logger.exception('XXXXXXX failed on executeSQL_INSERT XXXXXXX')
        raise
    try:
        executeSQL_MERGE(engine, df, sqlName, dTyper, kLister, aTypes, aNames, typers)
        pass
    except:
        logger.exception('XXXXXXX failed on executeSQL_MERGE XXXXXXX')
        raise


# ig_f() - Used to find files to be ignored when copying the dir tree
def ig_f(dir, files):
    return [f for f in files if os.path.isfile(os.path.join(dir, f))]


# archive() - Archives files after they are processed
@logger.catch
def archive(df, subdir, file, exportPath, archivePath, diffs = True, createInitial = True):
    # Create the path in the archive based on the location of the CSV
    if not os.path.isdir(os.path.join(archivePath, subdir)):
        shutil.copytree(os.path.join(exportPath, subdir),os.path.join(archivePath,subdir), ignore=ig_f)

    if cfg['ccdw']['archive_type'] == 'zip':
        if not os.path.isfile(os.path.join(archivePath, subdir, file)):
            try:
                # Create a zip'd version of the CSV
                zFi = zipfile.ZipFile(os.path.join(exportPath,subdir,(file[:-4]+'.zip')), 'w', zipfile.ZIP_DEFLATED)
                zFi.write(os.path.join(exportPath, subdir, file), file)
                zFi.close()

                # Move the zip file to the archive location
                shutil.move(os.path.join(exportPath, subdir, (file[:-4]+'.zip')), os.path.join(archivePath, subdir, (file[:-4]+'.zip')))

                # Remove the CSV file from the export folder
                os.remove(os.path.join(exportPath, subdir, file)) # comment this out if you want to keep files
            except:
                raise
    else:
        if cfg['ccdw']['archive_type'] == 'move':
            archive_filelist = sorted(glob.iglob(os.path.join(archivePath, subdir, subdir + '_Initial.csv')), 
                                      key=os.path.getctime)
            if (len(archive_filelist) == 0):
                logger.debug("INITALARCHIVE: Creating...")
                df.to_csv( os.path.join(archivePath, subdir, subdir + '_Initial.csv'), 
                           index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )

            if diffs:
                shutil.move(os.path.join(exportPath, subdir, file), os.path.join(archivePath, subdir, file))
            else:
                # Move the file to the archive location
                shutil.move(os.path.join(exportPath, subdir, file), os.path.join(archivePath, subdir, subdir + '.csv'))
                df.to_csv( os.path.join(archivePath, subdir, file), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )


# engine() - creates an engine to be used to interact with the SQL Server
@logger.catch
def engine( driver = cfg['sql']['driver'],
            server = cfg['sql']['server'],
            db = cfg['sql']['db'],
            schema = cfg['sql']['schema'] ):
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
# def sendEmail(emailFrom, emailTo, emailSubject, file):
#     login, password = emailFrom, getpass('Gmail password:') # 'persiden.smith@gmail.com', 'mqknmbbjsqzzjhyj' #
#     recipients = [emailTo]

#     # create message
#     with open(file) as fp:     
#         msg = MIMEText(fp.read(),'plain','utf-8')
#     # msg = MIMEText('message body…', 'plain', 'utf-8')
#     msg['Subject'] = Header(emailSubject, 'utf-8')
#     msg['From'] = login
#     msg['To'] = ", ".join(recipients)

#     # send it via gmail
#     # s = SMTP_SSL('webmail.haywood.edu', 443, timeout=100)
#     s =  smtplib.SMTP('smtp.office365.com', 587)
#     # s = SMTP_SSL('smtp.gmail.com', 465, timeout=10)
#     s.set_debuglevel(1)
#     try:
#         context = ssl.create_default_context()
#         s.starttls(context)
#         s.login(login, password)
#         s.sendmail(msg['From'], recipients, msg.as_string())
#     except smtplib.SMTPHeloError:
#         print('this didnt work')
#     finally:
#         s.quit()



# executeSQLAppend() - Attempts to execute an Append statement to the SQL Database with new Columns
@logger.catch
def executeSQLAppend(engine, df, sqlName, dTyper, schema):
    TableColumns= list(df.columns) 
    #newColumnCheck = False
    logger.debug('_______________________________________________________________________')
    #create SQL string and read matching Table on the server
    sqlStrings = f"SELECT DISTINCT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='{schema}' AND TABLE_NAME='{sqlName}'"
    existingColumns = list(pd.read_sql(sqlStrings, engine)["COLUMN_NAME"])
    logger.debug('--Diff:')
    #existingColumns = list(sqlRead.columns)
    newnames = list(df[df.columns.difference(existingColumns)].columns)

    if not newnames:
        logger.debug("No new columns")
        return()

    #attemp to create a dataframe and string of columns that need to be added to SQL Server
    try:
        logger.debug(f"Newnames = {newnames}")
        #updateList = list(set(list(sqlRead)).symmetric_difference(set(list(df))))
        #logger.debug(f"new columns: {newnames}")
        updateFrame = pd.DataFrame(columns=newnames)
        updateColumns = list(updateFrame.columns)
        updateColumns1 = ',\n\t'.join("[{0}] {1}".format(c,dTyper[c]) for c in reversed(updateColumns))
    except:
        logger.exception('ERROR!!!!')

    logger.debug(updateColumns1)
    
    #create SQL File based on tempalte to ALTER current SQL Table and append new Columns
    flds = {'TableSchema'          : schema, 
            'TableName'            : sqlName,
            'TableColumns'         : ', '.join("[{0}]".format(c) for c in TableColumns),
            'updateColumns'        : updateColumns1,
            'viewName'             : sqlName + '_Current',
            'viewSchema'           : sql_schema_history
        }
    filein = open(cfg['sql']['add_Columns'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)
    logger.debug('_______________________________________________________________________')
    
    #if there are added Columns attempt to push them to the SQL Table
    try:
        if(updateColumns):
            engine.execute(result)
            newColumnCheck = True

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        logger.error("-Error Updating Columns in SQL Table - ["+str(er.args[0])+"]" )
        logger.exception("Error in File: \t %s \n\n Error: %s \n\n" % (sqlName, er))
        raise
    if (updateColumns):
        filein = open(cfg['sql']['create_view'],"r")
        src = Template( filein.read() )
        result = src.substitute(flds)
        dropView = 'DROP VIEW IF EXISTS %s' % (flds['viewName'])
        try:
            logger.debug('----Creating Current View')
            #drop sql view if exits
            engine.execute(dropView)
            #create new sql view
            engine.execute(result)

        except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
            logger.error("-Error Creating View of SQL Table - ["+str(er.args[0])+"]" )
            logger.exception("Error in Table: \t %s \n\n Error: %s \n\n" % (sqlName, er))
            raise

# numericalSort() - Is used to properly sort files based on numbers correctly
@logger.catch
def numericalSort(value):
    numbers = re.compile(r'(\d+)')
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

@logger.catch
def createDiff( cf, lf ):
    if (lf.shape[0] == 0) | (cf.shape[0] == 0):
        return( cf )
        
    # Old version is last one archived
    lf['version'] = "old"

    # New version is the current one being processed
    cf['version'] = "new"

    #Join all the data together and ignore indexes so it all gets added
    full_set = pd.concat([lf, cf],ignore_index=True,sort=True)

    # Get all column names except 'version' defined above into col_names
    # col_names = full_set.column.names - 'version'
    col_names = full_set[full_set.columns.difference(["DataDatetime", "version"])].columns

    # Let's see what changes in the main columns we care about, keep only new records
    changes = full_set.drop_duplicates(subset=col_names, keep=False)    
    changes = changes[(changes["version"] == "new")]

    #Drop the temp columns - we don't need them now
    changes = changes.drop(['version'], axis=1)
    
    return( changes )
