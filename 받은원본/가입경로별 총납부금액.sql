SELECT 
	avg([총납부금액]) as 총납부금액평균, avg(총납부건수) as 총납부건수평균, count(가입경로) as 채널별숫자, sum(총납부금액) as 총납부금액합계, 가입경로
      
  FROM [MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보]
WHERE left(가입일,4) = '2017'
GROUP BY 가입경로
