-- 13_Lead conversion Target [001]
SELECT 
	List_EN.[Supporter Email], List_EN.[Korean name], List_EN.phone_number, List_EN.[Campaign ID], List_EN.[Campaign Date], 
	
	IIf(List_EN.[utm_source] Is Not Null, List_EN.[utm_source], 
		IIf(List_EN.[Campaign Data 33] Is Not Null, List_EN.[Campaign Data 33],
			IIf(List_EN.[Campaign Data 34] Is Not Null, List_EN.[Campaign Data 34])
			)
		) AS data1, 
	
	IIf([data1] Is Null,"Unknown",
		IIf([data1] Like "*facebook*","Facebook",
			IIf([data1] Like "*youtube*","Youtube",
				IIf(([data1] Like "*naver*") Or ([data1] Like "*happybean*"),"NAVER",
					IIf([data1] Like "*kakao*","����īī��",
						IIf([data1] Like "*honeyscreen*","Honeyscreen",
							IIf(([data1] Like "*act.greenpeace*") Or ([data1] Like "*me2.do*"),"�׸��ǽ�����������",
								IIf([data1] Like "*instagram*","Instagram",
									IIf(([data1] Like "*greenpeace.org*") Or ([data1] Like "*P3*"),"�׸��ǽ�Ȩ������",
										IIf(([data1] Like "*slownews*") Or ([data1] Like "*huffing*"),"��л�-" & Left([data1],10),
											IIf([data1] Like "*twitter*","Twitter","��Ÿ-" & Left([data1],10))
											)
										)
									)
								)
							)
						)
					)
				)
			)
		) AS data2, 
		
		"existing" AS grp
		
FROM List_EN

WHERE (
		(
			(List_EN.[Campaign Date]) <= Date()-"2" --���ú��� ��Ʋ ������ �۰ų� ���� ��¥
		)
	);

-- 13_Lead conversion Target [002]
SELECT 
	[001].[Supporter Email], [001].[Korean name], [001].[phone_number], 
		replace
			(replace
				(replace
					(replace
						(replace
							([001].[phone_number]," ","")
							,"-","")
							,"+","")
							,".","")
							,"*","") AS phone_number1, --���� �� ��ȣ ����
	iif(left([phone_number1],2)="82",mid([phone_number1],3,20),[phone_number1]) AS phone_number2, --������ȣ ����
	iif(left(phone_number2,3) in ("010","011") 	
		and len(phone_number2)=11,
		"comp"&left(phone_number2,3)&"-"&mid(phone_number2,4,4)&"-"&mid(phone_number2,8,4), --�ڸ��� �°� 010,011���۽� 'comp' ����
		iif(left(phone_number2,2) in ("10","11") 
			and len(phone_number2)=10,
			"comp"&"0"&left(phone_number2,2)&"-"&mid(phone_number2,3,4)&"-"&mid(phone_number2,7,4), --�տ� 0������� ���̰� 'comp' ����
			iif(left(phone_number2,3)="011" 
				and len(phone_number2)=10,"comp"&left(phone_number2,3)&"-"&mid(phone_number2,4,3)&"-"&mid(phone_number2,7,4),  --011�� �����ϰ� 9�ڸ��� ��� 'comp' ����
				iif(left(phone_number2,3)="11" 
				and len(phone_number2)=9,"comp"&"0"&left(phone_number2,2)&"-"&mid(phone_number2,3,3)&"-"&mid(phone_number2,6,4), --11�� �����ϴ� ��� 0 ���̰� 'comp' ���� **** left 3���� 2�� ���� �ʿ� *****
					iif(left(phone_number2,2)="02" 
					and len(phone_number2)=9,"comp"&left(phone_number2,2)&"-"&mid(phone_number2,3,3)&"-"&mid(phone_number2,6,4),  --02�� �����ϰ� 9�ڸ��� ��� 'comp' ����
						iif(left(phone_number2,2)="02" 
						and len(phone_number2)=10,"comp"&left(phone_number2,2)&"-"&mid(phone_number2,3,4)&"-"&mid(phone_number2,7,4), --02�� �����ϰ� 10�ڸ��� ��� 'comp' ����
							iif(left(phone_number2,2)="02" 
							and len(phone_number2)=10,"comp"&left(phone_number2,2)&"-"&mid(phone_number2,3,4)&"-"&mid(phone_number2,7,4), --�ߺ� �������� ����
								iif(left(phone_number2,3) in ("031","032","033","041","042","043","044","049","051","052","053","054","055","061","062","063","064","070") 
								and len(phone_number2)=10,"comp"&left(phone_number2,3)&"-"&mid(phone_number2,4,3)&"-"&mid(phone_number2,7,4), --��Ÿ������ȣ�� �����ϰ� 10�ڸ��� ��� 'comp' ����
									iif(left(phone_number2,3) in ("031","032","033","041","042","043","044","049","051","052","053","054","055","061","062","063","064","070") 
									and len(phone_number2)=11,"comp"&left(phone_number2,3)&"-"&mid(phone_number2,4,4)&"-"&mid(phone_number2,8,4), --��Ÿ������ȣ�� �����ϰ� 11�ڸ��� ��� 'comp' ����
										iif(left(phone_number2,2) in ("31","32","33","41","42","43","44","49","51","52","53","54","55","61","62","63","64","70") 
										and len(phone_number2)=9,"comp"&"0"&left(phone_number2,2)&"-"&mid(phone_number2,3,3)&"-"&mid(phone_number2,6,4),
											iif(left(phone_number2,2) in ("31","32","33","41","42","43","44","49","51","52","53","54","55","61","62","63","64","70") and 
											len(phone_number2)=10,"comp"&"0"&left(phone_number2,2)&"-"&mid(phone_number2,3,4)&"-"&mid(phone_number2,7,4),
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
		[001].[Campaign ID], [001].[Campaign Date], left([001].[data1],10) AS datapart, [001].[data2] AS Source
FROM 001;



--  13_Lead conversion Target [003] 

SELECT 

	Petition_campaign.[Campaign name_KR], [002].[Supporter Email], [002].[Korean name], [002].phone_number, 
	[002].phone_number3, [002].[Campaign ID], [002].[Campaign Date], [002].datapart, [002].Source

FROM 

	Petition_all AS Petition_all_1 

	RIGHT JOIN 
		(Petition_all 
			RIGHT JOIN 
				(002 LEFT JOIN Petition_campaign 
					ON [002].[Campaign ID] = Petition_campaign.[Campaign ID]
				) --[Campaign ID] �������� ķ���θ��� [002]�� ����
			ON Petition_all.Phone = [002].phone_number
		) --����ȣ �������� [1�� ���ε� 002]�� [Petition_all]�� ����
	ON Petition_all_1.Mail = [002].[Supporter Email] --�̸��� �������� [2�� ���ε� 002]�� [Petition_all]�� ����

WHERE (
		(([002].phone_number) Is Not Null) 
		AND 
		((Petition_all.Phone) Is Null) 
		AND 
		((Petition_all_1.Mail) Is Null)
	) --���ε� ���̺��� ������ [Petition_all] ���̺� ����ȣ�� �����ּҰ� ���� ��� ���� (������ Petition_all�� �ִ� ��� �ɷ���)

ORDER BY Petition_campaign.[Campaign name_KR];



--  13_Lead conversion Target [004��] 

SELECT 

	[003].[Campaign name_KR], [003].[Supporter Email], [003].[Korean name], [003].phone_number, 
	[003].phone_number3, [003].[Campaign ID], [003].[Campaign Date], [003].datapart, [003].Source

FROM 01_Clnt_i AS 01_Clnt_i_1 
	RIGHT JOIN 
		(003 LEFT JOIN 01_Clnt_i 
		ON [003].phone_number3 = [01_Clnt_i].�޴���ȭ��ȣ) --����ȣ �������� [003]���̺� [01_Clnt_i]���̺� ����
	ON [01_Clnt_i_1].�̸��� = [003].[Supporter Email] --�̸��� �������� [1�� ���ε� 003]���̺� [01_Clnt_i_1]���̺� ����

WHERE (
		(([01_Clnt_i].�޴���ȭ��ȣ) Is Null) 
		AND 
		(([01_Clnt_i_1].�̸���) Is Null)
	);


-- [004��2]

SELECT 
	[003].[Campaign name_KR], [003].[Supporter Email], [003].[Korean name], [003].phone_number, [003].phone_number3, 
	[003].phone_number4, [01_Clnt_i_phone].[�޴�����ȣ], [003].[Campaign ID], [003].[Campaign Date], [003].datapart, [003].Source

FROM 01_Clnt_i RIGHT JOIN 
	(003 LEFT JOIN 01_Clnt_i_phone 
		ON [003].phone_number4 = [01_Clnt_i_phone].[�޴�����ȣ]) 
		ON [01_Clnt_i].�̸��� = [003].[Supporter Email]

WHERE ((([01_Clnt_i_phone].�޴�����ȣ) Is Null) And (([01_Clnt_i].�̸���) Is Null));


--  13_Lead conversion Target [005] 

SELECT 
	[004��].[Campaign name_KR], [004��].[Supporter Email], [004��].[Korean name], [004��].phone_number, 
	Replace([004��].phone_number3,"comp","") AS phone_number3, 
	IIf(Left([004��].phone_number3,4)="comp","T","F") AS modifiedTF, 
	[004��].[Campaign ID], [004��].[Campaign Date], [004��].datapart, [004��].Source INTO Petition_daily
FROM 004��;


-- [005��3]

SELECT 
	[004��2].[Campaign name_KR], [004��2].[Supporter Email], [004��2].[Korean name], [004��2].phone_number, 
	Replace([004��2].phone_number3,"comp","") AS phone_number3, 
	IIf(Left([004��2].phone_number3,4)="comp","T","F") AS modifiedTF, 
	[004��2].[Campaign ID], [004��2].[Campaign Date], [004��2].datapart, [004��2].Source INTO Petition_daily
FROM 004��2;
