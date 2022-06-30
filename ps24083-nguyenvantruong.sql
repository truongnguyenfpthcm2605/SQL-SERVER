

CREATE DATABASE QUANLYHANG
ON
(	
	NAME = QUANLYHANG_dat,
	FILENAME = 'D:\SUMMER2022\COM2034-SQL SEVER\QUANLYHANG.dat',
	SIZE = 5,
	MAXSIZE = 50,
	FILEGROWTH = 5
)
LOG ON
(
	NAME = QUANLYHANG_ldf,
	FILENAME = 'D:\SUMMER2022\COM2034-SQL SEVER\QUANLYHANG.ldf',
	SIZE = 5MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
GO

USE QUANLYHANG 
GO

CREATE TABLE LOAIHANG
(
	MaLoai varchar(5) primary key,
	TenLoai nvarchar(20) not null,
	GhiChu nvarchar(100)
)
go
CREATE TABLE HANGHOA
(
	
	MaHH varchar(5) primary key,
	TenHH nvarchar(50) NOT NULL,	
	SoLuong int,
	DonGia money,
	MaLoai varchar(5),
	constraint fk_LOAIHANG  FOREIGN KEY(MaLoai) REFERENCES LOAIHANG(MaLoai),

)
go

insert into LOAIHANG values
('SUA',N'Sữa',N'Thùng 40 hộp 180ml'),
('KEM',N'Kem',N'Hộp 1000ml'),
('GIAY',N'Giấy Hộp',N'Lốc 3 Hộp'),
('DUONG',N'Đường Kính Trắng',N'Thùng 20 gói 1kg')
go
insert into HANGHOA values
('DBHOA',N'Đường kính trắng Biên Hòa',50,20000,N'DUONG'),
('DBBON',N'Đường kính trắng Bòn BonTây Ninh',50,22000,N'DUONG'),
('KemVM',N'Kem hộp Vinamilk',120,65000,N'KEM'),
('SuaTH',N'Sữa TH True Milk',30,290000,N'SUA')
GO


--1. Viết Stored Procedure tìm kiếm thông tin hàng hóa theo MaLoai, hiển thị kết quả
--gồm: MaHH, TenHH, TenLoai, SoLuong, DonGia, GhiChu. 

CREATE PROC CAU1 @MA varchar(5)
AS
	BEGIN
		SELECT MaHH,TenHH,TenLoai,SoLuong,DonGia,GhiChu FROM HANGHOA JOIN LOAIHANG ON LOAIHANG.MaLoai = HANGHOA.MaLoai WHERE HANGHOA.MaLoai = @MA
	END
GO
EXECUTE CAU1 'DUONG'

--2. Viết hàm trả về DonGia trung bình theo Maloai được truyền qua tham số.
--Viết truy vấn hiển thị Đơn giá trung bình của từng loại hàng, thông tin gồm:
--Maloai, Tenloai, Ghichu, DongiaTB (dùng hàm mới tạo để tính)GOALTER FUNCTION CAU2(@MA varchar(5))RETURNS MONEYAS	BEGIN		RETURN (SELECT AVG(DonGia) FROM HANGHOA JOIN LOAIHANG ON LOAIHANG.MaLoai = HANGHOA.MaLoai WHERE LOAIHANG.MaLoai  =@MA)	ENDGOSELECT LOAIHANG.*,dbo.CAU2(MaLoai) as 'dongia tb' FROM LOAIHANG GO--3. Tạo View lấy tất cả các thông tin loại hàng hóa. CREATE VIEW CAU3 AS	SELECT * FROM LOAIHANGGOINSERT INTO CAU3 VALUES('NEW',N'NEW',N'NEW')--4Viết Triger để khi xóa Loại hàng, nếu đã có hàng hóa thuộc loại hàng đó thì không cho xóa loại hàng.
GO
CREATE TRIGGER CAU4 ON LOAIHANG INSTEAD OF DELETE
AS
BEGIN
	IF EXISTS (SELECT * FROM HANGHOA WHERE MALOAI IN (SELECT MALOAI FROM DELETED))
		BEGIN
			PRINT N'K XOA DC!'
			ROLLBACK TRANSACTION
		END
	ELSE
		DELETE FROM LOAIHANG WHERE MALOAI IN (SELECT MALOAI FROM DELETED)
END