-- 행넘버 최대값 선택 --

(SELECT MAX(ROWN) AS ROWN, modified_number, COUNT(*)
FROM [work].[dbo].[petition_daily_after_test]
GROUP BY modified_number
HAVING COUNT(*) > 1)

-- 제거할 행 선택 --

SELECT A.ROWN AS ROWN
FROM [work].[dbo].[petition_daily_after_test] A
INNER JOIN
  (SELECT MAX(ROWN) AS ROWN, modified_number, COUNT(*)
  FROM [work].[dbo].[petition_daily_after_test]
  GROUP BY modified_number
  HAVING COUNT(*) > 1) B
ON A.modified_number = B.modified_number
  AND A.ROWN != B.ROWN



-- 완성형 --

DELETE FROM [work].[dbo].[petition_daily_after_test]
WHERE ROWN IN
	(SELECT A.ROWN AS ROWN
	FROM [work].[dbo].[petition_daily_after_test] A
	INNER JOIN
	  (SELECT MAX(ROWN) AS ROWN, modified_number, COUNT(*) AS COUNT
	  FROM [work].[dbo].[petition_daily_after_test]
	  GROUP BY modified_number
	  HAVING COUNT(*) > 1) B
	ON A.modified_number = B.modified_number
	  AND A.ROWN != B.ROWN)
