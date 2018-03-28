
-- EN 카운트 --

SELECT
	(SELECT count(*)
	FROM [work].[dbo].[en_email_ok_utf_180222]
	where email_ok = 'Y') as Y,
	(SELECT count(*)
	FROM [work].[dbo].[en_email_ok_utf_180222]
	where email_ok = 'N') as N,
	(SELECT count(*)
	FROM [work].[dbo].[en_email_ok_utf_180222]
	) as todo

 -- 불일치 확인 --
 SELECT I.회원번호, I.이메일수신여부, EN.email_ok, EN.email
 FROM [work].[dbo].[db0_clnt_i] I
 LEFT JOIN
 [work].[dbo].[en_email_ok_utf_180222] EN
 ON I.[이메일] = EN.[email]
 WHERE I.회원번호 IS NOT NULL
 and I.이메일수신여부 != EN.email_ok
