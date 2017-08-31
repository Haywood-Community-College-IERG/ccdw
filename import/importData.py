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
from datetime import date, timedelta
import datetime
import glob

with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

walk_dir = cfg['informer']['export_path']
log_path = cfg['informer']['log_path']

engine = export.engine(cfg['sql']['driver'], cfg['sql']['server'], cfg['sql']['db'], cfg['sql']['schema'])

kList, dTypes, aTypes, aNames, typers = meta.getDataTypes()

# !!!
# !!! Needs to check for existence of schemas before trying to create any tables
# !!!

print('=========begin loop===========')
#loops through each directory and subDirectory pass by each file.
with open(os.path.join(log_path,"log_{0}.txt".format( datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S%f") )), "w", 1) as log:
    lastFile = sorted(glob.iglob(os.path.join(log_path,'*.txt')), key=os.path.getctime)[-2]
    if not ((os.stat(lastFile)).st_size):
        for root, subdirs, files in os.walk(walk_dir):
            sys.stdout.flush()
            print('--\nroot = ' + root)
            print('_______________________________________________________________________')
            for subdir in subdirs:
                print('_______________________________________________________________________')
                print('\t- subdirectory ' + subdir)
            for file in sorted(files,key=export.numericalSort):
                if file.endswith('.csv'):
                    print("Processing "+file+"...")
                    #reads in csv file then creates an array out of the headers
                    try:
                        inputFrame = pd.read_csv(os.path.join(root, file),encoding='ansi',dtype='str') #buffering='utf-16-le'
                        # inputFrame = inputFrame.replace(np.nan, '', regex=True)
                        inputFrame = inputFrame.where(pd.notnull(inputFrame), None)
                        columnArray = np.asarray(list(inputFrame))
                    except UnicodeDecodeError as er:
                        print ("ERROR Reading File - ["+str(er.args[0])+"]" )
                        log.write("Error in File: \t %s \n\n Error: %s \n\n\n" % (file,er))
                        break
                    #dTyper creates a dictionary of Columns and their types to be passed to executeSQL_UPDATE
                    dTyper = {k: dTypes[k] for k in dTypes.keys() & columnArray}
                    #kLister creates a dictionary of keys to be passed to executeSQL_UPDATE
                    kLister = {k: kList[k] for k in kList.keys() & columnArray}
                    aTypesr = {k: aTypes[k] for k in aTypes.keys() & columnArray}
                    aNamesr = {k: aNames[k] for k in aNames.keys() & columnArray}
                    typersr = {k: typers[k] for k in typers.keys() & columnArray}

                    for k, v in list(aNamesr.items()):
                        if v == None:
                            del aNamesr[k]
                            del aTypesr[k]
                            del typersr[k]
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
                        export.executeSQL_UPDATE(engine, inputFrame, sqlName, dTyper, kLister, aTypesr, aNamesr, typersr, log)
                    except:
                        print('\t ---Error in file: %s the folder will be skipped' % file)
                        break
                    else:
                        #archives the files in another directory if their are no exceptions
                        print(".....archiving file")
                        export.archive(head,file,cfg['informer']['export_path'],cfg['informer']['archive_path'])
                    
                    print("......Done")        
    else:
        print('---Exiting Due to Logged Error in last run---')
        log.write("Error in last File see log: \t %s " % (lastFile))
print("DONE!!!!")