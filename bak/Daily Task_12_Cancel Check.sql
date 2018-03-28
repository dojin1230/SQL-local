use mrm
go

-- Case A

select 
	S.회원번호, S.회원상태, S.납부여부, S.납부일시중지시작, S.납부일시중지종료
from
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S	
ON H.회원번호 = S.회원번호
WHERE H.기록분류='Cancellation'
	AND H.처리진행사항='IH-진행'
	AND H.기록분류상세 in ('SS-Canceled', 'Canceled')
	AND S.회원번호 is null
go
