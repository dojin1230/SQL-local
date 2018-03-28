--Action 1
select *
	from MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
		where 기록분류 like 'TM%' 
		and 처리진행사항 in ('SK-진행','SK-지연') 
		and 기록분류상세 not in ('무응','통성-설명X','미처리','통성-추후재전')
order by 기록분류, 기록분류상세
go

--Case B
select 
	*
from 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
where 회원번호 in
	(select  
		회원번호
	from 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	where 기록분류 like 'TM%' 
	and 처리진행사항 ='SK-완료'
	and 기록분류상세 ='통성-후원거절'
	--and 참고일 = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
	and 참고일 >= CONVERT(varchar(10), '2017-09-28', 126) and  참고일 <= CONVERT(varchar(10), '2017-09-29', 126)
	)	
go

--Case C
------ CMS와 카드 최근 인증 날짜도 불러오도록 수정할 것
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON H.회원번호 = S.회원번호
WHERE
	H.기록분류='TM_감사' 
	and H.기록분류상세 ='통성-후원동의'
	and H.참고일 >= CONVERT(varchar(10), DATEADD(day, -2, GETDATE()), 126) 
	and H.참고일 < CONVERT(varchar(10), GETDATE(), 126)
	and ((S.CMS상태 not in ('신규완료','신규진행') and S.CARD상태 !='승인완료') OR S.CMS증빙자료등록필요='Y')
go

-- Case D : 후원증액성공
select 
	D.회원번호, D.회원상태, D.납부금액, D.납부시작년월, H.제목, H.참고일
from 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D left outer join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
on	D.회원번호 = H.회원번호
where H.기록분류 like 'TM%' 
	and H.처리진행사항 ='SK-완료'
	and H.기록분류상세 ='통성-증액성공'
	and 참고일 >= CONVERT(varchar(10), DATEADD(day, -2, GETDATE()), 126) 
	and H.참고일 < CONVERT(varchar(10), GETDATE(), 126)
	--and H.참고일 >= CONVERT(varchar(10), '2017-09-25', 126) and  H.참고일 <= CONVERT(varchar(10), '2017-09-26', 126)			
go

-- Case E : 
dbo.UV_GP_신용카드승인정보 
