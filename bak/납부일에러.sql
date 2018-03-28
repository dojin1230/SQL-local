	
select 
	S.회원번호
from
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
	left join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 MH
on
	S.회원번호 = MH.회원번호
where
	-- 1. 납부일 잘못되어 있었던 사람
	MH.변경일시 like '2017-09-26%' and MH.변경항목='납부일'
	-- 2. 상태가 normal인 사람
	and S.회원상태='Normal'
	-- 3. CMS/CARD 상태가 대기 중이 아닌 사람
	and (S.CMS상태 = '신규완료' OR S.CARD상태 = '승인완료')
	-- 4. 납부방법이 CMS인 사람
	and S.납부방법='CMS'
	-- 5. 납부시작이 9월인 사람
	and S.납부시작년월='2017-09'
	-- 6. 납부일시중지 걸려있는 사람
	and S.납부일시중지시작 is null
group by S.회원번호
	

select 
	*
from
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S