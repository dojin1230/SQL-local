SELECT 
	avg([�ѳ��αݾ�]) as �ѳ��αݾ����, avg(�ѳ��ΰǼ�) as �ѳ��ΰǼ����, count(���԰��) as ä�κ�����, sum(�ѳ��αݾ�) as �ѳ��αݾ��հ�, ���԰��
      
  FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ�������]
WHERE left(������,4) = '2017'
GROUP BY ���԰��
