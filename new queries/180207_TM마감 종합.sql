--TM ���� ���� (���� �ۼ��� �����鵵 ������)

--1. �ſ�ī�� - ���浿��: �ֱٽ��� Ȯ��
--2. ���� - ���׼���: ���� Ȯ��
--3. ����(����): ���� Ȯ�� (Ȥ�� ĵ�� ���)
--4. ����۵���: ��� Ȯ��/�������� �űԵ�� or �����ڷ��� Ȯ��
--5. �簳����: ��� Ȯ��
--6. �������� - ��� ��/�ֱٳ��� ����: ����¡ Ȯ��
--7. ���� - �Ŀ����� ���οϷ�/�űԿϷ�/�����ڷ���Ȯ��

-- 1. �뼺-���浿�� - �ֱٽ��� Ȯ�� --


SELECT H.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
WHERE CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)) CA
ON H.ȸ����ȣ = CA.ȸ����ȣ
WHERE
��Ϻз��� IN ('�뼺-���浿��')
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND CA.ȸ����ȣ IS NULL




-- ��� ���� ��� --


--SELECT *
--FROM
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T1
--CROSS JOIN
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T2
--WHERE
--  T1.ȸ����ȣ = T2.ȸ����ȣ
--  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
--  AND T1.�ݾ� > T2.�ݾ�
--  AND T1.ROWN = 1
--  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE(), 126)	-- ���۳���� ���⼭ ����
--  AND T2.ROWN = 2


-- 2. ���� ���� �ߴµ� ������ ��ܿ� ���� ȸ�� --

SELECT H.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT T1.ȸ����ȣ
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
  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)
  AND T2.ROWN = 2) T3
ON H.ȸ����ȣ = T3.ȸ����ȣ
WHERE ��Ϻз��� = '�뼺-���׼���'
AND ������ >= CONVERT(DATE,GETDATE() - 4)
AND T3.ȸ����ȣ IS NULL


-- 3. ��������� ~����(����)�ε� ĵ�� ����� ���� ȸ�� --

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT *
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	 WHERE ��Ϻз� = 'cancellation'
	 AND ������ >= CONVERT(DATE, GETDATE()-45)
	 ) H2
ON H.ȸ����ȣ = H2.ȸ����ȣ
WHERE H.��Ϻз��� LIKE '%(����)'
  AND CONVERT(varchar(10),H.������) BETWEEN CONVERT(DATE, GETDATE()-45) AND CONVERT(DATE, GETDATE() - 2)  -- ������ 45�� �̳� ��Ʋ ���� ��� 
  AND H2.ȸ����ȣ IS NULL



--4. ����۵���: ��� Ȯ��

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE ȸ������ = 'Normal') D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� LIKE '%����۵���'
	AND ������ >= CONVERT(DATE, GETDATE()-5)
	AND D.ȸ����ȣ IS NULL

--(�߰�) ����۵��� �������� �űԵ�� or �����ڷ��� Ȯ��

--5. �簳����: ��� Ȯ��
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE ȸ������ = 'Normal') D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� LIKE '%�簳����'
	AND ������ >= CONVERT(DATE, GETDATE()-5)
	AND D.ȸ����ȣ IS NULL

	
--6. �������� - ��� ��/�ֱٳ��� ����: ����¡ Ȯ�� (�߰��ʿ�)

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE ȸ������ = 'Freezing') D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� IN ('���', '�������')
	AND H.��Ϻз� LIKE '%��������%'
	AND ������ >= CONVERT(DATE, GETDATE()-5)
	AND D.ȸ����ȣ IS NULL


--7. ���� - �Ŀ����� ���οϷ�/�űԿϷ�/�����ڷ���Ȯ��

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR (���ι�� = 'CMS' AND CMS���� IN ('�űԿϷ�', '�ű�����'))
	 OR (���ι�� = 'CMS' AND CMS���� = '�űԴ��' AND CMS�����ڷ����ʿ� = 'N')
	 ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� = '�뼺-�Ŀ�����'
	AND H.��Ϻз� = 'TM_����'
	AND H.ó��������� != 'SK-����'
	AND ������ >= CONVERT(DATE, GETDATE()-5)
	AND D.ȸ����ȣ IS NULL


--8. ����ð� ���� SK-�Ϸ� �� (����ð� �� �ҷ��� �� ����)

--SELECT *
--FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
--WHERE H.ó��������� = 'SK-�Ϸ�'
--	AND ������ >= CONVERT(DATE, GETDATE()-30)
--
-- 	MRM���� �˻�



-- 3�ֵ� ������ ���� --

-- 1. �Ŀ����� --
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR (���ι�� = 'CMS' AND CMS���� IN ('�űԿϷ�', '�ű�����'))
	 OR (���ι�� = 'CMS' AND CMS���� = '�űԴ��' AND CMS�����ڷ����ʿ� = 'N')
	 ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� = '�뼺-�Ŀ�����'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL


-- 2. �Ŀ�����(����) --

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	 WHERE ������ >= CONVERT(DATE, GETDATE()-21)
		AND ��Ϻз� = 'Cancellation'
	) H2
ON H.ȸ����ȣ = H2.ȸ����ȣ
WHERE H.��Ϻз��� = '�뼺-�Ŀ�����(����)'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,H.����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND H2.ȸ����ȣ IS NULL


-- 3. ��� --
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR 
	 (���ι�� = 'CMS' AND CMS���� = '�űԿϷ�')
	 OR 
	 ȸ������ = 'Freezing'
	  ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� = '���'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL


-- 4. SK-����� ���� (����¡ �ʿ�� Ȯ��) -- 

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR 
	 (���ι�� = 'CMS' AND CMS���� = '�űԿϷ�')
	 OR 
	 ȸ������ = 'Freezing'
	  ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.ó��������� = 'SK-����'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL


