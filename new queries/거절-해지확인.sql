-- ��������� ~����(����)�ε� ĵ�� ����� ���ų� ĵ�� ���°� �ƴ� ȸ�� -- (�۵����ϴµ�)

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
  (SELECT *
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
  WHERE ��Ϻз� = 'cancellation') H2
ON H.ȸ����ȣ = H2.ȸ����ȣ
LEFT JOIN
  (SELECT ȸ����ȣ, ȸ������
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
  WHERE ȸ������ = 'canceled') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� LIKE '%����%'
  AND CONVERT(varchar(10),H.������) BETWEEN CONVERT(DATE, '2018-01-01') AND CONVERT(DATE, GETDATE() - 2)  -- ������ ��Ʋ ���� ��� (2018�� ���� ����)
  AND H2.ȸ����ȣ IS NULL
  AND D.ȸ����ȣ IS NULL