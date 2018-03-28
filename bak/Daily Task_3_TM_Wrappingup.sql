--Action 1
select *
	from MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
		where 기록분류 like 'TM%' 
		and 처리진행사항 in ('SK-진행','SK-지연') 
		and 기록분류상세 not in ('무응','통성-설명X','미처리','통성-추후재전')
order by 기록분류, 기록분류상세
go

--Case B
------- dj: 기록분류상세 추가 통성~~~거절 ------작성실패 밑에서 다시 시도
	SELECT 
		A.회원번호, A.납부방법, A.CMS상태, A.CARD상태, A.회원상태, A.납부여부, A.납부일시중지시작, A.납부일시중지종료, B.기록분류, B.처리진행사항, B.기록분류상세, B.참고일
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 A
	LEFT JOIN 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 B 
	ON A.회원번호 = B.회원번호

		WHERE A.회원번호 in
		(SELECT  
			B.회원번호
		FROM 
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 B
		WHERE 기록분류 like 'TM%' 
		and 처리진행사항 ='SK-완료'
		and 기록분류상세 in ('통성-후원거절', '통성-재개거절', '통성-재시작거절')
		--and 참고일 = '2017-10-19'
		and 참고일 = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
		--and 참고일 >= CONVERT(varchar(10), '2017-09-28', 126) and  참고일 <= CONVERT(varchar(10), '2017-09-29', 126)
		)	
	GO

-- Case B (DJ)

	SELECT  
			AR.회원번호, AR.기록분류, AR.처리진행사항, AR.기록분류상세, AR.참고일, SI.납부방법, SI.CMS상태, SI.CARD상태, SI.회원상태, SI.납부여부, SI.납부일시중지시작, SI.납부일시중지종료
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 AR
		LEFT JOIN 
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 SI
		ON AR.회원번호 = SI.회원번호
		WHERE 기록분류 like 'TM%' 
		AND 처리진행사항 ='SK-완료'
		AND 기록분류상세 in ('통성-후원거절', '통성-재개거절', '통성-재시작거절')
		-- AND 참고일 = '2017-10-19'
		AND 참고일 = CONVERT(VARCHAR(10), DATEADD(DAY, -5, GETDATE()), 126)
	GO
--Case C
------ CMS와 카드 최근 인증 날짜도 불러오도록 수정할 것 //dj: 참고일 제대로 불러오도록 수정 + 신규대기 추가 + 기록분류 추가
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
--------dj: 날짜함수 다시 확인 (전날이 아니고 이틀전것도 나옴)
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
