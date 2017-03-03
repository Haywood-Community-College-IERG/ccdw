CREATE TABLE [dw].[FactEnrollments]
(
	[Enrollments_Key] INT NOT NULL  IDENTITY, 
    [Students_Key] INT NOT NULL, 
    [Terms_Key] INT NOT NULL, 
    [Courses_Key] INT NOT NULL, 
    [Registration Status] NVARCHAR(20) NULL, 
    [Registration Status Date] DATE NULL, 
    [Initial Registration Status] NVARCHAR(20) NULL, 
    [Initial Registration Status Date] DATE NULL, 
    [Grade] NVARCHAR(2) NULL, 
    [Quality Points] DECIMAL(9, 2) NULL, 
    [Passing Grade Flag] NCHAR(1) NULL, 
    CONSTRAINT [PK_FactEnrollment] PRIMARY KEY ([Enrollments_Key]) ,
    CONSTRAINT [FK_FactEnrollment_DimStudents] FOREIGN KEY ([Students_Key]) REFERENCES [dw].[DimStudents]([Students_Key]), 
    CONSTRAINT [FK_FactEnrollments_DimTerms] FOREIGN KEY ([Terms_Key]) REFERENCES [dw].[DimTerms]([Terms_Key]), 
    CONSTRAINT [FK_FactEnrollments_DimCourses] FOREIGN KEY ([Courses_Key]) REFERENCES [dw].[DimCourses]([Courses_Key]), 
)
