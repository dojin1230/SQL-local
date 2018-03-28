select U.己疙,U.雀盔锅龋,U.绒措傈拳锅龋
from mrmData U
join (		
	select 林家, 惑技林家
	from dbo.smsFirst
	group by 林家, 惑技林家 having count(1) > 1
) S
ON (U.笼林家 = S.林家 AND U.笼林家惑技 = S.惑技林家) --OR (U.流厘林家 = S.林家 AND U.流厘林家惑技 = S.惑技林家)
;
 
 