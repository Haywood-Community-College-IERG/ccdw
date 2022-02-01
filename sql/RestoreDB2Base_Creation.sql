CREATE SCHEMA base_history
GO                
CREATE SCHEMA base_input
GO

PRINT 'Recreate base_history schema tables';
SELECT * INTO base_history.ACAD_PROGRAMS FROM history.ACAD_PROGRAMS;
SELECT * INTO base_history.COURSE_SECTIONS FROM history.COURSE_SECTIONS;
SELECT * INTO base_history.NON_COURSE FROM history.NON_COURSE;
SELECT * INTO base_history.TERMS FROM history.TERMS;

PRINT 'Recreate base_input schema tables';
SELECT * INTO base_input.ACAD_PROGRAMS FROM input.ACAD_PROGRAMS;
SELECT * INTO base_input.COURSE_SECTIONS FROM input.COURSE_SECTIONS;
SELECT * INTO base_input.NON_COURSE FROM input.NON_COURSE;
SELECT * INTO base_input.TERMS FROM input.TERMS;
