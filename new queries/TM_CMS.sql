-- CMS ������ ��� -- ///������ �Ҵ� �� ����///

SELECT
	S.ȸ����ȣ, S.CMS����, S.CMS�����ڷ����ʿ�, S.�ѳ��ΰǼ�, S.�������γ��, S.������, CA.��û��, CA.ó�����, CA.����޼���
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� in ('TM_CMS����', 'TM_��������_����_��������')
		AND ó��������� != 'SK-�Ϸ�') TC
ON
	S.ȸ����ȣ = TC.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� ='TM_����'
		AND ����Ͻ� >= CONVERT(varchar(10), DATEADD(week, -3, GETDATE()), 126)) TT
ON
	S.ȸ����ȣ = TT.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз��� = '���') N
ON
	S.ȸ����ȣ = N.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, MAX(��û��) AS �ֱٽ�û��
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS��������
	GROUP BY
		ȸ����ȣ) A 
ON
	S.ȸ����ȣ = A.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������� CA
ON
	A.ȸ����ȣ = CA.ȸ����ȣ AND A.�ֱٽ�û�� = CA.��û��
WHERE
	((S.CMS���� IN ('�űԽ���','��������') AND S.CARD���� !='���οϷ�') OR S.CMS�����ڷ����ʿ�='Y')
	AND S.ȸ������='NORMAL'
	AND S.���ʵ�ϱ���='����'
	AND S.���ι�� IS NOT NULL
	AND S.������ < CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
	AND TC.ȸ����ȣ IS NULL			-- CMS�������̳� ���������� ���� ������ ���� ���
	AND TT.ȸ����ȣ IS NULL			-- ������ ���� ������ ���� ���
	AND N.ȸ����ȣ IS NULL			-- ��� ����� ���� ���
	--AND CA.����޼��� IS NOT NULL	-- ó������ �޽����� �ִ� ���
ORDER BY 1 DESC

--select *
--FROM
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
--where ȸ����ȣ='82050200'

