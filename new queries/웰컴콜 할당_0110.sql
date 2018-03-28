-- ������ �Ҵ� --

-- �������� --
DROP TABLE IF EXISTS #ex
SELECT 
	H.ȸ����ȣ
INTO 
	#ex
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AS H		-- History
WHERE 
	(H.[��Ϻз�] = 'TM_����')						-- ������ ��� �ִ� �Ŀ���
	OR
	(H.[��Ϻз���] = '���')					-- ���
	OR
	(H.[��ϱ���2] LIKE '%1%')						-- �Ŀ��ڹ��� '1.��ȭ�ź�/���ѺҸ�'


-- Welcome 01 --
DROP TABLE IF EXISTS #wel01
SELECT
	D.ȸ����ȣ, D.���ι��, D.CMS����, D.ī���, D.CARD����, D.���԰��, D.ȸ������, D.�Ҽ�, D.�޴���ȭ��ȣ,
	CASE 
		WHEN [D].[����ȭ��ȣ] IS NOT NULL 
			OR [D].[������ȭ��ȣ] IS NOT NULL 
			OR [D].[�޴���ȭ��ȣ]='��' THEN '1'
		ELSE '0'
	END AS ����ó����,																-- ��ȭ��ȣ �ϳ��� ������ '1'
	CASE
		WHEN [D].���ι��='CMS'
			AND [D].CMS���� IN ('�űԽ���','��������','') THEN '��������/������'
		WHEN [D].���ι��='CMS' 
			AND [D].CMS���� = '�űԴ��'
			AND [D].CMS�����ڷ����ʿ�='Y' THEN '������'
		WHEN [D].���ι��='�ſ�ī��' 
			AND [D].CARD���� IN ('���δ��','') THEN '��������'
		ELSE NULL
	END AS ��������,																-- �������п���/�����󿩺� �Է�
	CASE
		WHEN D.���԰��='�Ÿ�����' 
			AND [D].[���ι��]='CMS'
			AND [D].[CMS����] IN ('�űԿϷ�','�űԽ���','�����Ϸ�','��������','') THEN '1' -- �Ÿ�����: CMS��� ����
		WHEN D.���԰��='�Ÿ�����' 
			AND [D].[���ι��]='�ſ�ī��'
			AND [D].[CARD����] IN ('���δ��','���οϷ�','') THEN '1'						-- �Ÿ�����: �ſ�ī��
		--WHEN D.���԰�� IN ('Lead Conversion','��ȭ')
		--	AND [D].[���ι��]='CMS'
		--	AND [D].[CMS����] IN ('�űԽ���','��������','') THEN '1'						-- ��ȭ/LC: CMS������ ���
		--WHEN D.���԰�� IN ('Lead Conversion','��ȭ')
		--	AND [D].[���ι��]='�ſ�ī��'
		--	AND [D].[CARD����] IN ('���δ��','') THEN '1'									-- ��ȭ/LC: �ſ�ī��
		WHEN D.���԰��='���ͳ�/Ȩ������' 
			AND [D].[���ι��]='CMS'
			AND [D].[CMS����] IN ('�űԴ��') THEN '1'										-- ���ͳ�: CMS �űԴ��
		WHEN D.���԰��='���ͳ�/Ȩ������' 
			AND [D].[���ι��]='�ſ�ī��'
			AND [D].[CARD����] IN ('���δ��','���οϷ�') THEN '1'							-- ���ͳ�: �ſ�ī��
		WHEN D.���԰�� IS NULL
			AND [D].[���ι��]='CMS'
			AND [D].[CMS����] IN ('�űԴ��') THEN '1'										-- ���԰�� NULL (���ͳݰ� ����)
		WHEN D.���԰�� IS NULL
			AND [D].[���ι��]='�ſ�ī��'
			AND [D].[CARD����] IN ('���δ��','���οϷ�','') THEN '1'						-- ���԰�� NULL (���ͳݰ� ����)
		ELSE '0'
	END AS ä�κ��ݴ�󱸺�,																-- ���԰�κ��� �� ����̸� '1'
	D.�����Է���
INTO
	#wel01
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] AS D		-- Donors Information
LEFT JOIN 
	#ex
ON D.ȸ����ȣ = #ex.ȸ����ȣ

WHERE 
D.ȸ������ Not In ('Canceled','Other')														-- ȸ������ Cancel �� Other ����
And ((IIf(D.����ȭ��ȣ Is Not Null,1,0)+IIf(D.������ȭ��ȣ Is Not Null,1,0)+IIf(D.�޴���ȭ��ȣ='��',1,0))>0) -- ��ȭ��ȣ�� �ִ� ��츸 ����
And ((D.������)>='2017-01-01')																-- 2017�� ���� ������ (���� �ʿ����� Ȯ��)
And ((D.���ʵ�ϱ���)='����')																-- ���ʵ�� ����
And ((D.��ϱ���)<>'�ܱ���')																-- �ܱ��� ����
And ((#ex.ȸ����ȣ) Is Null);																-- �������� ���� (������,���,�Ŀ��ڹ���1)

-- Welcome 02 --
DROP TABLE IF EXISTS #wel02
SELECT 
	#wel01.ȸ����ȣ, #wel01.�������� AS ����, #wel01.���԰��, #wel01.�Ҽ�, 
	iif(#wel01.���ι��='CMS',#wel01.CMS����, iif(#wel01.���ι��='�ſ�ī��',#wel01.CARD����,null)) AS ���ι������, 
	#wel01.ȸ������, 
	CONVERT(DATE,#wel01.�����Է���) AS �����Է���
INTO 
	#wel02
FROM 
	#wel01
WHERE
	#wel01.ä�κ��ݴ�󱸺�=1																-- �� ������ �ݴ���� ����
ORDER BY
	���� desc

-- �Ʒ� 3���� ������ ���� ����� �̿� --

-- ���� ����� -- ������� �Է�
SELECT * 
FROM #wel02

-- ��� �Ŀ��� ���� -- �ش��� ������� �����Ͽ� ���ټ������� ���� (SK-����->IH����, ���� W.CALL_WV->W.CALL)
SELECT *, '���ټ��� ����'
FROM #wel02
LEFT JOIN (
	SELECT *
	FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].dbo.UV_GP_�Ŀ������ݾ�����
	WHERE �ݾ� >= 100000									-- �����ݾ� 100000 �̻�
		AND ���� != '����'									-- ����/���/�Ͻ����� ����
		AND ������ = '') PL								-- �Ͻ��Ŀ��ݾ�(������ ����)�� �ƴ�
ON #wel02.ȸ����ȣ = PL.ȸ����ȣ
WHERE PL.ȸ����ȣ IS NOT NULL

-- ĵ�� ��û �� ó���� -- �ش��� ������� ����ó��
SELECT *, '����ó�� �����'
FROM #wel02
LEFT JOIN (
	SELECT *
	FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].dbo.UV_GP_�������
	WHERE
		��Ϻз� = 'Cancellation') H
ON #wel02.ȸ����ȣ = H.ȸ����ȣ
WHERE H.ȸ����ȣ IS NOT NULL