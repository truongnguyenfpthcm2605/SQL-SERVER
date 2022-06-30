--2. 2. QUERY (TRUY VẤN)



--a. Cho biết chi tiết giao hàng của đơn đặt hàng DH01, hiển thị: tên hàng hóa, số lượng giao và
--đơn giá giao.
SELECT TenHH,SLGiao,DonGiaGiao 
FROM HANGHOA JOIN CHITIETGIAOHANG ON CHITIETGIAOHANG.MaHH = HANGHOA.MaHH JOIN PHIEUGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao WHERE PHIEUGIAOHANG.MaDat = 'DH01'



--b. Cho biết thông tin những đơn đặt hàng không được giao, hiển thị: mã đặt, ngày đặt, tên
--khách hàng.

SELECT MaDat,NgayDat,TenKH 
FROM DONDATHANG JOIN KHACHHANG ON KHACHHANG.MaKH = DONDATHANG.MaKH WHERE MaDat NOT IN (SELECT MaDat FROM PHIEUGIAOHANG)

--c. Cho biết hàng hóa nào có đơn giá hiện hành cao nhất, hiển thị: tên hàng hóa, đơn giá hiện
--hành.

SELECT TOP 1 With ties TenHH,DonGiaHH AS PRICE FROM HANGHOA ORDER BY MaHH DESC


--d. Cho biết số lần đặt hàng của từng khách hàng, những khách hàng không đặt hàng thì phải
--hiển thị số lần đặt hàng bằng 0. Hiển thị: Mã khách hàng, tên khách hàng, số lần đặt
GO
ALTER FUNCTION SLDATHANG (@MA VARCHAR(9))
RETURNS INT
BEGIN
	IF EXISTS (SELECT * FROM DONDATHANG WHERE MAKH = @MA)
		BEGIN
			RETURN (SELECT COUNT(*)
					FROM DONDATHANG 
					WHERE MAKH = @MA)
		END
	RETURN 0
END
GO
SELECT TenKH,MaKH, dbo.SLDATHANG(MaKH) as 'SO LAN DAT' FROM KHACHHANG

-- e. Cho biết tổng tiền của từng phiếu giao hàng trong năm 2012, hiển thị: mã giao, ngày giao,
-- tổng tiền, với tổng tiền = SUM(SLGiao*DonGiaGiao)

SELECT PHIEUGIAOHANG.MaGiao,NgayGiao, sum(SLGiao * DonGiaGiao) AS N'TỔNG TIỀN' 
FROM PHIEUGIAOHANG JOIN CHITIETGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao
WHERE YEAR(NgayGiao) = 2012 GROUP BY  PHIEUGIAOHANG.MaGiao,NgayGiao


--f. Cho biết khách hàng nào có 2 lần đặt hàng trở lên, hiển thị: mã khách hàng, tên khách hàng,
--số lần đặt.

SELECT KHACHHANG.MaKH,TenKH,COUNT(*) AS 'SL'
FROM KHACHHANG JOIN DONDATHANG ON DONDATHANG.MaKH = KHACHHANG.MaKH GROUP BY KHACHHANG.MaKH, TenKH HAVING COUNT(*) >=2

--g. Cho biết mặt hàng nào đã được giao với tổng số lượng giao nhiều nhất, hiển thị: mã hàng,
--tên hàng hóa, tổng số lượng đã giao.

SELECT TOP 1 WITH TIES HANGHOA.MaHH,TenHH, SUM(SLGiao) AS 'TONG SL GIAO' FROM HANGHOA JOIN CHITIETGIAOHANG ON CHITIETGIAOHANG.MaHH = HANGHOA.MaHH GROUP BY  HANGHOA.MaHH,TenHH ORDER BY HANGHOA.MaHH,TenHH DESC


--h. Tăng số lượng còn của mặt hàng có mã bắt đầu bằng ký tự “M” lên 10.

UPDATE HANGHOA SET SLCon+=10 WHERE MaHH LIKE 'M%'
SELECT * FROM HANGHOA

--i. Copy dữ liệu bảng HangHoa sang một bảng HangHoa_copy, sau đó xóa những mặt hàng
--chưa được đặt trong bảng HangHoa. Chèn lại vào bảng HangHoa những dòng bị xóa từ bảng
--HangHoa_copy.

-- COPY BANG 
SELECT * INTO HANGHOA_COPY FROM HANGHOA
-- XOA VA THEM MOI
GO
CREATE TRIGGER CAUI ON HANGHOA_COPY AFTER DELETE
AS
BEGIN
	INSERT INTO HANGHOA SELECT * FROM deleted
END
GO

SELECT MaHH FROM HANGHOA WHERE MaHH NOT IN ( SELECT MaHH FROM CHITIETDATHANG )

--j. Cập nhật số điện thoại cho khách hàng có mã KH006.

UPDATE KHACHHANG SET DienThoai = '0377379249' WHERE MaKH = 'KH006'
SELECT * FROM KHACHHANG

--k. Sửa giá trị TinhTrang=NULL cho tất cả các đơn đặt hàng
UPDATE DONDATHANG SET TinhTrang = NULL

--l. Thêm cột ThanhTien cho bảng ChiTietGiaoHang, sau đó cập nhật giá trị cho cột này với
--ThanhTien = SLGiao*DonGiaGiao

ALTER TABLE CHITIETGIAOHANG ADD ThanhTien float

UPDATE CHITIETGIAOHANG SET ThanhTien = SLGiao* DonGiaGiao
select * from CHITIETGIAOHANG


 -- 3. VIEW (khung nhìn)


 --a. Tạo view thống kê doanh số giao hàng của từng mặt hàng trong 6 tháng đầu năm 2012

 GO
 CREATE VIEW CAU31 
 AS
	 SELECT TenHH, HANGHOA.MaHH,ThanhTien,NgayGiao,SLGiao 
	 FROM HANGHOA 
		 JOIN CHITIETGIAOHANG ON CHITIETGIAOHANG.MaHH = HANGHOA.MaHH 
		 JOIN PHIEUGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao
			 WHERE NgayGiao BETWEEN '2012-01-01' AND '2012-06-01'
			 GROUP BY TenHH, HANGHOA.MaHH,ThanhTien,NgayGiao,SLGiao
GO

-- b. Tạo view cho biết mặt hàng nào có tổng số lượng được đặt lớn nhất trong năm 2012
CREATE VIEW CAU32
AS
SELECT TOP 1 WITH TIES CHITIETDATHANG.MaHH, TenHH  ,COUNT(CHITIETDATHANG.MaHH) AS 'SL DAT' 
FROM CHITIETDATHANG 
	JOIN HANGHOA ON HANGHOA.MaHH = CHITIETDATHANG.MaHH 
	JOIN DONDATHANG ON DONDATHANG.MaDat = CHITIETDATHANG.MaDat
	 WHERE YEAR(NgayDat) = 2012
	 GROUP BY CHITIETDATHANG.MaHH, TenHH ORDER BY COUNT(CHITIETDATHANG.MaHH) DESC
GO

--c. Tạo view cho biết danh sách khách hàng ở Đà Nẵng có sử dụng WITH CHECK OPTION, sau đó
--chèn 2 khách hàng vào view này, một khách hàng có địa chỉ Đà Nẵng và một khách hàng có
--địa chỉ ở Quảng Nam, có nhận xét gì trong 2 trường hợp này?

CREATE VIEW CAU33 
AS
	SELECT * FROM KHACHHANG WHERE DiaChi = N'Đà Nẵng'
	WITH CHECK OPTION 
GO
INSERT INTO KHACHHANG VALUES('KH07',N'Bách Hóa Xanh',N'Đà Nẵng','2378346246')
INSERT INTO KHACHHANG VALUES('KH08',N'FPT SOFTWARE',N'Quảng Nam','2375323.6246')
select * from CAU33
SELECT * FROM KHACHHANG

--  4. STORE PROCEDURE + TRANSACTION (Thủ tục nội tại + giao dịch)


--a. Tạo thủ tục truyền vào mã đơn đặt hàng (@maddh) và mã hàng hóa (@mahh), xuất ra số
--lượng hàng hóa @mahh được đặt trong đơn đặt hàng @maddh.
GO
CREATE PROCEDURE CAU4A @MA VARCHAR(9), @MAHH VARCHAR(9)
AS
BEGIN 
	SELECT SLDat FROM DONDATHANG 
	JOIN CHITIETDATHANG ON CHITIETDATHANG.MaDat = DONDATHANG.MaDat 
	JOIN HANGHOA ON HANGHOA.MaHH = CHITIETDATHANG.MaHH 
	WHERE DONDATHANG.MaDat =@MA AND HANGHOA.MaHH = @MAHH

END
EXECUTE CAU4A 'DH01','BU'
GO

 -- b. Tạo thủ tục truyền vào mã phiếu giao hàng, xuất ra tổng tiền của phiếu giao hàng đó.
ALTER PROC CAU4B @MA VARCHAR(9)
AS
BEGIN
	DECLARE @TONG FLOAT =
	(SELECT SUM(ThanhTien) FROM PHIEUGIAOHANG 
	JOIN CHITIETGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao 
	WHERE PHIEUGIAOHANG.MaGiao = @MA)
	PRINT FORMAT(@TONG,'c','vi-VN')+ 'VND'
END
GO
EXECUTE CAU4B 'GH01'
GO
-- c. Tạo thủ tục truyền vào mã khách hàng, hiển thị các đơn đặt hàng của khách hàng đó, gồm
--các thông tin: Mã đặt, ngày đặt, mã giao, ngày giao.
CREATE PROC CAU4C @MA VARCHAR(9)
AS
BEGIN
	SELECT DONDATHANG.MaDat,NgayDat, MaGiao,NgayGiao 
	FROM KHACHHANG 
	JOIN DONDATHANG ON KHACHHANG.MaKH = DONDATHANG.MaKH 
	JOIN PHIEUGIAOHANG ON PHIEUGIAOHANG.MaDat = DONDATHANG.MaDat 
	WHERE KHACHHANG.MaKH = @MA
END
GO
EXECUTE CAU4C 'KH001'
SELECT * FROM KHACHHANG
GO

--d. Tạo thủ tục truyền vào ngày1 và ngày2, đếm xem có bao nhiêu phiếu giao hàng được giao
--trong khoảng thời gian từ ngày1 đến ngày2

ALTER PROC CAU4D @NGAY1 DATE, @NGAY2 DATE 
AS
BEGIN
	SELECT COUNT(*) AS 'SL PHIEU GIAO' FROM PHIEUGIAOHANG WHERE NgayGiao BETWEEN @NGAY1 AND  @NGAY2 
END
GO
EXECUTE CAU4D '2011-02-02' , '2012-01-23'

--e. Viết lại câu 3a, 3b, 3c bằng cách dùng thủ tục.

--  a. Tạo PROC thống kê doanh số giao hàng của từng mặt hàng trong 6 tháng đầu năm 2012
GO
ALTER PROC CAU4E3A @NGAY1 DATE, @NGAY2 DATE
AS
BEGIN
	 SELECT TenHH, HANGHOA.MaHH,ThanhTien,NgayGiao,SLGiao 
	 FROM HANGHOA 
		 JOIN CHITIETGIAOHANG ON CHITIETGIAOHANG.MaHH = HANGHOA.MaHH 
		 JOIN PHIEUGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao
			 WHERE NgayGiao BETWEEN @NGAY1 AND  @NGAY2
			 GROUP BY TenHH, HANGHOA.MaHH,ThanhTien,NgayGiao,SLGiao
END
GO
EXECUTE CAU4E3A '2011-02-02' , '2012-01-23'
GO
 -- b. Tạo PTC cho biết mặt hàng nào có tổng số lượng được đặt lớn nhất trong năm X


CREATE  PROC CAU4E3B @NAM INT
AS
BEGIN
	SELECT TOP 1 WITH TIES CHITIETDATHANG.MaHH, TenHH  ,COUNT(CHITIETDATHANG.MaHH) AS 'SL DAT' 
	FROM CHITIETDATHANG 
		JOIN HANGHOA ON HANGHOA.MaHH = CHITIETDATHANG.MaHH 
		JOIN DONDATHANG ON DONDATHANG.MaDat = CHITIETDATHANG.MaDat
		 WHERE YEAR(NgayDat) = @NAM
		 GROUP BY CHITIETDATHANG.MaHH, TenHH ORDER BY COUNT(CHITIETDATHANG.MaHH) DESC
END
GO
EXECUTE CAU4E3B 2011
GO
-- c. Tạo PROC cho biết danh sách khách hàng ở Đà Nẵng  sau đó
--chèn 2 khách hàng vào view này, một khách hàng có địa chỉ Đà Nẵng và một khách hàng có
--địa chỉ ở Quảng Nam, có nhận xét gì trong 2 trường hợp này?
CREATE PROC CAU4E3C @DIACHI NVARCHAR(20)
AS
BEGIN
	SELECT * FROM KHACHHANG WHERE DiaChi = @DIACHI
END
GO
EXECUTE CAU4E3C N'Quảng Nam'
GO

--f. Tạo thủ tục thêm mới một hàng hóa với tham số đầu vào là: mã hàng, tên hàng, đơn vị tính,
--số lượng, đơn giá. Yêu cầu:
-- Kiểm tra khóa chính, nếu vi phạm thì báo lỗi và chấm dứt thủ tục.
-- Kiểm tra tên hàng phải là duy nhất (có nghĩa tên hàng nếu khác null phải khác với tất cả
--các tên hàng đã tồn tại trong bảng HangHoa), nếu không duy nhất thì báo lỗi và chấm
--dứt thủ tục.
-- Kiểm tra số lượng nếu khác null thì phải >=0, ngược lại thì báo lỗi và chấm dứt thủ tục.
-- Kiểm tra đơn giá nếu khác null thì phải >=0, ngược lại thì báo lỗi và chấm dứt thủ tục.
-- Nếu các điều kiện trên thỏa thì cho thêm mới hàng hóa.

ALTER PROC CAU4F @MAHH VARCHAR(9) , @TEN NVARCHAR(50), @DVT  NVARCHAR(5),@SL INT ,@DONGIA FLOAT
 AS
 BEGIN
	BEGIN TRY
		IF EXISTS ( SELECT TenHH FROM HANGHOA WHERE TenHH = @TEN)
			BEGIN
			PRINT 'TEN DA TON TAI'
			RETURN
			END
		IF @SL <= 0
			BEGIN
			PRINT 'SO LUONG PHAI LON HON 0 '
			RETURN
			END
		IF @DONGIA <= 0
			BEGIN
			PRINT 'DON GIA PHAI LON HON 0 '
			RETURN
			END
		BEGIN TRAN
			INSERT INTO HANGHOA(MaHH,TenHH,DVT,SLCon,DonGiaHH)	
			VALUES(@MAHH,@TEN,@DVT,@SL,@DONGIA)
			PRINT ' THEM THANH CONG'
		COMMIT
	END TRY
	BEGIN CATCH
	PRINT N'LOI'
		ROLLBACK TRAN
		PRINT	CASE ERROR_NUMBER()
			WHEN 2627 THEN N'TRUNG KHOA CHINH'
			WHEN 547 THEN N'KHÔNG CÓ KHÓA NGOẠI'
			WHEN 515 THEN N'Rỗng'
			else N'Lỗi '+ ERROR_MESSAGE()
		END
	END CATCH
 END

GO 
EXECUTE  CAU4F 'ED',N'Bàn ủi Philip',N'cái',10,3000000
SELECT * FROM HANGHOA
GO

--g. Tạo thủ tục thêm mới một ChiTietGiaoHang với các tham số đầu vào là: mã giao, mã hàng
--hóa, số lượng giao. Yêu cầu:
-- Kiểm tra hàng hóa này có được đặt không, có nghĩa mã hàng hóa truyền vào có tồn tại
--trong ChiTietDatHang của đơn đặt hàng tương ứng với phiếu giao hàng này không? Nếu
--không thì báo lỗi và chấm dứt procedure.
-- Kiểm tra số lượng giao có nhỏ hơn số lượng đặt ứng với hàng hóa này không? Nếu không
--thì báo lỗi và chấm dứt procedure.
-- Kiểm tra số lượng giao có nhỏ hơn số lượng còn của hàng hóa này không? Nếu không thì
--báo lỗi và chấm dứt procedure.
-- Nếu thỏa 3 điều kiện trên thì cho thêm mới vào chi tiết giao hàng, với đơn giá giao được
--lấy từ đơn giá hiện hành của hàng hóa này. Sau khi thêm mới phải cập nhập lại cột số
--lượng còn của HangHoa: SLCon= SLCon - SLGiao.
--Cần phải lưu ý với 2 hành động thêm mới chi tiết giao hàng và cập nhật lại số lượng còn, nếu

--một trong hai hành động thất bại thì cả hai cùng thất bại. Cần phải sử dụng giao dịch (trans-
--action) để giải quyết vấn đề này.

ALTER PROC CAU4G @MAGIAO VARCHAR(9) , @MAHH VARCHAR(9), @SL INT, @DONGIA FLOAT, @TT FLOAT
AS
BEGIN
	
	BEGIN TRY
		IF @MAHH NOT IN (SELECT MaHH FROM CHITIETDATHANG) 
			BEGIN
			PRINT 'MA HANG NAY CHUA DC DAT HANG'
			RETURN
			END
		IF EXISTS ( SELECT SLDat FROM CHITIETDATHANG  WHERE MaHH LIKE @MAHH AND SLDAT < @SL)
			BEGIN
			PRINT 'SO LUONG GIAO PHAI NHO HON SO LUONG DAT'
			RETURN
			END
		IF EXISTS (SELECT SLCon FROM HANGHOA WHERE MaHH LIKE @MAHH AND SLCon < @SL)
			BEGIN
			PRINT 'SO LUONG GIAO PHAI NHO HON SO LUONG CON'
			RETURN
			END
		
		-- với đơn giá giao được lấy từ đơn giá hiện hành của hàng hóa này
		SET @DONGIA = (SELECT DonGiaHH FROM HANGHOA WHERE MaHH = @MAHH)
		BEGIN TRAN
		INSERT INTO CHITIETGIAOHANG(MaGiao,MaHH,SLGiao,DonGiaGiao,ThanhTien)
		VALUES (@MAGIAO,@MAHH,@SL,@DONGIA,(@SL *@DONGIA ))
		PRINT 'THEM THANH CONG'
		COMMIT
		
		UPDATE HANGHOA SET  SLCon -= @SL
		WHERE MaHH = @MAHH
		PRINT 'UPDATE THANH CONG'
		-- SO DONG THUC THI
		PRINT 'SO DONG THUC HIEN'  + CONVERT(VARCHAR, @@ROWCOUNT)
	END TRY
	BEGIN CATCH
		PRINT N'LOI'
		ROLLBACK TRAN
		PRINT	CASE ERROR_NUMBER()
			WHEN 2627 THEN N'TRUNG KHOA CHINH'
			WHEN 547 THEN N'KHÔNG CÓ KHÓA NGOẠI'
			WHEN 515 THEN N'Rỗng'
			else N'Lỗi '+ ERROR_MESSAGE()
		END
	END CATCH
	
END
GO
EXECUTE CAU4G 'GH06','TL',2,NULL,NULL 

SELECT  * FROM HANGHOA 
SELECT * FROM CHITIETDATHANG
SELECT * FROM CHITIETGIAOHANG
GO

-- 5. FUNCTION (hàm do người dùng định nghĩa)

-- a. Viết lại câu 4a bằng cách dùng Function
--a. Tạo thủ tục truyền vào mã đơn đặt hàng (@maddh) và mã hàng hóa (@mahh), xuất ra số
--lượng hàng hóa @mahh được đặt trong đơn đặt hàng @maddh.
CREATE FUNCTION CAU5A4A (@MA VARCHAR(9) , @MAHH VARCHAR(9))
RETURNS INT
AS
BEGIN
	RETURN (SELECT SLDat FROM DONDATHANG 
	JOIN CHITIETDATHANG ON CHITIETDATHANG.MaDat = DONDATHANG.MaDat 
	JOIN HANGHOA ON HANGHOA.MaHH = CHITIETDATHANG.MaHH 
	WHERE DONDATHANG.MaDat =@MA AND HANGHOA.MaHH = @MAHH)
END
GO
PRINT dbo.CAU5A4A('DH01','BU')


-- b. Viết lại câu 4b bằng cách dùng Function
 -- b. Tạo thủ tục truyền vào mã phiếu giao hàng, xuất ra tổng tiền của phiếu giao hàng đó.
 GO 
ALTER FUNCTION CAU5B4B (@MA VARCHAR(9))
 RETURNS INT
 AS
 BEGIN
	RETURN
	(SELECT SUM(ThanhTien) FROM PHIEUGIAOHANG 
	JOIN CHITIETGIAOHANG ON PHIEUGIAOHANG.MaGiao = CHITIETGIAOHANG.MaGiao 
	WHERE PHIEUGIAOHANG.MaGiao = @MA)	
 END
 GO
  PRINT dbo.CAU5B4B('GH01') 
  SELECT * FROM PHIEUGIAOHANG
  GO
-- c. Viết lại câu 4c bằng cách dùng
-- c. Tạo thủ tục truyền vào mã khách hàng, hiển thị các đơn đặt hàng của khách hàng đó, gồm
--các thông tin: Mã đặt, ngày đặt, mã giao, ngày giao.
CREATE FUNCTION CAU5C4C (@MA VARCHAR(9))
RETURNS @T TABLE (MADAT VARCHAR(9), NGAYDAT DATE,MAGIAO VARCHAR(9),NGAYDIAO DATE)
BEGIN
	INSERT INTO @T
		SELECT DONDATHANG.MaDat,NgayDat, MaGiao,NgayGiao 
		FROM KHACHHANG 
		JOIN DONDATHANG ON KHACHHANG.MaKH = DONDATHANG.MaKH 
		JOIN PHIEUGIAOHANG ON PHIEUGIAOHANG.MaDat = DONDATHANG.MaDat 
		WHERE KHACHHANG.MaKH = @MA
	RETURN 
END
GO
SELECT * FROM dbo.CAU5C4C('KH001')
GO

-- d. Viết lại câu 4d bằng cách dùng Function
--d. Tạo thủ tục truyền vào ngày1 và ngày2, đếm xem có bao nhiêu phiếu giao hàng được giao
--trong khoảng thời gian từ ngày1 đến ngày2

CREATE FUNCTION CAU5D4D (@NGAY1 DATE, @NGAY2 DATE)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*)  FROM PHIEUGIAOHANG WHERE NgayGiao BETWEEN @NGAY1 AND  @NGAY2 )
END
GO

PRINT dbo.CAU5D4D('2011-02-02' , '2012-01-23')
GO
--  6. TRIGGER

-- a. Số lượng còn của hàng hóa phải >0
CREATE TRIGGER CAU6A ON HANGHOA FOR UPDATE,INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM INSERTED WHERE SLCON <=0)
		BEGIN
			PRINT N'SLCON hàng hóa phải lớn hơn 0'
			ROLLBACK TRANSACTION
		END
END

-- DVT
--b Đơn vị tính của hàng hóa chỉ nhận một trong các giá trị: Cái, Thùng, Chiếc, Chai, Lon
GO


CREATE TRIGGER CAU6B ON HANGHOA FOR INSERT,UPDATE
AS
BEGIN
	IF EXISTS 
	(SELECT * FROM INSERTED 
	WHERE DVT != N'Cái' and DVT != N'Thùng'
		AND DVT != N'Chiếc' AND DVT != N'Chai'
		AND DVT != N'Lon')
		BEGIN
			PRINT N'Đơn vị tính không nằm trong Cái, Thùng, Chiếc, Chai, Lon'
			ROLLBACK TRANSACTION
		END
END
GO
INSERT INTO HANGHOA VALUES ('LT',N'Laptop',N'haha',10,45000)

-- C .Ngày giao hàng phải bằng hoặc sau ngày đặt hàng nhưng không được quá 30 ngày
GO
CREATE FUNCTION THANG(@MADAT VARCHAR(4)) RETURNS INT
BEGIN
	RETURN (SELECT MONTH(NGAYDAT)+1 FROM DONDATHANG 
			WHERE MADAT = @MADAT)
END
GO
SELECT *,DBO.THANG(MADAT) FROM DONDATHANG
GO
CREATE FUNCTION NAM(@MADAT VARCHAR(4)) RETURNS INT
BEGIN
	RETURN (SELECT YEAR(NGAYDAT)+1 FROM DONDATHANG 
			WHERE MADAT = @MADAT)
END
go
GO
CREATE FUNCTION NGAYDAT(@MADAT VARCHAR(4)) RETURNS DATE
BEGIN
	RETURN 
	(SELECT IIF(dbo.THANG(MADAT)>12,
		REPLACE(NGAYDAT,SUBSTRING(cast(NGAYDAT as varchar),1,7), cast(DBO.NAM(MADAT)as varchar)+'-'+'01'),

	iif(dbo.thang(MADAT)>9,
	REPLACE(NGAYDAT,SUBSTRING(cast(NGAYDAT as varchar),5,4),
				'-'+CAST(DBO.THANG(MADAT) AS VARCHAR)+'-'),
	REPLACE(NGAYDAT,SUBSTRING(cast(NGAYDAT as varchar),5,4),
				'-0'+CAST(DBO.THANG(MADAT) AS VARCHAR)+'-')))
	FROM DONDATHANG WHERE MADAT = @MADAT)
END
GO
SELECT *,DBO.NGAYDAT(MADAT) FROM DONDATHANG
GO
CREATE TRIGGER NGAYGIAO ON PHIEUGIAOHANG FOR INSERT,UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM INSERTED NG JOIN DONDATHANG ND 
									ON	NG.MADAT = ND.MADAT 
				WHERE ND.NGAYDAT > NG.NGAYGIAO)
		BEGIN
			PRINT N'Ngày giao không dc thấp hơn ngày đặt'
			rollback transaction
		END

	IF EXISTS (SELECT * FROM INSERTED NG JOIN DONDATHANG ND 
									ON	NG.MADAT = ND.MADAT 
				WHERE dbo.NGAYDAT(ND.MADAT) < NG.NGAYGIAO)
		BEGIN
			PRINT N'Ngày giao không dc quá 30 ngày'
			rollback transaction
		END
END

--UPDATE DONGIA HH
--Tạo trigger sau khi chèn 1 dòng mới vào bảng LichSuGia (gồm: mã hàng háo, ngày hiệu lực mới, đơn giá mới), nếu ngày có hiệu lực mới lớn hơn tất cả các ngày hiệu lực trong lịch sử giá của hàng hóa tương ứng thì cập nhật lại DonGiaHH bằng đơn giá mới cho hàng hóa này, ngược lại thì rollback.
   
DROP TRIGGER IF EXISTS trigger_LICHSUGIA
GO
CREATE TRIGGER trigger_LICHSUGIA ON LICHSUGIA FOR INSERT
AS
BEGIN
	DECLARE @BANGAO TABLE(MAHH VARCHAR(2),NGAY DATE)
	INSERT INTO @BANGAO SELECT MAHH,NGAYHL FROM inserted
	IF EXISTS 
	(SELECT * 
	FROM LICHSUGIA LSG JOIN @BANGAO BA ON LSG.MAHH=BA.MAHH
	WHERE LSG.NGAYHL > BA.NGAY)
		BEGIN
			PRINT N'Ngày nhập không dc bé hơn ngày cũ'
			ROLLBACK TRANSACTION
		END
END

	--VIEW
GO
CREATE VIEW UPDATE_DONGIAHH
AS
	SELECT MAHH,MAX(NGAYHL) AS NGAYMOINHAT FROM LICHSUGIA GROUP BY MAHH
GO
SELECT LSG.* 
FROM LICHSUGIA LSG JOIN DBO.UPDATE_DONGIAHH AO ON LSG.MAHH = AO.MAHH  WHERE LSG.NGAYHL = AO.NGAYMOINHAT

	--TRIGGER UPDATE DONGIA HH
GO
DROP TRIGGER IF EXISTS TRIGGER_UPDATE_DONGIAHH
GO
CREATE TRIGGER TRIGGER_UPDATE_DONGIAHH ON LICHSUGIA AFTER INSERT
AS
BEGIN
	DECLARE @MAHH TABLE(STT INT IDENTITY(1,1),MA VARCHAR(2))
	INSERT INTO @MAHH
	SELECT MAHH FROM INSERTED

	DECLARE @BIENAO VARCHAR(2)

	DECLARE @DEM INT = (SELECT COUNT(*) FROM @MAHH)
	DECLARE @I INT = 1

	DECLARE @BIENBANG TABLE(STT INT,MA VARCHAR(2),TIEN MONEY) 
	WHILE @I <= @DEM
		BEGIN
			SET @BIENAO = (SELECT MA FROM @MAHH WHERE STT = @I)

			INSERT INTO @BIENBANG
			SELECT @I,LSG.MAHH,LSG.DONGIA
			FROM LICHSUGIA LSG JOIN DBO.UPDATE_DONGIAHH AO 
						ON LSG.MAHH = AO.MAHH  
			WHERE LSG.NGAYHL = AO.NGAYMOINHAT
				AND LSG.MAHH = @BIENAO

DECLARE @MATHAY VARCHAR(2)
SET @MATHAY = (SELECT MA FROM @BIENBANG WHERE STT=@I)
DECLARE @TIENTHAY MONEY
SET @TIENTHAY = (SELECT TIEN FROM @BIENBANG WHERE STT=@I)
			UPDATE HANGHOA
			SET DONGIA = @TIENTHAY
			WHERE MAHH = @MATHAY
			SET @I = @I + 1
		END
END

INSERT INTO LICHSUGIA VALUES
('MG','2011-01-01',4700000),
('MQ','2011-01-06',400000)
GO
-- E Số lượng hàng hóa được giao không được lớn hơn số lượng hàng hóa được đặt tương ứng

CREATE TRIGGER KHITHEMTINHTRANG ON DONDATHANG FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM INSERTED WHERE TINHTRANG != 0)
		BEGIN
			PRINT N'Tình trạng phải bằng 0'
			rollback transaction
		END
END
GO
DROP TRIGGER IF EXISTS TINHTRANG
GO
CREATE TRIGGER TINHTRANG ON CHITIETGIAOHANG AFTER INSERT
AS
BEGIN
	DECLARE @BANGAO TABLE (MADAT VARCHAR(4))
	INSERT INTO @BANGAO
	SELECT MADAT
	FROM PHIEUGIAOHANG WHERE MAGIAO IN (SELECT MAGIAO FROM INSERTED)

	UPDATE DONDATHANG
	SET TINHTRANG = 1
	WHERE MADAT IN (SELECT * FROM @BANGAO)
END
select * from DONDATHANG



