-- 12_Welcome [00_��������]

SELECT dbo_UV_GP_�������.ȸ����ȣ
FROM dbo_UV_GP_�������
WHERE (((dbo_UV_GP_�������.��Ϻз�)="TM_����")) -- �̹� ��Ͽ� ������ �ִ� ���
	OR (((dbo_UV_GP_�������.��Ϻз���)="���")) -- ����� ���
	OR (((dbo_UV_GP_�������.��ϱ���2) Like "*1*")); -- ��ȭ�ź�/���ѺҸ� 



-- 12_Welcome [Welcome_01]

SELECT dbo_UV_GP_�Ŀ�������.ȸ����ȣ, dbo_UV_GP_�Ŀ�������.���ι��, dbo_UV_GP_�Ŀ�������.CMS����, 
		dbo_UV_GP_�Ŀ�������.ī���, dbo_UV_GP_�Ŀ�������.CARD����, dbo_UV_GP_�Ŀ�������.���԰��, 
		dbo_UV_GP_�Ŀ�������.ȸ������, dbo_UV_GP_�Ŀ�������.�Ҽ�, 
		
		IIf([dbo_UV_GP_�Ŀ�������].[����ȭ��ȣ] Is Not Null,1,0)
		+IIf([dbo_UV_GP_�Ŀ�������].[������ȭ��ȣ] Is Not Null,1,0)
		+IIf([dbo_UV_GP_�Ŀ�������].[�޴���ȭ��ȣ]="��",1,0) 
		AS ����ó����, 
		
		IIf([dbo_UV_GP_�Ŀ�������].���ι��="CMS" And [dbo_UV_GP_�Ŀ�������].CMS���� In ("�űԽ���","��������",""),"��������/������",  
			IIf([dbo_UV_GP_�Ŀ�������].���ι��="CMS" And [dbo_UV_GP_�Ŀ�������].CMS���� & dbo_UV_GP_�Ŀ�������.CMS�����ڷ����ʿ�="�űԴ��Y","������", 
				IIf([dbo_UV_GP_�Ŀ�������].���ι��="�ſ�ī��" And [dbo_UV_GP_�Ŀ�������].CARD���� In ("���δ��",""),"��������"
					,Null)
				)
			) 
		AS ��������, 
		
		IIf(dbo_UV_GP_�Ŀ�������.���԰��="�Ÿ�����" 
			And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CMS����] In ("CMS�űԿϷ�","CMS�űԽ���","CMS�����Ϸ�","CMS��������","CMS"),1,
			IIf(dbo_UV_GP_�Ŀ�������.���԰��="�Ÿ�����" 
			And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CARD����] In ("�ſ�ī����δ��","�ſ�ī����οϷ�","�ſ�ī��"),1,
				IIf(dbo_UV_GP_�Ŀ�������.���԰�� In ("Lead Conversion","��ȭ") 
				And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CMS����] In ("CMS�űԽ���","CMS��������","CMS"),1,
					IIf(dbo_UV_GP_�Ŀ�������.���԰�� In ("Lead Conversion","��ȭ") 
					And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CARD����] In ("�ſ�ī����δ��","�ſ�ī��"),1,
						IIf(dbo_UV_GP_�Ŀ�������.���԰�� In ("���ͳ�/Ȩ������") 
						And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CMS����]="CMS�űԴ��",1,
							IIf(dbo_UV_GP_�Ŀ�������.���԰�� In ("���ͳ�/Ȩ������") 
							And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CARD����] In ("�ſ�ī����δ��","�ſ�ī����οϷ�"),1,
								IIf(dbo_UV_GP_�Ŀ�������.���԰�� Is Null 
								And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CMS����]="CMS�űԴ��",1,
									IIf(dbo_UV_GP_�Ŀ�������.���԰�� Is Null 
									And [dbo_UV_GP_�Ŀ�������].[���ι��] & [dbo_UV_GP_�Ŀ�������].[CARD����] 
									In ("�ſ�ī����δ��","�ſ�ī����οϷ�","�ſ�ī��"),1,0)))))))) 
		AS ä�κ��ݴ�󱸺�, 
							--"�Ÿ�����"�̰� CMS�űԿϷ�/�űԽ���/�����Ϸ�/��������/����, CARD���δ��/���οϷ�/�����̸� 1
							--"Lead Conversion"�̳� "��ȭ"�̰� CMS�űԽ���/��������/����, CARD���δ��/�����̸� 1
							--"���ͳ�/Ȩ������"�̰� CMS�űԴ�� CARD���δ��/���οϷ��̸� 1
							--���԰�� NULL�̰� CMS�űԴ�� CARD���δ��/���οϷ�/�����̸� 1
							--�׹ۿ��� 0 (��:�Ÿ������̰� CMS�űԴ��/�������) 
							--�ݴ����=1
						
		
		dbo_UV_GP_�Ŀ�������.�����Է���

FROM 00_�������� RIGHT JOIN dbo_UV_GP_�Ŀ������� 

ON [00_��������].ȸ����ȣ = dbo_UV_GP_�Ŀ�������.ȸ����ȣ

WHERE (((dbo_UV_GP_�Ŀ�������.ȸ������) Not In ("Canceled","Other")) 
	And (
		(IIf(dbo_UV_GP_�Ŀ�������.����ȭ��ȣ Is Not Null,1,0)
		+IIf(dbo_UV_GP_�Ŀ�������.������ȭ��ȣ Is Not Null,1,0)
		+IIf(dbo_UV_GP_�Ŀ�������.�޴���ȭ��ȣ="��",1,0))  
			>0
		) 
	And ((dbo_UV_GP_�Ŀ�������.������)>="2017-01-01") 
	And ((dbo_UV_GP_�Ŀ�������.���ʵ�ϱ���)="����") 
	And ((dbo_UV_GP_�Ŀ�������.��ϱ���)<>"�ܱ���") 
	And (([00_��������].ȸ����ȣ) Is Null));




-- 12_Welcome [Welcome_02]

SELECT 
	Welcome_01.ȸ����ȣ, Welcome_01.�������� AS ����, Welcome_01.���԰��, Welcome_01.�Ҽ�, 
	iif(Welcome_01.���ι��="CMS",Welcome_01.CMS����, 
		iif(Welcome_01.���ι��="�ſ�ī��",Welcome_01.CARD����,null)) AS ���ι������, 
	Welcome_01.ȸ������, 
	format(Welcome_01.�����Է���,"yyyy-mm-dd") AS �����Է���
FROM Welcome_01
WHERE (((Welcome_01.ä�κ��ݴ�󱸺�)=1));



-- Welcome, CMS_F

SELECT 
	Welcome_02.[ȸ����ȣ], Welcome_02.[����], "TM_����-��ó��" as [��Ϻз�/�󼼺з�], date() as ����, 
	"SK-����" as ����1, "W.CALL_WV" as ����, Welcome_02.[���԰��], Welcome_02.[���ι������], Welcome_02.[�����Է���]

FROM Welcome_02

UNION ALL 

SELECT CMSpf_03.ȸ����ȣ, CMSpf_03.����, 
	"TM_CMS����-��ó��" AS [��Ϻз�/�󼼺з�], date() as ����, "SK-����" as ����1, 
	"CMSVR.CALL_WV" as ����, CMSpf_03.���԰��, CMSpf_03.CMS����, CMSpf_03.�����Է���

FROM Welcome_02 RIGHT JOIN CMSpf_03 ON Welcome_02.ȸ����ȣ = CMSpf_03.ȸ����ȣ
WHERE (((Welcome_02.ȸ����ȣ) Is Null));



--CMSpf_01

SELECT 

dbo_UV_GP_�Ŀ�������.ȸ����ȣ, dbo_UV_GP_�Ŀ�������.���ι��, dbo_UV_GP_�Ŀ�������.CMS����, dbo_UV_GP_�Ŀ�������.���԰��, dbo_UV_GP_�Ŀ�������.������, dbo_UV_GP_�Ŀ�������.�����Է���

FROM dbo_UV_GP_�Ŀ�������

WHERE (((dbo_UV_GP_�Ŀ�������.���ι��)="CMS") 
	AND ((dbo_UV_GP_�Ŀ�������.CMS����) Like "*���*") 
	AND ((dbo_UV_GP_�Ŀ�������.ȸ������)="Normal") 
	AND ((dbo_UV_GP_�Ŀ�������.���ʵ�ϱ���)="����") 
	AND ((dbo_UV_GP_�Ŀ�������.CMS�����ڷ����ʿ�)="Y"));



--CMSpf_02

SELECT 

	dbo_UV_GP_�������.ȸ����ȣ, dbo_UV_GP_�������.����Ͻ�, dbo_UV_GP_�������.��Ϻз�, 
	dbo_UV_GP_�������.��Ϻз���, dbo_UV_GP_�������.������, dbo_UV_GP_�������.ó���������, 
	dbo_UV_GP_�������.����, dbo_UV_GP_�������.�����Է���, dbo_UV_GP_�������.��ϱ���2, 
	IIf(dbo_UV_GP_�������.[ó���������] Like "*����*",1,
		IIf(dbo_UV_GP_�������.[ó���������] Like "*����*",1,0)) AS ������TF, 
	IIf(dbo_UV_GP_�������.[������]>=Date()-5,1,0) AS �ֱ�TF

FROM 
	CMSpf_01 INNER JOIN dbo_UV_GP_������� 
	
ON CMSpf_01.ȸ����ȣ = dbo_UV_GP_�������.ȸ����ȣ

WHERE (((dbo_UV_GP_�������.��Ϻз�) Not In ("Freezing","Impact report","Other mailings","Regular E-mail","Regular SMS","survey response","Welcome pack")) AND ((IIf([dbo_UV_GP_�������].[ó���������] Like "*����*",1,IIf([dbo_UV_GP_�������].[ó���������] Like "*����*",1,0)))=1)) OR (((dbo_UV_GP_�������.��Ϻз�) Not In ("Freezing","Impact report","Other mailings","Regular E-mail","Regular SMS","survey response","Welcome pack")) AND ((IIf([dbo_UV_GP_�������].[������]>=Date()-5,1,0))=1));




--CMSpf_03

SELECT 
	CMSpf_01.ȸ����ȣ, "������" AS ����, CMSpf_01.���԰��, CMSpf_01.���ι��, CMSpf_01.CMS����, CMSpf_01.������, 
	Format(CMSpf_01.�����Է���,'yyyy-mm-dd') AS �����Է���

FROM CMSpf_02 RIGHT JOIN CMSpf_01 

ON CMSpf_02.ȸ����ȣ = CMSpf_01.ȸ����ȣ

WHERE (
		((Format([CMSpf_01].[�����Է���],'yyyy-mm-dd'))<=Date()-3) 
		AND ((CMSpf_02.ȸ����ȣ) Is Null)
	);
