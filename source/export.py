import yaml
import urllib
import pyodbc
import pandas as pd
import numpy as np
from os import path
from string import Template
import sqlalchemy
from sqlalchemy import exc

with open("config.yml","r") as ymlfile:
    export_cfg = yaml.load(ymlfile)

def executeSQL_INSERT(engine, inputFrame, sqlName, dTyper):
    inputFrame.to_sql(sqlName, engine, flavor=None, schema=export_cfg['sql']['schema'], if_exists='append',
                 index=False, index_label=None, chunksize=None, dtype=dTyper)

def executeSQL_MERGE(engine, inputFrame, sqlName, dTyper,kLister):

    blankFrame = pd.DataFrame(columns=inputFrame.columns)

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

    TableKeys= list(kLister.keys()) #['KEY1','KEY2']
    TableColumns= list(inputFrame.columns) #['COL1', 'COL2']
    TableColumns.remove('DataDatetime') 

    print(TableKeys)

    # We are treating all non-key columns as Type 2 SCD at this time (20170721)
    TableColumns2= list(inputFrame.columns) #TableColumns 
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

    # This will skip and report errors
    # For example, if the tables do not yet exist, this will skip over
    # the DROP TABLE commands
    try:
        print("...executing sql command")
        rtn = engine.execute(result)

    #Capture pyodbc.ProgrammingError
    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        errCheck = True
        print ("---executing sql command - skipped SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))
    
    except (pyodbc.Error, pyodbc.ProgrammingError) as ex:
        print ("---executing sql command - skipped PYODBC ERROR ["+str(er.args[0])+"]" )
        errCheck = True
        sqlState = ex.args[1]
        log.write("Error in File: \t %f \n\n Error: %s \n\n\n" % (sqlName,sqlState))

    try:
       print("...executing delete command")
       rtn = engine.execute("DELETE FROM [{0}].[{1}]\n\nCOMMIT".format(cfg['sql']['schema'],sqlName))

    except (exc.SQLAlchemyError, exc.DBAPIError, exc.ProgrammingError) as er:
        errCheck = True
        print ("---executing DELETE command - skipped SQL Alchemy ERROR ["+str(er.args[0])+"]" )
        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (sqlName,er))

