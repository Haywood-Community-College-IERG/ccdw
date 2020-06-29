# To setup CCDW

1. Clone Existing Repository

    Using Tortoise GIT, right click in the folder where you want the CCDW folder created.
    Choose Git Clone... from the menu and enter the URL below into the URL field. Leave 
    all other defaults as they are.

    URL: https://github.com/haywood-ierg/ccdw-csc289

    The folder that is created will be referred as CCDW from now on.

2. Create the following folders within the CCDW folder:

    archive
    data
    meta

3. Copy the base data from the *basedata* folder into the data folder.

4. In the *import* folder, copy the *config_remote_template.yml* to *config.yml* and make the following changes:

    In the *sql* section, update the following items:

        * server: <Enter the server address>
        * db: CCDW_CSC289
    
    In the *informer* section, update the following items:

        * export_path: <Full path to CCDW folder>/data
        * export_path_wStatus: <Full path to CCDW folder>/data
        * export_path_meta: <Full path to CCDW folder>/meta

5. On the SQL Server, create the *CCDW_CSC289* database. All the tables will be created within this database.
   (IT may have done this for you)

6. Run setup/Create_Folders.bat.

7. Create shared drive space on Informer report server for CCDW export reports.

    The folder should contain a folder for each of the configured reports. A script is provided to create these folders.

8. Install the Informer reports to your Informer report server.

    Configure each of the reports to export their data to their respective folder onthe Informer server.

9. Install the following into the SQL Server database:

    * _Create_Schemas.sql
    * dbo.DelimitedSplit8K.sql
    * dw_util.GetEasterHolidays.sql
    * dw_util.Update_Date.sql

    To install each of these, open each in SQL Server Management Studio, ensure the *CCDW_CSC289* database is selected and submit the statements.

10. Run and install the TERMS data.

    In Informer, run the TERMS report.

    In the CCDW folder, run startimport.bat. This will load the TERMS table with the data from Colleague.

11. Return to SQL Server Management Studio and load *dw.Update_DimDate.StoredProcedure.sql*.
    
    Highlight the *REBUILD* section of *dw.Update_DimDate.StoredProcedure.sql* and submit. This will build the date table.

