import csv
import os
import glob
import sys
import yaml
import urllib
import pyodbc
import pandas as pd
import numpy as np
from os import path
from string import Template
import sqlalchemy
from sqlalchemy import exc
import shutil
import meta
import export


with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

walk_dir = cfg['informer']['export_path']

print('walk_dir = ' + walk_dir)

engine = export.engine(cfg['sql']['driver'], cfg['sql']['server'], cfg['sql']['db'], cfg['sql']['schema'])
# conn_details =  """
#   DRIVER={{{0}}};SERVER={1};DATABASE={2};SCHEMA={3};Trusted_Connection=Yes;
# """.format( cfg['sql']['driver'], 
#             cfg['sql']['server'],
#             cfg['sql']['db'],
#             cfg['sql']['schema'])

# params = urllib.parse.quote_plus(conn_details)

# engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)

kList, dTypes = meta.getDataTypes()

print('=========begin loop===========')
#loops through each directory and subDirectory pass by each file.
with open("log.txt", "w") as log:
    for root, subdirs, files in os.walk(walk_dir):
        print('--\nroot = ' + root)
        print('_______________________________________________________________________')
        for subdir in subdirs:
            print('_______________________________________________________________________')
            print('\t- subdirectory ' + subdir)
        for file in files:
            if file.endswith('.csv'):
                print("Processing "+file+"...")
                #reads in csv file then creates an array out of the headers
                inputFrame = pd.read_csv(os.path.join(root, file),dtype='str')
                inputFrame = inputFrame.replace(np.nan, '', regex=True)
                columnArray = np.asarray(list(inputFrame))

                #dTyper creates a dictionary of Columns and their types to be passed to executeSQL_UPDATE
                dTyper = {k: dTypes[k] for k in dTypes.keys() & columnArray}
                #kLister creates a dictionary of keys to be passed to executeSQL_UPDATE
                kLister = {k: kList[k] for k in kList.keys() & columnArray}
                for k, v in list(kLister.items()):
                    if v != 'K':
                        del kLister[k]

                #partitions root and creates the table name based on the folder name minus the last 5 chars
                one,two,three = root.rpartition('/')
                if '\\' in three:
                    head, sep, tail = three.rpartition('\\')
                    sqlName = head[:-5]
                    head = head
                else:
                    sqlName = three[:-5]
                    head = three

                #attempts to execute code catching any errors that may arrise then breaks out of loop of folder    
                try:
                    export.executeSQL_UPDATE(engine, inputFrame, sqlName, dTyper, kLister, log)
                except:
                    print('\t ---Error in file: %s the folder will be skipped' % file)
                    break
                else:
                    #archives the files in another directory if their are no exceptions
                    print(".....archiving file")
                    export.archive(head,file,cfg['informer']['export_path'],cfg['informer']['archive_path'])
                
                print("......Done")        
print("DONE!!!!")