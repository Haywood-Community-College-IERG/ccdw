import sys
import os
from os import path
import pandas as pd
import glob
from loguru import logger
import sqlalchemy
from sqlalchemy.dialects import mssql
from typing import TypeVar, List, Tuple, Dict

from module.exceptions import FileValidationError

MetaObject = TypeVar('MetaObject')

class CCDW_Meta:
    __lookuplist = None
    __cfg = {}
    __logger = None

    def __init__( self, cfg: dict ):
        self.__cfg = cfg.copy()
        self.__logger = self.__cfg['__local']['logger']

        self.loadLookupList( cfg )

        self.__logger.debug("CCDW_Meta initialized")

    @logger.catch
    def loadLookupList(self, engine: object = None, refresh: bool = False) -> None:

        if not self.__lookuplist or refresh:
            # Read all files in the meta folder
            meta_path = self.__cfg["informer"]["export_path_meta"]
            all_files = glob.glob(os.path.join(meta_path, "*_CDD*csv"))
            df_from_each_file = (pd.read_csv(f,encoding = "ansi", dtype="str", index_col=0) for f in all_files)
            self.__lookuplist = pd.concat(df_from_each_file)
            
            meta_custom = self.__cfg["ccdw"]["meta_custom"]
            meta_custom_csv = pd.read_csv(meta_custom,encoding = "ansi", dtype="str", index_col=0)

            self.__lookuplist = self.__lookuplist.append(meta_custom_csv)
            self.__lookuplist.index.rename("DATA.ELEMENT",inplace=True)
            self.__lookuplist.reset_index(inplace=True)
            self.__lookuplist = self.__lookuplist.drop_duplicates(subset="DATA.ELEMENT", keep="last")
            self.__lookuplist = self.__lookuplist.where(pd.notnull(self.__lookuplist), None)
            self.__lookuplist.set_index("DATA.ELEMENT",inplace=True)
        
        return

    # Return the key(s) for the specified fle
    @logger.catch
    def getKeyFields(self, file:str = "") -> List[str]:
        if file=='':
            keys = self.__lookuplist[(self.__lookuplist["DATABASE.USAGE.TYPE"]=='K')]
        else:
            keys = self.__lookuplist[(self.__lookuplist["SOURCE"]==file) & (self.__lookuplist["DATABASE.USAGE.TYPE"]=='K')]

        keys.reset_index(inplace=True)
        return(list(keys["DATA.ELEMENT"]))

    @logger.catch(exclude=FileValidationError)
    def getDataTypes(self, file: str = "", columns: List[str] = []) -> Tuple[Dict[str,str],Dict[str,str],Dict[str,str],Dict[str,str],Dict[str,str],Dict[str,str]]:
        """

        The following is from the metadata (though the comments on 
        the actions codes does not appear to be corret as the 
        2 action codes are always 0). This defines the DATABASE.USAGE.TYPE.

        Action Code 1 tells whether or not the field is actual stored
        data:
        D = Data (the field is stored. The CDD record's SOURCE field
            provides the file name)
        X = Calculated (not stored) by the process that demands it.
        I = Calculated (not stored) by the query statement that
            references it.

        Action Code 2 is either
        M (multivalued) or
        S (singlevalued)

        Here is a brief description of each of the data types, along
        with any restrictions on how it is used or stored:

        A - Assoc (MV)
        Multivalued stored data element that is associated by
        value with one or more other multivalued elements.
        No limit on number of rows in the associated, but
        each value is limited to the storage width for the field.

        B - Block
        Multivalued non-file based display element. Usually used
        for multi-line headers. While this is multi-lined, it
        is not a scrollable window.

        C - Comments
        Multivalued stored data element that is designed to store
        a maximum 1996 characters in all lines, with no more than
        32,500 characters for all lines.

        D - Data
        Single valued stored data element

        H - Hook Code
        Multivalued stored data element that has no limitations on
        the number of lines or the number of characters on each line.

        I - Computed Column
        Also known as I-descriptor, and Virtual Field

        K - Key
        Single valued key to a file

        L - List
        Multivalued stored data element. There is no limit to the
        number of lines, but each line is limited to the storage
        width for the field.

        P - Procedure
        Single valued element that is not file based. VAR1 is an
        example.

        Q - MV Pointer
        Multivalued secondary pointer to the key of a file. Will
        generate automatic reads of records in that other file so
        that elements from it can be used.

        S - Synonym
        Not used at this time

        T - Text
        Multivalued stored data element. Has a maximum of 1996
        characters for all lines.

        X - SV Pointer
        Single valued secondary pointer.

        Note that the values for maximum line and total length are not
        arbitrary choices, they are limitations of diffent data types in
        Oracle and PL/SQL. For Unidata the distinction is not really
        important because of the dynamic nature of files, but in order
        to maintain compatibility with Oracle we need to keep these limits.

        """
        src_file = file.replace('_','.')

        if src_file!='':
            dtLookuplist = self._CCDW_Meta__lookuplist.loc[self._CCDW_Meta__lookuplist["SOURCE"].isin([src_file,"SYS_CCDW"])]
        else:
            if len(columns) > 0:
                dtLookuplist_ccdw = self._CCDW_Meta__lookuplist.loc[self._CCDW_Meta__lookuplist["SOURCE"]=="SYS_CCDW"]
                all_columns = columns.copy()
                all_columns.extend(list(dtLookuplist_ccdw.index))
                all_columns = sorted([*{*all_columns}])

                missing_columns = list(set(all_columns) - set(self._CCDW_Meta__lookuplist.index))

                if not missing_columns:
                    dtLookuplist = self._CCDW_Meta__lookuplist.loc[all_columns]
                else:
                    raise(FileValidationError(source="getDataTypes", validation=f"Missing columns: {missing_columns}"))
            else:
                dtLookuplist = self._CCDW_Meta__lookuplist

        fieldNames = dtLookuplist.index.array
        dataType = dtLookuplist["DATA.TYPE"].copy()
        sqlType = dtLookuplist["DATA.TYPE"].copy()
        dataTypeMV = dtLookuplist["DATA.TYPE"].copy()
        dataLength = dtLookuplist["DEFAULT.DISPLAY.SIZE"].copy()
        usageType = dtLookuplist["DATABASE.USAGE.TYPE"].copy()
        elementAssocType = dtLookuplist["ELEMENT.ASSOC.TYPE"].copy()
        elementAssocName = dtLookuplist["ELEMENT.ASSOC.NAME"].copy()
        dataDecimalLength = dtLookuplist["DT2"].replace('', '0', regex=True).copy()

        if len(columns) == 0:
            columns = fieldNames.copy()
        else:
            if file != "":
                columns = columns.append(dtLookuplist_ccdw.index)

        for index, fieldDataType in dataType.iteritems():
            dtypers = "VARCHAR(MAX)"
            sqlType[index] = "VARCHAR(MAX)"

            if usageType[index] in ['A','Q','L','I','C']:
                if fieldDataType in ['S','U','',None]:
                    dtypers = f"VARCHAR({dataLength[index] or 'MAX'})"
                elif fieldDataType == 'T':
                    dtypers = "TIME"
                elif fieldDataType == 'N':
                    dtypers = f"NUMERIC({dataLength[index]}, {dataDecimalLength[index] or 0})"
                elif fieldDataType == 'D':
                    dtypers = "DATE"
                elif fieldDataType == "DT":
                    dtypers = "DATETIME"
                dataTypeMV[index] = dtypers
                dataType[index] = sqlalchemy.types.String(None)
                sqlType[index] = f"VARCHAR(MAX)"

            elif fieldDataType in ['S','U','',None]:
                dataType[index] = mssql.VARCHAR(dataLength[index])
                sqlType[index] = f"VARCHAR({dataLength[index]})"

            elif fieldDataType == 'T':
                dataType[index] = mssql.TIME
                sqlType[index] = "TIME"

            elif fieldDataType == 'N':
                if dataDecimalLength[index] and dataDecimalLength[index] != '0':
                    dataType[index] = mssql.NUMERIC(int(dataLength[index]),int(dataDecimalLength[index]))
                    sqlType[index] = f"NUMERIC({dataLength[index]},{dataDecimalLength[index]})"
                else:
                    if int(dataLength[index]) <= 2:
                        dataType[index] = mssql.TINYINT
                        sqlType[index] = "TINYINT"
                    elif int(dataLength[index]) <= 4:
                        dataType[index] = mssql.SMALLINT
                        sqlType[index] = "SMALLINT"
                    elif int(dataLength[index]) <= 9:
                        dataType[index] = mssql.INTEGER
                        sqlType[index] = "INTEGER"
                    else:
                        dataType[index] = mssql.BIGINT
                        sqlType[index] = "BIGINT"

            elif fieldDataType == 'D':
                dataType[index] = mssql.DATE
                sqlType[index] = "DATE"

            elif fieldDataType == "DT":
                dataType[index] = mssql.DATETIME
                sqlType[index] = "DATETIME"

            else:
                dataType[index] = mssql.VARCHAR(None)
                sqlType[index] = "VARCHAR(MAX)"

        keyList = dict(list(zip(fieldNames,usageType)))
        dataTypes = dict(list(zip(fieldNames,dataType)))
        sqlTypes = dict(list(zip(fieldNames,sqlType)))
        dataTypeMV = dict(list(zip(fieldNames,dataTypeMV)))
        elementAssocTypes = dict(list(zip(fieldNames,elementAssocType)))
        elementAssocNames = dict(list(zip(fieldNames,elementAssocName)))

        # Remove blank entries from the association and multi-value dictionaries (not every field is multi-valued or in an association)
        for key, val in list(elementAssocNames.items()):
            if val == None:
                del elementAssocNames[key]
                del elementAssocTypes[key]
                del dataTypeMV[key]

        for key, val in list(keyList.items()):
            if val != 'K':
                del keyList[key]

        return(keyList,dataTypes,sqlTypes,dataTypeMV,elementAssocTypes,elementAssocNames)
