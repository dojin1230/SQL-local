
  INSERT INTO [work].[dbo].[lead_gen_count] (DATE, c1, c2, c3)
  VALUES (CONVERT(VARCHAR(10),GETDATE(),126),'t','e','s')


INSERT INTO [work].[dbo].[lead_gen_count] (DATE, r5, r4, r3, r2, r1, c1, c2, c3, c4, c5, c6, c7, c8)
VALUES (CONVERT(VARCHAR(10),GETDATE(),126),
(SELECT COUNT(*)
FROM [work].[dbo].[en_data]
WHERE Campaign_Date = CONVERT(DATE,GETDATE()-5) ),
(SELECT COUNT(*)
FROM [work].[dbo].[en_data]
WHERE Campaign_Date = CONVERT(DATE,GETDATE()-4) ),
(SELECT COUNT(*)
FROM [work].[dbo].[en_data]
WHERE Campaign_Date = CONVERT(DATE,GETDATE()-3) ),
FROM [work].[dbo].[en_data]
(SELECT COUNT(*)
WHERE Campaign_Date = CONVERT(DATE,GETDATE()-2) ),
(SELECT COUNT(*)
FROM [work].[dbo].[en_data]
WHERE Campaign_Date = CONVERT(DATE,GETDATE()-1) ),
(SELECT COUNT(*)
FROM #001),
(SELECT COUNT(*)
FROM #001_1),
(SELECT COUNT(*)
FROM [work].[dbo].[petition_all_90]),
(SELECT COUNT(*)
FROM #003_1),
(SELECT COUNT(*)
FROM #003_2),
(SELECT COUNT(*)
FROM [work].[dbo].[db0_clnt_i_phone_mail]),
(SELECT COUNT(*)
FROM #004),
'test'
)


	(SELECT COUNT(*)
	FROM #001),
	(SELECT COUNT(*)
	FROM #001_1),
	(SELECT COUNT(*)
	FROM [work].[dbo].[petition_all_90]),
	(SELECT COUNT(*)
	FROM #003_1),
	(SELECT COUNT(*)
	FROM #003_2),
	(SELECT COUNT(*)
	FROM [work].[dbo].[db0_clnt_i_phone_mail]),
	(SELECT COUNT(*)
	FROM #004)



UPDATE [work].[dbo].[lead_gen_count]
SET c8 = (SELECT COUNT(*)
	       FROM [work].[dbo].[petition_daily_after]),
    c9 = (SELECT COUNT(*)
	       FROM [work].[dbo].[petition_daily_code]
	       WHERE input_date = CONVERT(DATE,GETDATE())),
    c10 = (SELECT COUNT(*)
	       FROM [work].[dbo].[petition_all]
	       WHERE Year_ = CONVERT(DATE, GETDATE())),
    c11 = (SELECT COUNT(*)
	       FROM [work].[dbo].[petition_all])
WHERE DATE = CONVERT(VARCHAR(10), GETDATE()+1, 126)
