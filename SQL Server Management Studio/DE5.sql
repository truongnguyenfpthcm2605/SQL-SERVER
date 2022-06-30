create database DE5
on
(
	name = DE5_dat,
	filename = 'D:\SUMMER2022\COM2034-SQL SEVER\DE5.dat',
	size = 5,
	maxsize = 50,
	filegrowth = 5
)
log on
(

	name = DE5_ldf,
	filename = 'D:\SUMMER2022\COM2034-SQL SEVER\DE5.ldf',
	size = 5mb,
	maxsize = 50mb,
	filegrowth = 5mb
)
go
use DE5
go

create table sinhvien
(
	Masv int primary key,
	Hotensv nvarchar(40),
	Namsinh int,
	Quequan nvarchar(300)
)
go
create table detai
(
		Madt char(10) primary key,
		Tendt nvarchar(30),
		Kinhphi int,
		Noithuctap nvarchar(30),
		Masv int references sinhvien(Masv),
		Ketqua decimal(5,2)
)
go
insert into sinhvien values
(1,N'Lê Văn Nam',1990,N'Nghệ An'),
(2,N'Nguyễn Thị Mỹ ',1990,N'Thanh Hóa'),
(3,N'Bùi Xuân Đức',1992,N'Hà Nội'),
(4,N'Nguyễn Văn Tùng ',null,N'Hà Tĩnh'),
(5,N'Lê Khánh Linh',1989,N'Hà Nam')
go
insert into detai values
('Dt01',N'GIS',100,N'Nghệ An',1,6.80),
('Dt02',N'ARC GIS',500,N'Nam Định',2,7.65),
('Dt03',N'Spatial DB',100,N'Hà Tĩnh',2,8.25),
('Dt04',N'Blockchain',300,N'Nam Định',null,null),
('Dt05',N'clound computing',700,N'Nam Định',null,null)
go


--1. Tạo Stored Procedure hiển thị đề tài của sinh viên thực hiện với điều kiện có kết quả thực tập cao 
--hơn giá trị được truyền vào qua tham số, thông tin gồm có: Madt, Tendt, HoTenSv, Kinhphi, 
--NoiThucTap, KetQua. 
create proc cau1 @madt char(10),@tendt nvarchar(30), @hoten nvarchar(40),@kp int,
@noithuctap nvarchar(30),@kq decimal(5,2)
as
begin
	select * from detai where Ketqua > (select  Ketqua from detai join sinhvien on sinhvien.Masv = detai.Masv where Madt =@madt and Tendt = @tendt and Hotensv = @hoten and Kinhphi =@kp and Ketqua = @kq) 
end
execute cau1 'Dt01','GIS',N'Lê Văn Nam',100,N'Nghệ An',6.80
go

--2. Tạo Function trả về tổng kinh phí thực hiện đề tài của một sinh viên, biết Masv truyền qua tham số.
--Viết truy vấn hiển thị tất cả danh sách sinh viên, thông tin: MaSV, HoTenSV, TongKinhphi
--Chú ý: TongKinhphi sử dụng hàm vừa tạo để tínhalter function cau2 (@ma int)returns int asbegin	return ( select SUM(Kinhphi) from sinhvien join detai on sinhvien.Masv = detai.Masv where sinhvien.Masv = @ma)endgoselect Masv,Hotensv,dbo.cau2(Masv) as 'tong kinh phi' from sinhvien--3. Tạo Triger xóa sinh viên (giả sử mỗi lần xóa 1 sinh viên) và xóa các đề tài có liên quan đến sinh viên này.
--Viết truy vấn xóa một sinh viên để kiểm tra Trigger đã tạo.gocreate trigger cau3 on sinhvien instead of deleteasbegin	declare @ma int	select @ma =(select Masv from deleted)	delete from detai where Masv = @ma	delete from sinhvien where Masv =@maendgoselect * from sinhvienselect * from detaigo--4. Tạo View DeAnKhongTacGia gồm tất cả các thông tin: MaSv, TenDeAN, KinhPhi, NoiThucTap, KetQua
--Viết câu lệnh Cập nhật sinh viên có mã là 7 để thực hiện các đề án chưa được phân công (Masv đang có 
--giá trị NULL) vào View DeAnKhongTacGia.create view cau4 as select* from detaigoselect * from cau4update cau4 set Masv = 7 where Masv is nullupdate sinhvien set Masv = 7 where Hotensv = N'Nguyễn Văn Tùng '