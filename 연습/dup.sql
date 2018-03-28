

DELETE FROM [work].[dbo].[petition_daily_after_rown]
WHERE ROWN IN
	(SELECT A.ROWN AS ROWN
	FROM [work].[dbo].[petition_daily_after_rown] A
	INNER JOIN
		(SELECT MAX(ROWN) AS ROWN, modified_number, COUNT(*) AS COUNT
		FROM [work].[dbo].[petition_daily_after_rown]
		GROUP BY modified_number
		HAVING COUNT(*) > 1) B
	ON A.modified_number = B.modified_number
		AND A.ROWN != B.ROWN)



    INSERT INTO [work].[dbo].[petition_all]( Year_, Name_, Phone, modified_phone, Mail)
    SELECT
    	CONVERT(DATE, GETDATE()),
    	[work].[dbo].[petition_daily_before].[korean_name],
    	[work].[dbo].[petition_daily_before].[phone_number],
    	[work].[dbo].[petition_daily_before].[modified_number],
    	[work].[dbo].[petition_daily_before].[supporter_email]
    FROM [work].[dbo].[petition_daily_before]



INSERT INTO [work].[dbo].[kemoji_all](input_date, phone, name, email, campaign_date, utm_term)
