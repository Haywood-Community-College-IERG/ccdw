USE CCDW_HIST
GO

CREATE OR ALTER PROCEDURE RestoreDB2Empty AS 
BEGIN;
	/* 
	EXEC RestoreDB2Empty;
	*/
    PRINT 'Delete existing history schema tables';
    IF OBJECT_ID('history.[ACAD_PROGRAMS]', 'U') IS NOT NULL
        DROP TABLE history.[ACAD_PROGRAMS]
    IF OBJECT_ID('history.[COURSE_SECTIONS]', 'U') IS NOT NULL
        DROP TABLE history.COURSE_SECTIONS
    IF OBJECT_ID('history.[NON_COURSES]', 'U') IS NOT NULL
        DROP TABLE history.NON_COURSES
    IF OBJECT_ID('history.[TERMS]', 'U') IS NOT NULL
        DROP TABLE history.TERMS

    PRINT 'Delete existing input schema tables';
    IF OBJECT_ID('input.[ACAD_PROGRAMS]', 'U') IS NOT NULL
        DROP TABLE input.[ACAD_PROGRAMS]
    IF OBJECT_ID('input.[COURSE_SECTIONS]', 'U') IS NOT NULL
        DROP TABLE input.COURSE_SECTIONS
    IF OBJECT_ID('input.[NON_COURSES]', 'U') IS NOT NULL
        DROP TABLE input.NON_COURSES
    IF OBJECT_ID('input.[TERMS]', 'U') IS NOT NULL
        DROP TABLE input.TERMS

    PRINT 'Delete existing base_history schema tables';
    IF OBJECT_ID('base_history.[ACAD_PROGRAMS]', 'U') IS NOT NULL
        DROP TABLE base_history.[ACAD_PROGRAMS]
    IF OBJECT_ID('base_history.[COURSE_SECTIONS]', 'U') IS NOT NULL
        DROP TABLE base_history.COURSE_SECTIONS
    IF OBJECT_ID('base_history.[NON_COURSES]', 'U') IS NOT NULL
        DROP TABLE base_history.NON_COURSES
    IF OBJECT_ID('base_history.[TERMS]', 'U') IS NOT NULL
        DROP TABLE base_history.TERMS

    PRINT 'Delete existing base_input schema tables';
    IF OBJECT_ID('base_input.[ACAD_PROGRAMS]', 'U') IS NOT NULL
        DROP TABLE base_input.[ACAD_PROGRAMS]
    IF OBJECT_ID('base_input.[COURSE_SECTIONS]', 'U') IS NOT NULL
        DROP TABLE base_input.COURSE_SECTIONS
    IF OBJECT_ID('base_input.[NON_COURSES]', 'U') IS NOT NULL
        DROP TABLE base_input.NON_COURSES
    IF OBJECT_ID('base_input.[TERMS]', 'U') IS NOT NULL
        DROP TABLE base_input.TERMS

    PRINT 'Delete exitsing history schema views';
    IF OBJECT_ID('history.[ACAD_PROGRAMS__ACPG_ADMISSION]', 'V') IS NOT NULL
        DROP VIEW history.ACAD_PROGRAMS__ACPG_ADMISSION
    IF OBJECT_ID('history.[ACAD_PROGRAMS__ACPG_STANDING_RULES]', 'V') IS NOT NULL
        DROP VIEW history.ACAD_PROGRAMS__ACPG_STANDING_RULES
    IF OBJECT_ID('history.[ACAD_PROGRAMS__PROGRAM_STATUS]', 'V') IS NOT NULL
        DROP VIEW history.ACAD_PROGRAMS__PROGRAM_STATUS
    IF OBJECT_ID('history.[ACAD_PROGRAMS_Current]', 'V') IS NOT NULL
        DROP VIEW history.[ACAD_PROGRAMS_Current]
    IF OBJECT_ID('history.[COURSE_SECTIONS__SEC_CONTACT]', 'V') IS NOT NULL
        DROP VIEW history.COURSE_SECTIONS__SEC_CONTACT
    IF OBJECT_ID('history.[COURSE_SECTIONS__SEC_STATUSES]', 'V') IS NOT NULL
        DROP VIEW history.COURSE_SECTIONS__SEC_STATUSES
    IF OBJECT_ID('history.[COURSE_SECTIONS_Current]', 'V') IS NOT NULL
        DROP VIEW history.COURSE_SECTIONS_Current
    IF OBJECT_ID('history.[NON_COURSES_Current]', 'V') IS NOT NULL
        DROP VIEW history.NON_COURSES_Current
    IF OBJECT_ID('history.[TERMS_Current]', 'V') IS NOT NULL
        DROP VIEW history.TERMS_Current
END;