@ECHO OFF
REM Need server name as first argument

IF %1.==. (
    SET ServerName=localhost
    ECHO Using %ServerName%
) else (
    if [%1]==[?] (
        GOTO Help   
    )
    SET ServerName=%1
)

ECHO Setting up initial database
SQLCMD -S %ServerName% -Q "CREATE DATABASE CCDW_HIST"
SQLCMD -S %ServerName% -i sql\Create_Schemas.sql > NUL
SQLCMD -S %ServerName% -i sql\dw_util.DelimitedSplit8K.sql > NUL
SQLCMD -S %ServerName% -i sql\dw_util.GetEasterHolidays.sql > NUL
SQLCMD -S %ServerName% -i sql\dw_util.Update_Date.sql > NUL
SQLCMD -S %ServerName% -i sql\dw_dim.Audit_Dimension.sql > NUL

ECHO Recreate the necessary folders
CALL .\Create_Folder.bat 

GOTO End

:Help
ECHO Must specify a server name (e.g. localhost)

:End