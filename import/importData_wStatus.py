import csv
import os
import sys
import yaml
import urllib
import pandas as pd
import numpy as np
from os import path
import regex
from datetime import date, timedelta
import sqlalchemy
from sqlalchemy import exc
import datetime
import meta
import export

with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

export_path = cfg['informer']['export_path_wStatus']
invalid_path = cfg['informer']['invalid_path_wStatus']
archive_path = cfg['informer']['archive_path_wStatus']
prefix = cfg['informer']['prefix']

pattern = r'{0}(?P<fnpat>.*)___.*|(?P<fnpat>.*)___.*'.format(prefix)

# Some files have dates that are way out there. Let's mark as invalid those that are more than a year out
invalid_date = date.today() + timedelta(365)

# All the status fields in association with one another
status_fields = { 
        'ACAD_PROGRAMS'     : ['ACPG.STATUS','ACPG.STATUS.DATE'],
        'APPLICATIONS'      : ['APPL.STATUS','APPL.STATUS.DATE','APPL.STATUS.TIME'],
        'STUDENT_ACAD_CRED' : ['STC.STATUS', 'STC.STATUS.DATE', 'STC.STATUS.TIME', 'STC.STATUS.REASON'],
        'STUDENT_PROGRAMS'  : ['STPR.STATUS','STPR.STATUS.DATE','STPR.STATUS.CHGOPR'],
        'STUDENT_TERMS'     : ['STTR.STATUS','STTR.STATUS.DATE']
    }

# Extract just the date and time fields
status_datetime_fields = {}
date_regex = regex.compile('.*\.DATE$|.*\.TIME$')
for key in status_fields.keys():
    fields = status_fields[key]
    status_datetime_fields[key] = [ f for f in fields if date_regex.match(f) ]

log = open("log/log_{0}.txt".format( datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S%f") ), "w")

engine = export.engine(cfg['sql']['driver'], 
                       cfg['sql']['server'],
                       cfg['sql']['db'],
                       cfg['sql']['schema'])

def processfile(df, fn, d):
    columnHeaders = list(df.columns.values)
    columnArray = np.asarray(columnHeaders)
    kList, dTypes = meta.getDataTypes()
    dTyper = {k: dTypes[k] for k in dTypes.keys() & columnArray}
    kLister = {k: kList[k] for k in kList.keys() & columnArray}
    for k, v in list(kLister.items()):
        if v != 'K':
            del kLister[k]

    try:
        print("Updating fn = "+fn+", d = "+d)
        export.executeSQL_UPDATE(engine, df, fn, dTyper, kLister, log)

        # Define and create the directory for all the output files
        # directory = '{path}/{folder}'.format(path=invalid_path,folder=fn)
        # os.makedirs(directory,exist_ok=True)
        # df.to_csv('{path}/{fn}_{dt}.csv'.format(path=directory,fn=fn,dt=d), index = False)

    except:
        print('\t ---Error in file: %s the folder will be skipped' % file)
        raise

    return

# Cycle through all the files in the folder
for root, subdirs, files in os.walk(export_path):
    for file in files:
        with open(root + '/' + file, "r") as csvinput:
            # We only want to process files that match the pattern for wStatus files
            m = regex.match(pattern,file)
            if m==None:
                continue
            fn = m.expandf("{fnpat}")

            # Get status and datetime fields for this file
            df_status = status_fields[fn]
            df_status_datetime = status_datetime_fields[fn]
            df_status_only = set(df_status).symmetric_difference(set(df_status_datetime))

            print("Processing "+fn+"...")

            df = pd.read_csv(csvinput,dtype='str')
            file_keys = meta.getKeyFields(fn.replace('_','.'))

            # Fill down the status fields so all status fields have a value            
            for fld in df_status:
                df[fld] = df.groupby(file_keys)[fld].ffill()

            # If the date field is still blank, set it
            df[df_status_datetime[0]].fillna('1900-01-01', inplace=True)

            # Create a new DataDatetime field using the date and time fields.
            # If the time field is still blank, set it. If it is missing, set it.
            if len(df_status_datetime)==2:
                df[df_status_datetime[1]].fillna('00:00:00', inplace=True)
                newDataDatetime = df[df_status_datetime[0]] + "T" + df[df_status_datetime[1]]
            else:
                newDataDatetime = df[df_status_datetime[0]] + "T00:00:00"

            df['DataDatetime']=pd.to_datetime(newDataDatetime)

            # Keep the latest record of any duplicated rows by all colums except the status fields
            df = df.drop_duplicates(set(df.columns).symmetric_difference(set(df_status_only)),keep='last')

            # Make datetime variable an actual datetime instead of a string, then sort
            df.sort_values(by='DataDatetime')

            # Define and create the directory for the INVALID output file
            os.makedirs(invalid_path,exist_ok=True)

            # Remove from the dataframe all rows with an invalid date
            # Keep the status date/time fields as string, as that is what they are in the database
            df[pd.to_datetime(df[df_status_datetime[0]])>invalid_date].to_csv('{path}/{fn}_INVALID.csv'.format(path=invalid_path,fn=fn))
            df = df[pd.to_datetime(df[df_status_datetime[0]])<=invalid_date]

            # Now, group by the date field and create cumulative files for each date in the file
            try:
                # This keeps the last record per day
                for d in sorted(df['DataDatetime'].dt.strftime('%Y-%m-%d').unique()):
                    processfile(df.loc[df[df_status_datetime[0]] == d].groupby(file_keys,as_index=False).last(), fn, d)

                # If you want cumulative files (i.e., all the most recent records up to this date), use this
                #for d in sorted(df['DataDatetime'].dt.strftime('%Y-%m-%d').unique()):
                #    processfile(df.loc[df[df_status_datetime[0]] <= d].groupby(file_keys,as_index=False).last(), fn, d)
            except:
                print('\t ---Error in file: %s' % fn)

        print(".....archiving file "+file)
        export.archive("",file,export_path,archive_path)

