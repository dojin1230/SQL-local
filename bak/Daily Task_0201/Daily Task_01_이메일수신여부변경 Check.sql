-- �̸��� ���ſ��� ���� --

SELECT 
	CH.*, I.�̸���
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN 
	[work].[dbo].[db0_clnt_i] I
ON 
	CH.ȸ����ȣ = I.ȸ����ȣ
WHERE 
	�����׸� = '�̸��ϼ��ſ���'
	AND CONVERT(DATE,�����Ͻ�) >= CONVERT(DATE,GETDATE() - 1) -- ����
	-- AND (CONVERT(DATE,�����Ͻ�) BETWEEN CONVERT(DATE, GETDATE()-3) AND CONVERT(DATE, GETDATE()-1)) -- ���� 3��
ORDER BY 
	������
