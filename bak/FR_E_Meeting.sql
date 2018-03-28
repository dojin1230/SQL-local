SELECT
	count(1) as Totaldonor, 
	sum(case when 총납부금액 > 1 then 1 else 0 end) as Netdonor,
	sum(case when 가입일 >= CONVERT(varchar(10), '2017-10-01', 126) then 1 else 0 end) as thismonth,
	sum(case when 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end) as thisyear,
	sum(case when 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) and 총납부금액 > 1 then 1 else 0 end) as Netdonor_thisyear
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
go

SELECT
	가입경로, 
	count(1) as 총가입자,
	sum(case when 최초납부년월 is not null then 1 else 0 end) as 전환된가입자
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	가입경로 in ('거리모집','인터넷/홈페이지','Lead Conversion')
	AND 가입일 >= CONVERT(varchar(10), '2017-01-01', 126)
GROUP BY
	가입경로
go

select
	가입경로,
	회원번호,
	최초납부년월
from
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	