------------------------ Special Appeal ��ü ����� 
--�ֱٿ� ������ ����/������ ��� Ȯ���ϴ� ���� �߰�
--�������γ���� �������� ����鸸 �ش��ų ��

SELECT
	S.ȸ����ȣ
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
	-- �ֱ� 8���� �̳��� �Ŀ��������� �ް� ������ ���� �ִ� �Ŀ��� ����
		(��Ϻз� like 'TM_�Ŀ�����%' AND ����Ͻ� >= CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126) AND ��Ϻз���='�뼺-���װ���')
	-- �ֱ� 1�� �̳��� �Ŀ��������� �ް� ���׷��̵� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз��� = '�뼺-���׼���' AND ������ >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3�� �̳� ����� ���� �ݿ��� ������ ���� �ִ� �Ŀ��� ���� 
		OR (��Ϻз� = 'TM_Ư���Ͻ��Ŀ�' AND ��Ϻз���='�뼺-�Ŀ�����' AND ������ >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- �ٿ�׷��̵� �̷��� 2�� ���� �ִ� ��� ����
		OR (��Ϻз��� = 'SS-DGamount'	AND ó���������='IH-�Ϸ�' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2�� �̳� ĵ�� ��û�� �� �� �ִ� ��� ����
		OR (��Ϻз� = 'Cancellation' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY ȸ����ȣ
) E
	ON S.ȸ����ȣ = E.ȸ����ȣ 
WHERE
	-- �ֱ� 8���� ���� �����ڸ� �ش�
	S.������ < CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126)
	AND S.ȸ������ = 'normal'
	AND E.ȸ����ȣ IS NULL 
EXCEPT 		-- �γ��� ����
(SELECT
	ȸ����ȣ
FROM 
	dbo.donotCall
GROUP BY ȸ����ȣ )	
GO



------------------------ Special Appeal ���� ����� 
SELECT
	S.ȸ����ȣ,
	S.����,
	S.��������ó,
	CASE 
	WHEN S.��������ó = '����' THEN ���ּ�
	WHEN S.��������ó = '����' THEN �����ּ�
	END AS �ּ�,
	CASE 
	WHEN S.��������ó = '����' THEN isNULL(���ּһ�,'')
	WHEN S.��������ó = '����' THEN isNULL(�����ּһ�,'')
	END AS �ּһ�,
	CASE 
	WHEN S.��������ó = '����' THEN �������ȣ
	WHEN S.��������ó = '����' THEN ��������ȣ
	END AS �����ȣ
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
	-- �ֱ� 8���� �̳��� �Ŀ��������� �ް� ������ ���� �ִ� �Ŀ��� ����
		(��Ϻз� like 'TM_�Ŀ�����%' AND ����Ͻ� >= CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126) AND ��Ϻз���='�뼺-���װ���')
	-- �ֱ� 1�� �̳��� �Ŀ��������� �ް� ���׷��̵� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз��� = '�뼺-���׼���' AND ������ >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3�� �̳� ����� ���� �ݿ��� ������ ���� �ִ� �Ŀ��� ���� 
		OR (��Ϻз� = 'TM_Ư���Ͻ��Ŀ�' AND ��Ϻз���='�뼺-�Ŀ�����' AND ������ >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- ���� �ݼ� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз���='�ݼ�-X')
	-- �ٿ�׷��̵� �̷��� 2�� ���� �ִ� ��� ����
		OR (��Ϻз��� = 'SS-DGamount'	AND ó���������='IH-�Ϸ�' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2�� �̳� ĵ�� ��û�� �� �� �ִ� ��� ����
		OR (��Ϻз� = 'Cancellation' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY ȸ����ȣ
) E 
ON S.ȸ����ȣ = E.ȸ����ȣ
	LEFT JOIN (
	SELECT
		ȸ����ȣ
	 FROM 
		dbo.donotCall
	 GROUP BY ȸ����ȣ 
	) D 
ON S.ȸ����ȣ = D.ȸ����ȣ
WHERE
	-- �ֱ� 8���� ���� �����ڸ� �ش�
	S.������ < CONVERT(varchar(10), DATEADD(month, -8, GETDATE()), 126)
	AND S.ȸ������ = 'normal'
	-- ���� ���ž��� ����
	AND S.��������ó in ('����','����')
	-- �����ȣ ���� �� ����
	AND (CASE WHEN S.��������ó='����' THEN S.�������ȣ ELSE S.��������ȣ END ) is not null
	AND E.ȸ����ȣ IS NULL 
	AND D.ȸ����ȣ IS NULL
ORDER BY ��������ó
GO

------------------------ Special Appeal TM ���� �����


SELECT
	S.ȸ����ȣ, S.����, S.�޴���ȭ��ȣ
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
	-- �ֱ� 7���� �̳��� �Ŀ��������� �ް� ������ ���� �ִ� �Ŀ��� ����
		(��Ϻз� like 'TM_�Ŀ�����%' AND ����Ͻ� >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126) AND ��Ϻз���='�뼺-���װ���')
	-- �ֱ� 1�� �̳��� �Ŀ��������� �ް� ���׷��̵� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз��� = '�뼺-���׼���' AND ������ >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3�� �̳� ����� ���� �ݿ��� ������ ���� �ִ� �Ŀ��� ���� 
		OR (��Ϻз� = 'TM_Ư���Ͻ��Ŀ�' AND ��Ϻз���='�뼺-�Ŀ�����' AND ������ >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- ���� �ݼ� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз���='�ݼ�-X')
	-- TM �̷��� 45�� �̳��� �ִ� ���
		 OR (������ >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126))
	-- �ٿ�׷��̵� �̷��� 2�� ���� �ִ� ��� ����
		OR (��Ϻз��� = 'SS-DGamount'	AND ó���������='IH-�Ϸ�' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2�� �̳� ĵ�� ��û�� �� �� �ִ� ��� ����
		OR (��Ϻз� = 'Cancellation' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY ȸ����ȣ
) E 
ON S.ȸ����ȣ = E.ȸ����ȣ
	LEFT JOIN (
	SELECT
		ȸ����ȣ
	 FROM 
		dbo.donotCall
	 GROUP BY ȸ����ȣ 
	) D 
ON S.ȸ����ȣ = D.ȸ����ȣ
WHERE
	-- �ֱ� 7���� ���� �����ڸ� �ش�
	S.������ < CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)
	AND S.ȸ������ = 'normal'
	-- ���� ���ž��� ����
	AND S.��������ó in ('����','����')
	-- �����ȣ ���� �� ����
	AND (CASE WHEN S.��������ó='����' THEN S.�������ȣ ELSE S.��������ȣ END ) is not null
	-- �޴�����ȣ ���� ��� ����
	AND S.�޴���ȭ��ȣ IS NOT NULL
	AND E.ȸ����ȣ IS NULL 
	AND D.ȸ����ȣ IS NULL	
ORDER BY ��������ó
GO


------------------------ Special Appeal DM ���� ����� 


SELECT
	S.ȸ����ȣ,
	S.����,
	S.��������ó,
	CASE 
	WHEN S.��������ó = '����' THEN ���ּ�
	WHEN S.��������ó = '����' THEN �����ּ�
	END AS �ּ�,
	CASE 
	WHEN S.��������ó = '����' THEN isNULL(���ּһ�,'')
	WHEN S.��������ó = '����' THEN isNULL(�����ּһ�,'')
	END AS �ּһ�,
	CASE 
	WHEN S.��������ó = '����' THEN �������ȣ
	WHEN S.��������ó = '����' THEN ��������ȣ
	END AS �����ȣ
FROM
	dbo.supporterInfo S
LEFT JOIN (
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
	-- �ֱ� 7���� �̳��� �Ŀ��������� �ް� ������ ���� �ִ� �Ŀ��� ����
		(��Ϻз� like 'TM_�Ŀ�����%' AND ����Ͻ� >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126) AND ��Ϻз���='�뼺-���װ���')
	-- �ֱ� 1�� �̳��� �Ŀ��������� �ް� ���׷��̵� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз��� = '�뼺-���׼���' AND ������ >= CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126))
	-- 3�� �̳� ����� ���� �ݿ��� ������ ���� �ִ� �Ŀ��� ���� 
		OR (��Ϻз� = 'TM_Ư���Ͻ��Ŀ�' AND ��Ϻз���='�뼺-�Ŀ�����' AND ������ >= CONVERT(varchar(10), DATEADD(year, -3, GETDATE()), 126))	
	-- ���� �ݼ� �̷��� �ִ� �Ŀ��� ����
		OR (��Ϻз���='�ݼ�-X')
	-- TM �̷��� 45�� �̳��� �ִ� ���
		OR (������ >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126))
	-- �ٿ�׷��̵� �̷��� 2�� ���� �ִ� ��� ����
		OR (��Ϻз��� = 'SS-DGamount'	AND ó���������='IH-�Ϸ�' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	-- 2�� �̳� ĵ�� ��û�� �� �� �ִ� ��� ����
		OR (��Ϻз� = 'Cancellation' AND ������ >= CONVERT(varchar(10), DATEADD(year, -2, GETDATE()), 126))
	GROUP BY ȸ����ȣ
) E 
ON S.ȸ����ȣ = E.ȸ����ȣ
	LEFT JOIN (
	SELECT
		ȸ����ȣ
	 FROM 
		dbo.donotCall
	 GROUP BY ȸ����ȣ 
	) D 
ON S.ȸ����ȣ = D.ȸ����ȣ
WHERE
	-- �ֱ� 7���� ���� �����ڸ� �ش�
	S.������ < CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)
	AND S.ȸ������ = 'normal'
	-- ���� ���ž��� ����
	AND S.��������ó in ('����','����')
	-- �����ȣ ���� �� ����
	AND (CASE WHEN S.��������ó='����' THEN S.�������ȣ ELSE S.��������ȣ END ) is not null
	-- �޴�����ȣ ���� ��� ����
	AND S.�޴���ȭ��ȣ IS NOT NULL
	AND E.ȸ����ȣ IS NULL 
	AND D.ȸ����ȣ IS NULL	
ORDER BY ��������ó
GO

use mrm
go

-- DM ��� �� TM �� ��� �̱�
SELECT
	D.ȸ����ȣ
FROM
	dbo.dmTarget D
	LEFT JOIN 
	(SELECT 
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		(������ >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126) AND (��Ϻз� like 'TM%' OR ��Ϻз� ='Cancellation') )
		OR (����Ͻ� >= CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126) AND (��Ϻз� like 'TM%' ))
	) H
	ON D.ȸ����ȣ = H.ȸ����ȣ
	LEFT JOIN
	(SELECT 
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	WHERE
		ȸ������ in ('Canceled','Stop_tmp')
	) S
	ON D.ȸ����ȣ = S.ȸ����ȣ
WHERE
	H.ȸ����ȣ IS NULL 
	AND S.ȸ����ȣ IS NULL
group by
D.ȸ����ȣ