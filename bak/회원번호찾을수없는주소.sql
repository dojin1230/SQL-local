select S.*
from dbo.outofList O
left join dbo.mrmAll S
ON (O.�ּ� = S.���ּ� and ISNULL(O.�ּһ�,'NULL') = ISNULL(S.���ּһ�, 'NULL')) OR (O.�ּ� = S.�����ּ� and ISNULL(O.�ּһ�, 'NULL') = ISNULL(S.�����ּһ�, 'NULL'))
where S.ȸ����ȣ IS NOT NULL

select S.*
from dbo.outofList O
left join dbo.mrmAll S
ON (O.�ּ� = S.���ּ� and ISNULL(O.�ּһ�,'NULL') = ISNULL(S.���ּһ�, 'NULL')) OR (O.�ּ� = S.�����ּ� and ISNULL(O.�ּһ�, 'NULL') = ISNULL(S.�����ּһ�, 'NULL'))

			
select *
from dbo.mrmAll 
where ���ּ� like '%����� ���ı� ��ǵ� 249-3����%' or �����ּ� like '%����� ���ı� ��ǵ� 249-3����%'


select 
	*
from dbo.outofList
	