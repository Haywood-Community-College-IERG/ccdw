@ECHO OFF

setLocal EnableDelayedExpansion

REM Get currently set branch if none provided by caller
if "%~1"=="" (
    For /f %%i in ('git rev-parse --abbrev-ref HEAD') do set "branch_name=%%i"
) ELSE (set "branch_name=%~1")

if "%~1"=="" (
    echo Using branch %branch_name%
)

git config branch.%branch_name%.syncCommitMsg "Changes from $(uname -n) on $(date +%%F) [$(date +%%a)] at $(date +%%T)"
git config --bool branch.%branch_name%.sync true