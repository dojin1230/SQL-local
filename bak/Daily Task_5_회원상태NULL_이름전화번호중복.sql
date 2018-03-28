-- 회원상태 NULL 찾기 --

select 
	mem.회원번호, mem.회원상태
from 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 mem 

where 
	mem.회원상태 = null

-- 이름+전화번호 중복 찾기 --

select 

성명, 휴대전화번호

from work.dbo.db0_clnt_i

group by 성명, 휴대전화번호

having COUNT(휴대전화번호) > 1


-- 이름+이메일 중복 찾기 --

select

성명, 이메일

from work.dbo.db0_clnt_i

group by 성명, 이메일

having COUNT(이메일) > 1