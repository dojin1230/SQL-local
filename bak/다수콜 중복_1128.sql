-- �ټ��� �ߺ�
SELECT 
 H.ȸ����ȣ, H.��Ϻз�, H.��Ϻз���, H.������, H.ó���������
FROM
 MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
WHERE
 H.ȸ����ȣ IN
  (SELECT 
   S.ȸ����ȣ
  FROM 
   MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
  LEFT JOIN
   MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
  ON 
   S.ȸ����ȣ = H.ȸ����ȣ
  WHERE
   H.ó��������� in ('SK-����','IH-����','IH-����')
   AND H.��Ϻз��� !='����'
   AND H.��Ϻз� not in ('�������� ��û/����','ķ���ΰ��� ��û/����/�Ҹ�����','���� �������� ��û/����','Impact report','Other mailings','Welcome pack')
  GROUP BY
   S.ȸ����ȣ
  HAVING 
   COUNT(S.ȸ����ȣ) >= 2)
 AND H.ó��������� in ('SK-����','IH-����','IH-����')
ORDER BY
 H.ȸ����ȣ