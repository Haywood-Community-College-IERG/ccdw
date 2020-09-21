import os
from pathlib import Path
import shutil
import glob
import time
import yaml
import argparse
import fileinput

#
# Example Call:
#
#  python .\fix_headers.py --filefolder=.\t --headers="{'PLP.PAC.LP.POSTION.IDS':'PLP.PAC.LP.POSITION.IDS'}" --debug=True
# 

parser = argparse.ArgumentParser(description="Fix headers on CCDW data")
parser.add_argument('--filefolder', dest='filefolder', default="",help="Name of file to correct")
parser.add_argument('--headers', dest='headers', type=yaml.full_load, default={},help="Dictionary of old headers to new headers")
parser.add_argument('--debug', dest='debug',default=False,help='Turn on debug flag')

args = parser.parse_args()

hdr_dict = args.headers
filefolder = args.filefolder
debug = args.debug

filefolder_path = Path(filefolder)

for root, subdirs, files in os.walk(filefolder_path):
    if debug:
        print(f"Found directory {root}")

    for fname in files:
        file = filefolder_path / fname

        # Get the datetime of file to restore after update
        #date_time = time.mktime(fname.date_time + (0, 0, -1))
        date_time = os.path.getmtime(file)

        if debug:
            print(f"Processing {file=}")

        # Update headers
        with fileinput.input(str(file), inplace=True) as f:
            for line in f:
                if fileinput.isfirstline():
                    for key in hdr_dict.keys():
                        line = line.replace(key,hdr_dict[key])
                    print(line, end='')
                else:
                    print(line, end='')
            
        # Fix the datetime back to the original value
        os.utime(file, (date_time, date_time))

            