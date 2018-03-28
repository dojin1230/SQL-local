
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
-- CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126)
-- CONVERT(DATE, GETDATE() -1)


-- 001★ -- 마지막으로 납부한 달이 4개월 이전이거나 납부기록이 없는 경우만 추출 (예: 1월초 작업시 최종납부년월이 전년도 8월 이전)

SELECT 회원번호, 최종납부년월
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE CONVERT(VARCHAR(7),최종납부년월) < CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
	OR 최종납부년월 IS NULL

-- 002 -- 모든 출금 신청 및 결과값을 가져와 잔액관련되면 SOFT로 분류, 카드와 CMS로 분류
SELECT 출금일, 회원코드, 신청금액,
	CASE
		WHEN 처리결과 = '출금완료' THEN '성공'
		ELSE '실패'
	END AS 결과,
	결과메세지,
	CASE
		WHEN 결과메세지 LIKE '%잔액%' THEN 'SOFT'
		WHEN 결과메세지 LIKE '%잔고%' THEN 'SOFT'
		WHEN 결과메세지 LIKE '%한도%' THEN 'SOFT'
		WHEN 처리결과 = '출금완료' THEN NULL
		ELSE 'HARD'
	END AS TYPE,
	'CMS' AS pymt_mtd
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과

UNION ALL

SELECT 출금일, 회원코드, 신청금액, 결과, 실패사유,
	CASE
		WHEN 실패사유 LIKE '%잔액%' THEN 'SOFT'
		WHEN 실패사유 LIKE '%잔고%' THEN 'SOFT'
		WHEN 실패사유 LIKE '%한도%' THEN 'SOFT'
		WHEN 결과 = '성공' THEN NULL
		ELSE 'HARD'
	END AS TYPE,
	'CRD' AS pymt_mtd
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과



-- 002_1 -- 3개월 이내에 잔액부족 콜이 가고 동의한 경우의 관리기록

SELECT 일련번호, ID, 회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE 
		기록분류 = 'TM_후원재개_잔액부족'
		AND 기록분류상세 = '통성-재개동의'
		AND CONVERT(VARCHAR(7),참고일) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -3, GETDATE()), 126)

-- 003★


SELECT [001★].회원번호, [002].출금일, [002].신청금액, [002].결과, [002].결과메세지, [002].Type, [002].Pymt_mtd, Format([002].출금일,'yyyy-mm') AS 출금년월, [001★].회원상태
FROM 002_1 RIGHT JOIN (002 INNER JOIN 001★ ON [002].회원코드 = [001★].회원번호) ON [002_1].회원번호 = [001★].회원번호
WHERE ((([002].결과)="실패") AND (([002].Type)="Soft") AND ((Format([002].[출금일],'yyyy-mm'))>="2017-09") AND (([002_1].회원번호) Is Null));

-- 004_soft freeze target f

SELECT [003★].회원번호, Count([003★].회원번호) AS 결제실패횟수
FROM 003★
GROUP BY [003★].회원번호, [003★].회원상태
HAVING (((Count([003★].회원번호))>=8) AND (([003★].회원상태)="Normal"));
