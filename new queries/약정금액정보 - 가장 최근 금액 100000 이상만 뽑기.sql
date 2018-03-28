
--dbo.UV_GP_후원자정보 	 		회원현황								D	Donor 
--dbo.UV_GP_후원약정금액정보 	 	납부항목								PL	Payment List
--dbo.UV_GP_일시후원결제결과 	 	신용카드(나이스페이) > 수시납부현황	T	Temporary Result
--dbo.UV_GP_신용카드승인정보 	 	신용카드 > 회원승인현황				CA 	Card Approval
--dbo.UV_GP_신용카드결제결과 	 	신용카드 > 정기납부현황				CR 	Card Result 	
--dbo.UV_GP_변경이력 	 		변경이력								CH 	Change History
--dbo.UV_GP_관리기록 	 		관리기록								H 	History	
--dbo.UV_GP_결제정보 	 		회비납부 - 성공한 후원금				PR	Payment Result	
--dbo.UV_GP_CMS승인정보 	 		SmartCMS > 회원신청					BA 	Bank Approval
--dbo.UV_GP_CMS결제결과 	 		SmartCMS > 출금신청					BR 	Bank Result



select top (100) *
from [MRMRT].[그린피스동아시아서울사무소0868].dbo.UV_GP_후원약정금액정보
where 금액 >= 100000
and 상태 != '종료'
and 종료년월 = ''

order by 신청일 desc


SELECT *
FROM [MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원약정금액정보] ii

WHERE 
ii.회원번호 IN
(SELECT
	
      sub.[회원번호]
   
	  FROM [MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원약정금액정보] sub
group by sub.회원번호
having count(*) > 1)




SELECT *
FROM [MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원약정금액정보] DA -- Donation Amount

WHERE
	DA.상태 = '진행'
	AND
	금액 > 100000