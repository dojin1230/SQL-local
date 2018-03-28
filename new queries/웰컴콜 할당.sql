-- ������ �Ҵ� --


-- �������� --
DROP TABLE IF EXISTS #ex
SELECT 
	MR.ȸ����ȣ
INTO 
	#ex
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�������] AS MR		-- Management Records
WHERE 
	(MR.[��Ϻз�] = 'TM_����')						-- ������ ��� �ִ� �Ŀ���
	OR
	(MR.[��Ϻз���] = '���')					-- ���
	OR
	(MR.[��ϱ���2] LIKE '%1%')						-- �Ŀ��ڹ��� '1.��ȭ�ź�/���ѺҸ�'


-- Welcome 01 --
DROP TABLE IF EXISTS #wel01
SELECT
	DI.ȸ����ȣ, DI.���ι��, DI.CMS����, DI.ī���, DI.CARD����, DI.���԰��, DI.ȸ������, DI.�Ҽ�, DI.�޴���ȭ��ȣ,
	CASE 
		WHEN [DI].[����ȭ��ȣ] IS NOT NULL 
			OR [DI].[������ȭ��ȣ] IS NOT NULL 
			OR [DI].[�޴���ȭ��ȣ]='��' THEN '1'
		ELSE '0'
	END AS ����ó����,																-- ��ȭ��ȣ �ϳ��� ������ '1'
	CASE
		WHEN [DI].���ι��='CMS'
			AND [DI].CMS���� IN ('�űԽ���','��������','') THEN '��������/������'
		WHEN [DI].���ι��='CMS' 
			AND [DI].CMS���� = '�űԴ��'
			AND [DI].CMS�����ڷ����ʿ�='Y' THEN '������'
		WHEN [DI].���ι��='�ſ�ī��' 
			AND [DI].CARD���� IN ('���δ��','') THEN '��������'
		ELSE NULL
	END AS ��������,																-- �������п���/�����󿩺� �Է�
	CASE
		WHEN DI.���԰��='�Ÿ�����' 
			AND [DI].[���ι��]='CMS'
			AND [DI].[CMS����] IN ('�űԿϷ�','�űԽ���','�����Ϸ�','��������','') THEN '1' -- �Ÿ�����: CMS��� ����
		WHEN DI.���԰��='�Ÿ�����' 
			AND [DI].[���ι��]='�ſ�ī��'
			AND [DI].[CARD����] IN ('���δ��','���οϷ�','') THEN '1'						-- �Ÿ�����: �ſ�ī��
		WHEN DI.���԰�� IN ('Lead Conversion','��ȭ')
			AND [DI].[���ι��]='CMS'
			AND [DI].[CMS����] IN ('�űԽ���','��������','') THEN '1'						-- ��ȭ/LC: CMS������ ���
		WHEN DI.���԰�� IN ('Lead Conversion','��ȭ')
			AND [DI].[���ι��]='�ſ�ī��'
			AND [DI].[CARD����] IN ('���δ��','') THEN '1'									-- ��ȭ/LC: �ſ�ī��
		WHEN DI.���԰��='���ͳ�/Ȩ������' 
			AND [DI].[���ι��]='CMS'
			AND [DI].[CMS����] IN ('�űԴ��') THEN '1'										-- ���ͳ�: CMS �űԴ��
		WHEN DI.���԰��='���ͳ�/Ȩ������' 
			AND [DI].[���ι��]='�ſ�ī��'
			AND [DI].[CARD����] IN ('���δ��','���οϷ�') THEN '1'							-- ���ͳ�: �ſ�ī��
		WHEN DI.���԰�� IS NULL
			AND [DI].[���ι��]='CMS'
			AND [DI].[CMS����] IN ('�űԴ��') THEN '1'										-- ���԰�� NULL (���ͳݰ� ����)
		WHEN DI.���԰�� IS NULL
			AND [DI].[���ι��]='�ſ�ī��'
			AND [DI].[CARD����] IN ('���δ��','���οϷ�','') THEN '1'						-- ���԰�� NULL (���ͳݰ� ����)
		ELSE '0'
	END AS ä�κ��ݴ�󱸺�,																-- ���԰�κ��� �� ����̸� '1'
	DI.�����Է���
INTO
	#wel01
FROM
	[MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������] AS DI		-- Donors Information
LEFT JOIN 
	#ex
ON DI.ȸ����ȣ = #ex.ȸ����ȣ

WHERE 
DI.ȸ������ Not In ('Canceled','Other')														-- ȸ������ Cancel �� Other ����
And ((IIf(DI.����ȭ��ȣ Is Not Null,1,0)+IIf(DI.������ȭ��ȣ Is Not Null,1,0)+IIf(DI.�޴���ȭ��ȣ='��',1,0))>0) -- ��ȭ��ȣ�� �ִ� ��츸 ����
And ((DI.������)>='2017-01-01')																-- 2017�� ���� ������ (���� �ʿ����� Ȯ��)
And ((DI.���ʵ�ϱ���)='����')																-- ���ʵ�� ����
And ((DI.��ϱ���)<>'�ܱ���')																-- �ܱ��� ����
And ((#ex.ȸ����ȣ) Is Null);																-- �������� ���� (������,���,�Ŀ��ڹ���1)

-- Welcome 02 --

SELECT 
	#wel01.ȸ����ȣ, #wel01.�������� AS ����, #wel01.���԰��, #wel01.�Ҽ�, 
	iif(#wel01.���ι��='CMS',#wel01.CMS����, iif(#wel01.���ι��='�ſ�ī��',#wel01.CARD����,null)) AS ���ι������, 
	#wel01.ȸ������, 
	CONVERT(DATE,#wel01.�����Է���) AS �����Է���
FROM 
	#wel01
WHERE
	#wel01.ä�κ��ݴ�󱸺�=1;																-- �� ������ �ݴ���� ����
