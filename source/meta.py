import csv
import os
import sys
import yaml
import urllib
import pandas as pd
import numpy as np
from os import path
import glob
import sqlalchemy
from sqlalchemy import exc

with open("config.yml","r") as ymlfile:
    meta_cfg = yaml.load(ymlfile)

def loadLookupList():
    global lookuplist 

    # If lookuplist exists, move along. Otherwise, create it
    try:
        if lookuplist.empty:
            pass

    except NameError:
        # Read all files in the meta folder
        meta_path = meta_cfg['informer']['export_path_meta']
        meta_path_cdd = meta_cfg['informer']['export_path_meta_cdd']
        all_files = glob.glob(os.path.join(meta_path_cdd, "*_CDD*csv"))
        df_from_each_file = (pd.read_csv(f,encoding = "ISO-8859-1",dtype='str') for f in all_files)
        lookuplist = pd.concat(df_from_each_file, ignore_index=True)
        lookuplist.set_index('ids')

        meta_custom = meta_cfg['informer']['meta_custom']
        meta_custom_csv = pd.read_csv(meta_custom,encoding = "ISO-8859-1",dtype='str')
        meta_custom_csv.set_index('ids')

        lookuplist.update(meta_custom_csv)

        lookuplist = lookuplist.replace(np.nan, '', regex=True)

loadLookupList()

# Return the key(s) for the specified fle
def getKeyFields(file=''):
    global lookuplist

    loadLookupList()

    if file=='':
        fl = lookuplist[(lookuplist['Database Usage Type ']=='K')]
    else:
        fl = lookuplist[(lookuplist['Source ']==file) & (lookuplist['Database Usage Type ']=='K')]

    return(fl.ids.tolist())

def getDataTypes(file=''):
    global lookuplist

    meta_path = meta_cfg['informer']['export_path_meta']

    loadLookupList()

    if file!='':
        dtLookuplist = lookuplist[(lookuplist['Source ']==file)]
    else:
        dtLookuplist = lookuplist

    fieldNames = dtLookuplist['ids'].copy()
    dataType = dtLookuplist['Data Type '].copy()
    dataLength = dtLookuplist['Default Display Size ']
    usageType = dtLookuplist['Database Usage Type '].copy()
    dataDecimalLength = dtLookuplist['Dt2 '].replace('', '0', regex=True).copy()

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
        elif types == 'DT':
            types = sqlalchemy.types.DateTime()
        dataType[index] = types

    keyList = pd.concat([fieldNames,usageType], axis=1)

    # Why is DataDatetime added to the keyList?
    # keyList = keyList.append([['DataDatetime',sqlalchemy.types.DateTime()]],ignore_index=True)
    kList = list(keyList.set_index('ids').to_dict().values()).pop()

    result = pd.concat([fieldNames,dataType], axis=1)
    dTypes = list(result.set_index('ids').to_dict().values()).pop()
    
    return(kList,dTypes)