-- �۾� 001 --

DROP TABLE IF EXISTS [work].[dbo].[001]

SELECT 
	List_EN.[Supporter Email],  List_EN.[Korean name], List_EN.phone_number, List_EN.[Campaign ID], List_EN.[Campaign Date], List_EN.[utm_source],
	
	CASE 
		WHEN List_EN.[utm_source] IS NOT NULL THEN List_EN.[utm_source]
		WHEN List_EN.[Campaign Data 33] Is Not Null THEN List_EN.[Campaign Data 33]
		WHEN List_EN.[Campaign Data 34] Is Not Null THEN List_EN.[Campaign Data 34]
		ELSE NULL
	END AS data1

INTO [work].[dbo].[001]

FROM
	[work].[dbo].['export-result_ANSI$'] AS List_EN


-- �۾� 001-1 --

DROP TABLE IF EXISTS [work].[dbo].[001-1]

SELECT *, 

	CASE
		WHEN [work].[dbo].[001].[data1] IS NULL THEN 'Unknown'
		WHEN [work].[dbo].[001].[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN [work].[dbo].[001].[data1] LIKE '%naver%' OR [work].[dbo].[001].[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN [work].[dbo].[001].[data1] LIKE '%kakao%' THEN '����īī��'
		WHEN [work].[dbo].[001].[data1] LIKE '%act.greenpeace%' OR [work].[dbo].[001].[data1] LIKE '%me2.do%' THEN '�׸��ǽ�����������'
		WHEN [work].[dbo].[001].[data1] LIKE '%greenpeace.org%' OR [work].[dbo].[001].[data1] LIKE '%P3%' THEN '�׸��ǽ�Ȩ������'
		WHEN [work].[dbo].[001].[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN [work].[dbo].[001].[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN [work].[dbo].[001].[data1] LIKE '%slownews%' OR [work].[dbo].[001].[data1] LIKE '%huffing%' THEN CONCAT('��л�-', Left([work].[dbo].[001].[data1],10))
		WHEN [work].[dbo].[001].[data1] LIKE '%twitter%' THEN 'Twitter'
		ELSE CONCAT('��Ÿ-', Left([work].[dbo].[001].[data1],10))
			--	 "%honeyscreen%" "Honeyscreen" ����
	END AS data2

INTO [work].[dbo].[001-1]

FROM [work].[dbo].[001]

WHERE 
	([work].[dbo].[001].[Campaign Date] <= GETDATE() - 2)


-- �۾� 002 --

SELECT 
	[work].[dbo].[001-1].[Supporter Email], [work].[dbo].[001-1].[Korean name], [work].[dbo].[001-1].[phone_number], 
	REPLACE([work].[dbo].[001-1].[phone_number],' ',''),
	[work].[dbo].[001-1].[phone_number] * 1,
	
/*	REPLACE
		(REPLACE
			(REPLACE
				(REPLACE
					(REPLACE
						([work].[dbo].[001-1].[phone_number],' ',''
						)
					,'-',''
					)
				,'+',''
				)
			,'.',''
			)
		,'*',''
		) AS phone_number1, --���� �� ��ȣ ����
*/
/**
	iif(left([phone_number1],2)='82',mid([phone_number1],3,20),[phone_number1]) AS phone_number2, --������ȣ ����
	iif(left(phone_number2,3) in ('010','011') 	
		and len(phone_number2)=11,
		'comp'&left(phone_number2,3)&'-'&mid(phone_number2,4,4)&'-'&mid(phone_number2,8,4), --�ڸ��� �°� 010,011���۽� 'comp' ����
		iif(left(phone_number2,2) in ('10','11') 
			and len(phone_number2)=10,
			'comp'&'0'&left(phone_number2,2)&'-'&mid(phone_number2,3,4)&'-'&mid(phone_number2,7,4), --�տ� 0������� ���̰� 'comp' ����
			iif(left(phone_number2,3)='011' 
				and len(phone_number2)=10,'comp'&left(phone_number2,3)&'-'&mid(phone_number2,4,3)&'-'&mid(phone_number2,7,4),  --011�� �����ϰ� 9�ڸ��� ��� 'comp' ����
				iif(left(phone_number2,2)='11' 
				and len(phone_number2)=9,'comp'&'0'&left(phone_number2,2)&'-'&mid(phone_number2,3,3)&'-'&mid(phone_number2,6,4), --11�� �����ϴ� ��� 0 ���̰� 'comp' ���� **** left 3���� 2�� ���� �ʿ� *****
					iif(left(phone_number2,2)='02' 
					and len(phone_number2)=9,'comp'&left(phone_number2,2)&'-'&mid(phone_number2,3,3)&'-'&mid(phone_number2,6,4),  --02�� �����ϰ� 9�ڸ��� ��� 'comp' ����
						iif(left(phone_number2,2)='02' 
						and len(phone_number2)=10,'comp'&left(phone_number2,2)&'-'&mid(phone_number2,3,4)&'-'&mid(phone_number2,7,4), --02�� �����ϰ� 10�ڸ��� ��� 'comp' ����
							iif(left(phone_number2,2)='02' 
							and len(phone_number2)=10,'comp'&left(phone_number2,2)&'-'&mid(phone_number2,3,4)&'-'&mid(phone_number2,7,4), --�ߺ� �������� ����
								iif(left(phone_number2,3) in ('031','032','033','041','042','043','044','049','051','052','053','054','055','061','062','063','064','070') 
								and len(phone_number2)=10,'comp'&left(phone_number2,3)&'-'&mid(phone_number2,4,3)&'-'&mid(phone_number2,7,4), --��Ÿ������ȣ�� �����ϰ� 10�ڸ��� ��� 'comp' ����
									iif(left(phone_number2,3) in ('031','032','033','041','042','043','044','049','051','052','053','054','055','061','062','063','064','070') 
									and len(phone_number2)=11,'comp'&left(phone_number2,3)&'-'&mid(phone_number2,4,4)&'-'&mid(phone_number2,8,4), --��Ÿ������ȣ�� �����ϰ� 11�ڸ��� ��� 'comp' ����
										iif(left(phone_number2,2) in ('31','32','33','41','42','43','44','49','51','52','53','54','55','61','62','63','64','70') 
										and len(phone_number2)=9,'comp'&'0'&left(phone_number2,2)&'-'&mid(phone_number2,3,3)&'-'&mid(phone_number2,6,4),
											iif(left(phone_number2,2) in ('31','32','33','41','42','43','44','49','51','52','53','54','55','61','62','63','64','70') and 
											len(phone_number2)=10,'comp'&'0'&left(phone_number2,2)&'-'&mid(phone_number2,3,4)&'-'&mid(phone_number2,7,4),
											[phone_number2])
											)
										)
									)
								)
							)
						)
					)
				)
			)
		) AS phone_number3, 
**/

		[work].[dbo].[001-1].[Campaign ID], [work].[dbo].[001-1].[Campaign Date], left([work].[dbo].[001-1].[data1],10) AS datapart, [work].[dbo].[001-1].[data2] AS Source

FROM [work].[dbo].[001-1];


