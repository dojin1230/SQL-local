-- Case A
SELECT D.회원번호, D.회원상태, D.납부여부, D.납부일시중지시작, D.납부일시중지종료, H.처리진행사항
	FROM dbo.UV_GP_후원자정보 D LEFT JOIN DBO.UV_GP_관리기록 H
		ON D.회원번호 = H.회원번호	
			WHERE H.기록분류='Cancellation' 
			and (H.기록분류상세='SS-Canceled' OR H.기록분류상세='Canceled')
			and H.처리진행사항='IH-진행'
			and (D.회원상태 !='canceled' OR D.납부여부!='N' OR 납부일시중지시작 is not null OR 납부일시중지종료 is not null)
go

-- Case B
SELECT D.회원번호, D.회원상태, D.납부여부, D.납부일시중지시작, D.납부일시중지종료, H.처리진행사항
	FROM dbo.UV_GP_후원자정보 D LEFT JOIN DBO.UV_GP_관리기록 H
		ON D.회원번호 = H.회원번호	
			WHERE H.기록분류='Cancellation' 
			and (H.기록분류상세='SS-Downgrade')
			and H.처리진행사항='IH-진행'
			and (D.회원상태 !='normal' OR D.납부여부!='Y' OR 납부일시중지시작 is not null OR 납부일시중지종료 is not null)
go

			
-- Case D
SELECT D.회원번호, D.회원상태, D.납부여부, D.납부일시중지시작, D.납부일시중지종료, H.처리진행사항
	FROM dbo.UV_GP_후원자정보 D LEFT JOIN DBO.UV_GP_관리기록 H
		ON D.회원번호 = H.회원번호	
			WHERE H.기록분류상세='자발_Unfreezing'
			and H.처리진행사항='IH-진행'			
go

		

			

		