

-- ���ĸ��� �Ҵ� �����Է��� ���� ������ ������ - �Ͽ���, �̸��� ���� Y, ȸ������ ĵ�� ���� --
-- ���� ������ db0_clnt_i �ֽ����� ������Ʈ --


SELECT 
	D.�����Է���, D.������, I.����, I.�̸���, I.�̸��ϼ��ſ���, I.ȸ����ȣ, D.ȸ������ 
FROM 
	[dbo].[db0_clnt_i] I
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	I.ȸ����ȣ = D.ȸ����ȣ
WHERE 
	CONVERT(DATE, D.�����Է���) BETWEEN CONVERT(DATE, GETDATE()-7) AND CONVERT(DATE, GETDATE()-1)   -- ���� �����Ͽ� ����. �׷��� ���� ��� ��¥ ���� �ʿ�.
	AND �̸��ϼ��ſ��� = 'Y'
	AND ȸ������ != 'Canceled'
ORDER BY �����Է���