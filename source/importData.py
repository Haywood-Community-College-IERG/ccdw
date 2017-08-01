import csv
# import pymssql
import os
import sys
import yaml
import urllib
import sqlalchemy
import pyodbc
import pandas as pd
import numpy as np
from os import path
from string import Template
from sqlalchemy import exc
# walk_dir = "C:/Users/kcsmith5/Desktop/pyCSV2SQL/test/"

with open("L:/TISS/RIE/CCDW/test/config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

walk_dir = cfg['informer']['export_path']

print('walk_dir = ' + walk_dir)

#print('walk_dir (absolute) = ' + os.path.abspath(walk_dir))

conn_details =  """
  DRIVER={{{0}}};SERVER={1};DATABASE={2};SCHEMA={3};Trusted_Connection=Yes;
""".format( cfg['sql']['driver'], 
            cfg['sql']['server'],
            cfg['sql']['db'],
            cfg['sql']['schema'])

#con = pyodbc.connect(conn_details)
params = urllib.parse.quote_plus(conn_details)
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)


df1 = pd.read_csv("K:/META/CDD/META__CF_CDD.csv",dtype='str')
df2 = pd.read_csv("K:/META/CDD/META__CORE_CDD.csv",dtype='str')
df3 = pd.read_csv("K:/META/CDD/META__HR_CDD.csv",dtype='str')
df5 = pd.read_csv("K:/META/CDD/META__TOOL_CDD.csv",dtype='str')
df6 = pd.read_csv("K:/META/CDD/META__UT_CDD.csv",dtype='str')
df4 = pd.read_csv("K:/META/CDD/META__ST_CDD.csv", encoding = "ISO-8859-1",dtype='str')

lookuplist = pd.concat([df1, df2, df3, df4, df5, df6],ignore_index=True)
lookuplist = lookuplist.replace(np.nan, '', regex=True)

# dfs = [pd.read_csv(path.join('K:/META/CDD',x)) for x in os.listdir("K:/META/CDD") if path.isfile(path.join("K:/META/CDD",x))]
# df = pd.concat(dfs)
#with open('CDD_ALL_2.csv','r') as lookuplist:
# with open('rtFields.csv','r') as lookuplist:
vLook = lookuplist
fieldNames = vLook['ids']
dataType = vLook['Data Type ']
dataLength = vLook['Default Display Size ']
usageType = vLook['Database Usage Type ']
dataDecimalLength = vLook['Dt2 ']
dataDecimalLength = dataDecimalLength.replace('', '0', regex=True)

dataType = dataType.copy()
fieldNames = fieldNames.copy()
usageType = usageType.copy()
dataDecimalLength = dataDecimalLength.copy()

for index, types in enumerate(dataType):
    if types == 'S' or types == '' or usageType[index] == 'A':
        types = sqlalchemy.types.String(8000) #dataLength[index]) #'VARCHAR(' + str(dataLength[index]) + ')'
    elif types == 'U':
        types = sqlalchemy.types.String(8000) #'VARCHAR(MAX)'
    elif types == 'T':
        types = sqlalchemy.types.Time() # 'TIME'
    elif types == 'N':
        types = sqlalchemy.types.Numeric(int(dataLength[index]),dataDecimalLength[index]) #'DECIMAL(' + str(dataLength[index]) + ',3)'
    elif types == 'D':
        types = sqlalchemy.types.Date()  # 'DATE'
#         print(types)
#         print(dataType[index])
    dataType[index] = types

# for index, types in enumerate(usageType):
#     if types == 'K':
#         usageType[index] = fieldNames[index]
keyList = pd.concat([fieldNames,usageType], axis=1)
print (keyList)
kList = list(keyList.set_index('ids').to_dict().values()).pop()

result = pd.concat([fieldNames,dataType], axis=1)

#print(result)

dTypes = list(result.set_index('ids').to_dict().values()).pop()
#print(dTypes)
#print(dtypes['ACAD.MAJORS'])

# Load Merge SQL Template into mergeTemplate

def executeSQL_MERGE(inputFrame, sqlName, dTyper,kLister):
    # all SQL commands (split on ';')
    #sqlCommands = sqlStr.split(';')

    # print(inputFrame.columns)
    blankFrame = pd.DataFrame(columns=inputFrame.columns)
    # Add three History columns to blankFrame
    # Add three History column types to dTyper
    blankFrame['EffectiveDate'] = ""
    blankFrame['ExpirationDate'] = ""
    blankFrame['CurrentFlag'] = ""
    # print(blankFrame)
    blankTyper = dTyper
    blankTyper['EffectiveDate'] = sqlalchemy.types.Date()
    blankTyper['ExpirationDate'] = sqlalchemy.types.Date()
    blankTyper['CurrentFlag'] = sqlalchemy.types.String(1)
    # print(blankTyper)
    blankFrame.to_sql(sqlName+"_History", engine, flavor=None, schema=cfg['sql']['schema'], if_exists='append',
                         index=False, index_label=None, chunksize=None, dtype=blankTyper)
    print("...wrote to table")
    #print("PRESS ENTER TO CONTINUE.")
    #wait = input()
    TableKeys= list(kLister.keys()) #['KEY1','KEY2']
    TableColumns= list(inputFrame.columns) #['COL1', 'COL2'] 
    # We are treating all non-key columns as Type 2 SCD at this time (20170721)
    TableColumns2= list(inputFrame.columns) #TableColumns 

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
            'TableColumns2_DEST'   : ', '.join("DEST.[{0}]".format(c) for c in TableColumns2)
            }
    filein = open(cfg['sql']['merge_scd2'],"r")
    src = Template( filein.read() )
    result = src.substitute(flds)

    # This will skip and report errors
    # For example, if the tables do not yet exist, this will skip over
    # the DROP TABLE commands
    try:
        print("......executing sql command")
        rtn = engine.execute(result)

    #Capture pyodbc.ProgrammingError
    except exc.SQLAlchemyError:
        print ("......executing sql command - skipped ["+str(exc.SQLAlchemyError)+"]" )
    except pyodbc.Error as ex:
        sqlState = ex.args[1]
        with open("log.txt", "w") as log:
            log.write("Error in File: %f \t Error: %s \n" % (sqlName,sqlState))

    try:
       print("......executing delete command")
       rtn = engine.execute("DELETE FROM [{0}].[{1}]\n\nCOMMIT".format(cfg['sql']['schema'],sqlName))

    except exc.SQLAlchemyError:
        print ("......executing sql command - skipped ["+str(exc.SQLAlchemyError)+"]" )

print('=========begin loop===========')
for root, subdirs, files in os.walk(walk_dir):
    print('--\nroot = ' + root)
    print('_______________________________________________________________________')
    for subdir in subdirs:
        print('_______________________________________________________________________')
        print('\t- subdirectory ' + subdir)
    for file in files:
        if file.endswith('.csv'):
            #if file.find('__')!=-1:
                with open(root + '/' + file, "r") as csvinput:
                    print("Processing "+file+"...")

                    inputFrame = pd.read_csv(csvinput,dtype='str')
                    inputFrame = inputFrame.replace(np.nan, '', regex=True)
                    del inputFrame['Current Date']
                    columnHeaders = list(inputFrame)
                    # print(inputFrame)
                    columnArray = np.asarray(columnHeaders)
                    #print(dictio)
                    dTyper = {k: dTypes[k] for k in dTypes.keys() & columnArray}
                    kLister = {k: kList[k] for k in kList.keys() & columnArray}
                    for k, v in list(kLister.items()):
                        if v != 'K':
                            del kLister[k]
                    #print(list(kLister.keys()))
                    # print(dTyper)
                    one,two,three = root.rpartition('/')
                    #print(three)
                    if '\\' in three:
                        head, sep, tail = three.rpartition('\\')
                        sqlName = head[:-5]
                    else:
                        sqlName = three[:-5]
                    # print(sqlName)

                    # Check if fields exist, alter table for any missing fields
                    # error on file if field exists and has a different type

                    inputFrame.to_sql(sqlName, engine, flavor=None, schema=cfg['sql']['schema'], if_exists='append',
                                         index=False, index_label=None, chunksize=None, dtype=dTyper)
                    
                    executeSQL_MERGE(inputFrame, sqlName, dTyper, kLister)
                    
                    print('...wrote to history')
                    #print("PRESS ENTER TO CONTINUE.")
                    #wait = input()

                    print("...archiving file")
                    # Archive file

                    print("...Done")

print("DONE!!!!")