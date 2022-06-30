CREATE DATABASE ps23337_leminhdat
go
use ps23337_leminhdat 
go


create table khachhang
(
	MaKh nvarchar(6) primary key,
	TenKH nvarchar(30) not null,
	DiaChi nvarchar(30),
	SoDT char(13)
)
go
create table datphong
(
	MaDatPhong nvarchar(6) primary key,
	MaPhong nvarchar(5) not null,
	MaKh nvarchar(6) references khachhang(MaKh),
	NgayDat date,
	GioBatDau time,
	GioKetThuc time,
	TienDatCoc money,
	GhiChu  nvarchar(200),
	TrangThaiDat nvarchar(50)
)
go

insert into khachhang values
(N'KH001',N'Nguyễn Thị Ngọc Mai',N'20 CMT8 ,TP.HCM','0938712385'),
(N'KH002',N'Phạm Văn Trí',N'23/15 Hồ Thị Kỷ, TP. HCM','0908912385'),
(N'KH003',N'Văn Mai Hương',N'45 Thành Thái, TP HCM','0918712458'),
(N'KH004',N'Vũ Thị Hồi',N'87 Bành Văn Trân,TP.HCM','0981789125')
go
insert into datphong values 
(N'DP001',N'P001',N'KH001','2022-03-26','11:00:00','13:00:00',100000,NULL,N'Đã Đặt'),
(N'DP002',N'P002',N'KH002','2022-03-27','17:15:00','19:15:00',500000,NULL,N'Đã Hủy'),
(N'DP003',N'P003',N'KH003','2022-03-26','20:30:00','22:15:00',100000,NULL,N'Đã Đặt'),
(N'DP004',N'P004',N'KH001','2022-04-01','19:30:00','21:15:00',200000,NULL,N'Đã Đặt')
go

--1. Tạo View KHACHHANG hiển thị tất cả những khách hàng đã từng đặt phòng Karaoke 
--Viết câu lệnh Update cho View KHACHHANG để cập nhật lại SoDT cho TenKH 'Vũ Thị Hồi'

create view cau1
as 
	select  khachhang.* from khachhang join datphong on khachhang.MaKh = datphong.MaKh 
go
update cau1 set SoDT = '453664647' where TenKH like N'Vũ Thị Hồi'


--2. Tạo Function trả về tổng số tiền đặt cọc theo NgayDat truyền qua tham số.
--Viết lệnh in nội dung: Tổng tiền đặt cọc của ngày … là xxx đồng. Với xxx là số tiền cọc tính 
--từ hàm vừa tạo.
--Ví dụ: Tổng tiền đặt cọc của ngày 26-09-2022 là 200000 đồng.
go
create function cau2 (@ngaydat date)
returns money
as
begin
	return (select SUM(TienDatCoc) from datphong where NgayDat = @ngaydat)
end
go

print N'tong tien dat coc cua ngay 27-03-2022 la ' + cast(dbo.cau2('2022-03-27') as varchar(10)) + N' đồng'
go

-- 3. Tạo Store Procedure đếm số lần đặt phòng của khách hàng có TenKH được truyền qua tham số. 
--Viết câu lệnh Execute Stored Procedure vừa tạo để xem số lần đặt hàng của khách hàng 
--tên ‘Nguyễn Thị Ngọc Mai’.

create proc cau3 @ten nvarchar(30)
as
begin
	select COUNT(*) from khachhang join datphong on datphong.MaKh = khachhang.MaKh where TenKH like @ten
end
go
execute cau3 N'Nguyễn Thị Ngọc Mai'
go

--4. Tạo Trigger cho phép khi thêm một khách hàng vào bảng KHACHHANG thì tự động đặt phòng 
--cho khách hàng này có MaPhong là P0001 với ngày đặt và giờ bắt đầu là thời điểm viết 
--Trigger, các trường còn lại sinh viên tự nhập dữ liệu phù hợp.
--Viết truy vấn thêm 1 khách hàng mới vào table KHACHHANG để kiểm tra trigger đã tạo.
alter trigger cau4 on khachhang after insert
as
begin
	insert into datphong values ((select MaKh from inserted)+'n',N'P0001',(select MaKh from inserted ),GETDATE(),'11:00:00','12:00:00',200000,null,N'Đã Đăt')
	
end
insert into khachhang values (N'KH009',N'Lê Minh Đạt','TP.HCM','45353566')
select * FROM datphong