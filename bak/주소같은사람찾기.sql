select U.����,U.ȸ����ȣ,U.�޴���ȭ��ȣ
from mrmData U
join (		
	select �ּ�, ���ּ�
	from dbo.smsFirst
	group by �ּ�, ���ּ� having count(1) > 1
) S
ON (U.���ּ� = S.�ּ� AND U.���ּһ� = S.���ּ�) --OR (U.�����ּ� = S.�ּ� AND U.�����ּһ� = S.���ּ�)
;
 
 