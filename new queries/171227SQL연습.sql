SELECT TOP (1000)
*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� record

WHERE 
	������ = CONVERT(varchar(10), GETDATE() - 1, 126)





SELECT TOP (100)
	DI.ȸ����ȣ, T1.��Ϻз���, T2.������, DI.���ο���, DI.���԰��,
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
		AH.ȸ����ȣ, AH.��Ϻз���
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AH
	WHERE 
		AH.��Ϻз��� = '�ݼ�-x') T1
	ON
		T1.ȸ����ȣ = DI.ȸ����ȣ
LEFT JOIN
	(SELECT 
		PH.ȸ����ȣ, PH.������
	FROM
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_��������] PH
	WHERE 
		LEFT(PH.������,4) IN (2016, 2017)) T2
	ON
		T2.ȸ����ȣ = DI.ȸ����ȣ

WHERE 
	DI.[ȸ������] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	T1.��Ϻз��� IS NULL
	AND
	T2.������ IS NOT NULL
	AND
	DI.���ο��� = 'Y'







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