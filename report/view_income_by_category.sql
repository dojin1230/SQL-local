SELECT [Comparison]
      ,[ConstituentID]
      ,[PaidDate]
      ,[Type]
      ,[Paymentmethod]
      ,[COCOA]
      ,[Account code]
      ,[Year]
      ,[Month]
      ,[Actual]
      ,[Budget]
      ,[category]
  FROM [report].[dbo].[vw_income_by_category]



  select category, sum(actual)
  FROM [report].[dbo].[vw_income_by_category]
  group by category

  select *
  FROM [report].[dbo].[vw_income_by_category]
  where actual < 0

  select *
  FROM [report].[dbo].[vw_income_by_category]
  where budget is not null
