select 
	mem.ȸ����ȣ, mem.ȸ������, crd.���ΰ��
from 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� mem 
	left join MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������� as crd
on 
	mem.ȸ����ȣ = crd.ȸ����ȣ
where 
	-- ��¥ ���� ����� Ȯ���� ��
	crd.������ = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
	-- crd.������ >= CONVERT(varchar(10), '2017-09-29', 126) and  crd.������ <= CONVERT(varchar(10), '2017-10-09', 126)
	and crd.���ΰ�� !='MRM'
order by 1 desc
go
