#! /usr/bin/python3
import os
from pathlib import Path
import shutil
import glob
import time
from zipfile import ZipFile
import yaml
import argparse
import fileinput
import regex as re

parser = argparse.ArgumentParser(description="Fix times on CCDW data")
parser.add_argument('--folder', dest='folder', default="./data",help="Name of file to correct")
parser.add_argument('--filefolder', dest='filefolder', default="",help="Name of file to correct")
parser.add_argument('--datepattern', dest='datepattern', default=r".*_([0-9][0-9]?)_([0-9][0-9]?)_([12][0-9][0-9][0-9]).*", help="File name pattern for date values")
parser.add_argument('--dayoffset', dest='dayoffset', default=1, help="Correct the day of the month")

args = parser.parse_args()

datepattern = args.datepattern
folder = args.folder
filefolder = args.filefolder
dayoffset = args.dayoffset

def process_filefolder( filefolder_path ):
    for root, subdirs, files in os.walk(filefolder_path):
        #print(f"Found directory {root}")

        for fname in files:
            file = filefolder_path / fname

            # Get the datetime of file to restore after update
            #date_time = time.mktime(fname.date_time + (0, 0, -1))
            #date_time = os.path.getmtime(file)

            date_time_regex = re.match(datepattern, str(file))
            date_time = time.mktime( (int(date_time_regex[3]), int(date_time_regex[1]), int(date_time_regex[2])+dayoffset, 0, 0, 0, 0, 0, -1) )

            print(f"Fixing file {file} with datetime {time.asctime(time.localtime(date_time))}")
            # Fix the datetime back to the original value
            os.utime(file, (date_time, date_time))

if folder != "":
    folder_path = Path(folder)

    for root, subdirs, files in os.walk(folder_path):
        if Path(root) != folder_path:
            print(f"Found directory {root}")
            process_filefolder( Path(root) )
 
else:
    process_filefolder( Path(filefolder) )
