-- ����Ʈ ����¡ Ÿ���� --


SELECT
	DD.ȸ����ȣ, COUNT(DD.ȸ����ȣ)
FROM
	(SELECT D.ȸ����ȣ, D.ȸ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
	INNER JOIN
		(SELECT �����, ȸ���ڵ�, ��û�ݾ�,
			CASE
				WHEN ó����� = '��ݿϷ�' THEN '����'
				ELSE '����'
			END AS ���,
			����޼���,
			CASE
				WHEN ����޼��� LIKE '%�ܾ�%' THEN 'SOFT'
				WHEN ����޼��� LIKE '%�ܰ�%' THEN 'SOFT'
				WHEN ����޼��� LIKE '%�ѵ�%' THEN 'SOFT'
				WHEN ó����� = '��ݿϷ�' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CMS' AS pymt_mtd
		FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������
		UNION ALL
		SELECT �����, ȸ���ڵ�, ��û�ݾ�, ���, ���л���,
			CASE
				WHEN ���л��� LIKE '%�ܾ�%' THEN 'SOFT'
				WHEN ���л��� LIKE '%�ܰ�%' THEN 'SOFT'
				WHEN ���л��� LIKE '%�ѵ�%' THEN 'SOFT'
				WHEN ��� = '����' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CRD' AS pymt_mtd
		FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������) BR_CR
	ON D.ȸ����ȣ = BR_CR.ȸ���ڵ� 		-- �Ŀ��������� CMS �� ī�� ������� ���� (����������� �̳����� �Ǿ������� ����Ʈ ���ε� ����)
	LEFT JOIN
		(SELECT �Ϸù�ȣ, ID, ȸ����ȣ, ����Ͻ�, ��Ϻз�, ��Ϻз���, ������, ó���������, ����, �����Է���, ��ϱ���2
		FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
		WHERE
					��Ϻз� = 'TM_�Ŀ��簳_�ܾ׺���'
					AND ��Ϻз��� = '�뼺-�簳����'
					AND CONVERT(VARCHAR(7),������) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -3, GETDATE()), 126)) H
	ON D.ȸ����ȣ = H.ȸ����ȣ    	-- �Ŀ��������� ������� ����
	WHERE (CONVERT(VARCHAR(7),D.�������γ��) < CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
		OR D.�������γ�� IS NULL)  -- ���������� ������ ���� 4���� �����̰ų� ���α���� ���� ��츸 ���� (��: 1���� �۾��� �������γ���� ���⵵ 8�� ����)
		AND BR_CR.��� = '����'			-- ī�� �� CMS ������� ��� ������ ���
		AND BR_CR.TYPE = 'SOFT'			-- ���л����� �ܾ�/�ܰ�/�ѵ� ������ ���
		AND CONVERT(VARCHAR(7),BR_CR.�����) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)  -- ������� �� ������� 4���� �̳��� ��츸 ����
		AND H.ȸ����ȣ IS NULL			-- 3���� �̳��� �ܾ׺��� ���� �ް� ������ ��� ����
	) DD
GROUP BY DD.ȸ����ȣ, DD.ȸ������
HAVING
	COUNT(DD.ȸ����ȣ) >= 8
	AND DD.ȸ������ = 'normal'