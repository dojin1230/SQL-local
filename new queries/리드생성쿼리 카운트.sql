SELECT Campaign_Date, COUNT(*) AS raw_count
FROM [work].[dbo].[en_data]
GROUP BY Campaign_date
ORDER BY 1



SELECT  (
        SELECT COUNT(*)
        FROM   tab1
        ) AS count1,
        (
        SELECT COUNT(*)
        FROM   tab2
        ) AS count2
FROM    dual


SELECT
(SELECT COUNT(*)
FROM #001) AS 1,
(SELECT COUNT(*)
FROM #001_1) AS 2,
(SELECT COUNT(*)
FROM #002) AS 3,
(SELECT COUNT(*)
FROM #002_1) AS 4,
(SELECT COUNT(*)
FROM #002_2) AS 5,
(SELECT COUNT(*)
FROM #003) AS 6,
(SELECT COUNT(*)
FROM [work].[dbo].[petition_all_90]) AS 7,
(SELECT COUNT(*)
FROM #003_1) AS 8,
(SELECT COUNT(*)
FROM #003_2) AS 9,
(SELECT COUNT(*)
FROM [work].[dbo].[db0_clnt_i_phone_mail]) AS 10,
(SELECT COUNT(*)
FROM #004) AS 11,
(SELECT COUNT(*)
FROM [work].[dbo].[petition_daily_before]) AS 12,
(SELECT COUNT(*)
FROM [work].[dbo].[petition_daily]) AS 13
