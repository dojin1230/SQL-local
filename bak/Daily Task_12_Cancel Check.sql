use mrm
go

-- Case A

select 
	S.ȸ����ȣ, S.ȸ������, S.���ο���, S.�����Ͻ���������, S.�����Ͻ���������
from
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S	
ON H.ȸ����ȣ = S.ȸ����ȣ
WHERE H.��Ϻз�='Cancellation'
	AND H.ó���������='IH-����'
	AND H.��Ϻз��� in ('SS-Canceled', 'Canceled')
	AND S.ȸ����ȣ is null
go
