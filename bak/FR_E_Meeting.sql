SELECT
	count(1) as Totaldonor, 
	sum(case when �ѳ��αݾ� > 1 then 1 else 0 end) as Netdonor,
	sum(case when ������ >= CONVERT(varchar(10), '2017-10-01', 126) then 1 else 0 end) as thismonth,
	sum(case when ������ >= CONVERT(varchar(10), '2017-01-01', 126) then 1 else 0 end) as thisyear,
	sum(case when ������ >= CONVERT(varchar(10), '2017-01-01', 126) and �ѳ��αݾ� > 1 then 1 else 0 end) as Netdonor_thisyear
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
go

SELECT
	���԰��, 
	count(1) as �Ѱ�����,
	sum(case when ���ʳ��γ�� is not null then 1 else 0 end) as ��ȯ�Ȱ�����
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���԰�� in ('�Ÿ�����','���ͳ�/Ȩ������','Lead Conversion')
	AND ������ >= CONVERT(varchar(10), '2017-01-01', 126)
GROUP BY
	���԰��
go

select
	���԰��,
	ȸ����ȣ,
	���ʳ��γ��
from
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	