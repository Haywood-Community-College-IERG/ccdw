import os
import yaml
import pandas as pd
import datetime 
import time

with open("..\..\import\config.yml","r") as ymlfile:
    cfg = yaml.load(ymlfile)

export_path = cfg['informer']['export_path']

#print('FILE,FILESIZE,TIMESTAMP')
df = pd.DataFrame( { 'FILE' : [],
                     'FILESIZE' : [],
                     'TIMESTAMP' : [] 
                    } )

for root, subdirs, files in os.walk(export_path):
    for file in files:
        file_size = os.path.getsize(root + '/' + file)
        file_ctime = time.strftime( '%Y-%m-%dT%H:%M:%S', time.localtime(os.path.getctime(root + '/' + file)))
        # print( f"{root.split('/')[-1]},{file_size},{file_ctime}" )
        df = df.append( { 'FILE' : root.split('/')[-1],
                          'FILESIZE' : int(file_size),
                          'TIMESTAMP' : file_ctime }, ignore_index=True )

today = datetime.datetime.now()
today_str = today.strftime( '%Y-%m-%d' )
scriptname = os.path.splitext( os.path.basename(__file__) )[0]

df.loc[:, 'FILESIZE'] = df['FILESIZE'].apply(int) #convert A to an int

df.to_csv( f'{scriptname}_report_{today_str}.csv', index=False )