USE mrm
go

-- ������ ����
SELECT 
	ȸ����ȣ, ����Ͻ�, ��Ϻз�, ��Ϻз���, ������, ó���������, ����, �����Է���, ��ϱ���2
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE 
	��Ϻз��� not in ('��ó��','�뼺-��������','�뼺-����X')
	AND ������ is null
go


-- �ſ�ī�� ������
SELECT 
	D.ȸ����ȣ, D.ȸ������, D.CARD����, H.��Ϻз�, H.��Ϻз���, H.�ֱ�Freezing��, C.������, CP.�ֱ������ 
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D 
LEFT JOIN 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������� C
ON 
	C.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN 
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, ��Ϻз���, MAX(������) �ֱ�Freezing��
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		��Ϻз�='Freezing'
	GROUP BY
		ȸ����ȣ, ��Ϻз�, ��Ϻз���
	)H
ON 
	D.ȸ����ȣ = H.ȸ����ȣ
LEFT JOIN 
	(SELECT 
		ȸ���ڵ�, MAX(�����) �ֱ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������
	WHERE 
		���='����'
	GROUP BY
		ȸ���ڵ�
	) CP
ON
	C.ȸ����ȣ = CP.ȸ���ڵ�
WHERE 
	C.������>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND D.ȸ������='Freezing'
	AND (H.�ֱ�Freezing�� <= C.������ OR H.�ֱ�Freezing�� <= CP.�ֱ������)
ORDER BY
	D.ȸ����ȣ
go


-- ĵ����� ����ġ
------ �ٽ� ���� �ʿ�
(SELECT 
	ȸ����ȣ, ��Ϻз�, ��Ϻз���, ������
FROM 	
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	��Ϻз� = 'Cancellation'
	AND ó��������� ='IH-�Ϸ�' 
	AND ��Ϻз��� in ('SS-Canceled', 'Canceled')) H
LEFT JOIN 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON 
	S.ȸ����ȣ = H.ȸ����ȣ
WHERE 
	S.ȸ������ !='canceled'
	AND 
EXCEPT 		
(SELECT
	ȸ����ȣ
FROM 
	dbo.donotCall
GROUP BY ȸ����ȣ )		
AND H.��Ϻз��� ='�ڹ�_Reactivation'
go

SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷�	


-- ĵ�� ����
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
WHERE 
	ȸ������='canceled' 
	AND (���ο���!='N' OR �����Ͻ��������� is not null OR �����Ͻ��������� is not null)
go

-- ����¡ ����
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
WHERE 
	ȸ������='Freezing' 
	AND (�����Ͻ��������� is null OR �����Ͻ��������� !='2020-12')
go

-- �븻 ����
-- �� ���̶� ����� ������ ���� �ִٸ� ���� ȸ��
-- max �����ϸ� �ҷ�������

SELECT
	S.ȸ����ȣ, S.CMS����, S.CARD����, S.CMS�����ڷ����ʿ�, S.�ѳ��ΰǼ�, S.�������γ��, S.������, H.������, H.��Ϻз�, H.��Ϻз���
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� P
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON
	P.ȸ����ȣ = S.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
ON
	P.ȸ����ȣ = H.ȸ����ȣ
WHERE
	P.�������='����'
	and ((S.CMS���� not in ('�űԿϷ�','�ű�����','�����Ϸ�','��������') and S.CARD���� !='���οϷ�') OR S.CMS�����ڷ����ʿ�='Y')
	and S.ȸ������='Normal'
	and S.�������γ�� >= '2017-05'
	and S.�ѳ��ΰǼ� >=2
	and S.���ι�� is not null
go

-- �����ݾ� ���� Y ������ ����
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� 
WHERE
	���Ῡ��='Y'
	AND (������ is null OR ������='')

-- �Ͻ��Ŀ� ����	
-- �����׸��� ����/�Ͻ� ���θ� �� �� �־�� �� �Ϻ��� ���� © �� ���� dbo.UV_GP_�Ŀ������ݾ����� 
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ�������
WHERE ���ʵ�ϱ���='�Ͻ�'
	AND ȸ������='Normal'
	AND ���ο���='Y'
	AND �ѳ��ΰǼ�='0'
	AND ���ν��۳�� is not null
	AND ���������� is null
	AND �������γ�� is null
	AND ���ι�� is not null

SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� 
WHERE
	���Ῡ��='Y'

-- 3�� �� ���� �������� �ִ��� Ȯ��
