-- ���԰�� NULL��
SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���԰�� is null


-- ������ NULL�� 
SELECT 
	ȸ����ȣ, ����Ͻ�, ��Ϻз�, ��Ϻз���, ������, ó���������, ����, �����Է���, ��ϱ���2
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE 
	��Ϻз���!='��ó��' AND
	������ is null
go


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
	C.��û��>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
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

-- CMS �����ڷ� ��� �ʿ��� �����
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
WHERE
	CMS�����ڷ����ʿ� = 'Y'
	AND ȸ������ =  'Normal'
	AND ������ < CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)

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

-- ���� �ȵ� ���ⳳ�������� �� �� �̻��� ��
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
--(
SELECT
	ȸ����ȣ
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ�������
WHERE
	����������='2017-12'
	AND ȸ������ != 'canceled' 
	AND ���ʵ�ϱ��� = N'����'
--	) S
--ON
--	P.ȸ����ȣ = S.ȸ����ȣ
--WHERE
--	P.����=N'����'
--	AND P.���Ῡ�� = 'N'
--	AND P.������ != ''
--	AND P.������ < '2017-12'
--	AND S.ȸ����ȣ is null
--GROUP BY
--	P.ȸ����ȣ


use mrm
go

SELECT
	count(ȸ����ȣ), ����, �޴���ȭ��ȣ
FROM
	[dbo].[db0_clnt_i]
WHERE
	�޴���ȭ��ȣ is not null
GROUP BY
	����, �޴���ȭ��ȣ
HAVING 
	count(ȸ����ȣ) >= 2

