@ECHO OFF

MD ..\archive 2> NUL
MD ..\error 2> NUL

MD ..\archive\wStatus 2> NUL
MD ..\archive\wStatus_INVALID 2> NUL
MD ..\log 2> NUL

REM If local install, need these as well.
MD ..\data 2> NUL
MD ..\meta 2> NUL
