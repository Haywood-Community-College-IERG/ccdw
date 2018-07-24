import os
import glob
import sys
import yaml
import pandas as pd
import pathlib
import numpy as np
import datetime
import argparse
import regex
from datetime import date, timedelta

global writedb
global diffs
global refresh
global log

run_datetime = datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S%f")
def timestamp():
    return( datetime.datetime.now().isoformat() )

with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

parser = argparse.ArgumentParser(description='Import CCDW data')
parser.add_argument('--nodb', dest='writedb', action='store_false', default=True,
                    help='Do not write to database (default: write to database)')
parser.add_argument('--diffs', dest='diffs', action='store_true', default=False,
                    help='Files to import are diffs already (default: using original files)')
parser.add_argument('--refresh', dest='refresh', action='store_true', default=False,
                    help='Refresh table and view structures (default: don''t refresh)')
parser.add_argument('--wStatus', dest='wStatus', action='store_true', default=False,
                    help='Refresh table and view structures (default: don''t refresh)')
parser.add_argument('--updateConfig', dest='updateConfig', action='store_true', default=False,
                    help='Refresh configuration in database (default: don''t refresh)')
args = parser.parse_args()

writedb = args.writedb
diffs = args.diffs
refresh = args.refresh
wStatus = args.wStatus
updateConfig = args.updateConfig

wStatus_suffix = "_wStatus" if wStatus else ""

export_path = cfg['informer']['export_path' + wStatus_suffix]
archive_path = cfg['informer']['archive_path' + wStatus_suffix]
log_path = cfg['informer']['log_path']

prefix = cfg['informer']['prefix']

log = open(os.path.join(log_path,"log_{0}{1}.txt".format( run_datetime, wStatus_suffix )), "w", 1)

print( "Arguments: writedb = [{0}], diffs = [{1}], refresh = [{2}], wStatus = [{3}], updateConfig=[{4}]".format( writedb, diffs, refresh, wStatus, updateConfig ) )
log.write( "Arguments: writedb = [{0}], diffs = [{1}], refresh = [{2}], wStatus = [{3}], updateConfig=[{4}]\n".format( writedb, diffs, refresh, wStatus, updateConfig ) )
    
# Import local packages
import meta
import export

engine = export.engine(cfg['sql']['driver'], cfg['sql']['server'], cfg['sql']['db'], cfg['sql']['schema'])

if refresh:
    meta.loadLookupList(refresh)

kList, dTypes, aTypes, aNames, typers = meta.getDataTypes()

if updateConfig:
    print("Update configuration")
    log.write("Update configuration")
    school = cfg['school']
    schooldf = pd.DataFrame(school, index = ['config'])
    schooldf.to_sql('config', engine, flavor=None, schema='local', if_exists='replace',
                 index=False, index_label=None, chunksize=None)

if wStatus:
    invalid_path = cfg['informer']['invalid_path_wStatus']
    
    pattern = r'{0}(?P<fnpat>.*)___.*|(?P<fnpat>.*)___.*'.format(prefix)

    # Some files have dates that are way out there. Let's mark as invalid those that are more than a year out
    invalid_date = date.today() + timedelta(365)

    # All the status fields in association with one another
    status_fields = { 
            'ACAD_PROGRAMS'     : ['ACPG.STATUS', 'ACPG.STATUS.DATE'],
            'APPLICATIONS'      : ['APPL.STATUS', 'APPL.STATUS.DATE', 'APPL.STATUS.TIME'],
            'COURSES'           : ['CRS.STATUS',  'CRS.STATUS.DATE'],
            'STUDENT_ACAD_CRED' : ['STC.STATUS',  'STC.STATUS.DATE',  'STC.STATUS.TIME', 'STC.STATUS.REASON'],
            'STUDENT_PROGRAMS'  : ['STPR.STATUS', 'STPR.STATUS.DATE', 'STPR.STATUS.CHGOPR'],
            'STUDENT_TERMS'     : ['STTR.STATUS', 'STTR.STATUS.DATE']
        }

    # Extract just the date and time fields
    status_datetime_fields = {}
    date_regex = regex.compile('.*\.DATE$|.*\.TIME$')
    for key in status_fields.keys():
        fields = status_fields[key]
        status_datetime_fields[key] = [ f for f in fields if date_regex.match(f) ]

    def processfile(df, fn, d):
        print("Updating fn = "+fn+", d = "+d)
        columnHeaders = list(df.columns.values)
        columnArray = np.asarray(columnHeaders)

        # dTyper is a dictionary of Columns and their types to be passed to executeSQL_UPDATE
        dTyper = {k: dTypes[k] for k in dTypes.keys() & columnArray}
        # kLister is a dictionary of keys to be passed to executeSQL_UPDATE
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

        try:
            # export.executeSQL_UPDATE(engine, df, fn, dTyper, kLister, log)
            export.executeSQL_UPDATE(engine, df, fn, dTyper, kLister, aTypesr, aNamesr, typersr, log)

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

                df = pd.read_csv(csvinput,encoding='ansi',dtype='str')
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

            print(".....closing file "+file)
            csvinput.close()

            print(".....archiving file "+file)
            export.archive(df, "", file, export_path, archive_path, log, createInitial = True)

else: # NOT wStatus
    # !!!
    # !!! Needs to check for existence of schemas before trying to create any tables
    # !!!

    print('=========begin loop===========')
    #loops through each directory and subDirectory pass by each file.
    for root, subdirs, files in os.walk(export_path):
        sys.stdout.flush()

        for subdir in subdirs:
            print('\tProcessing folder ' + subdir + '...')
            log.write('Processing folder ' + subdir + '...\n')

            filelist = sorted(glob.iglob(os.path.join(root, subdir, '*.csv')), key=os.path.getmtime)

            for i in range(len(filelist)):
                file = os.path.basename( filelist[i] )

                # for file in sorted(files, key=export.numericalSort):
                print("\t\tProcessing file " + file + "...")
                log.write("Processing file " + file + "...\n")

                #reads in csv file then creates an array out of the headers
                try:
                    inputFrame = pd.read_csv(os.path.join(root, subdir, file), encoding='ansi', dtype='str', na_values=None, keep_default_na=False)
                    inputFrame = inputFrame.where(pd.notnull(inputFrame), None)
                    columnArray = np.asarray(list(inputFrame))

                except UnicodeDecodeError as er:
                    print ("\t\t\tERROR Reading File - ["+str(er.args[0])+"]" )
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
                        #print("Deleting {0} from aNamesr, aTypesr, and typersr".format(k))
                        del aNamesr[k]
                        del aTypesr[k]
                        del typersr[k]

                for k, v in list(kLister.items()):
                    if v != 'K':
                        #print("Deleting {0} from kLister".format(k))
                        del kLister[k]

                sqlName = subdir[:-5]

                archive_filelist = sorted(glob.iglob(os.path.join(archive_path, subdir, subdir + '.csv')), key=os.path.getctime)
                if (len(archive_filelist) > 0) and not diffs:
                    lastarchive_filename = os.path.basename( archive_filelist[-1] )
                    print("\t\t\t{0} LASTARCHIVE: {1}".format( timestamp(), lastarchive_filename ))
                    log.write("{0} LASTARCHIVE: {1}\n".format( timestamp(), lastarchive_filename ))
                    #log.write("{0} SQL_UPDATE: {1} with {2} rows\n".format( timestamp(), file, df.shape[0] ))
                    archive_file = pd.read_csv( os.path.join(archive_path, subdir, lastarchive_filename), 
                                                encoding='ansi', dtype='str', 
                                                na_values=None, keep_default_na=False )

                    df = export.createDiff( inputFrame, archive_file )
                else:
                    df = inputFrame

                if 'DataDatetime' in df.columns:
                    pass
                else:
                    df['DataDatetime'] = datetime.datetime.now()

                if writedb:
                    #attempts to execute code catching any errors that may arrise then breaks out of loop of folder    
                    if df.shape[0] > 0:
                        try:
                            print("\t\t\t{0} SQL_UPDATE: {1} with {2} rows".format( timestamp(), file, df.shape[0] ))
                            log.write("{0} SQL_UPDATE: {1} with {2} rows\n".format( timestamp(), file, df.shape[0] ))

                            export.executeSQL_UPDATE(engine, df, sqlName, dTyper, kLister, aTypesr, aNamesr, typersr, log)

                            print("\t\t\t{0} SQL_UPDATE: {1} with {2} rows [DONE]".format( timestamp(), file, df.shape[0] ))
                            log.write("{0} SQL_UPDATE: {1} with {2} rows [DONE]\n".format( timestamp(), file, df.shape[0] ))
                        except:
                            print('\t\t\t---Error in file: %s the folder will be skipped' % file)
                            log.write('---Error in file: %s the folder will be skipped\n' % file)
                            break
                    else:
                        print("\t\t\t{0} SQL_UPDATE: No updated data for {1}".format( timestamp(), file ))
                        log.write("{0} SQL_UPDATE: No updated data for {1}\n".format( timestamp(), file ))
                    
                #archives the files in another directory if their are no exceptions
                print("\t\t\t{0} Archive: {1}".format( timestamp(), file ))
                log.write("{0} Archive: {1}\n".format( timestamp(), file ))

                export.archive(df, subdir, file, export_path, archive_path, log, diffs = diffs)

                print("\t\t\t{0} Archive: {1} [DONE]\n".format( timestamp(), file ))
                log.write("{0} Archive: {1} [DONE]\n".format( timestamp(), file ))
                    
                print("\t\tProcessing file " + file + "...[DONE]")
                log.write("Processing file " + file + "...[DONE]\n")

            print('\tProcessing folder ' + subdir + '...[DONE]')
            log.write('Processing folder ' + subdir + '...[DONE]\n')
    
print("DONE!!!!")
log.write("DONE.\n")