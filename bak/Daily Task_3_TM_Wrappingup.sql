--Action 1
select *
	from MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
		where ��Ϻз� like 'TM%' 
		and ó��������� in ('SK-����','SK-����') 
		and ��Ϻз��� not in ('����','�뼺-����X','��ó��','�뼺-��������')
order by ��Ϻз�, ��Ϻз���
go

--Case B
------- dj: ��Ϻз��� �߰� �뼺~~~���� ------�ۼ����� �ؿ��� �ٽ� �õ�
	SELECT 
		A.ȸ����ȣ, A.���ι��, A.CMS����, A.CARD����, A.ȸ������, A.���ο���, A.�����Ͻ���������, A.�����Ͻ���������, B.��Ϻз�, B.ó���������, B.��Ϻз���, B.������
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� A
	LEFT JOIN 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� B 
	ON A.ȸ����ȣ = B.ȸ����ȣ

		WHERE A.ȸ����ȣ in
		(SELECT  
			B.ȸ����ȣ
		FROM 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� B
		WHERE ��Ϻз� like 'TM%' 
		and ó��������� ='SK-�Ϸ�'
		and ��Ϻз��� in ('�뼺-�Ŀ�����', '�뼺-�簳����', '�뼺-����۰���')
		--and ������ = '2017-10-19'
		and ������ = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
		--and ������ >= CONVERT(varchar(10), '2017-09-28', 126) and  ������ <= CONVERT(varchar(10), '2017-09-29', 126)
		)	
	GO

-- Case B (DJ)

	SELECT  
			AR.ȸ����ȣ, AR.��Ϻз�, AR.ó���������, AR.��Ϻз���, AR.������, SI.���ι��, SI.CMS����, SI.CARD����, SI.ȸ������, SI.���ο���, SI.�����Ͻ���������, SI.�����Ͻ���������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� AR
		LEFT JOIN 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� SI
		ON AR.ȸ����ȣ = SI.ȸ����ȣ
		WHERE ��Ϻз� like 'TM%' 
		AND ó��������� ='SK-�Ϸ�'
		AND ��Ϻз��� in ('�뼺-�Ŀ�����', '�뼺-�簳����', '�뼺-����۰���')
		-- AND ������ = '2017-10-19'
		AND ������ = CONVERT(VARCHAR(10), DATEADD(DAY, -5, GETDATE()), 126)
	GO
--Case C
------ CMS�� ī�� �ֱ� ���� ��¥�� �ҷ������� ������ �� //dj: ������ ����� �ҷ������� ���� + �űԴ�� �߰� + ��Ϻз� �߰�
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
--------dj: ��¥�Լ� �ٽ� Ȯ�� (������ �ƴϰ� ��Ʋ���͵� ����)
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
