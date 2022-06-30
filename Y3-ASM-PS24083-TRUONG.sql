-- 1. Thêm thông tin vào các bảng
-- 1.1 Chèn dữ liệu vào bảng NGUOIDUNG
USE QLPHONGTRO_PS24083_TRUONG
GO
--IF EXISTS  ADDDATANGUOIDUNG
--DROP PROC ADDDATANGUOIDUNG
go
CREATE PROC ADDDATANGUOIDUNG
@MA NVARCHAR(15) , @TEN NVARCHAR(30), @DCHI NVARCHAR(100), @GTINH BIT, @DT NVARCHAR(12),@NS DATE,@EMAIL NVARCHAR(30)
AS 
BEGIN 
	BEGIN TRY
		INSERT INTO NGUOIDUNG(MANGUOIDUNG,TENNGUOIDUNG,DCHIA,GIOITINH,DIENTHOAI,NGAYSINH,EMAIL)
		VALUES(@MA,@TEN,@DCHI,@GTINH,@DT,@NS,@EMAIL)
		PRINT N'THÊM THÀNH CÔNG'
	END TRY
	BEGIN CATCH
		PRINT N'THÊM THẤT BẠI'
			PRINT	CASE error_number() 
				when 2627 then N'Trùng khóa chính'
				when 547 then N'Mã phòng trùng'
				when 515 then N'Rỗng'
				else N'Lỗi '+ error_message()
			END
	END CATCH
END
go
EXECUTE ADDDATANGUOIDUNG N'ND011',N'Đỗ Văn Tài',N'Tháp Mười ,Đồng Tháp',1,N'03772434','1997-12-27','tai@gmail.com' -- successful
EXECUTE ADDDATANGUOIDUNG N'ND016',N'Đỗ Văn Thiện',N'Tháp Mười ,Đồng Tháp',1,N'03772434','1997-12-27','tai@gmail.com' -- fail
SELECT * FROM NGUOIDUNG
GO
-- 1.2 Chèn dữ liệu vào bảng NHATRO
CREATE PROC ADDDATANHATRO
@MA INT,@MOTA NVARCHAR(100) , @DCHI NVARCHAR(100), @GIA FLOAT,@DT FLOAT, @NGAY DATE, @NGLH NVARCHAR(15),
@TRTHAI NVARCHAR(20),@PHISH FLOAT,@LOAITRO INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO NHATRO(MANHATRO,MOTA,DCHIA,GIAPHONG,DIENTICH,NGAYDANG,NGLIENHE,TRANGTHAI,PHISINHHOAT,LOAITRO)
		VALUES (@MA,@MOTA,@DCHI,@GIA,@DT,@NGAY,@NGLH,@TRTHAI,@PHISH,@LOAITRO)
		PRINT N'THÊM THÀNH CÔNG'
	END TRY
	BEGIN CATCH
		PRINT N'THÊM THẤT BẠI'
			PRINT	CASE error_number() 
				when 2627 then N'Trùng khóa chính'
				when 547 then N'Mã phòng trùng'
				when 515 then N'Rỗng'
				else N'Lỗi '+ error_message()
			END
	END CATCH
END
EXECUTE ADDDATANHATRO 7777,N'Sạch Đẹp , rỗng rãi , có sân thượng view đẹp',N'123 Nam Kì Khởi Nghĩa , Quận 1 , TPHCM',9000,
70,'2022-06-01',N'ND008',N'Còn 3 Phòng Trống',1115,890 -- successful
EXECUTE ADDDATANHATRO 9996,N'Co Không gian rỗng rãi , thoái mát',N'Lê Văn Việt , Quân 9 , TPHCM',2800,
20,'2022-06-01',N'ND008',N'Còn 3 Phòng Trống',300,665 -- fail
GO
SELECT * FROM NHATRO 
SELECT * FROM LOAINHATRO
GO
CREATE PROC ADDDATADANHGIA @NGDG NVARCHAR(15),@NTRO INT , @DG NVARCHAR(15), @ND NVARCHAR(150)
AS
BEGIN
BEGIN TRY
		INSERT INTO DANHGIA(NGDANHGIA,NHATRO,DANHGIA,NOIDUNGDANHGIA)
		VALUES (@NGDG,@NTRO,@DG,@ND)
		PRINT N'THÊM THÀNH CÔNG'
	END TRY
	BEGIN CATCH
		PRINT N'THÊM THẤT BẠI'
			PRINT	CASE error_number() 
				when 2627 then N'Trùng khóa chính'
				when 547 then N'Mã phòng trùng'
				when 515 then N'Rỗng'
				else N'Lỗi '+ error_message()
			END
	END CATCH
END
EXECUTE ADDDATADANHGIA N'ND011',8999,1,N'Dịch vụ quá tốt, cho 5 sao luôn' -- successfull
EXECUTE ADDDATADANHGIA N'ND006',8499,0,N'Dịch vụ quá tốt, cho 5 sao luôn'-- fail
GO
SELECT * FROM DANHGIA
GO
-- 2.A  Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các
--phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
--tin, khoảng giá tiền, loại hình nhà trọ.

CREATE PROC ASMY3_2A @DCHIA NVARCHAR(100), @DTMIN FLOAT, @DTMAX FLOAT , @NGAYMIN DATE,@NGAYMAX DATE, @GIAMIN FLOAT,
@GIAMAX FLOAT,
@LOAINHATRO INT
AS
BEGIN
	BEGIN TRY
			SELECT 
			N'Cho thuê phòng trọ tai : ' + NHATRO.DCHIA , -- NVARCHAR
			FORMAT(DIENTICH,'0.0') + 'm2' as 'Dien tich ', -- VARCHAR
			FORMAT(GIAPHONG , '#,##0') as 'Gia Tien', -- VARCHAR
			MOTA,
			CONVERT(VARCHAR,NGAYDANG,105) as 'Ngay Dang',-- VARCHAR
			IIF(GIOITINH =1 ,
			'A.' + RIGHT(TENNGUOIDUNG,CHARINDEX(' ',REVERSE(TENNGUOIDUNG))-1),
			'C.' +RIGHT(TENNGUOIDUNG,CHARINDEX(' ',REVERSE(TENNGUOIDUNG))-1)),--NVARCHAR
			DIENTHOAI, -- VARCHAR
			NGUOIDUNG.DCHIA -- NVARCHAR
			FROM NHATRO JOIN NGUOIDUNG ON NHATRO.NGLIENHE = NGUOIDUNG.MANGUOIDUNG	
			WHERE NHATRO.DCHIA = @DCHIA AND DIENTICH BETWEEN @DTMIN AND @DTMAX AND
			NGAYDANG BETWEEN @NGAYMIN AND @NGAYMAX AND GIAPHONG BETWEEN @GIAMIN AND @GIAMAX AND LOAITRO = @LOAINHATRO
			PRINT N'CÓ' + CAST(@@ROWCOUNT AS VARCHAR) + N'THỎA YÊU CẦU'	
	END TRY
	BEGIN CATCH
	PRINT N'LOI'
		PRINT	CASE ERROR_NUMBER()
			when 2627 then N'Trùng khóa chính'
			when 547 then N'Mã phòng trùng'
			when 515 then N'Rỗng'
			else N'Lỗi '+ ERROR_MESSAGE()
		END
	END CATCH
END
EXECUTE ASMY3_2A N'N12, Khuc C , KCN Công Nghệ Cao, Quận 9 , TPHCM',10,80,'2010-03-01','2022-03-01',1000,3000,665
SELECT * FROM NHATRO
GO

-- 2.B. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.

CREATE FUNCTION ASMY3_2B
(@MAND NVARCHAR(15), @TENND NVARCHAR(30) , @DCHI NVARCHAR(100) ,@GIOITINH BIT,@DT NVARCHAR(12),@NS DATE,@EMAIL NVARCHAR(30))
RETURNS NVARCHAR(5)
AS
BEGIN
	RETURN (SELECT MANGUOIDUNG FROM NGUOIDUNG WHERE MANGUOIDUNG =@MAND AND TENNGUOIDUNG =@TENND AND DCHIA LIKE @DCHI AND DIENTHOAI =@DT AND NGAYSINH = @NS AND EMAIL = @EMAIL) 
END
PRINT N'MÃ NGƯỜI DÙNG LÀ : ' + dbo.ASMY3_2B(N'ND008',N'Nguyễn Văn Trường',N'%TPHCM',1,N'0377379249','2001-05-26',N'truongnvps24083@fpt.edu.vn')
select * from DANHGIA

-- 2.C c. Viết hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO).
  --Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.
go
CREATE FUNCTION ASMY3_2CC (@MA INT)
 RETURNS @T TABLE(LIKES INT , DISLIKE INT)
 AS
 BEGIN 
	DECLARE @L INT , @D INT
	SET @L = (SELECT COUNT(DANHGIA)  FROM NHATRO NT JOIN DANHGIA DG ON NT.MANHATRO = DG.NHATRO
	WHERE DANHGIA = 1 AND MANHATRO = @MA)
	SET @D = (SELECT COUNT(DANHGIA)  FROM NHATRO NT JOIN DANHGIA DG ON NT.MANHATRO = DG.NHATRO
	WHERE DANHGIA = 0 AND MANHATRO = @MA)
	INSERT  INTO @T VALUES (@L,@D) 
	RETURN
 END
 go
 SELECT * FROM DBO.ASMY3_2CC(8999)

 -- 2D .d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
--các thông tin sau:
--- Diện tích
--- Giá
--- Mô tả
--- Ngày đăng tin
--- Tên người liên hệ
--- Địa chỉ
--- Điện thoại
--- Email
GO
ALTER VIEW LUOTLIKE 
AS 
SELECT TOP(10) DIENTICH,GIAPHONG,MOTA,NGAYDANG, TENNGUOIDUNG,NHATRO.DCHIA,DIENTHOAI,EMAIL,COUNT(DANHGIA)  AS 'LUOT LIKE' FROM NHATRO JOIN NGUOIDUNG ON NGUOIDUNG.MANGUOIDUNG = NHATRO.NGLIENHE JOIN
DANHGIA ON DANHGIA.NHATRO = NHATRO.MANHATRO
WHERE DANHGIA = 1
GROUP BY MANHATRO, DIENTICH,GIAPHONG,MOTA,NGAYDANG, TENNGUOIDUNG,NHATRO.DCHIA,DIENTHOAI,EMAIL 
ORDER BY COUNT(DANHGIA) DESC 
WITH CHECK OPTION
go
SELECT * FROM LUOTLIKE


-- 2.E e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của
--bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau:
--- Mã nhà trọ
--- Tên người đánh giá
--- Trạng thái LIKE hay DISLIKE
--- Nội dung đánh giá



CREATE PROC ASMY3_2C @MANT INT
AS 
BEGIN
	SELECT NHATRO ,TENNGUOIDUNG, N'DANH GIA' = CASE  DANHGIA
	WHEN   1  THEN N'THÍCH'
	ELSE N'KHÔNG THÍCH'
	END
	,NOIDUNGDANHGIA  FROM DANHGIA JOIN NGUOIDUNG ON NGUOIDUNG.MANGUOIDUNG = DANHGIA.NGDANHGIA
	WHERE NHATRO = @MANT
END
EXECUTE ASMY3_2C 4545
SELECT  *FROM DANHGIA

 -- 3.1 
--  Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện
--thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng
--DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
--xóa thực hiện không thành công.

 CREATE PROC DLETEDISLIKE @DISLIKE INT
 AS

 BEGIN
	BEGIN TRY
		DECLARE @SLDLS TABLE(MA INT, DL INT)
		-- BANG CÓ MA NHA TRO VA LUOT DISLIKE LON HON DISLIKE NHAP VAO
		INSERT INTO @SLDLS
		SELECT MANHATRO , COUNT(DANHGIA) FROM NHATRO JOIN DANHGIA ON DANHGIA.NHATRO = NHATRO.MANHATRO WHERE DANHGIA =0 GROUP BY MANHATRO HAVING COUNT(DANHGIA) > @DISLIKE
			 BEGIN TRAN
				 DELETE FROM DANHGIA WHERE NHATRO IN (SELECT MA  FROM @SLDLS)
				 DELETE FROM NHATRO WHERE MANHATRO IN (SELECT MA  FROM @SLDLS)
				PRINT N'XÓA THÀNH CÔNG' + CAST(@@ROWCOUNT AS VARCHAR) + N'SỐ DÒNG THỰC HIỆN'
			COMMIT TRAN
	END TRY
	BEGIN CATCH 
	ROLLBACK TRAN
	 PRINT N'XÓA kHÔNG THÀNH CÔNG'
	PRINT N'lỖI' + ERROR_MESSAGE()
	END CATCH
 END

 EXECUTE DLETEDISLIKE 10
 select * from NHATRO
 -- 3.2. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện
--thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào 
--qua các tham số.

CREATE PROC ASMY3B @NGAYMIN DATE, @NGAYMAX DATE 
 AS
 BEGIN
	BEGIN TRAN
	BEGIN TRY
	
	IF EXISTS ( SELECT MANHATRO FROM NHATRO WHERE NGAYDANG BETWEEN @NGAYMIN AND @NGAYMAX)
		BEGIN
			DELETE FROM NHATRO WHERE  NGAYDANG BETWEEN @NGAYMIN AND @NGAYMAX
			PRINT N'XÓA THÀNH CÔNG' + CAST(@@ROWCOUNT AS VARCHAR) + N'SỐ DÒNG THỰC HIỆN'
		END
		ELSE
		PRINT N'KHÔNG XÓA ĐƯỢC , KHÔNG CÓ NHA TRỌ TRONG KHOẢNG THOI GIAN DO'
	COMMIT
	END TRY
	BEGIN CATCH 
	ROLLBACK
	PRINT N'lỖI' + ERROR_MESSAGE()
	END CATCH
 END
EXECUTE ASMY3B '2000-02-02', '2002-01-01' -- FAIL
GO
-- 4.1  1. Tạo Trigger ràng buộc khi thêm, sửa thông tin nhà trọ phải thỏa mãn các điều kiện sau:
--  Diện tích phòng >=8 (m2)
--  Giá phòng >=0

CREATE TRIGGER ASM4A ON NHATRO FOR UPDATE,INSERT
AS
BEGIN
	IF EXISTS (SELECT DIENTICH, GIAPHONG FROM inserted WHERE DIENTICH < 8 AND GIAPHONG < 0)
	PRINT N'DIỆN TÍCH PHẢI LỚN HƠN 8 VÀ GIÁ PHÒNG PHẢI LỚN HƠN 0'	
END
INSERT INTO NHATRO  VALUES
(99,N'Gần trung tâm thương mại',N'Điện Biên Phủ , Quận Bình Thạnh.TP HCM',-1,60,'2022-06-01',N'ND004',N'Còn 3 Phòng',5000,890)
select * from NHATRO
go


-- 4.2 2. Tạo Trigger để khi xóa thông tin người dùng
--• Nếu có các đánh giá của người dùng đó thì xóa cả đánh giá
--• Nếu có thông tin liên hệ của người dùng đó trong nhà trọ thì sửa thông tin liên hệ
--sang người dùng khác hoặc để trống thông tin liên hệ

ALTER TRIGGER ASM4B ON NGUOIDUNG INSTEAD OF DELETE
AS
BEGIN
	DECLARE @MA NVARCHAR(10)
		SET @MA = ( SELECT MANGUOIDUNG  FROM deleted)
		DELETE FROM DANHGIA WHERE NGDANHGIA = @MA
	IF EXISTS ( SELECT MANHATRO FROM NHATRO WHERE NGLIENHE = @MA)
	BEGIN
		UPDATE NHATRO SET NGLIENHE = N'ND001' WHERE MANHATRO = @MA
	END
	DELETE FROM NGUOIDUNG WHERE MANGUOIDUNG = @MA
	PRINT N'XÓA THÀNH CÔNG '
END
SELECT * FROM NHATRO 

SELECT * FROM NGUOIDUNG 
SELECT * FROM NHATRO
SELECT * FROM DANHGIA 

DELETE FROM NGUOIDUNG WHERE MANGUOIDUNG = N'ND009' -- ĐÃ XÓA

