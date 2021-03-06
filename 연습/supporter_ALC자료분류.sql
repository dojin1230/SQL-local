/****** SSMS의 SelectTopNRows 명령 스크립트 ******/

--자료 구조
SELECT TOP (1000) [Comparison]
      ,[Region]
      ,[year]
           ,[Income type]
      ,[Source]
      ,[Sub-source]
      ,[NewDonor_Actual]
	  ,count(*)
  FROM [report].[dbo].[supporter_ALC_201801]
  group by [Comparison]
      ,[Region]
      ,[year]
       ,[Income type]
      ,[Source]
      ,[Sub-source]
      ,[NewDonor_Actual]
order by 1,2,3,4,5,6