-- diem tong so nhan vien, tong so nv nam sau khi them ,xao, sua, nhanvien
create trigger dem on nhanvien after insert, update, delete
as
begin
		declare @tongnv int ,@tongnam int
		Set @tongnv = (select count(*) from nhanvien)
		Set @tongnam = (select count(*) from nhanvien where PHAI = N'Nam')
		print 'co' + cast(@tongnv as varchar)  + 'nhan vien   ' +cast(@tongnam as varchar) + 'Nhan vien nam'


end
update  NHANVIEN
set phai = N'Nam'
where manv= '006'
delete  from nhanvien where manv = '012'

select * from nhanvien