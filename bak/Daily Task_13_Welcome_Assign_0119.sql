SELECT
	D.ȸ����ȣ,
	CASE
	WHEN ���ι�� = 'CMS' AND CMS����='�űԽ���' THEN '��������/������'
	WHEN ���ι�� = 'CMS' AND CMS����='�űԴ��' AND CMS�����ڷ����ʿ�='Y' THEN '������'
	ELSE ''
	END AS ����,
	CONVERT(DATE,GETDATE()) AS ����,
	'TM_����-��ó��' AS [��Ϻз�/�󼼺з�],
	CASE
	WHEN D.���αݾ� < 100000 THEN 'SK-����'
	ELSE 'IH-����'
	END AS ����1,
	CASE
	WHEN D.���αݾ� < 100000 THEN 'W.CALL_WV'
	ELSE 'W.CALL'
	END AS ����,
	CASE
	WHEN ���ι�� = 'CMS' THEN D.CMS����
	WHEN ���ι�� = '�ſ�ī��' THEN D.CARD����
	END AS [CMS/ī�����],
	D.���ι��,
	D.���԰��,
	D.������,
	D.CMS�����ڷ����ʿ�,
	D.���αݾ�
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		��Ϻз� like 'TM_����%'
		OR ��Ϻз� = 'Cancellation'
	) H
ON
	D.ȸ����ȣ = H.ȸ����ȣ
WHERE
	H.ȸ����ȣ is null											-- ����/����3����/����6���� �� ���� ���, ĵ�� ��� �ִ� ��� ����
	AND D.���԰�� in ('���ͳ�/Ȩ������','�Ÿ�����')				-- ���԰�ΰ� Web�̳� DDC�� ����鸸
	AND D.���ʵ�ϱ��� = '����'
	AND D.�޴���ȭ��ȣ = '��'
	AND D.��ϱ��� != '�ܱ���'
	AND D.ȸ������ not in ('canceled', 'other')					-- ȸ�� ����
	AND D.������ >= CONVERT(varchar(10), '2018-01-01', 126)		-- 2018�� �����ں���
	AND (
		(D.CMS���� = '�űԴ��' AND D.CMS�����ڷ����ʿ� = 'Y')
		OR (D.CMS���� = '�������' AND D.CMS�����ڷ����ʿ� = 'Y')	-- CMS������̰� �����ڷ� ���� ���
		OR (D.CMS���� = '�űԿϷ�')
		OR (D.CMS���� = '�����Ϸ�')									-- �Ǵ� CMS�Ϸ��� ���
		OR (D.CMS���� = '�űԽ���')
		OR (D.CMS���� = '��������')									-- �Ǵ� CMS������ ���
		OR (D.���ι�� = '�ſ�ī��')								-- �Ǵ� �ſ�ī���� ���
		)
