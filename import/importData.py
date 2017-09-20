import os
import glob
import sys
import yaml
import pandas as pd
import pathlib
import numpy as np
import datetime
import argparse

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
args = parser.parse_args()

writedb = args.writedb
diffs = args.diffs
refresh = args.refresh

export_path = cfg['informer']['export_path']
archive_path = cfg['informer']['archive_path']
log_path = cfg['informer']['log_path']

log = open(os.path.join(log_path,"log_{0}.txt".format( run_datetime )), "w", 1)

print( "Arguments: writedb = [{0}], diffs = [{1}], refresh = [{2}]".format( writedb, diffs, refresh ) )
log.write( "Arguments: writedb = [{0}], diffs = [{1}], refresh = [{2}]\n".format( writedb, diffs, refresh ) )

# Import local packages
import meta
import export

engine = export.engine(cfg['sql']['driver'], cfg['sql']['server'], cfg['sql']['db'], cfg['sql']['schema'])

if refresh:
    meta.loadLookupList(refresh)

kList, dTypes, aTypes, aNames, typers = meta.getDataTypes()

# !!!
# !!! Needs to check for existence of schemas before trying to create any tables
# !!!

print('=========begin loop===========')
#loops through each directory and subDirectory pass by each file.
for root, subdirs, files in os.walk(export_path):
    sys.stdout.flush()

    for subdir in subdirs:
        print('\tProcessing folder ' + subdir + '...')

        filelist = sorted(glob.iglob(os.path.join(root, subdir, '*.csv')), key=os.path.getmtime)

        for i in range(len(filelist)):
            file = os.path.basename( filelist[i] )

            # for file in sorted(files, key=export.numericalSort):
            print("\t\tProcessing file " + file + "...")

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
                    del aNamesr[k]
                    del aTypesr[k]
                    del typersr[k]
            for k, v in list(kLister.items()):
                if v != 'K':
                    del kLister[k]

            sqlName = subdir[:-5]

            archive_filelist = sorted(glob.iglob(os.path.join(archive_path, subdir, subdir + '.csv')), key=os.path.getctime)
            if (len(archive_filelist) > 0) and not diffs:
                lastarchive_filename = os.path.basename( archive_filelist[-1] )
                print("\t\t\t{0} LASTARCHIVE: {1}".format( timestamp(), lastarchive_filename ))
                #log.write("{0} SQL_UPDATE: {1} with {2} rows\n".format( timestamp(), file, df.shape[0] ))
                archive_file = pd.read_csv( os.path.join(archive_path, subdir, lastarchive_filename), 
                                            encoding='ansi', dtype='str', 
                                            na_values=None, keep_default_na=False )

                df = export.createDiff( inputFrame, archive_file )
            else:
                df = inputFrame

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

            export.archive(df, subdir, file, export_path, archive_path, diffs)

            print("\t\t\t{0} Archive: {1} [DONE]\n".format( timestamp(), file ))
            log.write("{0} Archive: {1} [DONE]\n".format( timestamp(), file ))
            #else:
            #    print( "\t\t\t...no data to save" )
                
            print("\t\t\t...Done")        
    
print("DONE!!!!")