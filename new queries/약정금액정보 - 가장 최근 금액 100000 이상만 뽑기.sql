
--dbo.UV_GP_�Ŀ������� 	 		ȸ����Ȳ								D	Donor 
--dbo.UV_GP_�Ŀ������ݾ����� 	 	�����׸�								PL	Payment List
--dbo.UV_GP_�Ͻ��Ŀ�������� 	 	�ſ�ī��(���̽�����) > ���ó�����Ȳ	T	Temporary Result
--dbo.UV_GP_�ſ�ī��������� 	 	�ſ�ī�� > ȸ��������Ȳ				CA 	Card Approval
--dbo.UV_GP_�ſ�ī�������� 	 	�ſ�ī�� > ���ⳳ����Ȳ				CR 	Card Result 	
--dbo.UV_GP_�����̷� 	 		�����̷�								CH 	Change History
--dbo.UV_GP_������� 	 		�������								H 	History	
--dbo.UV_GP_�������� 	 		ȸ�񳳺� - ������ �Ŀ���				PR	Payment Result	
--dbo.UV_GP_CMS�������� 	 		SmartCMS > ȸ����û					BA 	Bank Approval
--dbo.UV_GP_CMS������� 	 		SmartCMS > ��ݽ�û					BR 	Bank Result



select top (100) *
from [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].dbo.UV_GP_�Ŀ������ݾ�����
where �ݾ� >= 100000
and ���� != '����'
and ������ = ''

order by ��û�� desc


SELECT *
FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ������ݾ�����] ii

WHERE 
ii.ȸ����ȣ IN
(SELECT
	
      sub.[ȸ����ȣ]
   
	  FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ������ݾ�����] sub
group by sub.ȸ����ȣ
having count(*) > 1)




SELECT *
FROM [MRMRT].[�׸��ǽ����ƽþƼ���繫��0868].[dbo].[UV_GP_�Ŀ������ݾ�����] DA -- Donation Amount

WHERE
	DA.���� = '����'
	AND
	�ݾ� > 100000