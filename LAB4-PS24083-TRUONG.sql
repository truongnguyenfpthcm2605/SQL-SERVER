--1.1 Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là
--TenNV, cột thứ 2 nhận giá trị
--o “TangLuong” nếu lương hiện tại của nhân viên nhỏ hơn trung bình lương trong
--phòng mà nhân viên đó đang làm việc.
--o “KhongTangLuong “nếu lương hiện tại của nhân viên lớn hơn trung bình lương
--trong phòng mà nhân viên đó đang làm việc.
DECLARE @LUONGTB TABLE (PHONG INT, LUONGTB FLOAT)
INSERT INTO @LUONGTB
SELECT PHG , AVG(LUONG) AS LUONGTB
FROM NHANVIEN GROUP BY PHG
-- DUNG IIF
SELECT  TENNV , LUONG,LUONGTB, PHG ,IIF(LUONG>=LUONGTB, 'K TANG LUONG','TANG LUONG')
as 'tang luong'
FROM NHANVIEN nv  JOIN @LUONGTB TB  ON nv.PHG = TB.PHONG

-- DUNG CASE
SELECT  TENNV , LUONG,LUONGTB, PHG,'XET TANG LUONG ' = 
case 
when luong>=luongtb then 'KHONG TANG'
else 'TANG'
end 
from nhanvien nv  JOIN @LUONGTB TB  ON nv.PHG = TB.PHONG

-- 1.2 Viết chương trình phân loại nhân viên dựa vào mức lương.
-- Nếu lương nhân viên nhỏ hơn luong trung bình cua phong  mà nhân viên đó đang làm việc thì
--xếp loại “nhanvien”, ngược lại xếp loại “truongphong”

DECLARE @AVGLUONG TABLE (PHG INT,LUONGTB FLOAT)
INSERT INTO @AVGLUONG
SELECT PHG,AVG(LUONG) FROM NHANVIEN GROUP BY PHG
 -- IIF
SELECT TENNV ,NV.PHG, LUONG, LUONGTB,
IIF(LUONG<LUONGTB ,'NHAN VIEN','TRUONG PHONG') AS 'CHUC VU'
FROM NHANVIEN NV JOIN @AVGLUONG AV ON AV.PHG = NV.PHG

-- CASE
SELECT TENNV ,NV.PHG, LUONG, LUONGTB,
'CHUC VU ' = CASE 
WHEN LUONG<LUONGTB THEN 'NHANVIEN'
ELSE 'TRUONG PHONG'
END
FROM NHANVIEN NV JOIN @AVGLUONG AV ON AV.PHG = NV.PHG

-- 1.3 .Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
-- IIF
SELECT IIF(PHAI = N'Nam','Mr.'+TENNV,IIF(PHAI = N'Nữ','Ms.'+TENNV,'KHONGBIET'+TENNV)) AS 'GENDER'
FROM NHANVIEN
-- CASE 
SELECT 'GENDER' = CASE
WHEN PHAI = N'Nam' THEN 'Mr.'+TENNV
WHEN PHAI = N'Nữ' THEN 'Ms.'+TENNV
ELSE 'KHONGBIET'+TENNV
END
FROM NHANVIEN
--1.4 Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
-- 0<luong<25000 thì đóng 10% tiền lương
-- 25000<luong<30000 thì đóng 12% tiền lương
-- 30000<luong<40000 thì đóng 15% tiền lương
-- 40000<luong<50000 thì đóng 20% tiền lương
-- Luong>50000 đóng 25% tiền lương


-- IIF
SELECT 
TENNV,LUONG,
IIF(LUONG<25000,LUONG*0.1,
IIF(LUONG<30000,LUONG*0.12,
IIF(LUONG<40000,LUONG*0.15,
IIF(LUONG<50000,LUONG*0.2,LUONG*0.25)))) AS N'THUẾ' 
FROM NHANVIEN

-- CASE
SELECT
TENNV,LUONG,N'THUẾ' = CASE
WHEN LUONG<25000 THEN LUONG*0.1
WHEN LUONG<30000 THEN LUONG*0.12
 WHEN LUONG<40000 THEN LUONG*0.15
 WHEN LUONG<50000 THEN LUONG*0.2
 ELSE LUONG*0.25
END
FROM NHANVIEN

-- 2.1 Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
 --2.2 Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng
 --không tính nhân viên có MaNV là 4.
DECLARE @DIEM INT ,@I INT =2
SET @DIEM = (SELECT COUNT(*) FROM NHANVIEN)
WHILE(@I<@DIEM)
BEGIN
	IF @I =4
	BEGIN 
	SET @I=@I+2
	CONTINUE
	END
	SELECT HONV,TENLOT,TENNV ,MANV FROM NHANVIEN
	WHERE CAST(MANV AS INT)= @I 
	SET @I = @I+2
END

-- 3.1 Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
-- Nhận thông báo “Thêm dữ liệu thành công” từ khối Try
-- Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Thêm dữ liệu thất bại”
--từ khối Catch



BEGIN TRY
INSERT INTO PHONGBAN VALUES 
(101,'d','001','01/01/2022')
PRINT N'THÊM THÀNH CÔNG'
END TRY
BEGIN CATCH 
DECLARE @MSG VARCHAR(100)
 SET @MSG = CASE ERROR_NUMBER()
 WHEN 2627 THEN 'TRUNG KHOA CHINH' -- KHOA CHINH TRUNG , 
 WHEN 547 THEN 'MA TRUONG PHONG KHONG CO' -- MA KHONG TON TAI KHOA CHINH , MA KHOA NGOAI NHAP
 WHEN 515 THEN 'DU LIEU CHUA NHAP DU' -- NULL
 when 245 then N'TỪ TEXT -> NUMBER FAIL'
 ELSE 'LOI '+  CAST(ERROR_NUMBER() AS CHAR) 
 END
 print @MSG
 RAISERROR(@MSG,15,1) -- 1 trang thai loi,level 15
END CATCH
 -- 3.2 Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng
-- RAISERROR để thông báo lỗi.
DECLARE @CHIA INT =5
BEGIN TRY 
 SET @CHIA = @CHIA/0
 PRINT 'THANH CONG'
END TRY 
BEGIN CATCH 
	DECLARE @LOI VARCHAR(100) , @SEVERITY INT , @STATES INT
	SET @LOI = ERROR_MESSAGE()
	SET @SEVERITY = ERROR_SEVERITY()
	SET @STATES = ERROR_STATE()
	PRINT 'LOI' + CAST(ERROR_NUMBER() AS VARCHAR)
	RAISERROR(@LOI,@SEVERITY,@STATES)	
END CATCH 


-- 4.1  Viết chương trình thêm một nhân viên mới. Nếu thêm nhân viên thành công thì thêm 1
 --thân nhân cho nhân viên vừa tạo.
 BEGIN TRAN
 BEGIN TRY
 INSERT INTO NHANVIEN VALUES 
 (N'Nguyễn',N'Văn',N'Trường',23,'2001-05-26',N'Đồng Tháp',N'Nam',50000,N'005',5)
 INSERT INTO THANNHAN VALUES
 (23,N'Nhựt',N'Nam','1994-08-07','Anh Em')
 COMMIT
 PRINT 'SUCCESFULL' 
 END TRY
 BEGIN CATCH 
 ROLLBACK
 DECLARE @LOI2 NVARCHAR(200)
 SET @LOI2 = N'LỖI' + CAST(ERROR_MESSAGE() AS NVARCHAR)
 RAISERROR(@LOI2,16,1)
 END CATCH

 -- 4.2 Viết chương trình thêm một công việc mới cho đề án số 1, đồng thời phân công nhân viên
-- mói thêm ở câu trên đảm nhận công việc mới tạo.
BEGIN TRAN
BEGIN TRY
	INSERT INTO CONGVIEC VALUES
	(1,3,N'KINH DOANH')
	INSERT INTO PHANCONG VALUES 
	(N'23','5',2,10)
COMMIT
PRINT N'THÊM THÀNH CÔNG'
END TRY
BEGIN CATCH 
 ROLLBACK
DECLARE @MES VARCHAR(100) ,@SEVERITY1 INT , @STATE INT, @NUMBER VARCHAR(30)
	SET @MES = ERROR_MESSAGE()
	SET @SEVERITY1 = ERROR_SEVERITY()
	SET @STATE = ERROR_STATE()
	SET @NUMBER = ERROR_NUMBER()
	PRINT 'LOI' + CONVERT(VARCHAR, @NUMBER)
RAISERROR(@MES,@SEVERITY1,@STATE)
END CATCH



