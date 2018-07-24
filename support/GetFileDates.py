import os
#import glob
#import sys
import yaml
#import pandas as pd
#import pathlib
#import numpy as np
from datetime import date
#from datetime 
import time

with open("..\import\config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

export_path = cfg['informer']['export_path']

print('FILE,FILESIZE,TIMESTAMP')

for root, subdirs, files in os.walk(export_path):
    for file in files:
        file_size = os.path.getsize(root + '/' + file)
        file_ctime = time.strftime( '%Y-%m-%dT%H:%M:%S', time.localtime(os.path.getctime(root + '/' + file)))
        print( f"{root.split('/')[2]},{file_size},{file_ctime}" )
