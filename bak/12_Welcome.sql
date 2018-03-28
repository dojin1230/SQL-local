-- 12_Welcome [00_제외조건]

SELECT dbo_UV_GP_관리기록.회원번호
FROM dbo_UV_GP_관리기록
WHERE (((dbo_UV_GP_관리기록.기록분류)="TM_감사")) -- 이미 기록에 감사콜 있는 경우
	OR (((dbo_UV_GP_관리기록.기록분류상세)="결번")) -- 결번인 경우
	OR (((dbo_UV_GP_관리기록.기록구분2) Like "*1*")); -- 통화거부/강한불만 



-- 12_Welcome [Welcome_01]

SELECT dbo_UV_GP_후원자정보.회원번호, dbo_UV_GP_후원자정보.납부방법, dbo_UV_GP_후원자정보.CMS상태, 
		dbo_UV_GP_후원자정보.카드사, dbo_UV_GP_후원자정보.CARD상태, dbo_UV_GP_후원자정보.가입경로, 
		dbo_UV_GP_후원자정보.회원상태, dbo_UV_GP_후원자정보.소속, 
		
		IIf([dbo_UV_GP_후원자정보].[집전화번호] Is Not Null,1,0)
		+IIf([dbo_UV_GP_후원자정보].[직장전화번호] Is Not Null,1,0)
		+IIf([dbo_UV_GP_후원자정보].[휴대전화번호]="유",1,0) 
		AS 연락처유무, 
		
		IIf([dbo_UV_GP_후원자정보].납부방법="CMS" And [dbo_UV_GP_후원자정보].CMS상태 In ("신규실패","수정실패",""),"인증실패/녹취대상",  
			IIf([dbo_UV_GP_후원자정보].납부방법="CMS" And [dbo_UV_GP_후원자정보].CMS상태 & dbo_UV_GP_후원자정보.CMS증빙자료등록필요="신규대기Y","녹취대상", 
				IIf([dbo_UV_GP_후원자정보].납부방법="신용카드" And [dbo_UV_GP_후원자정보].CARD상태 In ("승인대기",""),"인증실패"
					,Null)
				)
			) 
		AS 인증여부, 
		
		IIf(dbo_UV_GP_후원자정보.가입경로="거리모집" 
			And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CMS상태] In ("CMS신규완료","CMS신규실패","CMS수정완료","CMS수정실패","CMS"),1,
			IIf(dbo_UV_GP_후원자정보.가입경로="거리모집" 
			And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CARD상태] In ("신용카드승인대기","신용카드승인완료","신용카드"),1,
				IIf(dbo_UV_GP_후원자정보.가입경로 In ("Lead Conversion","전화") 
				And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CMS상태] In ("CMS신규실패","CMS수정실패","CMS"),1,
					IIf(dbo_UV_GP_후원자정보.가입경로 In ("Lead Conversion","전화") 
					And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CARD상태] In ("신용카드승인대기","신용카드"),1,
						IIf(dbo_UV_GP_후원자정보.가입경로 In ("인터넷/홈페이지") 
						And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CMS상태]="CMS신규대기",1,
							IIf(dbo_UV_GP_후원자정보.가입경로 In ("인터넷/홈페이지") 
							And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CARD상태] In ("신용카드승인대기","신용카드승인완료"),1,
								IIf(dbo_UV_GP_후원자정보.가입경로 Is Null 
								And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CMS상태]="CMS신규대기",1,
									IIf(dbo_UV_GP_후원자정보.가입경로 Is Null 
									And [dbo_UV_GP_후원자정보].[납부방법] & [dbo_UV_GP_후원자정보].[CARD상태] 
									In ("신용카드승인대기","신용카드승인완료","신용카드"),1,0)))))))) 
		AS 채널별콜대상구분, 
							--"거리모집"이고 CMS신규완료/신규실패/수정완료/수정실패/공백, CARD승인대기/승인완료/공백이면 1
							--"Lead Conversion"이나 "전화"이고 CMS신규실패/수정실패/공백, CARD승인대기/공백이면 1
							--"인터넷/홈페이지"이고 CMS신규대기 CARD승인대기/승인완료이면 1
							--가입경로 NULL이고 CMS신규대기 CARD승인대기/승인완료/공백이면 1
							--그밖에는 0 (예:거리모집이고 CMS신규대기/수정대기) 
							--콜대상자=1
						
		
		dbo_UV_GP_후원자정보.최초입력일

FROM 00_제외조건 RIGHT JOIN dbo_UV_GP_후원자정보 

ON [00_제외조건].회원번호 = dbo_UV_GP_후원자정보.회원번호

WHERE (((dbo_UV_GP_후원자정보.회원상태) Not In ("Canceled","Other")) 
	And (
		(IIf(dbo_UV_GP_후원자정보.집전화번호 Is Not Null,1,0)
		+IIf(dbo_UV_GP_후원자정보.직장전화번호 Is Not Null,1,0)
		+IIf(dbo_UV_GP_후원자정보.휴대전화번호="유",1,0))  
			>0
		) 
	And ((dbo_UV_GP_후원자정보.가입일)>="2017-01-01") 
	And ((dbo_UV_GP_후원자정보.최초등록구분)="정기") 
	And ((dbo_UV_GP_후원자정보.등록구분)<>"외국인") 
	And (([00_제외조건].회원번호) Is Null));




-- 12_Welcome [Welcome_02]

SELECT 
	Welcome_01.회원번호, Welcome_01.인증여부 AS 내용, Welcome_01.가입경로, Welcome_01.소속, 
	iif(Welcome_01.납부방법="CMS",Welcome_01.CMS상태, 
		iif(Welcome_01.납부방법="신용카드",Welcome_01.CARD상태,null)) AS 납부방법상태, 
	Welcome_01.회원상태, 
	format(Welcome_01.최초입력일,"yyyy-mm-dd") AS 최초입력일
FROM Welcome_01
WHERE (((Welcome_01.채널별콜대상구분)=1));



-- Welcome, CMS_F

SELECT 
	Welcome_02.[회원번호], Welcome_02.[내용], "TM_감사-미처리" as [기록분류/상세분류], date() as 일자, 
	"SK-진행" as 구분1, "W.CALL_WV" as 제목, Welcome_02.[가입경로], Welcome_02.[납부방법상태], Welcome_02.[최초입력일]

FROM Welcome_02

UNION ALL 

SELECT CMSpf_03.회원번호, CMSpf_03.내용, 
	"TM_CMS증빙-미처리" AS [기록분류/상세분류], date() as 일자, "SK-진행" as 구분1, 
	"CMSVR.CALL_WV" as 제목, CMSpf_03.가입경로, CMSpf_03.CMS상태, CMSpf_03.최초입력일

FROM Welcome_02 RIGHT JOIN CMSpf_03 ON Welcome_02.회원번호 = CMSpf_03.회원번호
WHERE (((Welcome_02.회원번호) Is Null));



--CMSpf_01

SELECT 

dbo_UV_GP_후원자정보.회원번호, dbo_UV_GP_후원자정보.납부방법, dbo_UV_GP_후원자정보.CMS상태, dbo_UV_GP_후원자정보.가입경로, dbo_UV_GP_후원자정보.가입일, dbo_UV_GP_후원자정보.최초입력일

FROM dbo_UV_GP_후원자정보

WHERE (((dbo_UV_GP_후원자정보.납부방법)="CMS") 
	AND ((dbo_UV_GP_후원자정보.CMS상태) Like "*대기*") 
	AND ((dbo_UV_GP_후원자정보.회원상태)="Normal") 
	AND ((dbo_UV_GP_후원자정보.최초등록구분)="정기") 
	AND ((dbo_UV_GP_후원자정보.CMS증빙자료등록필요)="Y"));



--CMSpf_02

SELECT 

	dbo_UV_GP_관리기록.회원번호, dbo_UV_GP_관리기록.기록일시, dbo_UV_GP_관리기록.기록분류, 
	dbo_UV_GP_관리기록.기록분류상세, dbo_UV_GP_관리기록.참고일, dbo_UV_GP_관리기록.처리진행사항, 
	dbo_UV_GP_관리기록.제목, dbo_UV_GP_관리기록.최초입력자, dbo_UV_GP_관리기록.기록구분2, 
	IIf(dbo_UV_GP_관리기록.[처리진행사항] Like "*지연*",1,
		IIf(dbo_UV_GP_관리기록.[처리진행사항] Like "*진행*",1,0)) AS 진행중TF, 
	IIf(dbo_UV_GP_관리기록.[참고일]>=Date()-5,1,0) AS 최근TF

FROM 
	CMSpf_01 INNER JOIN dbo_UV_GP_관리기록 
	
ON CMSpf_01.회원번호 = dbo_UV_GP_관리기록.회원번호

WHERE (((dbo_UV_GP_관리기록.기록분류) Not In ("Freezing","Impact report","Other mailings","Regular E-mail","Regular SMS","survey response","Welcome pack")) AND ((IIf([dbo_UV_GP_관리기록].[처리진행사항] Like "*지연*",1,IIf([dbo_UV_GP_관리기록].[처리진행사항] Like "*진행*",1,0)))=1)) OR (((dbo_UV_GP_관리기록.기록분류) Not In ("Freezing","Impact report","Other mailings","Regular E-mail","Regular SMS","survey response","Welcome pack")) AND ((IIf([dbo_UV_GP_관리기록].[참고일]>=Date()-5,1,0))=1));




--CMSpf_03

SELECT 
	CMSpf_01.회원번호, "녹취대상" AS 내용, CMSpf_01.가입경로, CMSpf_01.납부방법, CMSpf_01.CMS상태, CMSpf_01.가입일, 
	Format(CMSpf_01.최초입력일,'yyyy-mm-dd') AS 최초입력일

FROM CMSpf_02 RIGHT JOIN CMSpf_01 

ON CMSpf_02.회원번호 = CMSpf_01.회원번호

WHERE (
		((Format([CMSpf_01].[최초입력일],'yyyy-mm-dd'))<=Date()-3) 
		AND ((CMSpf_02.회원번호) Is Null)
	);
