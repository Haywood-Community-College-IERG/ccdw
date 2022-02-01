import argparse
import datetime 
import os
import pandas as pd
import shutil
import time
import yaml

parser = argparse.ArgumentParser(description="Copy CCDW stage data for a particular date")
parser.add_argument(
    "--date",
    dest="copy_file_date",
    action="store",
    default="",
    required=True,
    help="Date to use for copying data from stage data to data folder",
)
args = parser.parse_args()
copy_file_date = args.copy_file_date

print(f"Copying data from stage data folder to data folder for {copy_file_date}")

#os.chdir("..\\..")

with open("config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)

export_path = cfg['informer']['export_path']
stage_path = cfg['informer']['stage_path']

print(f"Using stage_path={stage_path}, export_path={export_path}")

# ig_f() - Used to find files to be ignored when copying the dir tree
def ig_f(dir, files):
    return [f for f in files if os.path.isfile(os.path.join(dir, f))]


for root, subdirs, files in os.walk(stage_path):
    for file in files:
        file_mtime = time.strftime( '%Y-%m-%d', time.localtime(os.path.getmtime(root + '/' + file)))
        data_folder = root.split('/')[-1]

        if file_mtime == copy_file_date:
            print( f"{file},{data_folder},{file_mtime}" )

            # Create the path in the archive based on the location of the CSV
            if not os.path.isdir(os.path.join(export_path, data_folder)):
                shutil.copytree(
                    os.path.join(stage_path, data_folder),
                    os.path.join(export_path, data_folder),
                    ignore=ig_f,
                )

            # Now, move the file to the data folder
            shutil.move(
                os.path.join(stage_path, data_folder, file),
                os.path.join(export_path, data_folder, file),
            )
