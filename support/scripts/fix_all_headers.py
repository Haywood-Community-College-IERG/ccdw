#! /usr/bin/python3
import os
from pathlib import Path
import subprocess
import pandas as pd

data_path = Path("./data")
data_wStatus_path = Path("./data___wStatus")

corrections = {
    "ACAD_REQMT_BLOCKS_1001" : "{'ACRB.MIN.NO.LEVEL.COURSES.LEVELS':'ACRB.NO.LEVEL.COURSES.LEVELS'}",
    "APPLICATION_STATUSES_1001" : "{'APPS.USER9 ':'APPS.USER9', 'APPS.USER7 ':'APPS.USER7', 'APPLICATION.STATUSES.CHGDATE ':'APPLICATION.STATUSES.CHGDATE', 'APPS.USER5 ':'APPS.USER5', 'APPS.USER10 ':'APPS.USER10', 'APPS.USER3 ':'APPS.USER3', 'APPS.USER4 ':'APPS.USER4', 'APPS.USER2 ':'APPS.USER2', 'APPS.USER8 ':'APPS.USER8', 'APPS.USER6 ':'APPS.USER6'}",
    "AWARDS_1001" : "{'AW.DI.LOAN..TYPE':'AW.DL.LOAN.TYPE'}",
    "CALENDAR_SCHEDULES_1001" : "{'CALS.START.TIME ' : 'CALS.START.TIME'}",
    "CRED_TYPES_1001" : "{'CRTP.USER9 ':'CRTP.USER9', 'CRTP.USER6 ':'CRTP.USER6', 'CRTP.USER8 ':'CRTP.USER8', 'CRTP.USER5 ':'CRTP.USER5', 'CRTP.USER7 ':'CRTP.USER7', 'CRTP.USER4 ':'CRTP.USER4', 'CRTP.USER10 ':'CRTP.USER10'}",
    "ELF_TRANSLATE_TABLES_1001" : "{'ELF.ACTION.CODES.1':'ELFT.ACTION.CODES.1','ELF.ACTION.CODES.2':'ELFT.ACTION.CODES.2','ELF.ACTION.CODES.3':'ELFT.ACTION.CODES.3','ELF.ACTION.CODES.4':'ELFT.ACTION.CODES.4'}",
    "FA_TRANSMITTALS_1001" : "{'FA.TA.TERM.LOAN.FEES':'FAX.TA.TERM.LOAN.FEES','FAX.GI.REFERENCE.NO':'FAX.GL.REFERENCE.NO','FAX.TA.DEXCESS.XMIT.AMT':'FAX.TA.D7.EXCESS.XMIT.AMT'}",
    "FOREIGN_PERSON_1001" : "{'FPER.PASSPORT.NUMBER':'FPER.PASSPORT.NO'}",
    "META__CF_VALCODES_1001" : "{'VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    # Can't fix META__CORE_VALCODES_1001 due to unicode characters
    # "META__CORE_VALCODES_1001" : "{'VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    "META__HR_VALCODES_1001" : "{'VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    "META__ST_VALCODES_1001" : "{'VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    "META__TOOL_VALCODES_1001" : "{'Val Zero Fill ':'VAL.ZERO.FILL','VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    "META__UT_VALCODES_1001" : "{'VAL.ACTION.CODE.1 ':'VAL.ACTION.CODE.1','VAL.ACTION.CODE.2 ':'VAL.ACTION.CODE.2','VAL.ACTION.CODE.3 ':'VAL.ACTION.CODE.3','VAL.ACTION.CODE.4 ':'VAL.ACTION.CODE.4'}",
    "PAC_LOAD_PERIODS_1001" : "{'PLP.PAC.LP.POSTION.ID':'PLP.PAC.LP.POSITION.IDS','PAC.LOAD.PERIOD.CHGDATE':'PAC.LOAD.PERIODS.CHGDATE','PAC.LOAD.PERIOD.ADDOPR':'PAC.LOAD.PERIODS.ADDOPR','PAC.LOAD.PERIOD.CHGOPR':'PAC.LOAD.PERIODS.CHGOPR'}",
    "PERPOSWG_1002" : "{'PPWG.IPEDS.CONTRACT.TYPE ':'PPWG.IPEDS.CONTRACT.TYPE','PPWG.PAY.CYCLE.ID':'PPWG.PAYCYCLE.ID'}",
    "PERPOSWG_1003" : "{'PPWG.IPEDS.CONTRACT.TYPE ':'PPWG.IPEDS.CONTRACT.TYPE','PPWG.PAY.CYCLE.ID':'PPWG.PAYCYCLE.ID'}",
    "PERPOSWG_1004" : "{'PPWG.IPEDS.CONTRACT.TYPE ':'PPWG.IPEDS.CONTRACT.TYPE','PPWG.PAY.CYCLE.ID':'PPWG.PAYCYCLE.ID'}",
    "PERSON_1001" : "{'VETERAN.TYPE2.DESCRIPTION':'VETERAN.TYPE.DESCRIPTION'}",
    "PERSON_1002" : "{'VETERAN.TYPE2.DESCRIPTION':'VETERAN.TYPE.DESCRIPTION'}",
    "PERSON_1003" : "{'VETERAN.TYPE2.DESCRIPTION':'VETERAN.TYPE.DESCRIPTION'}",
    "PERSON_1004" : "{'VETERAN.TYPE2.DESCRIPTION':'VETERAN.TYPE.DESCRIPTION'}",
    "POSPAY_1001" : "{'POSPAY.POSTYPE.ID':'POSPAY.POSETYPE.ID'}",
    "SAP_RESULTS_1001" : "{'SAP.TRM.CMPL.CRED':'SAPR.TRM.CMPL.CRED'}",
    "SOC_CODES_1001" : "{'SOC.FORMER.DESCS.1':'XXXX_FORMER_DESC_XXXX','SOC.FORMER.DESCS':'SOC.FORMER.CODES','XXXX_FORMER_DESC_XXXX':'SOC.FORMER.DESCS'}",
    "XCE_ICR_1001" : "{'XCE.COUNTRY':'XCE.COUNTY','XCE.CEPS.HOURS':'XCE.CEBS.HOURS'}",
    "XLE_STUDENTS_1001" : "{'XLS.AHS.COMPLETE':'XLE.AHS.COMPLETE'}",

}

col_deletions = {
    "FOREIGN_PERSON_1001" : ["QBSEC","FPER.HOME.LANG.SCH.COUNTRY","FPER.HOME.LANG.SCH.NO.YRS"],
    "STUDENT_NON_COURSES_1002" : ["STNC.CATEGORY.1"]
}

row_deletions = {
    "INSTITUTIONS_ATTEND_1001" : "`INSTA.INSTITUTIONS.ID` == ''",
    "INSTITUTIONS_ATTEND_1002" : "`INSTA.INSTITUTIONS.ID` == ''",
    "STUDENT_ACAD_LEVELS_1001" : "`STA.ACAD.LEVEL` == ''",
    "STUDENT_PROGRAMS_1001" : "`STPR.STUDENT` == '' or `STPR.ACAD.PROGRAM` == ''",
    "STUDENT_PROGRAMS_1002" : "`STPR.STUDENT` == '' or `STPR.ACAD.PROGRAM` == ''"
}

row_deletions_wStatus = {
    "STUDENT_PROGRAMS___wStatus_1001.csv" : "`STPR.STUDENT` == '' or `STPR.ACAD.PROGRAM` == ''"
}

for key in corrections.keys():
    folder_path = data_path / key

    Python_Path = "C:/Python/Miniconda3/python.exe"
    Script_Path = "./fix_headers.py"
    cmd = f'{Python_Path} {Script_Path} --filefolder={folder_path} --headers="{corrections[key]}"'
    print(f"Processing {key} for correction")
    try:
        status = subprocess.call(cmd, shell=True)
    except:
        print(f"Error in file {folder_path}")
    #print(cmd)

for key in col_deletions.keys():
    folder_path = data_path / key

    print(f"Processing {key} for column removal")

    for root, subdirs, files in os.walk(folder_path):
    #print(f"Found directory {root}")

        for fname in files:
            file = folder_path / fname

            date_time = os.path.getmtime(file)

            df = pd.read_csv(file,encoding='ansi',dtype='str',engine='python',na_values=None, keep_default_na=False)

            try:
                df.drop(col_deletions[key],axis=1,inplace=True)
                df.to_csv(file,index=False)
                del df

                # Fix the datetime back to the original value
                os.utime(file, (date_time, date_time))
            except:
                print(f"Processing {key} for column removal - FAILED")
                break

for key in row_deletions.keys():
    folder_path = data_path / key

    print(f"Processing {key} for row removal")

    for root, subdirs, files in os.walk(folder_path):
    #print(f"Found directory {root}")

        for fname in files:
            file = folder_path / fname

            date_time = os.path.getmtime(file)

            df = pd.read_csv(file,encoding='ansi',dtype='str',engine='python',na_values=None, keep_default_na=False)

            try:
                indices = df.query(row_deletions[key]).index
                df.drop(indices,inplace=True)
                df.to_csv(file,index=False)
                del df

                # Fix the datetime back to the original value
                os.utime(file, (date_time, date_time))
            except:
                print(f"Processing {key} for row removal - FAILED")
                break

for key in row_deletions_wStatus.keys():
    file = data_wStatus_path / key

    print(f"Processing {key} for row removal (wStatus)")

    date_time = os.path.getmtime(file)

    df = pd.read_csv(file,encoding='ansi',dtype='str',engine='python',na_values=None, keep_default_na=False)

    try:
        indices = df.query(row_deletions_wStatus[key]).index
        df.drop(indices,inplace=True)
        df.to_csv(file,index=False)
        del df

        # Fix the datetime back to the original value
        os.utime(file, (date_time, date_time))
    except:
        print(f"Processing {key} for row removal (wStatus) - FAILED")
        break
