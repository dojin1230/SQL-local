

-- ȸ�����°� canceled �ε� ĵ�� ����� ���� ȸ�� -- 

SELECT TOP (100)
	DI.ȸ����ȣ, DI.ȸ������, DI.���ο���, DI.���԰��
	
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] DI
LEFT JOIN
	(SELECT 
		* 
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] 
	WHERE
		��Ϻз� = 'Cancellation') AR
ON
	DI.ȸ����ȣ = AR.ȸ����ȣ
WHERE 
	DI.[ȸ������] = 'canceled'
	AND
	AR.[ȸ����ȣ] IS NULL
	


-- ȸ�����°� Freezing �ε� ����� ���� ȸ�� -- 

SELECT TOP (100)
	DI.ȸ����ȣ, DI.ȸ������, DI.���ο���, DI.���԰��
	
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] DI

LEFT JOIN
	(SELECT 
	* 
	FROM
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
	WHERE 
		��Ϻз� = 'freezing') AR
ON
	DI.ȸ����ȣ = AR.ȸ����ȣ
WHERE 
	DI.[ȸ������] = 'freezing'
	AND
	AR.[ȸ����ȣ] IS NULL