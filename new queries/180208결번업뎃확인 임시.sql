SELECT CH.ȸ����ȣ, CH.�����Ͻ�, CH.�����׸�, CH.������, CH.������, H.��Ϻз���, H.������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
  WHERE ��Ϻз��� = '���'
  ) H
ON CH.ȸ����ȣ = H.ȸ����ȣ
WHERE CH.�����׸� = '�޴���ȭ��ȣ'
  AND CH.������ != '��'
  AND CONVERT(DATE,CH.�����Ͻ�) >= CONVERT(DATE,H.������) 



  SELECT CH.ȸ����ȣ, CH.�����Ͻ�, CH.�����׸�, CH.������, CH.������, H.��Ϻз���, H.������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
  WHERE ��Ϻз��� = '���'
  ) H
ON CH.ȸ����ȣ = H.ȸ����ȣ
WHERE CH.�����׸� = '�޴���ȭ��ȣ'
  AND CH.������ != '��'
  AND CONVERT(DATE,CH.�����Ͻ�) = CONVERT(DATE,H.������) 



-- ��ȭ��ȣ �ϰ� �����Ѱǵ� Ȯ�� --
  SELECT CH.ȸ����ȣ, CH.�����Ͻ�, CH.�����׸�, CH.������, CH.������, H.��Ϻз���, H.������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
  WHERE ��Ϻз��� = '���'
  ) H
ON CH.ȸ����ȣ = H.ȸ����ȣ
WHERE CH.�����׸� = '�޴���ȭ��ȣ'
  AND CH.������ != '��'
  AND �����Ͻ� = '2017-11-14 12:14'
  AND CONVERT(DATE,CH.�����Ͻ�) >= CONVERT(DATE,H.������) 


-- ��ȭ��ȣ �ϰ� �����Ѱǵ� Ȯ�� --


SELECT CH.ȸ����ȣ, CH.�����Ͻ�, CH.�����׸�, CH.������, CH.������, H.��Ϻз���, H.������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
  (SELECT *
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
  WHERE ��Ϻз��� = '���'
  ) H
ON CH.ȸ����ȣ = H.ȸ����ȣ
WHERE CH.�����׸� = '�޴���ȭ��ȣ'
  AND CH.������ != '��'
  AND �����Ͻ� LIKE '2017-11-14%'
  AND H.ȸ����ȣ IS NOT NULL



  
  -- �޴���ȭ��ȣ ���µ� '��'�� ����  ====> �ϰ������� �ΰ��� �༭ �ذ�
  SELECT D.�޴���ȭ��ȣ, D.ȸ����ȣ
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
  WHERE D.ȸ����ȣ IN ('82051964','82052015', '82020937',
'82032080',
'82023479',
'82000793',
'82001413',
'82028556')



-- ������ --
  SELECT CH.ȸ����ȣ, CH.�����Ͻ�, CH.�����׸�, CH.������, CH.������, H.��Ϻз���, H.������, D.�޴���ȭ��ȣ
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
  LEFT JOIN
    (SELECT *
    FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
    WHERE ��Ϻз��� = '���'
    ) H
  ON CH.ȸ����ȣ = H.ȸ����ȣ
  LEFT JOIN
    (SELECT ȸ����ȣ, �޴���ȭ��ȣ
    FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
    ) D
  ON CH.ȸ����ȣ = D.ȸ����ȣ
  WHERE CH.�����׸� = '�޴���ȭ��ȣ'
    AND CH.������ != '��'
    AND CONVERT(DATE,CH.�����Ͻ�) >= CONVERT(DATE,H.������)
    AND D.�޴���ȭ��ȣ = '��'
