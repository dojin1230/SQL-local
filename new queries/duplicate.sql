DROP TABLE IF EXISTS #tmp01

SELECT max(supporter_email), modified_number, count(*) AS dup_count
--INTO #tmp01
FROM [work].[dbo].[petition_daily_after]
GROUP BY modified_number
Having count(*) > 1

delete from #tmp01
