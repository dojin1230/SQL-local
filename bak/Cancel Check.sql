-- Case A
SELECT D.ȸ����ȣ, D.ȸ������, D.���ο���, D.�����Ͻ���������, D.�����Ͻ���������, H.ó���������
	FROM dbo.UV_GP_�Ŀ������� D LEFT JOIN DBO.UV_GP_������� H
		ON D.ȸ����ȣ = H.ȸ����ȣ	
			WHERE H.��Ϻз�='Cancellation' 
			and (H.��Ϻз���='SS-Canceled' OR H.��Ϻз���='Canceled')
			and H.ó���������='IH-����'
			and (D.ȸ������ !='canceled' OR D.���ο���!='N' OR �����Ͻ��������� is not null OR �����Ͻ��������� is not null)
go

-- Case B
SELECT D.ȸ����ȣ, D.ȸ������, D.���ο���, D.�����Ͻ���������, D.�����Ͻ���������, H.ó���������
	FROM dbo.UV_GP_�Ŀ������� D LEFT JOIN DBO.UV_GP_������� H
		ON D.ȸ����ȣ = H.ȸ����ȣ	
			WHERE H.��Ϻз�='Cancellation' 
			and (H.��Ϻз���='SS-Downgrade')
			and H.ó���������='IH-����'
			and (D.ȸ������ !='normal' OR D.���ο���!='Y' OR �����Ͻ��������� is not null OR �����Ͻ��������� is not null)
go

			
-- Case D
SELECT D.ȸ����ȣ, D.ȸ������, D.���ο���, D.�����Ͻ���������, D.�����Ͻ���������, H.ó���������
	FROM dbo.UV_GP_�Ŀ������� D LEFT JOIN DBO.UV_GP_������� H
		ON D.ȸ����ȣ = H.ȸ����ȣ	
			WHERE H.��Ϻз���='�ڹ�_Unfreezing'
			and H.ó���������='IH-����'			
go

		

			

		