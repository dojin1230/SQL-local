select 
	mem.회원번호, mem.회원상태, crd.승인경로
from 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 mem 
	left join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 as crd
on 
	mem.회원번호 = crd.회원번호
where 
	-- 날짜 정보 제대로 확인할 것
	crd.승인일 = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
	-- crd.승인일 >= CONVERT(varchar(10), '2017-09-29', 126) and  crd.승인일 <= CONVERT(varchar(10), '2017-10-09', 126)
	and crd.승인경로 !='MRM'
order by 1 desc
go
