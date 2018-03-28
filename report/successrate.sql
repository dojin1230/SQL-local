SELECT [Predebit], [12], count(predebit) as count_predbit
FROM [report].[dbo].[vw_success_rate]
group by [Predebit], [12]



-- SELECT a, b, COUNT(a) FROM tbl GROUP BY a, b
