# To setup CCDW

1. Clone Existing Repository

    Using Tortoise GIT, right click in the folder where you want the CCDW folder created.
    Choose Git Clone... from the menu and enter the URL below into the URL field. Leave 
    all other defaults as they are.
 
    URL: https://github.com/haywood-ierg/ccdw
 
    The folder that is created will be referred as CCDW from now on.
 
2. Edit *config.yml*, making the following changes:

    In the *sql* section, update the following items:

        * server: <Enter the server address or localhost if running on the local server>
        * db: CCDW_HIST
        * driver: <Enter the proper driver for the installed version of SQL Server>
    
    In the *informer* section, update the following items:

        * export_path: <Full path to data folder>
        * export_path_wStatus: <Full path to data with Statuses folder>
        * export_path_meta: <Full path to metadata folder>

    In the *ccdw* section, update the following items:

        * log_path: <Full directory path to location for log files with trailing slash '/'>
        * archive_path: <Full directory path to location for archive files with trailing slash '/'>
        * archive_path_wStatus: <Full directory path to location for with Status archive files with trailing slash '/'>
        * invalid_path_wStatus: <Full directory path to location for with Status Invalid data files with trailing slash '/'>
        * error_path: <Full directory path to location for error files with trailing slash '/'>
        * log_path: <Full directory path to location for log files with trailing slash '/'>

    In the remaining sections, update as necessary. You can delete the *school* section if you will not be using this file for anything else. 

3. If your *config.yml* file is stored in the *CCDW* directory, run *setup.py*. If your *config.yml* file is stored in a different location than the *CCDW* directory, run *setup.py --path=<path to config.yml file>*

4. Install Informer reports and schedule each to run according to the Informer Setup document (*Informer_Setup.md*).

5. Run With Status reports in Informer. After With Status reports have run, validate the files with CCDW by running *ccdw.py --wStatusValidate"*. Any invalid records will be stored in the folder you specified in the *config.yml* file. Modify the With Status Informer reports with invalid data to correct the data or make changes in the stored CSV files. Once all validation errors are corrected, run *ccdw.py --wStatus* or use the *startImport_wStatus.bat* batch file.

6. Schedule *statImport.bat* to run after the Informer reports are complete.