--Action 1
select *
	from MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
		where ��Ϻз� like 'TM%' 
		and ó��������� in ('SK-����','SK-����') 
		and ��Ϻз��� not in ('����','�뼺-����X','��ó��','�뼺-��������')
order by ��Ϻз�, ��Ϻз���
go

--Case B
select 
	*
from 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
where ȸ����ȣ in
	(select  
		ȸ����ȣ
	from 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	where ��Ϻз� like 'TM%' 
	and ó��������� ='SK-�Ϸ�'
	and ��Ϻз��� ='�뼺-�Ŀ�����'
	--and ������ = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
	and ������ >= CONVERT(varchar(10), '2017-09-28', 126) and  ������ <= CONVERT(varchar(10), '2017-09-29', 126)
	)	
go

--Case C
------ CMS�� ī�� �ֱ� ���� ��¥�� �ҷ������� ������ ��
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON H.ȸ����ȣ = S.ȸ����ȣ
WHERE
	H.��Ϻз�='TM_����' 
	and H.��Ϻз��� ='�뼺-�Ŀ�����'
	and H.������ >= CONVERT(varchar(10), DATEADD(day, -2, GETDATE()), 126) 
	and H.������ < CONVERT(varchar(10), GETDATE(), 126)
	and ((S.CMS���� not in ('�űԿϷ�','�ű�����') and S.CARD���� !='���οϷ�') OR S.CMS�����ڷ����ʿ�='Y')
go

-- Case D : �Ŀ����׼���
select 
	D.ȸ����ȣ, D.ȸ������, D.���αݾ�, D.���ν��۳��, H.����, H.������
from 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D left outer join MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
on	D.ȸ����ȣ = H.ȸ����ȣ
where H.��Ϻз� like 'TM%' 
	and H.ó��������� ='SK-�Ϸ�'
	and H.��Ϻз��� ='�뼺-���׼���'
	and ������ >= CONVERT(varchar(10), DATEADD(day, -2, GETDATE()), 126) 
	and H.������ < CONVERT(varchar(10), GETDATE(), 126)
	--and H.������ >= CONVERT(varchar(10), '2017-09-25', 126) and  H.������ <= CONVERT(varchar(10), '2017-09-26', 126)			
go

-- Case E : 
dbo.UV_GP_�ſ�ī��������� 
