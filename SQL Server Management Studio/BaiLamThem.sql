--1. Tạo SP thêm 1 thân nhân mới. Có kiểm tra trùng khóa chính và chỉ cho phép thêm thân nhân của nhân
--viên đang tồn tại.
--Thực thi SP vừa tạo

CREATE PROC ADDNEWNV1 @MA NVARCHAR(9),@TEN NVARCHAR(15) ,@PHAI  NVARCHAR(3), @NS DATE,@QH  NVARCHAR(15)
AS
BEGIN
	BEGIN TRY
		IF EXISTS ( SELECT MANV FROM NHANVIEN JOIN THANNHAN ON NHANVIEN.MANV = THANNHAN.MA_NVIEN)
		BEGIN
		INSERT INTO THANNHAN(MA_NVIEN,TENTN,PHAI,NGSINH,QUANHE) VALUES (@MA,@TEN,@PHAI,@NS,@QH)
		PRINT N'THÊM THÀNH CÔNG'
		END
		ELSE
		PRINT N'kHÔNG CÓ NHÂN VIÊN CÓ SẴN ĐỂ THÊM NHÂN THÂN'
	END TRY
	BEGIN CATCH 
		PRINT N'thêm thất bại!'
			PRINT	CASE error_number() 
						when 2627 then N'Trùng khóa chính'
						when 547 then N'Chưa có mã khoa ngoai'
						when 515 then N'Rỗng'
						else 'Lỗi '+ error_message()
					END
	END CATCH
END
EXECUTE  ADDNEWNV1 '001',N'Nam',N'Nam','1990-01-01',N'Cậu Cháu' 
GO
--2. Tạo SP tính số thân nhân của từng nhân viên của phòng ban có MaPH được truyền vào qua tham số,
--thông tin gồm: MaNN, HoTenNV, MoiQH, SoLuongTN.

CREATE PROC SLNT @MAPGH INT
AS
BEGIN
	SELECT MANV,HONV,TENLOT,TENNV, QUANHE, PHG,COUNT(MA_NVIEN) AS 'SLNT' FROM NHANVIEN JOIN THANNHAN ON THANNHAN.MA_NVIEN =NHANVIEN.MANV
	WHERE PHG = @MAPGH
	GROUP BY MANV,HONV,TENLOT,TENNV, QUANHE,PHG
END
EXECUTE SLNT 4
GO
--3. Viết hàm trả về tổng số nhân viên có phân công tham gia đề án theo MADA truyền vào qua tham số.
--Viết lệnh hoặc truy vấn để dùng hàm vừa tạo

CREATE FUNCTION SUMSLNV ( @MADA INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM NHANVIEN JOIN PHANCONG ON PHANCONG.MA_NVIEN = NHANVIEN.MANV WHERE MADA =  @MADA )
END
GO
PRINT 'TONG SO LUONG NHAN VIEN : ' + CAST(DBO.SUMSLNV(3) AS VARCHAR)

GO
-- 4. Viết hàm trả về danh sách nhân viên tham gia từ 2 đề án trở lên, thông tin gồm: MaNV, TenNV,
--SoLuongDATG, PHG.
CREATE FUNCTION BTLMCAU4()
RETURNS @T TABLE( MA NVARCHAR(15),TEN NVARCHAR(30),SLDA INT, PHONG INT)
AS
BEGIN
	INSERT INTO @T
	SELECT MANV,TENNV,COUNT(MADA), PHG FROM NHANVIEN JOIN PHANCONG ON NHANVIEN.MANV = PHANCONG.MA_NVIEN GROUP BY  MANV,TENNV, PHG
	HAVING COUNT(MADA) >= 2
	RETURN
	
END
GO
SELECT * FROM DBO.BTLMCAU4()
GO

--Viết truy vấn liệt kê MAPHG, TENPHG, TR_PHG của các phòng ban có nhân viên trong danh sách trả về
--của hàm trên. (Không hiển thị các dòng trùng thông tin)

SELECT MAPHG,TENPHG,TRPHG  FROM PHONGBAN JOIN DBO.BTLMCAU4() T ON PHONGBAN.MAPHG = T.MA

 -- 5. Tạo trigger không khi thêm mới hoặc cập nhật PHONGBAN thì NG_NHANCHUC không được sau ngày
-- hiện hành.
GO
CREATE TRIGGER BTLTCAU5 ON PHONGBAN FOR INSERT, UPDATE
AS
BEGIN 
	IF EXISTS ( SELECT NG_NHANCHUC FROM inserted  WHERE NG_NHANCHUC < GETDATE())
	PRINT N'NGÀY NHẬN CHỨC PHẢI LỚN HƠN NGÀY HIỆN TẠI'
END
INSERT INTO PHONGBAN VALUES (N'Công Nghệ',99,N'005','2020-01-01')


-- 6. Tạo trigger khi thêm mới PHONGBAN thì đồng thời thêm phòng ban này vào bảng DIADIEM_PHG với
-- thông tin địa điểm là TP.HCM.
GO
CREATE TRIGGER BTLTCAU6 ON PHONGBAN INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO PHONGBAN SELECT * FROM inserted
	INSERT INTO DIADIEM_PHG VALUES ((SELECT MAPHG FROM inserted),N'TP.HCM')
	PRINT 'SUCCESSFULLY'
END
GO
-- 7. Tạo View cho phép cập nhật thông tin THANNHAN.
-- Thêm 1 thân nhân mới (của 1 nhân viên đang có trong bảng NHANVIEN) vào View vừa tạo.
GO
CREATE VIEW BTLMCAU7
AS
	SELECT NHANVIEN.*, THANNHAN.* FROM THANNHAN JOIN NHANVIEN ON NHANVIEN.MANV = THANNHAN.MA_NVIEN
GO

---- 8. Tạo View THONGTIN hiển thị danh sách nhân viên đang tham gia dự án, thông tin gồm: MADA, TENDA,
--TENCV, MANV, HOTENNV, PHAI, NGSINH, LUONG, MAPHG, TENPHG, THOIGIAN.
CREATE VIEW BTLTCAU8 
AS
	SELECT DEAN.MADA,TENDA,TEN_CONG_VIEC,MANV,HONV,TENLOT,TENNV,PHAI,NGSINH,LUONG,MAPHG,TENPHG,THOIGIAN
	FROM NHANVIEN JOIN PHANCONG ON PHANCONG.MA_NVIEN = NHANVIEN.MANV
	JOIN CONGVIEC ON CONGVIEC.MADA = PHANCONG.MADA JOIN DEAN ON DEAN.MADA = PHANCONG.MADA
	JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
	
	GO
SELECT * FROM BTLTCAU8
--- Viết truy vấn dựa trên View THONGTIN để hiện thị danh sách nhân viên thuộc phòng ‘Nghiên cứu’
--tham gia dự án.

SELECT * FROM BTLTCAU8 WHERE TENPHG = N'Nghiên cứu'

--- Viết truy vấn dựa trên View THONGTIN để đếm số lượng nhân viên tham gia từng đề án
SELECT COUNT(MANV) AS 'SLTGDEAN' FROM BTLTCAU8 

--- Viết truy vấn dựa trên View THONGTIN để hiện thị danh sách nhân viên tham gia đề án với tổng thời
--gian nhiều nhất.
SELECT TOP 1 WITH TIES  SUM(THOIGIAN) AS FULLTIME, MANV FROM BTLTCAU8  GROUP BY MANV ORDER BY SUM(THOIGIAN) DESC
--- Viết truy vấn dựa trên View THONGTIN để hiện thị tổng lương phải trả cho nhân viên tham gia đề án
--của từng phòng ban.
SELECT SUM(LUONG),PHONGBAN.MAPHG  FROM BTLTCAU8 JOIN PHONGBAN ON PHONGBAN.MAPHG = BTLTCAU8.MANV GROUP BY PHONGBAN.MAPHG


--- Viết truy vấn dựa trên View THONGTIN để hiện thị danh sách nhân viên có tuổi lớn hơn tuổi trung
--bình của các nhân viên tham gia đề án

SELECT BTLTCAU8.*, YEAR(GETDATE()) - YEAR(NGSINH) AS 'TUOI' FROM BTLTCAU8 WHERE YEAR(GETDATE()) - YEAR(NGSINH) > (
SELECT AVG(YEAR(GETDATE()) - YEAR(NGSINH)) FROM NHANVIEN JOIN PHANCONG ON PHANCONG.MA_NVIEN = NHANVIEN.MANV) 