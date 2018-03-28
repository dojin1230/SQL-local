SELECT DISTINCT CH.회원번호, D.회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON CH.회원번호 = D.회원번호
WHERE 
(CH.변경항목 = '증빙자료추가' 
 OR CH.변경항목 LIKE '예금%' 
 OR CH.변경항목 IN ('은행', '계좌번호','납부금액','납부방법','납부일') 
OR (CH.변경항목 = '납부여부' AND CH.수정후 = 'Y'))
AND CH.변경일시 >= GETDATE() - 4
AND D.회원상태 IN ('Freezing','Canceled')
AND (D.납부방법 = '신용카드' OR D.은행 != '' AND D.납부방법 = 'CMS')
AND D.납부여부 = 'Y'
