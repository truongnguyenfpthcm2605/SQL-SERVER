﻿USE QLDA_PS24083_TRUONG
GO

--1.1 Nhập vào MaNV cho biết tuổi của nhân viên này.

CREATE FUNCTION TUOINHANVIEN (@MA NVARCHAR(9))
RETURNS INT
AS
BEGIN
	RETURN (SELECT YEAR(GETDATE()) - YEAR(NGSINH) AS N'TUỔI' FROM NHANVIEN WHERE MANV = @MA)
END
GO
PRINT N'TUÔI CỦA NHÂN VIÊN LÀ : ' + CONVERT(VARCHAR(3) , dbo.TUOINHANVIEN('001')) -- nv 001 -55tuoi
SELECT NHANVIEN.* , dbo.TUOINHANVIEN(MANV) AS TUOI FROM NHANVIEN
GO
-- 1.2  Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia

CREATE FUNCTION DEANNHANVIEN (@MA NVARCHAR(9))
RETURNS INT
AS
BEGIN
	RETURN  ( SELECT COUNT(MA_NVIEN) FROM PHANCONG  WHERE MA_NVIEN = @MA )
END
GO
PRINT N'SỐ LƯỢNG ĐỀ ÁN MÀ  NHÂN VIÊN NÀY THAM GIA LÀ : ' + CONVERT(VARCHAR(3) , dbo.DEANNHANVIEN('005'))
SELECT MANV,TENNV ,dbo.DEANNHANVIEN(MANV) AS 'SO LUONG NHAN VIEN THAM GIA' FROM NHANVIEN
GO

-- 1.3  Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái


CREATE FUNCTION SLGIOITINHNHANVIEN (@PHAI NVARCHAR(3))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(MANV) FROM NHANVIEN WHERE PHAI LIKE @PHAI)
END
GO
PRINT N'TÌM  NHÂN VIÊN THEO GIỚI TÍNH, SỐ LƯỢNG LÀ  : ' + CONVERT(VARCHAR(3) , dbo.SLGIOITINHNHANVIEN(N'Nam'))
SELECT  dbo.SLGIOITINHNHANVIEN(PHAI) FROM NHANVIEN GROUP BY PHAI
GO

-- MORE truyen tham so vao lam ma phong ban tinh so nv nam va nv nu cua phong ban do
CREATE FUNCTION SNVNU_NVNAM (@MAPB INT)
RETURNS @t TABLE(PHONG INT ,TONGNV INT,nam int, nu int)
AS
BEGIN
	INSERT INTO @T
	SELECT PHG, count(*) as 'tong nv',sum(IIF(PHAI=N'Nam',1,0)) as 'Nam',sum(IIF(PHAI=N'Nam',0,1)) as 'Nữ'
	FROM NHANVIEN WHERE PHG =@MAPB group BY PHG 
	RETURN
END
go
SELECT * FROM dbo.SNVNU_NVNAM(1)



-- 1.4  Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
-- họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
GO
ALTER FUNCTION LUONGTBCUPHONG (@TEN NVARCHAR(15))
RETURNS @TB TABLE
(HO NVARCHAR(15), LOT NVARCHAR(15), TEN NVARCHAR(15), LUONG FLOAT)
AS 
BEGIN
	DECLARE @LUONGTB FLOAT 
	SET @LUONGTB =  (SELECT  AVG(LUONG) FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG WHERE TENPHG = @TEN)
	INSERT INTO @TB 
	SELECT HONV,TENLOT,TENNV, LUONG FROM  NHANVIEN 
	WHERE LUONG >   @LUONGTB
	 RETURN
END
GO
SELECT * FROM dbo.LUONGTBCUPHONG(N'Điều Hành')
SELECT * FROM NHANVIEN
GO
-- 2.1  Hiển thị thông tin HoNV, TenNV, TenPHG, DiaDiemPhg.
GO
CREATE VIEW INFROR_NV_PB
AS
	SELECT HONV,TENNV, TENPHG, DIADIEM  FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
	JOIN DIADIEM_PHG ON PHONGBAN.MAPHG = DIADIEM_PHG.MAPHG
GO
SELECT * FROM INFROR_NV_PB
GO

-- 2.2 Hiển thị thông tin TenNv, Lương, Tuổi.
GO
CREATE VIEW TENV_LUONG_TUOI
AS
 SELECT TENNV, LUONG, YEAR(GETDATE())- YEAR(NGSINH) AS N'TUÔI' FROM NHANVIEN 

 GO
SELECT * FROM TENV_LUONG_TUOI

-- 2.3  Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất


GO
CREATE VIEW TRUONGPHONGLN
AS  
	SELECT  TENPHG, TP.HONV +TP.TENLOT+ TP.TENNV AS 'LEADER' FROM NHANVIEN NV JOIN PHONGBAN PB  ON NV.PHG = PB.MAPHG JOIN
	NHANVIEN TP ON TP.MANV = PB.TRPHG GROUP BY MAPHG, TENPHG, TP.HONV,TP.TENLOT, TP.TENNV HAVING COUNT(NV.MANV) >= ALL
	(SELECT COUNT(MANV) FROM NHANVIEN  GROUP BY PHG)
GO
SELECT *  FROM TRUONGPHONGLN

-- 3.1  Tạo View hiển thị thông tin MaNV, HoTenNV, TenPHG, Tổng thời gian tham gia vào
-- các dự án.
go
CREATE VIEW BAI3_1
AS
	SELECT MANV, HONV+ TENLOT + TENNV AS 'FULLNAME EMPLOYEE',TENPHG , SUM(THOIGIAN) AS 'FULL TIME' FROM NHANVIEN NV 
	JOIN PHONGBAN PB ON PB.MAPHG = NV.PHG
	JOIN PHANCONG PC ON PC.MA_NVIEN = NV.MANV
	GROUP BY MANV, HONV, TENLOT , TENNV,TENPHG 
go
SELECT * FROM BAI3_1

-- 3.2  Tạo View cho phép cập nhật thông tin DeAn, gồm: MaDA, TenDA, DDIEM_DA,PHONG.
GO
CREATE VIEW UPDATEINFOR 
AS
	SELECT MADA,TENDA,DDIEM_DA, PHONG FROM DEAN 
	WHERE MADA = 1
GO
SELECT * FROM  UPDATEINFOR
-- UPDATE VIEW NHU 1 TABLE
UPDATE UPDATEINFOR
SET  TENDA = N'CÔ NGA'
-- Thực hiện thêm 1 đề án mới vào View vừa tạo.
INSERT INTO UPDATEINFOR(TENDA,MADA,DDIEM_DA,PHONG)
VALUES (N'HONDA',90,N'ĐỒNG THÁP',1)
SELECT * FROM DEAN
SELECT * FROM PHONGBAN
GO
-- 3.3 Viết hàm cho nhập vào MaDA, tính tổng thời gian làm việc của các nhân nhiên tham gia đề án đó.
CREATE FUNCTION TIMEDEAN(@MA INT)
RETURNS INT
AS
	BEGIN
		RETURN (SELECT SUM(THOIGIAN) FROM PHANCONG JOIN NHANVIEN ON NHANVIEN.MANV = PHANCONG.MA_NVIEN WHERE MADA = @MA)
	END
GO
PRINT N'TONG THOI GIAN CUA CAC NHAN VIEN LAM VIEC TRONG DE AN LA  : ' + CONVERT(VARCHAR(3) , dbo.TIMEDEAN(1))

-- 3.4  Viết hàm cho nhập vào MaDA, đếm số nhân nhiên tham gia đề án đó.
go
CREATE FUNCTION DIEMSLNV(@MA INT)
RETURNS INT
AS
	BEGIN
	RETURN (SELECT COUNT(MA_NVIEN) FROM PHANCONG JOIN NHANVIEN ON NHANVIEN.MANV = PHANCONG.MA_NVIEN WHERE MADA = @MA)
	END
go	
PRINT N'TONG  NHAN VIEN THAM GIA TRONG DE AN LA  : ' + CONVERT(VARCHAR(3) , dbo.DIEMSLNV(1))

-- 3.5 Viết truy vấn hiển thị thông tin: MaDA, TenDA, TenPB chủ trì, số nhân viên tham gia đề
 --án, Tổng thời gian tham gia. (sử dụng 2 hàm đã tạo ở câu trên)
 GO
 CREATE FUNCTION TONGHOP(@MA INT)
 RETURNS @T TABLE
 (MADA INT,TEN NVARCHAR(15),TENPHONG NVARCHAR(15), TONGTHOIGIAN INT,TONGNHANVIEN INT)
 AS
 BEGIN
 INSERT INTO @T
SELECT MADA,TENDA,TENPHG, dbo.TIMEDEAN(@MA) AS 'TONG THOI GIAN',dbo.DIEMSLNV(@MA) AS 'TONG NV' 
FROM DEAN JOIN PHONGBAN ON PHONGBAN.MAPHG = DEAN.PHONG 
WHERE MADA = @MA
	RETURN
	
 END
 GO

 SELECT * FROM DBO.TONGHOP(1)