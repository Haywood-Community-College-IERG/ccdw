import csv
import os
import sys
import yaml
import urllib
import pandas as pd
import numpy as np
from os import path
import regex
import glob
from datetime import date, timedelta

with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

export_path = cfg['informer']['export_path_wStatus']
output_path = cfg['informer']['output_path_wStatus']
prefix = cfg['informer']['prefix']

pattern = r'{0}(?P<fnpat>.*)___.*|(?P<fnpat>.*)___.*'.format(prefix)

# Some files have dates that are way out there. Let's mark those as invalid
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

# This will expand a dataframe by splitting a MV column into individual rows 
def explode(df, cols, split_on=','):
    """
    Explode dataframe on the given column, split on given delimeter

    From: https://stackoverflow.com/questions/38651008/splitting-multiple-columns-into-rows-in-pandas-dataframe
    """
    cols_sep = list(set(df.columns) - set(cols))
    df_cols = df[cols_sep]
    explode_len = df[cols[0]].str.split(split_on).map(len)
    repeat_list = []
    for r, e in zip(df_cols.as_matrix(), explode_len):
        repeat_list.extend([list(r)]*e)
    df_repeat = pd.DataFrame(repeat_list, columns=cols_sep)
    df_explode = pd.concat([df[col].str.split(split_on, expand=True).stack().str.strip().reset_index(drop=True)
                            for col in cols], axis=1)
    df_explode.columns = cols
    return pd.concat((df_repeat, df_explode), axis=1)

# Return the key(s) for the specified fle
def getKeyFields(file=''):
    global lookuplist

    # If lookuplist exists, move along. Otherwise, create it
    try:
        if lookuplist.empty:
            pass

    except NameError:
        # Read all files in the meta folder
        meta_path = cfg['informer']['export_path_meta_cdd']
        all_files = glob.glob(os.path.join(meta_path, "*_CDD*csv"))
        df_from_each_file = (pd.read_csv(f,encoding = "ISO-8859-1",dtype='str') for f in all_files)
        lookuplist = pd.concat(df_from_each_file, ignore_index=True)
        lookuplist = lookuplist.replace(np.nan, '', regex=True)

    if file=='':
        fl = lookuplist[(lookuplist['Database Usage Type ']=='K')]
    else:
        fl = lookuplist[(lookuplist['Source ']==file) & (lookuplist['Database Usage Type ']=='K')]

    return(fl.ids.tolist())

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
            file_keys = getKeyFields(fn.replace('_','.'))

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

            df['DataDatetime']=newDataDatetime

            # Keep the latest record of any duplicated rows by all colums except the status fields
            # TODO: Should keep date/time fields in the dup check
            df = df.drop_duplicates(df.columns.difference(df_status_only),keep='last')

            # Set the index to the keys of the file for the groupby/splitting below
            df = df.set_index(file_keys)

            # Define and create the directory for all the output files
            directory = '{path}/{folder}'.format(path=output_path,folder=fn)
            os.makedirs(directory,exist_ok=True)

            # Define and create the directory for the INVALID output file
            invalid_directory = '{path}/INVALID'.format(path=output_path)
            os.makedirs(invalid_directory,exist_ok=True)

            # Remove from the dataframe all rows with an invalid date
            df[df_status_datetime[0]] = pd.to_datetime(df[df_status_datetime[0]])
            df[df[df_status_datetime[0]]>invalid_date].to_csv('{path}/{fn}_INVALID.csv'.format(path=invalid_directory,fn=fn))
            df = df[df[df_status_datetime[0]]<=invalid_date]

            # Now, group by the date field and create cumulative files for each date in the file
            for d in df[df_status_datetime[0]].dt.strftime('%Y-%m-%d').unique():
                df.loc[df[df_status_datetime[0]] <= d] \
                    .groupby(file_keys,as_index=False).last() \
                    .to_csv('{path}/{fn}_{dt}.csv'.format(path=directory,fn=fn,dt=d))
