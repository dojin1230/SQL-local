use mrm
go
-- Case A
SELECT
	H.*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON H.ȸ����ȣ = S.ȸ����ȣ
WHERE
	H.��Ϻз�='TM_����' 
	and H.��Ϻз��� ='�뼺-�Ŀ�����'
	and H.����Ͻ� >= CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126) 
	and H.����Ͻ� < CONVERT(varchar(10), DATEADD(day, -20, GETDATE()), 126)
	and ((S.CMS���� not in ('�űԿϷ�','�ű�����') and S.CARD���� !='���οϷ�') OR S.CMS�����ڷ����ʿ�='Y')
go

-- Case B
SELECT
	S.*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON H.ȸ����ȣ = S.ȸ����ȣ
WHERE
	H.��Ϻз�='TM_����' 
	and H.��Ϻз��� not in ('�뼺-�Ŀ�����','�뼺-�Ŀ�����')
	and H.����Ͻ� >= CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126) 
	and H.����Ͻ� < CONVERT(varchar(10), DATEADD(day, -20, GETDATE()), 126)
	and ((S.CMS���� not in ('�űԿϷ�','�ű�����') and S.CARD���� !='���οϷ�') OR S.CMS�����ڷ����ʿ�='Y' OR S.CARD����='���δ��')
go
