select S.*
from dbo.outofList O
left join dbo.mrmAll S
ON (O.林家 = S.笼林家 and ISNULL(O.林家惑技,'NULL') = ISNULL(S.笼林家惑技, 'NULL')) OR (O.林家 = S.流厘林家 and ISNULL(O.林家惑技, 'NULL') = ISNULL(S.流厘林家惑技, 'NULL'))
where S.雀盔锅龋 IS NOT NULL

select S.*
from dbo.outofList O
left join dbo.mrmAll S
ON (O.林家 = S.笼林家 and ISNULL(O.林家惑技,'NULL') = ISNULL(S.笼林家惑技, 'NULL')) OR (O.林家 = S.流厘林家 and ISNULL(O.林家惑技, 'NULL') = ISNULL(S.流厘林家惑技, 'NULL'))

			
select *
from dbo.mrmAll 
where 笼林家 like '%辑匡矫 价颇备 泪角悼 249-3锅瘤%' or 流厘林家 like '%辑匡矫 价颇备 泪角悼 249-3锅瘤%'


select 
	*
from dbo.outofList
	