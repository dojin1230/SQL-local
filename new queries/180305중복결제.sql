--�ߺ����� ã��--

SELECT *
FROM
(SELECT ȸ����ȣ
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
WHERE �������='����'
	AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- ������ 1��
	AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-0, 0)) T
GROUP BY ȸ����ȣ
HAVING COUNT(ȸ����ȣ) > 1


