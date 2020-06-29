import os
from pathlib import Path
import shutil

data_root = "data\\"


for root, subdirs, files in os.walk(data_root):
    #print(f"Found directory {root}")

    for subdir in subdirs:
        fname = os.path.join(root,subdir,f"{subdir}.csv")

        if os.path.exists(fname):
            print(f"Deleting {fname}")
            os.remove (fname)
