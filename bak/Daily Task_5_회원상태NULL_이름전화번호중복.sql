-- ȸ������ NULL ã�� --

select 
	mem.ȸ����ȣ, mem.ȸ������
from 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� mem 

where 
	mem.ȸ������ = null

-- �̸�+��ȭ��ȣ �ߺ� ã�� --

select 

����, �޴���ȭ��ȣ

from work.dbo.db0_clnt_i

group by ����, �޴���ȭ��ȣ

having COUNT(�޴���ȭ��ȣ) > 1


-- �̸�+�̸��� �ߺ� ã�� --

select

����, �̸���

from work.dbo.db0_clnt_i

group by ����, �̸���

having COUNT(�̸���) > 1