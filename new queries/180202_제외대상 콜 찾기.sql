
-- ���ܴ�� �� ã�� --
-- ����ε� ����� �� �������ΰ� ã�� --

SELECT H.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ = 'normal') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE
(H.���� LIKE '%RA%'
OR H.��Ϻз� LIKE '%�����%')
AND H.ó��������� LIKE '%����'
AND D.ȸ����ȣ IS NOT NULL