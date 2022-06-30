-- 1.1 Chèn dữ liệu vào bảng NGUOIDUNG
USE QLPHONGTRO_PS24083_TRUONG
GO
--IF EXISTS  ADDDATANGUOIDUNG
--DROP PROC ADDDATANGUOIDUNG
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