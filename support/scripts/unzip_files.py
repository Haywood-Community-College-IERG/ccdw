import os
from pathlib import Path
import shutil
import glob
import time
from zipfile import ZipFile

data_root = "data\\"
dest_root = "zip\\"


for root, subdirs, files in os.walk(data_root):
    print(f"Found directory {root}")

    for fname in files:
        if fname.lower().endswith(".zip"):
            full_path = os.path.join(root,fname)
            dest_path = root.replace(data_root,dest_root)

            print(f"    Extracting files from {full_path}")
            with ZipFile(full_path,'r') as zipObj:
                zipObj.extractall(path=root)

                for f in zipObj.infolist():
                    # path to this extracted f-item
                    fullpath = os.path.join(root, f.filename)
                    # still need to adjust the dt o/w item will have the current dt
                    date_time = time.mktime(f.date_time + (0, 0, -1))
                    # update dt
                    os.utime(fullpath, (date_time, date_time))

            Path(dest_path).mkdir(parents=True, exist_ok=True)

            shutil.move(full_path, dest_path)
            print(f"    ...moving to {dest_path}")
            