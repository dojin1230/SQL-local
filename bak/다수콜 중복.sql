-- 다수콜 중복
SELECT 
 H.회원번호, H.기록분류, H.기록분류상세, H.참고일, H.처리진행사항
FROM
 MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
WHERE
 H.회원번호 IN
  (SELECT 
   S.회원번호
  FROM 
   MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
  LEFT JOIN
   MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
  ON 
   S.회원번호 = H.회원번호
  WHERE
   H.처리진행사항 in ('SK-진행','IH-지연','IH-진행')
   AND H.기록분류상세 !='제외'
   AND H.기록분류 not in ('결제관련 요청/문의','캠페인관련 요청/문의/불만사항')
  GROUP BY
   S.회원번호
  HAVING 
   COUNT(S.회원번호) >= 2)
 AND H.처리진행사항 in ('SK-진행','IH-지연','IH-진행')
ORDER BY
 H.회원번호