CREATE DATABASE DE3
ON
(
	NAME = DE3_dat,
	FILENAME = 'D:\SUMMER2022\COM2034-SQL SEVER\DE3.dat',
	SIZE = 5,
	MAXSIZE = 50,
	FILEGROWTH = 5
)
LOG ON
(
	NAME = DE3_ldf,
	FILENAME = 'D:\SUMMER2022\COM2034-SQL SEVER\DE3.ldf',
	SIZE = 5MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
GO
USE DE3 
GO

CREATE TABLE KHACHHANG
(
	MaKh VARCHAR(3) PRIMARY KEY,
	HoTenKH NVARCHAR(30),
	DiaChi  NVARCHAR(30)
)
go
create table DONDATHANG
(
	SoDH varchar(4) primary key,
	NgayDat datetime,
	MaKh VARCHAR(3) ,
	constraint fk_kh foreign key(MaKh) references KHACHHANG(MaKh)
)
go
create table CT_DATHANG
(
	SoDH varchar(4),
	MaSP VARCHAR(5),
	SoLuong int,
	Dongia money
	constraint fk_dondathang foreign key(SoDH) references DONDATHANG(SoDH),
	primary key(SoDH,MaSP)
)
go

insert into KHACHHANG values 
('A01',N'Trần Thị Phương Trang',N'111 Nguyễn Trãi'),
('A02',N'Lê Thu Thủy',N'222 Lê Lợi'),
('A03',N'Trấn Quốc Thái',N'20 Trần Quốc Thảo'),
('A04',N'Đô Thị Mộng Thu',N'18 Lê Hồng Phong'),
('A05',N'Lê Ngô Minh Tâm',N'255 Trần Hưng Đạo')
GO
insert into DONDATHANG VALUES
('D001','2007-02-15','A01'),
('D002','2007-02-20','A02'),
('D003','2007-03-02','A01')
GO
insert into CT_DATHANG values
('D001','JAC02',1,1200000),
('D001','SMN01',2,180000),
('D001','VES01',1,700000),
('D002','QTY02',1,150000),
('D002','SMN02',2,180000)
GO

--1. Tạo View hiển thị toàn bộ thông tin của bảng KHACHHANG.
--Thực hiện thêm một khách hàng mới vài View vừa tạo.

CREATE VIEW CAU1 
AS SELECT * FROM KHACHHANG
GO
SELECT * FROM CAU1
INSERT INTO CAU1 VALUES ('A06',N'Lê Ngô Minh Toàn',N'123 Nam Kỳ Khởi Nghĩa')
GO
--2. Tạo View danh sách khách hàng đặt mua hàng vào tháng 02 năm 2007 gồm:
--Makh, Tên KH, Địa chỉ

CREATE VIEW CAU2 
AS
	SELECT KHACHHANG.MaKh,HoTenKH,DiaChi FROM KHACHHANG JOIN DONDATHANG ON DONDATHANG.MaKh = KHACHHANG.MaKh 
	WHERE YEAR(NgayDat) = 2007 and MONTH(NgayDat) = 2
GO
SELECT * FROM CAU2
GO

--3. Viết hàm tính số lần đặt hàng của khách hàng theo Makh

ALTER FUNCTION CAU3 (@MA VARCHAR(3))
RETURNS INT
AS
BEGIN
	RETURN ( SELECT COUNT(*) FROM KHACHHANG JOIN DONDATHANG ON DONDATHANG.MaKh = KHACHHANG.MaKh 
	WHERE KHACHHANG.MaKh = @MA GROUP BY KHACHHANG.MaKh)
END
GO
SELECT HoTenKH,dbo.CAU3(MaKh) FROM KHACHHANG 

--4. Tạo thủ tục hiển thị thông tin:
--Số ĐH, Ngày ĐH, Tên KH, Tổng số lần đặt hàng (dùng hàm viết ở câu 3),
--Tổng Thành Tiền. (Thành tiền = Số lượng * Đơn giá)
GO
CREATE PROC CAU4 
AS
	BEGIN
		SELECT DONDATHANG.SoDH,NgayDat,HoTenKH,dbo.CAU3(KHACHHANG.MaKh) AS 'TONG SL DAT HANG',(SoLuong*Dongia) AS 'THANH TIEN'
		FROM DONDATHANG JOIN CT_DATHANG ON DONDATHANG.SoDH = CT_DATHANG.SoDH
		JOIN KHACHHANG ON KHACHHANG.MaKh = DONDATHANG.MaKh 
		END
GO
EXECUTE CAU4

