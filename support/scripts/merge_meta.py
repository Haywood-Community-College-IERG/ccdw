import os
import fileinput
from pathlib import Path
import pandas as pd
import glob

merge_custom = True #and False

meta_path = Path("../../meta")

all_files = glob.glob(os.path.join(meta_path, "*_CDD*csv"))
df_from_each_file = (pd.read_csv(f,encoding = "ansi", dtype="str", index_col=0) for f in all_files)
all_meta = pd.concat(df_from_each_file)

if merge_custom:
    meta_custom_csv = pd.read_csv(Path("../../META__CUSTOM_CDD.csv"),encoding = "ansi", dtype="str", index_col=0)
    all_meta = all_meta.append(meta_custom_csv)
    
all_meta.index.rename("DATA.ELEMENT",inplace=True)
all_meta.reset_index(inplace=True)
all_meta = all_meta.drop_duplicates(subset="DATA.ELEMENT", keep="last")
all_meta = all_meta.where(pd.notnull(all_meta), None)
all_meta.sort_values(by="DATA.ELEMENT",inplace=True)
all_meta.set_index("DATA.ELEMENT",inplace=True)

all_meta.to_csv("./all_meta.csv")