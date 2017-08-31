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
        all_files = glob.glob(os.path.join(meta_path, "*_CDD*csv"))
        df_from_each_file = (pd.read_csv(f,encoding = "ISO-8859-1",dtype='str') for f in all_files)
        lookuplist = pd.concat(df_from_each_file, ignore_index=True)
        
        meta_custom = meta_cfg['informer']['meta_custom']
        meta_custom_csv = pd.read_csv(meta_custom,encoding = "ISO-8859-1",dtype='str')

        metaList = set(meta_custom_csv['ids'].copy())
        lookList = lookuplist['ids'].copy()
        meta_custom_csv = meta_custom_csv.sort_values(by='ids')
        delThis = [item for i, item in enumerate(lookList) if item in metaList]
        delIDs = [list(lookList).index(item) for i,item in enumerate(delThis)]
        meta_custom_csv.set_index('ids')
        lookuplist.drop(delIDs,axis=0, inplace=True)
        lookuplist = lookuplist.append(meta_custom_csv, ignore_index=True)
        lookuplist = lookuplist.where(pd.notnull(lookuplist), None)
        lookuplist.set_index('ids')
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
    typers = dtLookuplist['Data Type '].copy()
    dataLength = dtLookuplist['Default Display Size ']
    usageType = dtLookuplist['Database Usage Type '].copy()
    aType = dtLookuplist['Element Assoc Type '].copy()
    aName = dtLookuplist['Element Assoc Name '].copy()
    dataDecimalLength = dtLookuplist['Dt2 '].replace('', '0', regex=True).copy()

    for index, types in enumerate(dataType):
        if usageType[index] == 'A':
            if types == 'S' or types == '' or types == None:
                dtypers = 'VARCHAR(%s)' % (dataLength[index])
            elif types == 'U':
                dtypers = 'VHARCHAR(%s)' % (dataLength[index])
            elif types == 'T':
                dtypers = 'TIME'
            elif types == 'N':
                dtypers = 'NUMERIC(%s,%s)' % (dataLength[index], dataDecimalLength[index])
            elif types == 'D':
                dtypers = 'DATE'
            elif types == 'DT':
                dtypers = 'DATETIME'
            typers[index] = dtypers
            types = sqlalchemy.types.String(8000)
        elif types == 'S' or types == '' or types == None:
            types = sqlalchemy.types.String(dataLength[index]) #types = sqlalchemy.types.String(8000)
        elif types == 'U':
            types = sqlalchemy.types.String(dataLength[index]) #types = sqlalchemy.types.String(8000)
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
    aTypes = pd.concat([fieldNames,aType], axis=1)
    typers = pd.concat([fieldNames,typers], axis=1)
    aNames = pd.concat([fieldNames,aName], axis=1)
    result = pd.concat([fieldNames,dataType], axis=1)


    aTypes = list(aTypes.set_index('ids').to_dict().values()).pop()
    typers = list(typers.set_index('ids').to_dict().values()).pop()
    aNames = list(aNames.set_index('ids').to_dict().values()).pop()
    kList = list(keyList.set_index('ids').to_dict().values()).pop()
    dTypes = list(result.set_index('ids').to_dict().values()).pop()
    return(kList,dTypes,aTypes,aNames,typers)