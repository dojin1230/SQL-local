SELECT TOP (1000)
*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� record

WHERE 
	������ = CONVERT(varchar(10), GETDATE() - 1, 126)





SELECT TOP (100)
	DI.ȸ����ȣ, T1.ȸ����ȣ, T1.��Ϻз���, T2.������, DI.���ο���, DI.���԰��,
	CASE WHEN
		DI.���԰�� = '�Ÿ�����'
		THEN 
		'����+�޷¹��'
		ELSE
		'����'
		END
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] DI
LEFT JOIN 
	(SELECT 
		ȸ����ȣ, ��Ϻз���
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
	WHERE 
		��Ϻз��� = '�ݼ�-x') T1
	ON
		DI.ȸ����ȣ = T1.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ, ������
	FROM
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_��������]
	WHERE 
		LEFT(������,4) IN (2016, 2017)) T2
	ON
		DI.ȸ����ȣ = T2.ȸ����ȣ

WHERE 
	DI.[ȸ������] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	T1.ȸ����ȣ IS NULL
	AND
	T2.������ IS NOT NULL
	AND
	DI.���ο��� = 'Y'



-----


SELECT TOP (100)
	DI.ȸ����ȣ, T1.ȸ����ȣ, T1.��Ϻз���, T2.������, DI.���ο���, DI.���԰��,
	CASE WHEN
		DI.���԰�� = '�Ÿ�����'
		THEN 
		'����+�޷¹��'
		ELSE
		'����'
		END
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] DI

LEFT JOIN
	(SELECT 
		ȸ����ȣ, ������
	FROM
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_��������]
	WHERE 
		LEFT(������,4) IN (2016, 2017)) T2
	ON
		DI.ȸ����ȣ = T2.ȸ����ȣ

WHERE 
	DI.[ȸ������] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	DI.ȸ����ȣ NOT IN 
	(SELECT 
		ȸ����ȣ, ��Ϻз���
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
	WHERE 
		��Ϻз��� = '�ݼ�-x')
	AND
	DI.ȸ����ȣ IN
	(SELECT 
		ȸ����ȣ, ������
	FROM
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_��������]
	WHERE 
		LEFT(������,4) IN (2016, 2017))
	AND
	DI.���ο��� = 'Y'


------



SELECT TOP (100)
	*
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] A
WHERE EXISTS
	(SELECT 
		ȸ����ȣ
		FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
		WHERE
		��Ϻз��� = '�ݼ�-x'
		)

-------


SELECT TOP (100)
	*
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] A
WHERE 
	A.ȸ����ȣ NOT IN
	(SELECT 
		ȸ����ȣ
		FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
		WHERE
		��Ϻз��� = '�ݼ�-x'
		)


---------








SELECT 
	PH.ȸ����ȣ, PH.������
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_��������] PH
WHERE 
	LEFT(PH.������,4) IN (2016, 2017)

SELECT 
	AH.ȸ����ȣ, AH.��Ϻз���
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AH
WHERE 
	AH.��Ϻз��� = '�ݼ�-x'





-- ������ Iī�庯���̰� ������ ��¥�� ī�� �������γ�¥ �� --


-- ����� �������� �� ã�� ���� --

-- �����̷¿��� ���ι���� [������ü] �� �߸��� ������ ���� ��� --

-- ���������� ������ ����¡ ����� ã�� �Ŀ������ڵ��� 12�� ����� ���еȰ��, ī����γ�¥Ȯ��, ī����ѵ����� -- ī����ݽ��γ��� ���� Iī�庯��
���ΰ���/�����ܾ׺���


�ŷ����� �ŷ�����ī��
ȸ����������ó���Ұ�
��ȿ�� ȸ���� �ƴմϴ�.
