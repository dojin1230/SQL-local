DECLARE @TOTAL_DONOR INT
DECLARE @TOTAL_NETDONOR INT
DECLARE @YEAR_DONOR INT
DECLARE @YEAR_NETDONOR INT
DECLARE @MONTH_DONOR INT
DECLARE @DDC_DONOR INT
DECLARE @DDC_NETDONOR INT
DECLARE @WEB_DONOR INT
DECLARE @WEB_NETDONOR INT
DECLARE @TM_DONOR INT
DECLARE @TM_NETDONOR INT
DECLARE @TOTAL_NETDONOR_RATIO decimal(5,1)
DECLARE @YEAR_NETDONOR_RATIO decimal(5,1)
DECLARE @DDC_RATIO decimal(5,1)
DECLARE @WEB_RATIO decimal(5,1)
DECLARE @TM_RATIO decimal(5,1)
DECLARE @DDC_NETDONOR_RATIO decimal(5,1)
DECLARE @WEB_NETDONOR_RATIO decimal(5,1)
DECLARE @TM_NETDONOR_RATIO decimal(5,1)

SELECT 
	@TOTAL_DONOR = COUNT(1), 
	@TOTAL_NETDONOR = sum(case when 총납부금액 > 1 then 1 else 0 end),
	@YEAR_DONOR = sum(case when 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end),
	@YEAR_NETDONOR = sum(case when 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) and 총납부금액 > 1 then 1 else 0 end),
	@MONTH_DONOR = sum(case when 가입일 >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126) then 1 else 0 end),
	@DDC_DONOR = sum(case when 가입경로='거리모집' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end),
	@DDC_NETDONOR = sum(case when 가입경로='거리모집' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) and 최초납부년월 is not null then 1 else 0 end),
	@WEB_DONOR = sum(case when 가입경로='인터넷/홈페이지' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end),
	@WEB_NETDONOR = sum(case when 가입경로='인터넷/홈페이지' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) and 최초납부년월 is not null then 1 else 0 end),
	@TM_DONOR = sum(case when 가입경로='Lead Conversion' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end),
	@TM_NETDONOR = sum(case when 가입경로='Lead Conversion' and 가입일 >= CONVERT(varchar(10), '2017-01-01', 126) and 최초납부년월 is not null then 1 else 0 end)
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보

SET @TOTAL_NETDONOR_RATIO = CAST((@TOTAL_NETDONOR* 100) /  @TOTAL_DONOR AS DECIMAL(5,1))
SET @YEAR_NETDONOR_RATIO = CAST((@YEAR_NETDONOR* 100) /  @YEAR_DONOR AS DECIMAL(5,1))
SET @DDC_RATIO = (@DDC_DONOR* 100) /  @YEAR_DONOR
SET @WEB_RATIO = (@WEB_DONOR* 100) /  @YEAR_DONOR
SET @TM_RATIO = (@TM_DONOR* 100) /  @YEAR_DONOR
SET @DDC_NETDONOR_RATIO = (@DDC_NETDONOR* 100) /  @DDC_DONOR
SET @WEB_NETDONOR_RATIO = (@WEB_NETDONOR* 100) /  @WEB_DONOR
SET @TM_NETDONOR_RATIO = (@TM_NETDONOR* 100) /  @TM_DONOR

PRINT 
	CONCAT('Total # of dnr/net : ', @TOTAL_DONOR, '/', @TOTAL_NETDONOR, ' (', @TOTAL_NETDONOR_RATIO, '%)', CHAR(13),
	'Total # of dnr/net(2017) : ',  @YEAR_DONOR, '/', @YEAR_NETDONOR,  ' (', @YEAR_NETDONOR_RATIO, '%)', CHAR(13), CHAR(13), 
	'Total no. of donor this month : ', @MONTH_DONOR, CHAR(13), CHAR(13), 
	'Channel : 가입자/납부자(당년가입자비/전환율)', CHAR(13), CHAR(13),
	'DDC : ', @DDC_DONOR, '/',  @DDC_NETDONOR,  ' (', @DDC_RATIO, '%/', @DDC_NETDONOR_RATIO, '%)', CHAR(13),
	'Web : ', @WEB_DONOR, '/',  @WEB_NETDONOR, ' (', @WEB_RATIO, '%/', @WEB_NETDONOR_RATIO, '%)', CHAR(13),
	'Lead Conversion : ', @TM_DONOR, '/',  @TM_NETDONOR, ' (', @TM_RATIO, '%/', @TM_NETDONOR_RATIO, '%)' 
)


