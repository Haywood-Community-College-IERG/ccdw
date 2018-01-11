USE [IERG]
GO
/****** Object:  View [history].[PERSON_Current]    Script Date: 1/11/2018 10:12:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[PERSON_Current]
AS
SELECT        ID, [FIRST.NAME], [MIDDLE.NAME], [LAST.NAME], SUFFIX, [NAME.HISTORY.LAST.NAME], GENDER, [BIRTH.DATE], [DECEASED.DATE], [MARITAL.STATUS], ETHNIC, [PER.ETHNICS], [PER.RACES], CITIZENSHIP, 
                         [PERSON.ALT.IDS], [ADDRESS.LINES], CITY, STATE, ZIP, [ADDR.TYPE], [RESIDENCE.COUNTY], [RESIDENCE.STATE], [RESIDENCE.COUNTRY], [EMER.CONTACT.PHONE], [PERSON.OVRL.EMP.STAT], 
                         [VETERAN.TYPE], [VETERAN.TYPE2.DESCRIPTION], [VISA.TYPE], [PRIVACY.FLAG], [DIRECTORY.FLAG], [PERSON.EMAIL.ADDRESSES], [PERSON.EMAIL.TYPES], [PERSONAL.PHONE.NUMBER], 
                         [PERSONAL.PHONE.TYPE], [PERSON.ADD.DATE], [PERSON.ADD.OPERATOR], [PERSON.CHANGE.DATE], [PERSON.CHANGE.OPERATOR], EffectiveDatetime, ExpirationDatetime, CurrentFlag
FROM            history.PERSON
WHERE        (CurrentFlag = 'Y')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[36] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PERSON (history)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1905
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'history', @level1type=N'VIEW',@level1name=N'PERSON_Current'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'history', @level1type=N'VIEW',@level1name=N'PERSON_Current'
GO
