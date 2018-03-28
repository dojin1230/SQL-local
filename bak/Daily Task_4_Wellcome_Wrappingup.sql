use mrm
go
-- Case A
SELECT
	H.*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON H.회원번호 = S.회원번호
WHERE
	H.기록분류='TM_감사' 
	and H.기록분류상세 ='통성-후원동의'
	and H.기록일시 >= CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126) 
	and H.기록일시 < CONVERT(varchar(10), DATEADD(day, -20, GETDATE()), 126)
	and ((S.CMS상태 not in ('신규완료','신규진행') and S.CARD상태 !='승인완료') OR S.CMS증빙자료등록필요='Y')
go

-- Case B
SELECT
	S.*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON H.회원번호 = S.회원번호
WHERE
	H.기록분류='TM_감사' 
	and H.기록분류상세 not in ('통성-후원거절','통성-후원동의')   -- 결번추가? --
	and H.기록일시 >= CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126) 
	and H.기록일시 < CONVERT(varchar(10), DATEADD(day, -20, GETDATE()), 126)
	and ((S.CMS상태 not in ('신규완료','신규진행') and S.CARD상태 !='승인완료') OR S.CMS증빙자료등록필요='Y' OR S.CARD상태='승인대기')
go
