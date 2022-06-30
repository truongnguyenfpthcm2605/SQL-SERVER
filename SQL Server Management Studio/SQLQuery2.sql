create function fn (@age int)
returns int
as
begin
	return year(getdate()) - @age
end
go
print dbo.fn(2001)
go
-- vd 2

create function diemnv ()
returns int
as
begin
	return (select count(manv) from NHANVIEN)
end
go
 print cast(dbo.diemnv() as varchar)
go
  -- vd 3
create function slnv(@gioitinh nvarchar(3))
returns int
as
begin 
	return ( select count(manv) from NHANVIEN where phai like @gioitinh)
end

print cast(dbo.slnv(N'Nam') as varchar)

-- vd 4 tim cac nhan vien cua phong so 5
create function findphg(@ma int)
returns table
as

	return (select * from NHANVIEN where PHG = @ma)
go
select * from findphg(5)

 -- vd 5 ham da gia tri
 create function dagiatri (@phong int)
 returns @t table 
 ( ten nvarchar(15), ma int,phong nvarchar(9), ngay date)
 as
 begin
  if @phong is null
  begin
  insert into @t (ten,ma,phong,ngay)
  select TENPHG,MAPHG,TRPHG,NG_NHANCHUC  from PHONGBAN
  end
  else
  begin
  insert into @t (ten,ma,phong,ngay)
  select TENPHG,MAPHG,TRPHG,NG_NHANCHUC  from PHONGBAN where MAPHG = @phong
  end
  return
 end
 select * from dbo.dagiatri(null)