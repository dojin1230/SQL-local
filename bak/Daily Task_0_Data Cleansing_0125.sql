--dbo.UV_GP_�Ŀ������� 	 		ȸ����Ȳ								D	Donor 
--dbo.UV_GP_�Ŀ������ݾ����� 	 	�����׸�								PL	Payment List
--dbo.UV_GP_�Ͻ��Ŀ�������� 	 	�ſ�ī��(���̽�����) > ���ó�����Ȳ	T	Temporary Result
--dbo.UV_GP_�ſ�ī��������� 	 	�ſ�ī�� > ȸ��������Ȳ				CA 	Card Approval
--dbo.UV_GP_�ſ�ī�������� 	 	�ſ�ī�� > ���ⳳ����Ȳ				CR 	Card Result 	
--dbo.UV_GP_�����̷� 	 		�����̷�								CH 	Change History
--dbo.UV_GP_������� 	 		�������								H 	History	
--dbo.UV_GP_�������� 	 		ȸ�񳳺� - ������ �Ŀ���				PR	Payment Result	
--dbo.UV_GP_CMS�������� 	 		SmartCMS > ȸ����û					BA 	Bank Approval
--dbo.UV_GP_CMS������� 	 		SmartCMS > ��ݽ�û					BR 	Bank Result

USE work
GO
-- ���԰�� NULL��
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���԰�� is null

-- ȸ������ NULL��
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	ȸ������ is null


-- ������ NULL�� 
SELECT 
	ȸ����ȣ, ����Ͻ�, ��Ϻз�, ��Ϻз���, ������, ó���������, ����, �����Է���, ��ϱ���2
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE 
	��Ϻз���!='��ó��' AND
	������ is null
go

-- �̸� & ��ȭ��ȣ �ߺ� ã��
SELECT
	����, �޴���ȭ��ȣ
FROM 
	[work].[dbo].[db0_clnt_i]
GROUP BY 
	����, �޴���ȭ��ȣ
HAVING COUNT(�޴���ȭ��ȣ) > 1

-- �̸� & �̸��� �ߺ� ã��
SELECT
	����, �̸���
FROM 
	[work].[dbo].[db0_clnt_i]
GROUP BY 
	����, �̸���
HAVING COUNT(�̸���) > 1


-- CMS ������ : �ֱ� 30�� ���� CMS ���� �����ߴµ��� Freezing���� �����ִ� ���
SELECT 
	D.ȸ����ȣ, D.ȸ������, D.CMS����, H.��Ϻз�, H.��Ϻз���, H.�ֱ�Freezing��, C.��û��, CP.�ֱ������ 
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D 
LEFT JOIN 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������� 	 C
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
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������
	WHERE 
		ó�����=N'��ݿϷ�'
	GROUP BY
		ȸ���ڵ�
	) CP
ON
	C.ȸ����ȣ = CP.ȸ���ڵ�
WHERE 
	C.��û�� >= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND C.��û���� = N'�ű�' 	
	AND D.ȸ������='Freezing'
	AND (H.�ֱ�Freezing�� <= C.��û�� OR H.�ֱ�Freezing�� <= CP.�ֱ������)
ORDER BY
	D.ȸ����ȣ
go


-- �ſ�ī�� ������ : �ֱ� 30�� ���� �ſ�ī�� �����ߴµ��� Freezing���� �����ִ� ���
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
		���=N'����'
	GROUP BY
		ȸ���ڵ�
	) CP
ON
	C.ȸ����ȣ = CP.ȸ���ڵ�
WHERE 
	C.������>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND D.ȸ������ = 'Freezing'
	AND (H.�ֱ�Freezing�� <= C.������ OR H.�ֱ�Freezing�� <= CP.�ֱ������)
ORDER BY
	D.ȸ����ȣ
go

-- �ſ�ī�� ���� ������ Ȯ�� -- TM���� �ſ�ī�� ���� �� ���� �� ī�庯���� �ߴ��� Ȯ��
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
  (
  SELECT ȸ����ȣ
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
  WHERE ������ >= CONVERT(varchar(10), DATEADD(day, -4, GETDATE()), 126)
) CA
ON H.ȸ����ȣ = CA.ȸ����ȣ
WHERE ��Ϻз� = 'TM_�ſ�ī�����Ό��' AND ��Ϻз��� = '�뼺-���浿��'
  AND H.������ >= CONVERT(varchar(10), DATEADD(day, -4, GETDATE()), 126)
  AND CA.ȸ����ȣ IS NULL

-- ĵ�� 
------ �ٽ� ���� �ʿ�
--SELECT
--	H.ȸ����ȣ, H.�Ŀ������, S.ȸ������
--(SELECT 
--	ȸ����ȣ, MAX(������) AS �Ŀ������
--FROM 	
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
--WHERE
--	��Ϻз� = 'Cancellation'
--	AND ó��������� ='IH-�Ϸ�' 
--	AND ��Ϻз��� in ('SS-Canceled', 'Canceled')
--GROUP BY 
--	ȸ����ȣ) H
--LEFT JOIN 
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
--ON 
--	S.ȸ����ȣ = H.ȸ����ȣ
--WHERE 
--	S.ȸ������ !='canceled'

--SELECT
--	*
--FROM
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷�	

-- ȸ�� ���� ������ ��ġ�� 
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
-- ����¡ �� ��¥ �ҷ������� ���� : �ݵ�� �ʿ������� ����
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
WHERE 
	ȸ������='Freezing' 
	AND (�����Ͻ��������� is null OR �����Ͻ��������� !='2020-12')
go

-- �Ͻ������� ����
SELECT
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
WHERE
	�����Ͻ��������� is not null
	AND �����Ͻ��������� !='2020-12'
	AND ȸ������ != 'Stop_tmp'
GO

---- �Ͻ��Ŀ��� �����ؾ���
---- �븻 ����
--SELECT
--	ȸ����ȣ, ȸ������, �����Ͻ���������, �����Ͻ���������, ���ο���, �������γ��, �ѳ��ΰǼ�
--FROM 
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
--WHERE
--	(�����Ͻ��������� is not null OR �����Ͻ��������� is not null OR ���ο���='N')
--	AND ȸ������ = 'Normal'
--ORDER BY �������γ�� DESC

-- CMS �����ڷ� ��� �ʿ��� �����     -- ���ʵ�� �Ͻ� ���� ������ ������ ���ܷ� ����
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(SELECT ȸ����ȣ
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE ��Ϻз� = 'TM_����' AND ó��������� = 'SK-����') H
ON D.ȸ����ȣ = H.ȸ����ȣ
WHERE
	CMS�����ڷ����ʿ� = 'Y'
	AND ȸ������ =  'Normal'
	AND ������ < CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)   -- ���ʵ���Ϸ� ����??
	AND H.ȸ����ȣ IS NULL
	AND D.���ʵ�ϱ��� != '�Ͻ�'

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
	AND ���ν��۳�� is not null
	AND ���������� is null
	--AND �������γ�� is null
	AND ���ι�� is not null

	
-- �ټ��� �ߺ�
SELECT 
	H.ȸ����ȣ, H.��Ϻз�, H.��Ϻз���, H.������, H.ó���������
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
WHERE
	H.ȸ����ȣ IN
		(SELECT 
			S.ȸ����ȣ
		FROM 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
		LEFT JOIN
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
		ON 
			S.ȸ����ȣ = H.ȸ����ȣ
		WHERE
			H.ó��������� in (N'SK-����',N'IH-����',N'IH-����')
			AND H.��Ϻз��� !=N'����'
			AND H.��Ϻз� not in (N'�������� ��û/����',N'ķ���ΰ��� ��û/����/�Ҹ�����',N'���� �������� ��û/����','��Ÿ','Impact report','Other mailings','Welcome pack',N'���ݰ��ù���','Annual report')
		GROUP BY
			S.ȸ����ȣ
		HAVING 
			COUNT(S.ȸ����ȣ) >= 2)
	AND H.ó��������� in (N'SK-����',N'IH-����',N'IH-����')
ORDER BY
	H.ȸ����ȣ

-- ĵ�� ��� ����ġ



-- 3�� �����µ��� ���� �� �� �������� �ִ��� Ȯ��
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	��Ϻз�=N'TM_����' AND
	ó��������� not in (N'SK-�Ϸ�', N'IH-�Ϸ�') AND
	����Ͻ� < CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126)


-- TM �� ó����������� �߸��� ��
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
WHERE ��Ϻз� LIKE 'TM%' 
	AND ó��������� IN (N'SK-����',N'SK-����') 
	AND ��Ϻз��� NOT IN (N'����',N'�뼺-����X',N'��ó��',N'�뼺-��������')
	OR ó��������� is null
ORDER BY 
	��Ϻз�, ��Ϻз���
GO

---- ���� �ȵ� ���ⳳ�������� �� �� �̻��� ��
--SELECT 
--	ȸ����ȣ, ���Ῡ��
--FROM 
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� 
--GROUP BY
--	ȸ����ȣ, ���Ῡ��
--HAVING
--	���Ῡ�� = 'N'
--	AND ȸ����ȣ >= 2
--ORDER BY ȸ����ȣ

-- �Ⱓ �Ŀ��� ���� 
SELECT
	*--P.ȸ����ȣ, P.������
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������ݾ����� P
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
ON
	P.ȸ����ȣ = S.ȸ����ȣ
WHERE
	P.������ = '2017-12'
	AND P.���۳�� != '2017-12'
	AND P.���Ῡ�� = 'N'
	AND S.ȸ������ != 'canceled' 
	AND S.���ʵ�ϱ��� = N'����'



-- ȸ�����°� canceled �ε� ĵ�� ����� ���� ȸ�� 
SELECT 
	D.ȸ����ȣ, D.ȸ������, D.���ο���, D.���԰��
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] D
LEFT JOIN
	(SELECT 
		* 
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] 
	WHERE 
		��Ϻз� = 'Cancellation') H
ON
	D.ȸ����ȣ = H.ȸ����ȣ
WHERE 
	D.[ȸ������] = 'canceled'
	AND H.[ȸ����ȣ] IS NULL


-- ȸ�����°� Freezing �ε� ����� ���� ȸ�� 
SELECT
	D.ȸ����ȣ, D.ȸ������, D.���ο���, D.���԰��
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] D
LEFT JOIN
	(SELECT 
		* 
	FROM 
		[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������]
	WHERE 
		��Ϻз� = 'freezing') H
ON
	D.ȸ����ȣ = H.ȸ����ȣ
WHERE 
	D.[ȸ������] = 'freezing'
	AND H.[ȸ����ȣ] IS NULL


-- ĵ�� �����ϵ� ��¥ �������� ĵ����� ���� �˻�

SELECT
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN 
	(SELECT 
		* 
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE 
		��Ϻз� = 'Cancellation' 
		AND ������ >= GETDATE() - 14) H			-- �����Ͻÿ� ������ ���ں��� ū ���� �Է�
ON 
	CH.ȸ����ȣ = H.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ, ȸ������
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	WHERE 
		ȸ������ = 'canceled') D
ON 
	CH.ȸ����ȣ = D.ȸ����ȣ
WHERE 
	������ = 'canceled'							-- ȸ�����°� canceled�� ����� �ڷ�˻�
	AND �����Ͻ� >= GETDATE() - 7				-- ���÷κ��� 24*7 �ð��� ����� �ڷ���� �˻� (���� ���� ����)
	AND H.ȸ����ȣ IS NULL
	AND D.ȸ����ȣ IS NOT NULL

-- ĵ��ȸ�� �������� �� Ȯ�� �� ���� ó�� --

SELECT D.ȸ����ȣ
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
(SELECT ȸ����ȣ
 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
 WHERE 
 ��Ϻз� NOT LIKE '%�����%'
 AND ó��������� = 'SK-����') H
ON D.ȸ����ȣ = H.ȸ����ȣ
WHERE ȸ������ = 'canceled'
AND H.ȸ����ȣ IS NOT NULL


