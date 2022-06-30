USE QLDA_PS24083_TRUONG
GO


--1.1 In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.

ALTER PROCEDURE HELLO @TEN NVARCHAR(15) 
AS
	BEGIN
		PRINT N'XIN CHÀO ' + @TEN  
	END
EXECUTE HELLO N'TRƯỜNG'
GO
-- 1.2 Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.

ALTER PROCEDURE TONG @S1 FLOAT , @S2 FLOAT
AS
	BEGIN 
		DECLARE @SUM FLOAT
		SET @SUM = @S1 + @S2
		PRINT @SUM
	END
EXECUTE TONG 2,5
GO
--1.3 Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.

ALTER  PROCEDURE soN  @N INT
AS
BEGIN
	DECLARE @TOG INT =0,@I INT =1
	WHILE(@I <= @N)
	BEGIN
		IF(@I%2=0)
		SET @TOG+=@I
		SET @I+=1
	END
	PRINT 'TONG CAC SO CHAN LA : ' + CAST(@TOG AS CHAR)
END
EXECUTE soN 30
GO
-- 1.4 Nhập vào 2 số. In ra Eước chung lớn nhất của chúng:
ALTER PROCEDURE UCLN @S1 INT ,@S2 INT
AS 
BEGIN 
	DECLARE @UC INT =0
	IF(@S1 = 0 AND @S2 = 0)
	PRINT N'KHÔNG CÓ UCLN'
	IF(@S1 =0 OR @S2=0)
	BEGIN
	SET @UC = @S1 + @S2
	PRINT N'UCLN LA : ' + CAST(@UC AS CHAR)
	END
			IF(@S1 !=0 AND @S2!=0)
			BEGIN 
				WHILE(@S1!=@S2)
				BEGIN
					IF(@S1>@S2) SET @S1-=@S2
					
					ELSE SET @S2-=@S1
				END
				SET @UC = @S1
				PRINT N'UCLN LA : ' + CAST(@UC AS CHAR)
			END

END
EXECUTE UCLN 200 ,500
GO

-- 2.1  Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
CREATE PROCEDURE INFORNV @MA NVARCHAR(9)
AS 
BEGIN 
 IF EXISTS (SELECT MANV FROM NHANVIEN WHERE MANV = @MA)
 SELECT MANV,TENNV FROM NHANVIEN WHERE MANV = @MA
 ELSE
 PRINT 'KHÔNG CÓ MÃ NHAN VIÊN ĐÓ '
END
EXECUTE INFORNV '005'
GO

-- 2.2 Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
ALTER PROCEDURE SLTGDA @MAA  INT
AS
	BEGIN
		DECLARE @SLNV INT
			 IF EXISTS (SELECT MADA  FROM DEAN WHERE MADA = @MAA)
			 SELECT COUNT(MANV) AS 'AMOUT EMPLOYEE'  FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
			 JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG WHERE MADA = @MAA GROUP BY MADA
			 ELSE
			 PRINT N'KHÔNG CÓ NHÂN VIÊN CỦA PHONG ĐÓ'
	END
EXECUTE SLTGDA 10
GO

---- 2.3 Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham
--gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
CREATE PROCEDURE SLDD @MA INT , @DD NVARCHAR(45) 
	AS
		BEGIN 
		IF EXISTS (SELECT MADA , DDIEM_DA FROM DEAN WHERE MADA = @MA AND  DDIEM_DA= @DD)
		 SELECT COUNT(MANV) AS 'SLNV THAM GIA' FROM DEAN DE  JOIN PHONGBAN PB ON PB.MAPHG = DE.PHONG
		 JOIN NHANVIEN NV ON NV.PHG = PB.MAPHG
		WHERE MADA = @MA AND  DDIEM_DA= @DD GROUP BY MADA
		ELSE 
		PRINT N'KHÔNG CÓ NHÂN VIÊN NÀO THAM GIA DỰ ÁN Ở ĐỊA ĐIỂM ĐÓ'
	END
EXECUTE SLDD 20,N'TP HCM'
GO
-- 2.4 Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là
-- @Trphg và các nhân viên này không có thân nhân.
CREATE PROCEDURE TRUONGPHONG @TRP NVARCHAR(9) 
AS 
	BEGIN
		IF EXISTS (SELECT MANV FROM NHANVIEN NV JOIN PHONGBAN PB ON NV.MANV = PB.TRPHG WHERE TRPHG = @TRP)
		SELECT NV.HONV ,NV.TENLOT, NV.TENNV , NV.MANV
		FROM  NHANVIEN NV JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG 
		JOIN NHANVIEN TP ON TP.MANV = PB.TRPHG WHERE PB.TRPHG =@TRP GROUP BY NV.HONV ,NV.TENLOT, NV.TENNV , NV.MANV
		HAVING NV.MANV NOT IN (SELECT MA_NVIEN FROM THANNHAN)
		ELSE
		PRINT N'KHÔNG CÓ NHÂN VIÊN NHƯ TIÊU CHÍ BẠN MUỐN'
	END
EXECUTE TRUONGPHONG N'005'
GO
-- 2.5 Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có
-- mã @Mapb hay không
CREATE PROCEDURE THUOCPB @MANV NVARCHAR(9) , @MAPB INT
AS
	BEGIN
		IF EXISTS (SELECT MANV FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG WHERE MANV = @MANV AND MAPHG = @MAPB)
		PRINT N'CÓ MANV  : ' + CAST(@MANV AS NVARCHAR) + N' TRONG PHONG BAN CÓ MÃ : ' + CAST(@MAPB AS NVARCHAR)
		ELSE 
		PRINT N'KHÔNG CÓ MANV TRONG PHONG BAN ĐÓ'
	END
EXECUTE THUOCPB N'001' ,4
GO
-- 3.1 Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng
--tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
USE QLDA_PS24083_TRUONG
DROP PROC IF EXISTS ADDNEWPHONBAN
GO
CREATE PROCEDURE ADDNEWPHONBAN
		@MAPHG INT ,@TENPHG NVARCHAR(15),@TRPHG NVARCHAR(9),@NG_NHANCHUC DATE
AS
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT MAPHG FROM PHONGBAN WHERE MAPHG=@MAPHG)
		PRINT N'đã có phòng' + CAST(@MAPHG AS VARCHAR)

	ELSE
	BEGIN 
		INSERT INTO PHONGBAN(MAPHG,TENPHG,TRPHG,NG_NHANCHUC) VALUES
			(@MAPHG,@TENPHG,@TRPHG,@NG_NHANCHUC)
			PRINT N'ADD SUCCESSFUL';
	END
	END TRY
	BEGIN CATCH
		PRINT N'ADD FAIL'
		PRINT	CASE error_number() 
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Mã phòng trùng'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				END
	END CATCH
END
EXECUTE ADDNEWPHONBAN 1,N'CNTT','008','2022-05-09' -- FAIL
EXECUTE ADDNEWPHONBAN 6,N'CNTT','008','2022-05-09' -- SUCCESS
GO

-- 3.2 Cập nhật phòng ban có tên CNTT thành phòng IT.
ALTER PROCEDURE UPPB 
AS
BEGIN
	BEGIN TRY
	
	UPDATE PHONGBAN
	SET TENPHG = 'IT'
	WHERE TENPHG = 'CNTT'
	PRINT N'UPDATE SUCCESSFUL!' + CAST(@@ROWCOUNT AS VARCHAR ) + 'DUOC CAP NHAT'

	END TRY
	BEGIN CATCH
	PRINT N'UPDATE FAIL!'
		PRINT	CASE error_number() 
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Mã phòng trùng'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				END
	END CATCH
END
EXECUTE UPPB
GO

-- 3.3 Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
-- vào với điều kiện:
-- *nhân viên này trực thuộc phòng IT
-- *Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong<25000 thì nhân viên
-- này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản lý
-- *Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân viên
--nữ thì độ tuổi phải từ 18-60.

ALTER PROCEDURE ADDNEWNV @HO NVARCHAR(15) , @LOT NVARCHAR(15), @TEN NVARCHAR(15),
@MA NVARCHAR(9),@NS DATE, @DCHI NVARCHAR(30), @GTINH NVARCHAR(15),@LUONG FLOAT


AS 
BEGIN 
	DECLARE  @MAQL NVARCHAR(9) , @AGE INT,@PHONG INT
	BEGIN TRY 
				SELECT @PHONG = ( SELECT  MAPHG FROM PHONGBAN WHERE TENPHG = N'IT')
				IF(@LUONG < 2500 )
					SET @MAQL = N'009'
				ELSE 
					SET @MAQL = N'005'
				SELECT @AGE = YEAR(GETDATE()) - YEAR(@NS)
					IF(@GTINH = N'Nam' and @AGE < 18 OR @AGE > 65)
					BEGIN
						PRINT N'NAM PHẢI CÓ TUỔI TỪ 18 - 65'
						RETURN
					END
					ELSE IF(@GTINH = N'Nữ' and @AGE < 18 OR @AGE >60)
					BEGIN
						PRINT N'NỮ PHẢI CÓ TUỔI TỪ 18 - 60'
						RETURN
					END
					ELSE 
					BEGIN
				INSERT INTO NHANVIEN 
				VALUES
				(@HO,@LOT,@TEN,@MA,@NS,@DCHI,@GTINH,@LUONG)
				PRINT N'UPDATE SUCCESSFUL!'
				RETURN
				END
			
	END TRY
	BEGIN CATCH
	PRINT N'THÊM THẤT BẠI'
		PRINT	CASE error_number() 
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Mã phòng trùng'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				END
	END CATCH
END
EXECUTE ADDNEWNV N'Nguyễn',N'Văn',N'Hiếu',N'012','01/01/2001',N'123a',N'Nam',30000
GO
-- CHUA XU LY XONG

-- 4.1 Thêm một phân công công việc mới vào bảng phân công. tất cả giá trị đều truyền dưới
-- dạng tham số đầu vào. Có kiểm tra rỗng và các ràng buộc khóa chính, khóa ngoại.
CREATE PROCEDURE ADDNEWWORK @MADA INT,@STT INT,@TENWORK NVARCHAR(50)
AS
BEGIN
	BEGIN TRY
	INSERT INTO CONGVIEC VALUES 
	(@MADA,@STT,@TENWORK)
	PRINT N'UPDATE SUCCESSFUL!'

	END TRY
	BEGIN CATCH
	PRINT N'UPDATE FAIL!'
		PRINT	CASE error_number() 
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Mã phòng trùng'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				END
	END CATCH
END
EXECUTE ADDNEWWORK 001,5,N'LẬP TRÌNH'
GO
-- 4.2 Cập nhật thời gian làm việc của các công việc đã phân công của dự án số 10 thêm 4 giờ ở
 --những dòng dữ liệu chưa quá 30 giờ.
ALTER PROCEDURE UPDATEWORK @THOIGIAN FLOAT ,@MA INT
AS
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT * FROM CONGVIEC JOIN PHANCONG ON PHANCONG.MADA =CONGVIEC.MADA WHERE PHANCONG.MADA = @MA)
	BEGIN
	UPDATE PHANCONG
	SET THOIGIAN = THOIGIAN + @THOIGIAN
	WHERE THOIGIAN <= 30 AND MADA = @MA
	END
	PRINT 'UPDATE SUCCESSFULL!'	
	END TRY
	BEGIN CATCH
	PRINT N'UPDATE FAIL!'
		PRINT	CASE error_number() 
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Mã phòng trùng'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				END
	END CATCH
END
EXECUTE  UPDATEWORK 4,10
GO