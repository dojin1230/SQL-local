SELECT CH.회원번호, CH.변경일시, CH.변경항목, CH.수정전, CH.수정후, H.기록분류상세, H.참고일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
  WHERE 기록분류상세 = '결번'
  ) H
ON CH.회원번호 = H.회원번호
WHERE CH.변경항목 = '휴대전화번호'
  AND CH.수정후 != '무'
  AND CONVERT(DATE,CH.변경일시) >= CONVERT(DATE,H.참고일) 



  SELECT CH.회원번호, CH.변경일시, CH.변경항목, CH.수정전, CH.수정후, H.기록분류상세, H.참고일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
  WHERE 기록분류상세 = '결번'
  ) H
ON CH.회원번호 = H.회원번호
WHERE CH.변경항목 = '휴대전화번호'
  AND CH.수정후 != '무'
  AND CONVERT(DATE,CH.변경일시) = CONVERT(DATE,H.참고일) 



-- 전화번호 일괄 변경한건들 확인 --
  SELECT CH.회원번호, CH.변경일시, CH.변경항목, CH.수정전, CH.수정후, H.기록분류상세, H.참고일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
  WHERE 기록분류상세 = '결번'
  ) H
ON CH.회원번호 = H.회원번호
WHERE CH.변경항목 = '휴대전화번호'
  AND CH.수정후 != '무'
  AND 변경일시 = '2017-11-14 12:14'
  AND CONVERT(DATE,CH.변경일시) >= CONVERT(DATE,H.참고일) 


-- 전화번호 일괄 변경한건들 확인 --


SELECT CH.회원번호, CH.변경일시, CH.변경항목, CH.수정전, CH.수정후, H.기록분류상세, H.참고일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
  WHERE 기록분류상세 = '결번'
  ) H
ON CH.회원번호 = H.회원번호
WHERE CH.변경항목 = '휴대전화번호'
  AND CH.수정후 != '무'
  AND 변경일시 LIKE '2017-11-14%'
  AND H.회원번호 IS NOT NULL



  
  -- 휴대전화번호 없는데 '유'로 나옴  ====> 일괄수정에 널값을 줘서 해결
  SELECT D.휴대전화번호, D.회원번호
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
  WHERE D.회원번호 IN ('82051964','82052015', '82020937',
'82032080',
'82023479',
'82000793',
'82001413',
'82028556')



-- 최종형 --
  SELECT CH.회원번호, CH.변경일시, CH.변경항목, CH.수정전, CH.수정후, H.기록분류상세, H.참고일, D.휴대전화번호
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
  LEFT JOIN
    (SELECT *
    FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
    WHERE 기록분류상세 = '결번'
    ) H
  ON CH.회원번호 = H.회원번호
  LEFT JOIN
    (SELECT 회원번호, 휴대전화번호
    FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
    ) D
  ON CH.회원번호 = D.회원번호
  WHERE CH.변경항목 = '휴대전화번호'
    AND CH.수정후 != '무'
    AND CONVERT(DATE,CH.변경일시) >= CONVERT(DATE,H.참고일)
    AND D.휴대전화번호 = '유'
