USE com2034_IT1730_DoanHuynhDuyCuong_ASM
--Bài 1 Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp.
		--o SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG

IF OBJECT_ID('SP_NGUOIDUNG') IS NOT NULL
	DROP PROCEDURE SP_NGUOIDUNG
go
create PROCEDURE SP_NGUOIDUNG @MANGUOIDUNG VARCHAR(4),@TENNGUOIDUNG NVARCHAR(40),@GIOITINH BIT,@DT VARCHAR(12),@DIACHI NVARCHAR(50),@EMAIL VARCHAR(50),@NGAYSNH DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO NGUOIDUNG 
		VALUES (@MANGUOIDUNG,@TENNGUOIDUNG,@GIOITINH,@DT,@DIACHI,@EMAIL,@NGAYSNH)
		print N'Thêm thành công'
	END TRY
	BEGIN CATCH
		PRINT N'Thêm thất bại'
		print	case error_number()
					when 2627 then N'Trùng khóa chính'
					when 515 then N'Rỗng'
					else 'Lỗi '+ error_message()
				end
	END CATCH
END
SELECT * FROM NGUOIDUNG
EXECUTE SP_NGUOIDUNG '0020',N'Cương đẹp trai',1,'09876543219',N'Trường Thọ, Thủ Đức,HCM','cuongdeptrai@gmail.com','01/16/2003'

		--Câu 2 o SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO
IF OBJECT_ID('SP_NHATRO') IS NOT NULL
	DROP PROCEDURE SP_NHATRO
go
CREATE PROCEDURE SP_NHATRO @MANHATRO VARCHAR(4),@MALOAINHA VARCHAR(3),@NGUOILIENHE VARCHAR(4),@DIENTICH FLOAT,@GIAPHONG MONEY,@DIACHI NVARCHAR(50),@THONGTINNHATRO NVARCHAR(60),@NGAYDANG DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO NHATRO
		VALUES (@MANHATRO,@MALOAINHA,@NGUOILIENHE,@DIENTICH,@GIAPHONG,@DIACHI,@THONGTINNHATRO,@NGAYDANG)
		print N'SUCCESS'
	END TRY
	BEGIN CATCH
		PRINT N'Thêm thất bại'
		print	case error_number()
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Khóa ngoại'
					when 515 then N'Rỗng'
					else N'Lỗi '+ error_message()
				end
	END CATCH
END
EXECUTE SP_NHATRO @NGAYDANG='',@NGUOILIENHE='0020',@DIENTICH=26.6,@GIAPHONG=2100000,@DIACHI=N'Quang Trung,Quận 12',@THONGTINNHATRO=N'Bao xin,Max đẹp,Đẳng cấp châu Á',@MANHATRO='N020',@MALOAINHA='003'

	--Câu 3 o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA
IF OBJECT_ID('SP_DANHGIA') IS NOT NULL
	DROP PROCEDURE SP_DANHGIA
go
CREATE PROCEDURE SP_DANHGIA @NGUOIDANHGIA VARCHAR(4),@MANHATRO VARCHAR(4),@NOIDUNGDANHGIA NVARCHAR(50),@DANHGIA NVARCHAR(20) = null
AS
BEGIN
	BEGIN TRY
		INSERT INTO DANHGIA
		VALUES (@NGUOIDANHGIA,@MANHATRO,@NOIDUNGDANHGIA,@DANHGIA)
		print N'SUCCESS'
	END TRY
	BEGIN CATCH
		PRINT N'Thêm thất bại'
		print	case error_number()
					when 2627 then N'Trùng khóa chính'
					when 547 then N'Khóa ngoại'
					when 515 then N'Rỗng'
					else N'Lỗi '+ error_message()
				end
	END CATCH
END

EXECUTE SP_DANHGIA @NGUOIDANHGIA='0020',@MANHATRO='N006',@NOIDUNGDANHGIA=N'Amazing gút chóp',@DANHGIA = N'Tuyệt'



--BÀI 2
	--Câu 1 Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng tin, khoảng giá tiền, loại hình nhà trọ. SP này trả về thông tin các phòng trọ, gồm các cột có định dạng sau:
		--o Cột thứ nhất: có định dạng ‘Cho thuê phòng trọ tại’ + <Địa chỉ phòng trọ> + <Tên quận/Huyện>
		--o Cột thứ hai: Hiển thị diện tích phòng trọ dưới định dạng số theo chuẩn Việt Nam + m2. Ví dụ 30,5 m2
		--o Cột thứ ba: Hiển thị thông tin giá phòng dưới định dạng số theo định dạng chuẩn Việt Nam. Ví dụ 1.700.000
		--o Cột thứ tư: Hiển thị thông tin mô tả của phòng trọ
		--o Cột thứ năm: Hiển thị ngày đăng tin dưới định dạng chuẩn Việt Nam. Ví dụ: 27-02-2012
		--o Cột thứ sáu: Hiển thị thông tin người liên hệ dưới định dạng sau:
			-- Nếu giới tính là Nam. Hiển thị: A. + tên người liên hệ. Ví dụ A. Thắng
			-- Nếu giới tính là Nữ. Hiển thị: C. + tên người liên hệ. Ví dụ C. Lan
		--o Cột thứ bảy: Số điện thoại liên hệ
		--o Cột thứ tám: Địa chỉ người liên hệ
	-- Viết hai lời gọi cho SP này
IF OBJECT_ID('SD_SPBAI2_CAU1') IS NOT NULL
DROP PROCEDURE SD_SPBAI2_CAU1
GO 
CREATE PROCEDURE SD_SPBAI2_CAU1 @QUAN NVARCHAR(10),@DTMIN FLOAT = NULL,@DTMAX FLOAT = NULL,
								@MONEYMIN MONEY = NULL,@MONEYMAX MONEY = NULL,
								@NGDANGMIN DATE = NULL,@NGDANGMAX DATE = NULL,
								@LOAINHATRO NVARCHAR(20)
AS
BEGIN
	IF @DTMIN IS NULL SELECT @DTMIN =  MIN(DIENTICH) FROM NHATRO 
	IF @DTMAX IS NULL SELECT @DTMAX =  MAX(DIENTICH) FROM NHATRO
	IF @MONEYMIN IS NULL SELECT @MONEYMIN =  MIN(GIAPHONG) FROM NHATRO 
	IF @MONEYMAX IS NULL SELECT @MONEYMAX =  MAX(GIAPHONG) FROM NHATRO
	IF @NGDANGMIN IS NULL SELECT @NGDANGMIN =  MIN(NGAYDANG) FROM NHATRO 
	IF @NGDANGMAX IS NULL SELECT @NGDANGMAX =  MAX(NGAYDANG) FROM NHATRO
	DECLARE @MALOAINHA VARCHAR(3) = (SELECT MALOAI FROM LOAINHA WHERE TENLOAINHA = @LOAINHATRO)
	DECLARE @AO TABLE(MANHATRO VARCHAR(4),MALOAINHA VARCHAR(3),NGUOILIENHE VARCHAR(4),DIENTICH FLOAT,GIAPHONG MONEY,DIACHI NVARCHAR(50),THONGTINNHATRO NVARCHAR(50),NGDANG DATE)
	INSERT INTO @AO 
		SELECT * FROM NHATRO WHERE DIACHI LIKE  '%'+@QUAN+'%'
								AND DIENTICH>=@DTMIN AND DIENTICH<=@DTMAX
								AND GIAPHONG>=@MONEYMIN AND GIAPHONG<=@MONEYMAX
								AND NGAYDANG>=@NGDANGMIN AND NGAYDANG<=@NGDANGMAX
								AND MALOAINHA = @MALOAINHA
	IF EXISTS (SELECT * FROM @AO)
		BEGIN
			SELECT N'Cho thuê phòng  trọ tại : '+NT.DIACHI as N'Vị trí',
			format(DIENTICH,'0.0')+'m2' as N'Diện tích',
			FORMAT(GIAPHONG,'#,##0') as N'Giá phòng',
			THONGTINNHATRO,
			CONVERT(VARCHAR,NGDANG,105) AS N'Ngày đăng tin',
			N'Người liên hệ' = IIF(GIOITINH=1,'A. ','C.') + TENNGUOIDUNG,
			DIENTHOAI,ND.DIACHI
			FROM @AO NT join NGUOIDUNG ND on NT.NGUOILIENHE = ND.MANGUOIDUNG
			PRINT N'IN thành công'
		END
	else
		PRINT N'In thất bại'	
END
EXECUTE SD_SPBAI2_CAU1 @QUAN=N'Quận 12',@DTMIN=20,@DTMAX=28,@MONEYMIN=2000000,
@LOAINHATRO = N'Chung cư'


--Câu b Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.
select * from NGUOIDUNG
GO
CREATE FUNCTION CAU2_B(@DIENTHOAI VARCHAR(12),@EMAIL VARCHAR(50),@NGAYSINH DATE) 
RETURNS TABLE
AS
	RETURN (SELECT MANGUOIDUNG FROM NGUOIDUNG 
			WHERE DIENTHOAI = @DIENTHOAI
					OR	EMAIL = @EMAIL OR @NGAYSINH = NGAYSINH)
GO
SELECT * FROM DBO.CAU2_B('0936249840','123','10/10/2003')
	--Câu c Viết hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO). Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.

GO
alter FUNCTION LIKE_DISLIKE(@MA VARCHAR(4)) 
RETURNS @TONG_LIKE_DISLIKE 
TABLE(Ma varchar(4),Tong tinyint,TongLike tinyint,TongDislike tinyint)
as
begin
	insert into @TONG_LIKE_DISLIKE
	select MANHATRO,count(*),sum(iif(DANHGIA = 'LIKE',1,0)),
		sum(iif(DANHGIA = 'LIKE',0,1)) 
	from DANHGIA where MANHATRO = @MA group by MANHATRO
	return
end
GO
select * from DBO.LIKE_DISLIKE('N006')
--thu
go
create FUNCTION LIKE_DISLIKE7(@MA VARCHAR(4)) 
RETURNS
TABLE
as
	return (select MANHATRO,count(*) as 'Tong',sum(iif(DANHGIA = 'LIKE',1,0)) as 'Tonglike',
				sum(iif(DANHGIA = 'LIKE',0,1)) as 'tongdislike'
			from DANHGIA where MANHATRO = @MA group by MANHATRO)
go
select * from DBO.LIKE_DISLIKE7('N006')

	--Câu d Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm các thông tin sau:
		-- Diện tích
		--- Giá
		-- Mô tả
		-- Ngày đăng tin
		-- Tên người liên hệ
		-- Địa chỉ
		-- Điện thoại
		-- Email
	--CÁCH 1
GO
CREATE VIEW BAI2_CAUD
AS
	SELECT MANHATRO,DIENTICH,GIAPHONG,THONGTINNHATRO,NGAYDANG,TENNGUOIDUNG,ND.DIACHI,DIENTHOAI,EMAIL
	FROM NHATRO NT JOIN NGUOIDUNG ND ON NT.NGUOILIENHE = ND.MANGUOIDUNG
	WHERE MANHATRO IN (SELECT Ma FROM LIKE_DISLIKE_2() 
					WHERE TongLike >= (SELECT MIN(TongLike) FROM (SELECT TOP(10) TongLike FROM LIKE_DISLIKE_2() ORDER BY TongLike DESC) AS B))
GO
SELECT * FROM BAI2_CAUD

	--CÁCH 2
GO
ALTER VIEW BAI2_CAUD_CACH2
AS
	SELECT MANHATRO,DIENTICH,GIAPHONG,THONGTINNHATRO,NGAYDANG,TENNGUOIDUNG,ND.DIACHI,DIENTHOAI,EMAIL
	FROM NHATRO NT JOIN NGUOIDUNG ND ON NT.NGUOILIENHE = ND.MANGUOIDUNG
	WHERE MANHATRO IN (SELECT TOP(10) with ties Ma FROM LIKE_DISLIKE_2() ORDER BY TongLike DESC)
GO
SELECT * FROM BAI2_CAUD_CACH2

	--CÁCH 3 K XÀI HÀM
GO
alter VIEW BAI2_CAUD_CACH3
AS
	SELECT MANHATRO,DIENTICH,GIAPHONG,THONGTINNHATRO,NGAYDANG,TENNGUOIDUNG,ND.DIACHI,DIENTHOAI,EMAIL
	FROM NHATRO NT JOIN NGUOIDUNG ND ON NT.NGUOILIENHE = ND.MANGUOIDUNG
	WHERE MANHATRO IN (SELECT TOP(10) with ties MANHATRO FROM DANHGIA GROUP BY MANHATRO ORDER BY SUM(IIF(DANHGIA = 'LIKE',1,0))  DESC)
GO
SELECT * FROM BAI2_CAUD_CACH3
	
	--CÁCH 4
GO
CREATE VIEW BAI2_CAUD_CACH4
AS
	SELECT top(10) NT.MANHATRO,DIENTICH,GIAPHONG,THONGTINNHATRO,NGAYDANG,TENNGUOIDUNG,ND.DIACHI,DIENTHOAI,EMAIL,SUM(IIF(DANHGIA='LIKE',1,0)) AS 'TongLike'
	FROM NHATRO NT JOIN NGUOIDUNG ND ON NT.NGUOILIENHE = ND.MANGUOIDUNG
					JOIN DANHGIA DG ON DG.MANHATRO = NT.MANHATRO
	GROUP BY NT.MANHATRO,DIENTICH,GIAPHONG,THONGTINNHATRO,NGAYDANG,TENNGUOIDUNG,ND.DIACHI,DIENTHOAI,EMAIL
	ORDER BY TongLike desc
GO
select * from BAI2_CAUD_CACH4
	--Câu e Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau:
		--- Mã nhà trọ
		--- Tên người đánh giá
		--- Trạng thái LIKE hay DISLIKE
		--- Nội dung đánh giá
drop procedure if exists STATUS_NHATRO
go
CREATE PROCEDURE STATUS_NHATRO @MANHATRO VARCHAR(4)
AS
BEGIN
	IF EXISTS (SELECT * FROM NHATRO WHERE MANHATRO = @MANHATRO)
		select NT.MANHATRO,TENNGUOIDUNG,DG.DANHGIA,NOIDUNGDANHGIA 
		from NHATRO NT JOIN NGUOIDUNG ND ON NT.NGUOILIENHE = ND.MANGUOIDUNG 
		JOIN DANHGIA DG ON NT.MANHATRO = DG.MANHATRO 
		WHERE NT.MANHATRO = @MANHATRO
	ELSE
		PRINT N'Không có nhà trọ này'
END

EXECUTE STATUS_NHATRO 'N005'


--Bài 3
	--Câu 1 Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
	--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác xóa thực hiện không thành công.
-- TRIGGER
DROP TRIGGER IF EXISTS DELETE_NHATRO_DANHGIA
GO
CREATE TRIGGER DELETE_NHATRO_DANHGIA ON NHATRO INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM DANHGIA WHERE MANHATRO IN (SELECT MANHATRO FROM deleted)
	DELETE FROM NHATRO WHERE MANHATRO IN (SELECT MANHATRO FROM deleted)
END


		--cách 1
--PROCEDURE
DROP PROCEDURE IF EXISTS NHAN_THAMSO
GO
CREATE PROCEDURE NHAN_THAMSO @DISLIKE INT
AS
BEGIN
	DECLARE @AO TABLE (MANHATRO VARCHAR(4))
	INSERT INTO @AO
	SELECT MANHATRO FROM DANHGIA where DANHGIA LIKE 'Dislike' GROUP BY MANHATRO HAVING COUNT(*) > @DISLIKE
	DELETE FROM NHATRO WHERE MANHATRO IN (SELECT * FROM @AO)
END
EXECUTE NHAN_THAMSO 3
SELECT MANHATRO,COUNT(*) FROM DANHGIA GROUP BY MANHATRO
SELECT MANHATRO,COUNT(*) FROM DANHGIA where DANHGIA LIKE 'Dislike' GROUP BY MANHATRO
SELECT MANHATRO,COUNT(*) FROM DANHGIA where DANHGIA LIKE 'Dislike' GROUP BY MANHATRO HAVING COUNT(*) > 2

INSERT INTO DANHGIA VALUES
('0006','N006',N'Tệ',N'DISLIKE'),
('0008','N008',N'Tệ',N'DISLIKE'),
('0002','N008',N'Tệ',N'DISLIKE'),
('0002','N001',N'Tệ',N'DISLIKE'),
('0001','N001',N'Tệ',N'DISLIKE'),
('0006','N005',N'Tệ',N'DISLIKE'),
('0001','N002',N'Tệ',N'DISLIKE'),
('0006','N004',N'Tệ',N'DISLIKE'),
('0002','N004',N'Tệ',N'DISLIKE'),
('0006','N001',N'Tệ',N'DISLIKE')


		--Cách 2
DROP PROCEDURE IF EXISTS Bai3_Cau2_cach2
GO
CREATE PROCEDURE Bai3_Cau2_cach2 @DISLIKE INT
AS
BEGIN
	DECLARE @CO TABLE (MA VARCHAR(4))
	INSERT INTO @CO SELECT MANHATRO FROM DANHGIA GROUP BY MANHATRO
	DECLARE @DEM INT = (SELECT COUNT(*) FROM @CO)
	DECLARE @I INT = 1
	DECLARE @AO TABLE (MA VARCHAR(4))
	WHILE @I<=@DEM
		BEGIN
			INSERT INTO @AO
			SELECT MIN(MA) FROM @CO WHERE MA NOT IN (SELECT * FROM @AO)
			DECLARE @MAAO VARCHAR(4) = (select MAX(MA) from @AO)
			declare @LAYRAMA TABLE (MA VARCHAR(4))
			INSERT INTO @LAYRAMA
			SELECT Ma  FROM DBO.LIKE_DISLIKE(@MAAO) WHERE TongDislike > @DISLIKE
			SET @I = @I+1
		END
	DELETE FROM NHATRO WHERE MANHATRO IN (SELECT * FROM @LAYRAMA)
END
EXECUTE Bai3_Cau2_cach2 3

		--Cách 3
--FUNCTION
GO
alter FUNCTION LIKE_DISLIKE_2()
RETURNS @TONG_LIKE_DISLIKE TABLE(Ma varchar(4),Tong tinyint,TongLike tinyint,TongDislike tinyint)
as
begin
	insert into @TONG_LIKE_DISLIKE
	select MANHATRO,count(*),sum(iif(DANHGIA = 'LIKE',1,0)),sum(iif(DANHGIA = 'LIKE',0,1)) from DANHGIA  group by MANHATRO
	return
end
GO
select * from LIKE_DISLIKE_2()
--PROC
DROP PROCEDURE IF EXISTS BAI3_CAU2_CACH3
GO
CREATE PROCEDURE BAI3_CAU2_CACH3 @DISLIKE INT
AS
BEGIN
	DECLARE @BANGAO TABLE (MANHATRO VARCHAR(4))
	INSERT INTO @BANGAO SELECT Ma FROM LIKE_DISLIKE_2() WHERE TongDislike > @DISLIKE
	DELETE FROM NHATRO WHERE MANHATRO IN (SELECT * FROM @BANGAO)
END


	--Câu 2 Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào qua các tham số.
	--Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này.
	--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác xóa thực hiện không thành công.
GO
CREATE PROCEDURE NHAN_THAMSO_DATE @MINDATE DATE,@MAXDATE DATE
AS
BEGIN
	DECLARE @AO TABLE (MANHATRO VARCHAR(4))
	INSERT INTO @AO
	SELECT MANHATRO FROM NHATRO WHERE @MINDATE < NGAYDANG AND NGAYDANG < @MAXDATE
	DELETE FROM NHATRO WHERE MANHATRO IN (SELECT * FROM @AO)
END

EXECUTE NHAN_THAMSO_DATE '1899-12-12','1900-01-02'
select * from NHATRO 



--Bài 4
	--Câu 1 Tạo Trigger ràng buộc khi thêm, sửa thông tin nhà trọ phải thỏa mãn các điều kiện sau:
		--• Diện tích phòng >=8 (m2)
		--• Giá phòng >=0
GO
CREATE TRIGGER NHATRO_insert_update ON NHATRO FOR INSERT,UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM INSERTED WHERE DIENTICH<8)
		BEGIN
			PRINT N'Diện tích k dc bé hơn 8'
			rollback transaction
		END
	IF EXISTS (SELECT * FROM INSERTED WHERE GIAPHONG<0)
		BEGIN
			PRINT N'Giá phòng không dc bé hơn 0'
			rollback transaction
		END
END

insert into NHATRO values ('N032','002','0002',9,22222222,N'23 Quang Trung,Quận 12',N'Đẹp trong mơ','01/01/2022')


	--Câu 2 Tạo Trigger để khi xóa thông tin người dùng
		--• Nếu có các đánh giá của người dùng đó thì xóa cả đánh giá
		--• Nếu có thông tin liên hệ của người dùng đó trong nhà trọ thì sửa thông tin liên hệ sang người dùng khác hoặc để trống thông tin liên hệ
DROP TRIGGER IF EXISTS NOT_DELETE_NGUOIDUNG_0001
GO
CREATE TRIGGER NOT_DELETE_NGUOIDUNG_0001 ON NGUOIDUNG FOR UPDATE,DELETE
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted WHERE MANGUOIDUNG = '0001')
		BEGIN
			PRINT N'0001 quá đẹp trai nên không thể xóa end sửa'
			ROLLBACK TRANSACTION
		END
END


GO
create TRIGGER DELETE_DANHGIA_WHEN_DELETE_NGUOIDUNG ON NGUOIDUNG INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM DANHGIA WHERE NGUOIDANHGIA IN (SELECT MANGUOIDUNG FROM deleted)
	IF EXISTS (SELECT MANHATRO FROM NHATRO WHERE NGUOILIENHE IN (SELECT MANGUOIDUNG FROM deleted))
		BEGIN
			UPDATE NHATRO
			SET NGUOILIENHE = '0001'
			where NGUOILIENHE in (SELECT MANGUOIDUNG FROM deleted)
		END
	DELETE FROM NGUOIDUNG WHERE MANGUOIDUNG IN (SELECT MANGUOIDUNG FROM deleted)
END

delete from NGUOIDUNG where MANGUOIDUNG = '0100'
select * from NGUOIDUNG
select * from NHATRO
select * from DANHGIA

INSERT INTO NGUOIDUNG VALUES
('0100',N'Đoàn Huỳnh Duy Cương',1,'0936249840',N'Đường 12,p Trường Thọ,Thủ Đức','cuongdhdps25442@gmail.com','01/16/2003')
INSERT INTO NHATRO VALUES
('N023','002','0100',23,2600000,N'23 Quang Trung,Quận 12',N'Bao đẹp, bao xịn,full nội thất','05/20/2022')
INSERT INTO DANHGIA VALUES
('0100','N006',N'Ngon,Tuyệt',N'LIKE')


select * from LOAINHA
