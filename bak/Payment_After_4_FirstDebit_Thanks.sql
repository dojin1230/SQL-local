USE local
go

SELECT 
	I.ȸ����ȣ, I.����, I.�̸���--, P.������, S.�ѳ��ΰǼ�
FROM 
	[dbo].[db0_clnt_i] I
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������� P
ON
	I.ȸ����ȣ = P.ȸ����ȣ 
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
ON
	P.ȸ����ȣ = S.ȸ����ȣ
--LEFT JOIN
--	(SELECT 
--		ȸ����ȣ
--	FROM
--		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_������� 
--	WHERE
--		��Ϻз� = 'Regular E-mail' 
--		AND ��Ϻз��� = '1st debit thanks') H
--ON
--	S.ȸ����ȣ = H.ȸ����ȣ
WHERE
	I.�̸��ϼ��ſ���='Y'
	AND P.������ >= CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
	AND P.�������='����'
	AND S.���ʵ�ϱ���='����'
	AND S.�ѳ��ΰǼ�=1
	--AND H.ȸ����ȣ is null
GO