SELECT
	��Ϻз�, ����, COUNT(*) �Ǽ�
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	����Ͻ�>= CONVERT(varchar(10),'2017-09-01', 126) 
	AND ����Ͻ�< CONVERT(varchar(10),'2017-10-01', 126) 
	AND ��Ϻз� like 'TM%'
	AND (���� like '%MPC' OR ���� like '%WV')
	GROUP BY ��Ϻз�, ����
	ORDER BY ����
	