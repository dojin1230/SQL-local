SELECT ȸ����ȣ, count(*)
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
GROUP BY ȸ����ȣ
HAVING COUNT(*) > 1
ORDER BY ȸ����ȣ

--- ����

SELECT ȸ����ȣ, COUNT(*)
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
GROUP BY ȸ����ȣ

SELECT ȸ����ȣ, RANK() OVER(ORDER BY �Ϸù�ȣ)
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����

SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC), *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����



--- 

SELECT ROW_NUMBER() OVER(PARTITION BY PL.ȸ����ȣ ORDER BY PL.�Ϸù�ȣ DESC), *
FROM 
(SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� 
WHERE ���۳�� != ������) PL		-- �Ͻ��Ŀ� �ƴ� �͸� ����
LEFT JOIN
(SELECT ȸ����ȣ
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
GROUP BY ȸ����ȣ
HAVING COUNT(*) > 1) TMP1			-- �����׸� 2�� �̻� ����
ON PL.ȸ����ȣ = TMP1.ȸ����ȣ
WHERE TMP1.ȸ����ȣ IS NOT NULL




--  select A.�Ϸù�ȣ, A.ȸ����ȣ, A.�ݾ�, B.�Ϸù�ȣ, B.�ݾ�
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  cross join MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� B
--  where A.ȸ����ȣ = b.ȸ����ȣ
--  and a.�Ϸù�ȣ > b.�Ϸù�ȣ
--  and a.�ݾ� > b.�ݾ�
 

(SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� PL
LEFT JOIN
	(SELECT ȸ����ȣ
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	GROUP BY ȸ����ȣ
	HAVING COUNT(*) > 1) TMP1
ON PL.ȸ����ȣ = TMP1.ȸ����ȣ
WHERE PL.���۳�� != PL.������
	AND TMP1.ȸ����ȣ IS NOT NULL) -- �����׸� �ΰ� �̻��̰�


