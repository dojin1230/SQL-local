--SELECT ȸ����ȣ, count(*)
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--GROUP BY ȸ����ȣ
--HAVING COUNT(*) > 1
--ORDER BY ȸ����ȣ

----- ����

--SELECT ȸ����ȣ, COUNT(*)
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--GROUP BY ȸ����ȣ

--SELECT ȸ����ȣ, RANK() OVER(ORDER BY �Ϸù�ȣ)
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����








--DROP TABLE IF EXISTS #TMP1

--SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *

--INTO #TMP1


--SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--FROM
--(SELECT A.*
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--LEFT JOIN
--(SELECT ȸ����ȣ 
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--GROUP BY ȸ����ȣ
--HAVING COUNT(ȸ����ȣ) > 1) B
--ON A.ȸ����ȣ = B.ȸ����ȣ
--WHERE A.���۳�� != A.������
--AND B.ȸ����ȣ IS NOT NULL) TMP1 -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����




--  select A.�Ϸù�ȣ, A.ȸ����ȣ, A.�ݾ�, B.�Ϸù�ȣ, B.�ݾ�
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  cross join MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� B
--  where A.ȸ����ȣ = b.ȸ����ȣ
--  and a.�Ϸù�ȣ > b.�Ϸù�ȣ
--  and a.�ݾ� > b.�ݾ�
 
--(
--SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--FROM
--(SELECT A.*
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--LEFT JOIN
--(SELECT ȸ����ȣ 
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--GROUP BY ȸ����ȣ
--HAVING COUNT(ȸ����ȣ) > 1) B
--ON A.ȸ����ȣ = B.ȸ����ȣ
--WHERE A.���۳�� != A.������
--AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--) TMP2




--SELECT *
--FROM 
--(SELECT *
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--WHERE ���۳�� != ������) A
--CROSS JOIN 
--(SELECT *
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--WHERE ���۳�� != ������) B
--WHERE A.ȸ����ȣ = B.ȸ����ȣ
--AND A.�Ϸù�ȣ > B.�Ϸù�ȣ
--AND A.�ݾ� > B.�ݾ�
--ORDER BY A.ȸ����ȣ





SELECT *
FROM
  (
  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
  FROM
  (SELECT A.*
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
  LEFT JOIN
  (SELECT ȸ����ȣ
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
  GROUP BY ȸ����ȣ
  HAVING COUNT(ȸ����ȣ) > 1) B
  ON A.ȸ����ȣ = B.ȸ����ȣ
  WHERE A.���۳�� != A.������
  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
  ) T1
CROSS JOIN
  (
  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
  FROM
  (SELECT A.*
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
  LEFT JOIN
  (SELECT ȸ����ȣ
  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
  GROUP BY ȸ����ȣ
  HAVING COUNT(ȸ����ȣ) > 1) B
  ON A.ȸ����ȣ = B.ȸ����ȣ
  WHERE A.���۳�� != A.������
  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
  ) T2
WHERE
  T1.ȸ����ȣ = T2.ȸ����ȣ
  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
  AND T1.�ݾ� > T2.�ݾ�
  AND T1.ROWN = 1
  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE(), 126)
  AND T2.ROWN = 2


  SELECT CONVERT(DATE, GETDATE())   -- 2018-02-06
  SELECT CONVERT(VARCHAR, GETDATE())   -- 02 6 2018 10:56AM
  SELECT CONVERT(VARCHAR(10), GETDATE())   -- 02 6 2018 
  SELECT CONVERT(VARCHAR(10), GETDATE(), 126)   -- 2018-02-06
  SELECT CONVERT(VARCHAR(7), GETDATE(), 126)   -- 2018-02



  ��� ������ ��� => ������ϰ� ��