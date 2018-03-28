------------------------ Special Appeal 전체 대상자 
--최근에 실제로 감액/증액한 사람 확인하는 쿼리 추가
--최종납부년월이 저번달인 사람들만 해당시킬 것

SELECT
	S.회원번호
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
	-- 최근 8개월 이내에 후원증액콜을 받고 거절한 적이 있는 후원자 제외
		(기록분류 like 'TM_후원증액%' AND 기록일시 >= CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126) AND 기록분류상세='통성-증액거절')
	-- 최근 1년 이내에 후원증액콜을 받고 업그레이드 이력이 있는 후원자 제외
		OR (기록분류상세 = '통성-증액성공' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3년 이내 스페셜 어필 콜에서 거절한 적이 있는 후원자 제외 
		OR (기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원거절' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- 다운그레이드 이력이 2년 내에 있는 사람 제외
		OR (기록분류상세 = 'SS-DGamount'	AND 처리진행사항='IH-완료' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2년 이내 캔슬 신청을 한 적 있는 사람 제외
		OR (기록분류 = 'Cancellation' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY 회원번호
) E
	ON S.회원번호 = E.회원번호 
WHERE
	-- 최근 8개월 이전 가입자만 해당
	S.가입일 < CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126)
	AND S.회원상태 = 'normal'
	AND E.회원번호 IS NULL 
EXCEPT 		-- 두낫콜 제외
(SELECT
	회원번호
FROM 
	dbo.donotCall
GROUP BY 회원번호 )	
GO



------------------------ Special Appeal 우편 대상자 
SELECT
	S.회원번호,
	S.성명,
	S.우편물수신처,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN 집주소
	WHEN S.우편물수신처 = '직장' THEN 직장주소
	END AS 주소,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN isNULL(집주소상세,'')
	WHEN S.우편물수신처 = '직장' THEN isNULL(직장주소상세,'')
	END AS 주소상세,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN 집우편번호
	WHEN S.우편물수신처 = '직장' THEN 직장우편번호
	END AS 우편번호
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
	-- 최근 8개월 이내에 후원증액콜을 받고 거절한 적이 있는 후원자 제외
		(기록분류 like 'TM_후원증액%' AND 기록일시 >= CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126) AND 기록분류상세='통성-증액거절')
	-- 최근 1년 이내에 후원증액콜을 받고 업그레이드 이력이 있는 후원자 제외
		OR (기록분류상세 = '통성-증액성공' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3년 이내 스페셜 어필 콜에서 거절한 적이 있는 후원자 제외 
		OR (기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원거절' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- 우편 반송 이력이 있는 후원자 제외
		OR (기록분류상세='반송-X')
	-- 다운그레이드 이력이 2년 내에 있는 사람 제외
		OR (기록분류상세 = 'SS-DGamount'	AND 처리진행사항='IH-완료' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2년 이내 캔슬 신청을 한 적 있는 사람 제외
		OR (기록분류 = 'Cancellation' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY 회원번호
) E 
ON S.회원번호 = E.회원번호
	LEFT JOIN (
	SELECT
		회원번호
	 FROM 
		dbo.donotCall
	 GROUP BY 회원번호 
	) D 
ON S.회원번호 = D.회원번호
WHERE
	-- 최근 8개월 이전 가입자만 해당
	S.가입일 < CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126)
	AND S.회원상태 = 'normal'
	-- 우편 수신안함 제외
	AND S.우편물수신처 in ('자택','직장')
	-- 우편번호 없는 것 제외
	AND (CASE WHEN S.우편물수신처='자택' THEN S.집우편번호 ELSE S.직장우편번호 END ) is not null
	AND E.회원번호 IS NULL 
	AND D.회원번호 IS NULL
ORDER BY 우편물수신처
GO

------------------------ Special Appeal TM 최종 대상자


SELECT
	S.회원번호, S.성명, S.휴대전화번호
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
	-- 최근 7개월 이내에 후원증액콜을 받고 거절한 적이 있는 후원자 제외
		(기록분류 like 'TM_후원증액%' AND 기록일시 >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126) AND 기록분류상세='통성-증액거절')
	-- 최근 1년 이내에 후원증액콜을 받고 업그레이드 이력이 있는 후원자 제외
		OR (기록분류상세 = '통성-증액성공' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3년 이내 스페셜 어필 콜에서 거절한 적이 있는 후원자 제외 
		OR (기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원거절' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- 우편 반송 이력이 있는 후원자 제외
		OR (기록분류상세='반송-X')
	-- TM 이력이 45일 이내에 있는 사람
		 OR (참고일 >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126))
	-- 다운그레이드 이력이 2년 내에 있는 사람 제외
		OR (기록분류상세 = 'SS-DGamount'	AND 처리진행사항='IH-완료' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2년 이내 캔슬 신청을 한 적 있는 사람 제외
		OR (기록분류 = 'Cancellation' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY 회원번호
) E 
ON S.회원번호 = E.회원번호
	LEFT JOIN (
	SELECT
		회원번호
	 FROM 
		dbo.donotCall
	 GROUP BY 회원번호 
	) D 
ON S.회원번호 = D.회원번호
WHERE
	-- 최근 7개월 이전 가입자만 해당
	S.가입일 < CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)
	AND S.회원상태 = 'normal'
	-- 우편 수신안함 제외
	AND S.우편물수신처 in ('자택','직장')
	-- 우편번호 없는 것 제외
	AND (CASE WHEN S.우편물수신처='자택' THEN S.집우편번호 ELSE S.직장우편번호 END ) is not null
	-- 휴대폰번호 없는 사람 제외
	AND S.휴대전화번호 IS NOT NULL
	AND E.회원번호 IS NULL 
	AND D.회원번호 IS NULL	
ORDER BY 우편물수신처
GO


------------------------ Special Appeal DM 최종 대상자 


SELECT
	S.회원번호,
	S.성명,
	S.우편물수신처,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN 집주소
	WHEN S.우편물수신처 = '직장' THEN 직장주소
	END AS 주소,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN isNULL(집주소상세,'')
	WHEN S.우편물수신처 = '직장' THEN isNULL(직장주소상세,'')
	END AS 주소상세,
	CASE 
	WHEN S.우편물수신처 = '자택' THEN 집우편번호
	WHEN S.우편물수신처 = '직장' THEN 직장우편번호
	END AS 우편번호
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
	-- 최근 7개월 이내에 후원증액콜을 받고 거절한 적이 있는 후원자 제외
		(기록분류 like 'TM_후원증액%' AND 기록일시 >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126) AND 기록분류상세='통성-증액거절')
	-- 최근 1년 이내에 후원증액콜을 받고 업그레이드 이력이 있는 후원자 제외
		OR (기록분류상세 = '통성-증액성공' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3년 이내 스페셜 어필 콜에서 거절한 적이 있는 후원자 제외 
		OR (기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원거절' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- 우편 반송 이력이 있는 후원자 제외
		OR (기록분류상세='반송-X')
	-- TM 이력이 45일 이내에 있는 사람
		OR (참고일 >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126))
	-- 다운그레이드 이력이 2년 내에 있는 사람 제외
		OR (기록분류상세 = 'SS-DGamount'	AND 처리진행사항='IH-완료' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2년 이내 캔슬 신청을 한 적 있는 사람 제외
		OR (기록분류 = 'Cancellation' AND 참고일 >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY 회원번호
) E 
ON S.회원번호 = E.회원번호
	LEFT JOIN (
	SELECT
		회원번호
	 FROM 
		dbo.donotCall
	 GROUP BY 회원번호 
	) D 
ON S.회원번호 = D.회원번호
WHERE
	-- 최근 7개월 이전 가입자만 해당
	S.가입일 < CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)
	AND S.회원상태 = 'normal'
	-- 우편 수신안함 제외
	AND S.우편물수신처 in ('자택','직장')
	-- 우편번호 없는 것 제외
	AND (CASE WHEN S.우편물수신처='자택' THEN S.집우편번호 ELSE S.직장우편번호 END ) is not null
	-- 휴대폰번호 없는 사람 제외
	AND S.휴대전화번호 IS NOT NULL
	AND E.회원번호 IS NULL 
	AND D.회원번호 IS NULL	
ORDER BY 우편물수신처
GO

use mrm
go

-- DM 대상 중 TM 콜 대상 뽑기
SELECT
	D.회원번호
FROM
	dbo.dmTarget D
	LEFT JOIN 
	(SELECT 
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		(참고일 >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126) AND (기록분류 like 'TM%' OR 기록분류 ='Cancellation') )
		OR (기록일시 >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126) AND (기록분류 like 'TM%' ))
	) H
	ON D.회원번호 = H.회원번호
	LEFT JOIN
	(SELECT 
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	WHERE
		회원상태 in ('Canceled','Stop_tmp')
	) S
	ON D.회원번호 = S.회원번호
WHERE
	H.회원번호 IS NULL 
	AND S.회원번호 IS NULL
group by
D.회원번호