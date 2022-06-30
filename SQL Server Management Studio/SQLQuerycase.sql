declare @pt int = 4
-- cach 1 simple case
print case @pt
	when 1 then  'cong'
	when 2 then 'tru'
	when 3 then 'nhan'
	when 4 then 'chia'
	else 'khong biet'
end 

-- cach 2 search case
print case
	when @pt=1 then  'cong'
	when  @pt=2 then 'tru'
	when  @pt=3 then 'nhan'
	when  @pt=4 then 'chia'
	else 'khong biet'
end 

-- vd hoc luc
declare @hocluc float =9
print case
		when @hocluc >=9 then 'gioi'
		when @hocluc >=7.5 then 'kha'
		when @hocluc >=5 then 'tb'
		when @hocluc <5 then 'yeu'
		else 'khong biet nua'
end
