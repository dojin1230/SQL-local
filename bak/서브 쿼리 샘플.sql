SELECT 
  Year(�����) AS [Debit year], 
  Month(�����) AS [Debit month], 
  ����� AS [Debit date], 
  ȸ���ڵ� AS Constituent_id, 
  ��û�ݾ� AS Amount, 
  CASE
  WHEN ó����� like '%����%' THEN 0
  ELSE 1
  END AS Response, 
  [Payment method]
 FROM
 (
  SELECT
   �����,
   ȸ���ڵ�,
   ��û�ݾ�,
   ó�����,
   'CMS' as [Payment method]
  FROM 
   MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������
  UNION ALL
  SELECT 
   [�����],
   [ȸ���ڵ�], 
   [��û�ݾ�], 
   [���], 
   'CRD' as [Payment method]
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������
  ) PR
 WHERE
  ����� >= CONVERT(varchar(10), '2017-10-01', 126) 
  AND ����� < CONVERT(varchar(10), '2017-11-01', 126)