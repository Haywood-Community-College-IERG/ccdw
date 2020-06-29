#! /usr/bin/python3
import sys
import os
from pathlib import Path
import shutil
import glob
import pandas as pd
import zipfile
import datetime
import argparse
import regex
from datetime import date, timedelta
from loguru import logger

# Import other local packages
from module.exceptions import FileValidationError
from module.config import load_cfg
from module.meta import CCDW_Meta, MetaObject
from module.export import CCDW_Export

__source__ = 'ccdw.py'
__version__ = "2.0.0"

def ccdw() -> None:
    run_datetime = datetime.datetime.now()
    def timestamp():
        return( datetime.datetime.now().isoformat() )

    parser = argparse.ArgumentParser(description='Import CCDW data')
    parser.add_argument('--nodb', dest='writedb', action='store_false', default=True,
                        help='Do not write to database (default: write to database)')
    parser.add_argument('--diffs', dest='diffs', action='store_true', default=False,
                        help='Files to import are diffs already (default: using original files)')
    parser.add_argument('--refresh', dest='refresh', action='store_true', default=False,
                        help='Refresh table and view structures (default: don''t refresh)')
    parser.add_argument('--wStatus', dest='wStatus', action='store_true', default=False,
                        help='Process with Status data (default: Process daily data)')
    parser.add_argument('--wStatusValidate', dest='wStatusValidate', action='store_true', default=False,
                        help='Validate dates in with Status data but do not process data (default: don''t validate dates)')
    parser.add_argument('--updateConfig', dest='updateConfig', action='store_true', default=False,
                        help='Refresh configuration in database (default: don''t refresh)')
    parser.add_argument('--outputErrorDF', dest='outputErrorDF', action='store_true', default=False,
                        help='Output dataframes that cause errors')
    parser.add_argument('--debug', dest='debug_flag', action='store_true', default=True,
                        help='Turn on debugging in logging output')
    parser.add_argument('--logging', dest='logger_level', default="INFO",
                        choices=['TRACE','DEBUG','INFO','SUCCESS','WARNING','ERROR','CRITICAL'],
                        help='Specify which level of logging to use in logging output')
    parser.add_argument('--path', dest='config_path', default=".",
                        help='Specify the path to the config.yml file')                    
                        
    args = parser.parse_args()

    writedb = args.writedb
    diffs = args.diffs
    refresh = args.refresh
    wStatusValidate = args.wStatusValidate
    wStatus = args.wStatus or args.wStatusValidate
    updateConfig = args.updateConfig
    outputErrorDF = args.outputErrorDF
    debug_flag = args.debug_flag
    cmd_log_level = 'DEBUG' if debug_flag else args.logger_level
    config_path = Path(args.config_path.replace('"','').strip()) / "config.yml"

    cfg = load_cfg(config_path)

    wStatus_suffix = "_wStatus" if wStatus else ""

    # These are some common variables the program needs throughout
    archive_path = cfg['ccdw']['archive_path' + wStatus_suffix]
    export_path = cfg['informer']['export_path' + wStatus_suffix]
    invalid_path = cfg['ccdw']['invalid_path_wStatus']
    log_path = cfg['ccdw']['log_path']
    prefix = cfg['informer']['prefix']

    cfg_log_level = cfg['ccdw']['log_level'].upper()
    logger_types = ['TRACE','DEBUG','INFO','SUCCESS','WARNING','ERROR','CRITICAL']
    if not cfg_log_level in logger_types:
        if cmd_log_level:
            logger_level = cmd_log_level
        else:
            logger_level = 'INFO'
    else:
        logger_idx = min([logger_types.index(i) for i in [cfg_log_level,cmd_log_level]])
        logger_level = logger_types[logger_idx]

    # Setup the new logger
    logger.remove()
    logger.add(os.path.join(log_path,f"log_{wStatus_suffix}_{{time}}.txt"),
               enqueue=True, 
               backtrace=True, 
               diagnose=True, 
               level=logger_level,
               rotation="20 MB")
    logger.debug( f"Arguments: writedb = [{writedb}], diffs = [{diffs}], refresh = [{refresh}], wStatus = [{wStatus}], updateConfig=[{updateConfig}]" )

    __local_cfg = { 'source'          : __source__,
                    'version'         : __version__,
                    'run_datetime'    : run_datetime,
                    'wStatus_suffix'  : wStatus_suffix,
                    'wStatusValidate' : wStatusValidate,
                    'outputErrorDF'   : outputErrorDF,
                    'logger'          : logger
                  }

    cfg.update( {'__local' : __local_cfg} )
       
    metaObj = CCDW_Meta(cfg)
    exportObj = CCDW_Export(cfg,metaObj)

    # Push the 'school' section of the configuration to SQL Server, if requested
    if updateConfig:
        logger.info("Update configuration")
        school = cfg['school']
        schooldf = pd.DataFrame(school, index = ['config'])
        schooldf.to_sql('config', exportObj.engine, flavor=None, schema='local', if_exists='replace',
                    index=False, index_label=None, chunksize=None)

    # Some files from Colleague have statuses with status dates. When building the database,
    # we will use special Informer reports to load the data. This block of code is used for that.
    if wStatus:
        
        pattern = r'{0}(?P<fnpat>.*)___.*|(?P<fnpat>.*)___.*'.format(prefix)

        # Some files have dates that are way out there. Let's mark as invalid those that are more than a year out
        invalid_date = pd.Timestamp(date.today() + timedelta(365))

        status_fields = cfg["status_fields"].copy()

        # # Extract just the date and time fields
        status_datetime_fields = {}
        date_regex = regex.compile(r'.*\.DATE$|.*\.TIME$')
        for key in status_fields.keys():
            fields = status_fields[key]
            status_datetime_fields[key] = [ f for f in fields if date_regex.match(f) ]

        # Cycle through all the files in the export folder
        for root, subdirs, files in os.walk(export_path):
            for file in files:
                with open(f"{root}/{file}", "r") as csvinput:
                    # We only want to process files that match the pattern for wStatus files
                    m = regex.match(pattern,file)
                    if m==None:
                        continue
                    fn = m.expandf("{fnpat}")

                    logger.debug(f"Processing {fn}...")

                    Audit_Key = exportObj.CreateTableAuditRecord( fn, file )
                    records = 0
                    error_flag = 'N'

                    # Read the file in and get the keys for this file
                    df = pd.read_csv(csvinput, encoding='ansi', dtype='str', engine='python', na_values=None, keep_default_na=False)
                    file_keys = metaObj.getKeyFields(fn.replace('_','.'))

                    # Get status and datetime fields for this file
                    df_status = status_fields[fn]
                    df_status_datetime = status_datetime_fields[fn]
                    df_status_only = set(df_status).symmetric_difference(set(df_status_datetime))

                    if len(df_status_datetime) == 0:
                        logger.error(f"No DATE/TIME/DATETIME fields found in {fn}")
                        continue

                    # Fill down the status fields so all status fields have a value            
                    for fld in df_status:
                        df[fld] = df.groupby(file_keys)[fld].ffill()

                    # If the date field is still blank (i.e., was never provided), set it
                    df[df_status_datetime[0]].fillna("1900-01-01", inplace=True)
                    df.loc[df[df_status_datetime[0]] == '',df_status_datetime[0]] = "1900-01-01"

                    # Create a new DataDatetime field using the date and time fields.
                    # If the time field is still blank, set it. If it is missing, set it.
                    if len(df_status_datetime)==2:
                        df[df_status_datetime[1]].fillna("00:00:00", inplace=True)
                        newDataDatetime = df[df_status_datetime[0]] + 'T' + df[df_status_datetime[1]]
                    else:
                        newDataDatetime = df[df_status_datetime[0]] + "T00:00:00"

                    # Make datetime variable an actual datetime instead of a string
                    df['DataDatetime']=pd.to_datetime(newDataDatetime)

                    # Keep the latest record of any duplicated rows by all columns except the status fields
                    df = df.drop_duplicates(set(df.columns).symmetric_difference(set(df_status_only)),keep='last')

                    # Sort by the DataDatetime
                    df.sort_values(by='DataDatetime')

                    # Define and create the directory for the INVALID output file
                    os.makedirs(invalid_path,exist_ok=True)

                    # Remove from the dataframe all rows with an invalid date
                    # Keep the status date/time fields as string, as that is what they are in the database
                    df_invalid = df[pd.to_datetime(df[df_status_datetime[0]])>invalid_date]
                    if len(df_invalid):
                        df_invalid.to_csv(f'{invalid_path}/{fn}_INVALID.csv')

                    table_records = 0

                    if not wStatusValidate:
                        df = df[pd.to_datetime(df[df_status_datetime[0]])<=invalid_date]

                        try:
                            # Now, group by the date field and create cumulative files for each date in the file
                            for d in sorted(df['DataDatetime'].dt.strftime("%Y-%m-%d").unique()): 
                                logger.debug(f"DataDatetime = {d}")
                                table_records = exportObj.executeSQL_UPDATE( fn, df.loc[df[df_status_datetime[0]] == d].groupby(file_keys,as_index=False).last(), Audit_Key )
                                #table_records = processfile(, fn, d)
                                if table_records == -1:
                                    error_flag = 'Y'
                                    break
                                else:
                                    records += table_records

                        except FileValidationError as er:
                            logger.error(f"Source: {er.source}, Validation: {er.validation}")
                            error_flag = 'Y'

                        except:
                            logger.error(f"---Error in file: {fn}")
                            error_flag = 'Y'

                logger.info(f".....closing file {file}")
                csvinput.close()

                if error_flag == 'N' and not wStatusValidate:
                    # Finally, archive the file in the archive folder if their were no exceptions processing the file.
                    logger.info(f".....archiving file {file}")
                    archive(df, "", file, archive_path, export_path, cfg, createInitial = True)
 
                exportObj.records += records
                exportObj.UpdateTableAuditRecord(Audit_Key,records,error_flag)

    else: # NOT wStatus
        logger.info("=========begin loop===========")

        # loops through each directory and subdirectory of the Informer export path and processes each file.
        for root, subdirs, files in os.walk(export_path):

            # This block processes each Colleague File's folder (ACAC_CREDENTIAL_1001, etc.)
            for subdir in subdirs:
                logger.info(f"Processing folder {subdir}...")

                # The COLLEAGUE file name is the directory name minus the version number at the end
                sqlName = subdir[:-5]

                # Get all the files in the folder
                filelist = sorted(glob.iglob(os.path.join(root, subdir, "*.csv")), key=os.path.getmtime)

                # This block processes each Colleague File export. These are exported each day as CSV files.
                for i in range(len(filelist)):
                    file = os.path.basename( filelist[i] )

                    logger.info(f"Processing file {file}...")
                    Audit_Key = exportObj.CreateTableAuditRecord( sqlName, file )
                    records = 0
                    error_flag = 'N'

                    # Reads in csv file then creates an array out of the headers
                    try:
                        inputFrame = pd.read_csv(os.path.join(root, subdir, file), encoding='ansi', dtype='str', na_values=None, keep_default_na=False, engine='python')
                        inputFrame = inputFrame.where(pd.notnull(inputFrame), None) # Keep only non-empty rows

                    # The most common error has been that there is an error in the Unicode so handle this
                    except UnicodeDecodeError as er:
                        logger.error(f"Error in File: \t {file}\n\n Error: {er}\n\n")
                        break

                    # Get a sorted list of a CSV file named as the file with the version added in the archive folder.
                    #     Example: For ACAD_CREDENTIALS_1001, look for ACAD_CREDENTIALS_1001.csv in the archive folder.
                    # We need to know if this is the first time this file is being processed.
                    # If it is not, this file is the shadow copy of the most recent records in the database.
                    archive_filelist = sorted(glob.iglob(os.path.join(archive_path, subdir, subdir + '_LF.csv')), key=os.path.getctime)

                    # Check if there are files in the archive folder and we are not already processing a 
                    #     diff file (and therefore, do not need to create another diff)
                    if (len(archive_filelist) > 0) and not diffs:
                        lastarchive_filename = os.path.basename( archive_filelist[-1] )
                        logger.debug(f"{timestamp()} LASTARCHIVE: {lastarchive_filename}")
                        archive_file = pd.read_csv( os.path.join(archive_path, subdir, lastarchive_filename), 
                                                    encoding='ansi', dtype='str', 
                                                    na_values=None, keep_default_na=False, engine='python' )

                        # Create a diff of the current datafram against the existing shadow copy
                        df = createDiff( inputFrame, archive_file )
                    else:
                        # No previous copy, so use the current dataframe
                        df = inputFrame

                    # If there is no DataDatetime column in the current dataframe, add one using the current date
                    if "DataDatetime" in df.columns:
                        pass
                    else:
                        df["DataDatetime"] = datetime.datetime.now()

                    if writedb:
                        # If there is data in the dataframe, try to write it to the database.
                        # If it fails, break out of the loop that is processing files in this folder.
                        if df.shape[0] > 0:
                            try:
                                logger.debug(f"{timestamp()} SQL_UPDATE: {file} with {df.shape[0]} rows")

                                records = exportObj.executeSQL_UPDATE( sqlName, df, Audit_Key ) 

                                logger.debug(f"{timestamp()} SQL_UPDATE: {file} with {records} rows [DONE]")

                            except FileValidationError as er:
                                logger.error(f"Source: {er.source}, Validation: {er.validation}")
                                error_flag = 'Y'

                            except:
                                logger.error(f"'---Error in file: {file} -- the folder will be skipped")
                                error_flag = 'Y'
        
                        else:
                            logger.debug(f"{timestamp()} SQL_UPDATE: No updated data for {file}")
                        
                    if error_flag == 'N':
                        # Finally, archive the file in the archive folder if their were no exceptions processing the file.
                        logger.debug(f"{timestamp()} Archive: {file}")
                        archive(df, subdir, file, archive_path, export_path, cfg, diffs = diffs)
                        logger.debug(f"{timestamp()} Archive: {file} [DONE]")
 
                    exportObj.records += records
                    exportObj.UpdateTableAuditRecord(Audit_Key,records,error_flag)
                        
                    logger.info(f"Processing file {file}...[DONE]")

                    if error_flag == 'Y':
                        break

                logger.info(f"Processing folder {subdir}...[DONE]")
        
    logger.info("DONE.")

@logger.catch
def createDiff( cf, lf ):
    if (lf.shape[0] == 0) | (cf.shape[0] == 0):
        return( cf )
        
    # Old version is last one archived
    lf['version'] = "old"

    # New version is the current one being processed
    cf['version'] = "new"

    #Join all the data together and ignore indexes so it all gets added
    full_set = pd.concat([lf, cf],ignore_index=True)

    # Get all column names except 'version' defined above into col_names
    # col_names = full_set.column.names - 'version'
    col_names = full_set[full_set.columns.difference(["DataDatetime", "version"])].columns

    # Let's see what changes in the main columns we care about, keep only new records
    changes = full_set.drop_duplicates(subset=col_names, keep=False)    
    changes = changes[(changes["version"] == "new")]

    #Drop the temp columns - we don't need them now
    changes = changes.drop(['version'], axis=1)
    
    return( changes )

# archive() - Archives files after they are processed
@logger.catch
def archive(df, subdir, file, archive_path, export_path, cfg, diffs = True, createInitial = True):

    # ig_f() - Used to find files to be ignored when copying the dir tree
    def ig_f(dir, files):
        return [f for f in files if os.path.isfile(os.path.join(dir, f))]

    # Create the path in the archive based on the location of the CSV
    if not os.path.isdir(os.path.join(archive_path, subdir)):
        shutil.copytree(os.path.join(export_path, subdir),os.path.join(archive_path,subdir), ignore=ig_f)

    if cfg['ccdw']['archive_type'] == 'zip':
        if not os.path.isfile(os.path.join(archive_path, subdir, file)):
            try:
                # Create a zip'd version of the CSV
                zFi = zipfile.ZipFile(os.path.join(export_path,subdir,(file[:-4]+'.zip')), 'w', zipfile.ZIP_DEFLATED)
                zFi.write(os.path.join(export_path, subdir, file), file)
                zFi.close()

                # Move the zip file to the archive location
                shutil.move(os.path.join(export_path, subdir, (file[:-4]+'.zip')), os.path.join(archive_path, subdir, (file[:-4]+'.zip')))

                # Remove the CSV file from the export folder
                os.remove(os.path.join(export_path, subdir, file)) # comment this out if you want to keep files
            except:
                raise
    else:
        if cfg['ccdw']['archive_type'] == 'move':
            old_archive_file = glob.glob(os.path.join(archive_path, subdir, '*_LF.csv'))

            if diffs:
                shutil.move(os.path.join(export_path, subdir, file), os.path.join(archive_path, subdir, file))
            else:
                # Move the file to the archive location
                shutil.move(os.path.join(export_path, subdir, file), os.path.join(archive_path, subdir, file[:-4] + '_LF.csv'))
                df.to_csv( os.path.join(archive_path, subdir, file), index = False, date_format="%Y-%m-%dT%H:%M:%SZ" )

            if (len(old_archive_file) > 0):
                os.remove(old_archive_file[0])


if __name__ == '__main__': 
    ccdw()