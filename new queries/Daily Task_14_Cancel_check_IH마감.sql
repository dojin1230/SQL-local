

-- IH ����� ó�� --

--��Ϻз���: SS-canceled / Canceled -> ĵ�� ó�� Ȯ��
--��Ϻз���: SS-DGamount -> ���� Ȯ��
--��Ϻз���: SS-tempstop -> �Ͻ����� Ȯ��
--����: Iī�庯�� -> ����Ȯ��
--����: I���º��� -> ����Ȯ��
--����: I�ݾ׺��� -> ����Ȯ��
--��Ϻз���: �ڹ�_Unfreezeing -> ��� �� �������� ����Ȯ��
--��Ϻз���: �Ŀ��ݾ�downgrade -> ���� Ȯ��
--��Ϻз���: �Ŀ��ݾ�upgrade -> ���� Ȯ��


-- ĵ��Ȯ�� --

SELECT H.*, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ != 'canceled') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE 
��Ϻз��� IN ('SS-Canceled', 'Canceled')
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 5)
AND D.ȸ����ȣ IS NOT NULL


-- ����Ȯ�� --






-- ����: Iī�庯�� -> ����Ȯ�� --

SELECT H.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
WHERE CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)) CA
ON H.ȸ����ȣ = CA.ȸ����ȣ
WHERE
���� LIKE '%ī�庯��'
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND CA.ȸ����ȣ IS NULL


-- ����: ������û -> ����Ȯ�� --

SELECT H.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ = 'stop_tmp') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE
(H.���� LIKE '%����%'
OR H.��Ϻз��� LIKE '%����%'   -- �����׽�Ʈ
OR H.��Ϻз� LIKE '%����%')	-- �����׽�Ʈ
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND D.ȸ����ȣ IS NULL


