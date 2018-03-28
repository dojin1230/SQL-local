

--����� ���õǴ� ù��° ����� LC�����ڵ� �� ���������� �ִ� �����ڵ��̴�.
--�ش� �����ڵ��� ���԰�� �� �Ҽ��� Ȯ���Ͽ� TM�������ÿ� �������� ������ ��û�Ѵ�.
--�̹� ������ �� ���� CMS�������� �Ҵ��Ͽ� ���ο� ���������� �Էµ� �� �ֵ��� �Ѵ�.

-- ����� ���õǴ� �ι�° ����� CMS


-- �������� --
DROP TABLE IF EXISTS #ex
SELECT 
	H.ȸ����ȣ
INTO 
	#ex
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AS H		-- History
WHERE 
	(H.[��Ϻз�] = 'TM_����')					-- ������ ��� �ִ� �Ŀ���
	OR
	(H.[��Ϻз���] = '���')					-- ���
	OR
	(H.[��ϱ���2] LIKE '%1%')					-- �Ŀ��ڹ��� '1.��ȭ�ź�/���ѺҸ�'
	OR
	(H.��Ϻз� LIKE '%CMS%' AND H.ó��������� LIKE '%����%')  -- CMS�� ������


-- LC������ �� CMS �� �ſ�ī�� ���� 01 --
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
		WHEN D.���԰�� IN ('Lead Conversion','��ȭ')
			AND [D].[���ι��]='CMS'
			AND [D].[CMS����] IN ('�űԽ���','��������','') THEN '1'						-- ��ȭ/LC: CMS������ ���
		WHEN D.���԰�� IN ('Lead Conversion','��ȭ')
			AND [D].[���ι��]='�ſ�ī��'
			AND [D].[CARD����] IN ('���δ��','') THEN '1'									-- ��ȭ/LC: �ſ�ī��
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
	D.ȸ������ Not In ('Canceled','Other')													-- ȸ������ Cancel �� Other ����
And ((IIf(D.����ȭ��ȣ Is Not Null,1,0)+IIf(D.������ȭ��ȣ Is Not Null,1,0)+IIf(D.�޴���ȭ��ȣ='��',1,0))>0) -- ��ȭ��ȣ�� �ִ� ��츸 ����
And ((D.������)>='2017-01-01')																-- 2017�� ���� ������ (���� �ʿ����� Ȯ��)
And ((D.���ʵ�ϱ���)='����')																-- ���ʵ�� ����
And ((D.��ϱ���)!='�ܱ���')																-- �ܱ��� ����
And ((#ex.ȸ����ȣ) Is Null)																-- �������� ���� (������,���,�Ŀ��ڹ���1)


-- LC������ �� CMS �� �ſ�ī�� ���� 02 --

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

SELECT * 
FROM #wel02

-- CMS_01 -- Normal ���� ȸ���߿� CMS��� ���̰� ���� ��� �ʿ��� ���
DROP TABLE IF EXISTS #cms_01
SELECT 
	D.ȸ����ȣ, D.���ι��, D.CMS����, D.���԰��, D.������, D.�����Է���
INTO #cms_01
FROM 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] AS D		-- Donors Information
WHERE 
	(D.���ι�� = 'CMS')								-- CMS
	AND (D.CMS���� LIKE '%���%')						-- '�űԴ��/�������'
	AND (D.ȸ������ = 'Normal')							-- ȸ������ 'Normal'
	AND (D.���ʵ�ϱ��� = '����')						-- ���ʵ�� '����'
	AND (D.CMS�����ڷ����ʿ�='Y')						-- CMS���� ����ʿ�


-- CMS_02 -- 
DROP TABLE IF EXISTS #cms_02
SELECT 
	H.ȸ����ȣ, H.����Ͻ�, H.��Ϻз�, H.��Ϻз���, H.������, H.ó���������, H.����, H.�����Է���, H.��ϱ���2, 
	CASE 
		WHEN H.[ó���������] LIKE '%����%' THEN '1'
		WHEN H.[ó���������] LIKE '%����%' THEN '1'
		ELSE '0'
	END AS ������TF,
	CASE
		WHEN H.[������] >= GETDATE() - 6 THEN '1'
		ELSE '0'
	END AS �ֱ�TF
INTO #cms_02
FROM 
	#cms_01 
INNER JOIN 
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AS H 
ON #cms_01.ȸ����ȣ = H.ȸ����ȣ

WHERE 
	(H.��Ϻз� NOT IN ('Freezing','Impact report','Other mailings','Regular E-mail','Regular SMS','survey response','Welcome pack')) -- 'Annual report' �߰����� Ȯ��
	AND (([H].[ó���������] Like '%����%') OR ([H].[ó���������] Like '%����%'))		-- ���� ��Ϻз��� �ƴϸ鼭 �������� ��ϸ� ����
	OR 
	((H.��Ϻз�) NOT IN ('Freezing','Impact report','Other mailings','Regular E-mail','Regular SMS','survey response','Welcome pack')) 
	AND ([H].[������]>=GETDATE()-6)														-- ���� ��Ϻз��� �ƴϸ鼭 �������� 5�� �̳��� ��ϸ� ���� 


-- CMSpf_03 --

SELECT 
	#cms_01.ȸ����ȣ, '������' AS ����, #cms_01.���԰��, #cms_01.���ι��, #cms_01.CMS����, #cms_01.������, 
	CONVERT(DATE,#cms_01.�����Է���) AS �����Է���
FROM 
	#cms_01 LEFT JOIN #cms_02
ON 
	#cms_01.ȸ����ȣ = #cms_02.ȸ����ȣ
WHERE 
	CONVERT(DATE,#cms_01.�����Է���) <= GETDATE()-3
	AND 
	#cms_02.ȸ����ȣ IS NULL

