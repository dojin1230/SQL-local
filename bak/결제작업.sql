SELECT 
	dbo_UV_GP_후원자정보.회원번호, 
	dbo_UV_GP_후원자정보.납부방법, 
	dbo_UV_GP_후원자정보.회원상태, 
	dbo_UV_GP_후원자정보.납부금액, 
	dbo_UV_GP_후원자정보.납부주기개월, 
	IIf(dbo_UV_GP_후원자정보.[납부방법]="CMS" And dbo_UV_GP_후원자정보.[CMS상태]="신규완료",1,
		IIf(dbo_UV_GP_후원자정보.[납부방법]="CMS" And dbo_UV_GP_후원자정보.[CMS상태]="수정완료",1,
			IIf(dbo_UV_GP_후원자정보.[납부방법]="신용카드" And dbo_UV_GP_후원자정보.[CARD상태]="승인완료",1,0))) AS 결제조건1, 

	IIf(dbo_UV_GP_후원자정보.[납부주기개월]=1,1,0) AS 결제조건2, 
	IIf(dbo_UV_GP_후원자정보.[납부시작년월] Is Null,0,1) AS 결제조건3, 
	IIf(dbo_UV_GP_후원자정보.[납부일시중지시작] Is Null,1,0) AS 결제조건4, 
	IIf(dbo_UV_GP_후원자정보.[납부일시중지종료] Is Null,1,0) AS 결제조건5, 
	dbo_UV_GP_후원자정보.납부일, 
	IIf([최종납부년월]="2017-10",0,1) AS 결제조건6
FROM 
	dbo_UV_GP_후원자정보
WHERE 
	(
		((IIf([최종납부년월]="2017-10",0,1))=1) 
		And 
		((IIf(dbo_UV_GP_후원자정보.납부방법="CMS" And dbo_UV_GP_후원자정보.CMS상태="신규완료",1,
			IIf(dbo_UV_GP_후원자정보.납부방법="CMS" And dbo_UV_GP_후원자정보.CMS상태="수정완료",1,
				IIf(dbo_UV_GP_후원자정보.납부방법="신용카드" And dbo_UV_GP_후원자정보.CARD상태="승인완료",1,0))))=1) 
		And ((IIf(dbo_UV_GP_후원자정보.납부주기개월=1,1,0))=1) 
		And ((IIf(dbo_UV_GP_후원자정보.납부시작년월 Is Null,0,1))=1) 
		And ((IIf(dbo_UV_GP_후원자정보.납부일시중지시작 Is Null,1,0))=1) 
		And ((IIf(dbo_UV_GP_후원자정보.납부일시중지종료 Is Null,1,0))=1)
	);
