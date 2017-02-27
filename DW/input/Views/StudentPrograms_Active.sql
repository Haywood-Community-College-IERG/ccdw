CREATE VIEW [input].[StudentPrograms_Active] AS
	SELECT [sp].[StudentProgramsID], 
	       [sp].[ProgramsID], 
		   [sp].[PersonsID], 
		   [sp].[CampusID], 
		   [sp].[Program Code], 
		   [sp].[Program Name], 
		   [sp].[Credential], 
		   [sp].[Credential Type], 
		   [sp].[Major Code], 
		   [sp].[Major Name], 
		   [sp].[Major CIP], 
		   [sp].[Catalog], 
		   [sp].[First Term in Program], 
		   [sp].[Is First Term in Program], 
		   [sp].[Program Hours Attempted], 
		   [sp].[Program Hours Completed], 
		   [sp].[Program GPA], 
		   [sp].[Term Code], 
		   [sp].[Term], 
		   [sp].[Term Type], 
		   [sp].[Term Abbreviation], 
		   [sp].[Academic Year], 
		   [sp].[Reporting Academic Year], 
		   [sp].[Year], 
		   [sp].[Reporting Year], 
		   [sp].[Reporting Code], 
		   [sp].[Reporting Code Alternate], 
		   [sp].[Term Sort Order], 
		   [sp].[Age], 
		   [sp].[Gender], 
		   [sp].[Race], 
		   [sp].[Hispanic or Latino], 
		   [sp].[Citizenship], 
		   [sp].[City], 
		   [sp].[State Code], 
		   [sp].[Postal Code], 
		   [sp].[County], 
		   [sp].[Country], 
		   [sp].[State of Residence], 
		   [sp].[Cohort], 
		   [sp].[Total Hours Attempted], 
		   [sp].[Total Hours Completed], 
		   [sp].[Total GPA], 
		   [sp].[RECORD_HASH]
	  FROM input.StudentPrograms sp
	  INNER JOIN (SELECT sc1.CampusID, sc1.[Term Code], COUNT(sc1.Course) AS CourseCount
	                FROM input.StudentCourses sc1
				   WHERE sc1.[Registration Status] IN ('A','N','W')
				   GROUP BY sc1.CampusID, sc1.[Term Code]
				 ) sc ON (sc.CampusID=sp.CampusID AND sc.[Term Code]=sp.[Term Code])
	 WHERE sc.CourseCount>0

