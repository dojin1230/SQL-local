SELECT DISTINCT CH.ȸ����ȣ, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON CH.ȸ����ȣ = D.ȸ����ȣ
WHERE 
(CH.�����׸� = '�����ڷ��߰�' OR CH.�����׸� LIKE '����%' 
--OR CH.�����׸� IN ('����', '���¹�ȣ','���αݾ�','���ι��','������') 
OR (CH.�����׸� = '���ο���' AND CH.������ = 'Y'))
AND CH.�����Ͻ� >= GETDATE() - 4
AND D.ȸ������ IN ('Freezing','Canceled')
