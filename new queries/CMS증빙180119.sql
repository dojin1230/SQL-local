
--SELECT *
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보

--dbo.UV_GP_후원자정보 	 		회원현황								D	Donor 회원번호, 납부방법, CMS상태, CARD상태, 가입경로, 가입일, 회원상태, 등록구분, 성별, 나이, 최초등록구분, 예금주본인, 소속, DDM번호, DDM명, DDF번호, DDF명, DD장소번호, DD장소, 납부여부, 은행, 예금주, 납부금액, 납부주기개월, 납부시작년월, 납부종료년월, 납부일시중지시작, 납부일시중지종료, 최초납부년월, 최종납부년월, 총납부금액, 총납부건수, Web아이디, 집전화번호, 직장전화번호, 휴대전화번호, 이메일, 생년월일, 카드사, 최초입력일, CMS증빙자료등록필요, 납부일
--dbo.UV_GP_후원약정금액정보 	 	납부항목							PL	Payment List 일련번호, ID, 회원번호, 납부여부, 상태, 납부방법, 신청일, 금액, 종료여부, 납부종료일, 시작년월, 종료년월, 납부주기, 납부항목-사용자구분1
--dbo.UV_GP_일시후원결제결과 	 	신용카드(나이스페이) > 수시납부현황	T	Temporary Result 일련번호, ID, 결제일, 성명, 회원번호, 결제방법, 결제모듈, 결제금액, 수수료, 결제자, 결제수단정보, 결제취소일시, 취소자, 취소사유
--dbo.UV_GP_신용카드승인정보 	 	신용카드 > 회원승인현황				CA 	Card Approval CARD상태, 회원번호, 승인일, 승인경로, 카드사, 카드번호, 유효기간, 승인자, 승인일시
--dbo.UV_GP_신용카드결제결과 	 	신용카드 > 정기납부현황				CR 	Card Result 일련번호, ID, 출금일, 구분, 회원명, 회원코드, 카드사, Web, 신청금액, 수수료, 결과, 실패사유, 취소일시
--dbo.UV_GP_변경이력 	 		변경이력								CH 	Change History 일련번호, ID, 회원번호, 변경일시, 변경항목, 수정전, 수정후
--dbo.UV_GP_관리기록 	 		관리기록								H 	History	일련번호, ID, 회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
--dbo.UV_GP_결제정보 	 		회비납부 - 성공한 후원금				PR	Payment Result 일련번호, ID, 회원번호, 귀속년월, 납부일, 정기수시, 납부방법, 납부금액, 환불상태, 환불총액
--dbo.UV_GP_CMS승인정보 	 		SmartCMS > 회원신청					BA 	Bank Approval 신청일, 신청구분, 회원번호, 은행, 계좌번호, 예금주, 예금주번호, 처리결과, 결과메세지
--dbo.UV_GP_CMS결제결과 	 		SmartCMS > 출금신청					BR 	Bank Result 일련번호, ID, 출금일, 구분, 회원코드, 은행, 예금주, 신청금액, 처리결과, 수수료, 실출금액, 결과메세지

-- P.납부일 >= CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
-- CONVERT(VARCHAR(7), DATEADD(MONTH, -3, GETDATE()), 126)
-- CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126)
-- CONVERT(DATE, GETDATE() -1)


SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(SELECT *
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE 
		기록분류상세 = '통성-재시작동의' AND CONVERT(DATE,참고일) > CONVERT(DATE,GETDATE()-4)
		OR 기록분류상세 = '통성-재개동의' AND CONVERT(DATE,참고일) > CONVERT(DATE,GETDATE()-4) --재시작 동의/재개 동의 등이 최근에 있으면 제외
		OR (기록분류 = 'TM_감사' AND 처리진행사항 IN ('SK-진행','SK-지연'))						--감사콜이 진행중이면 제외
		OR 기록분류 = 'TM_CMS증빙' AND 처리진행사항 = 'SK-진행'									--CMS콜이 진행중이면 제외
		OR 기록분류상세 = '결번'																--결번 제외
		) H
ON D.회원번호 = H.회원번호
LEFT JOIN
	(SELECT *
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력
	WHERE 
		변경항목 = '증빙자료 추가' AND 변경일시 >= GETDATE() - 4
		OR 변경항목 = '증빙자료 수정' AND 변경일시 >= GETDATE() - 4
		OR 변경항목 = '은행' AND 변경일시 >= GETDATE() - 4
		OR 변경항목 = '납부여부' AND 변경일시 >= GETDATE() - 4) CH								--CMS정보가 최근에 변경되었으면 제외
ON D.회원번호 = CH.회원번호
WHERE 
납부방법 = 'CMS'
AND D.CMS상태 NOT LIKE '%완료'
AND D.CMS상태 NOT LIKE '%진행'
AND D.회원상태 = 'normal'
AND D.최초등록구분 = '정기'
AND H.회원번호 IS NULL  
AND CH.회원번호 IS NULL
AND CONVERT(DATE,D.가입일) < CONVERT(DATE,GETDATE()-5)										   --최근가입자 (감사콜 할당대기자) 제외
						
						



--AND CONVERT(DATE,D.가입일) < CONVERT(DATE,GETDATE()-30)  -- 대략 감사콜 마감 시점 지남


--재시작 동의/재개 동의 등이 최근에 있으면 제외
--CMS정보가 최근에 변경되었으면 제외
--CMS콜이 진행중이면 제외
--감사콜이 진행중이면 제외

