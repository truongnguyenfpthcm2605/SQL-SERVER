 -- 1.1  Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì
-- xuất thông báo “luong phải >15000’

ALTER TRIGGER ADDNV ON NHANVIEN FOR INSERT,UPDATE
AS
BEGIN 
	IF EXISTS (SELECT LUONG FROM inserted WHERE LUONG <= 15000)
		BEGIN
			PRINT N'PHẢI THÊM LƯƠNG LỚN HƠN 15000'
			ROLLBACK TRAN
		END
END
INSERT INTO NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values (N'1345',N'Trần',N'Văn',N'Kha',N'Lê Văn Việt , TPHCM','1999-01-01',N'Nam',60000,N'001',7)
GO


-- 1.2  Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.

CREATE TRIGGER ADDNVAGE  ON NHANVIEN FOR INSERT
AS
BEGIN
	DECLARE @AGE INT
	SET @AGE = YEAR(GETDATE())- (SELECT YEAR(NGSINH) FROM inserted) 
		IF(@AGE < 18 OR @AGE > 65) 
		BEGIN
			PRINT N'TUỔI PHẢI NHỎ HƠN 18 VÀ LỚN HƠN 65'
			ROLLBACK TRAN
		END	
END
INSERT INTO NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values (N'135',N'Trần',N'Văn',N'Hùng',N'Lê Văn Việt , TPHCM','2000-01-01',N'Nam',16000,N'001',7)
GO

-- 1.3  Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM
CREATE TRIGGER UPNVTPHCM ON NHANVIEN FOR UPDATE
AS
BEGIN
	IF EXISTS ( SELECT MANV FROM deleted WHERE DCHI LIKE '%Tp HCM%')
	BEGIN
		PRINT N'KHÔNG THỂ CẬP NHẬT NHỮNG SINH VIÊN Ở TPHCM'
		ROLLBACK TRAN
	END
END
SELECT * FROM NHANVIEN 
UPDATE NHANVIEN 
SET LUONG = 40000
WHERE MANV = '008'
GO

-- 2.1 Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
-- thêm mới nhân viên.
CREATE TRIGGER COUNTNV ON NHANVIEN AFTER INSERT , UPDATE , DELETE
AS
BEGIN
	DECLARE @SLNU INT ,@SLNAM INT
		SET @SLNU = (SELECT COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nữ')
		SET @SLNAM = (SELECT COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nam')
	PRINT N'Nhân Viên Nữ : ' + cast(@SLNU AS VARCHAR) + N'Nhân Viên Nam :  '+ convert(varchar(3), @slnam)
END

INSERT INTO NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values (N'13',N'Trần',N'Văn',N'Mẫn',N'M4A1-ak47-trên sao hỏa ','1989-04-01',N'Nam',19000,N'001',7)
INSERT INTO NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values (N'18',N'Trần',N'Thị',N'Ngọc',N'M4A1-ak47-trên sao Kim ','1998-04-01',N'Nữ',19000,N'001',7)
go
 -- 2.2 Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
-- cập nhật phần giới tính nhân viên
CREATE TRIGGER COUNTNVTD ON NHANVIEN AFTER INSERT , UPDATE , DELETE
AS
BEGIN
	DECLARE @SLNU INT ,@SLNAM INT
		SET @SLNU = (SELECT COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nữ')
		SET @SLNAM = (SELECT COUNT(*) FROM NHANVIEN WHERE PHAI = N'Nam')
	PRINT N'Nhân Viên Nữ : ' + cast(@SLNU AS VARCHAR) + N'Nhân Viên Nam :  '+ convert(varchar(3), @slnam)
END
update NHANVIEN
set phai = N'Nữ'
where manv = '006'
GO
-- 2.3  Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN
DROP TRIGGER IF EXISTS SLDA
GO
CREATE TRIGGER SLDA ON DEAN AFTER  DELETE
AS
BEGIN
	DECLARE @DA INT,@SLDA INT
	SET @DA = (SELECT MADA FROM deleted)
	DELETE FROM DEAN WHERE MADA = @DA
	SELECT @SLDA =  (SELECT COUNT(MADA) FROM DEAN)
	
	PRINT N'SỐ LƯỢNG ĐỀ ÁN CON LẠI SAU KHI XÓA LÀ : ' + CAST(@SLDA AS VARCHAR) 
	
END
INSERT INTO DEAN VALUES ( N'SQL',19,N'Đồng Tháp',6)
SELECT COUNT(*) FROM DEAN
DELETE DEAN WHERE MADA = 19
GO
 -- 3.1 Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân
 -- viên trong bảng nhân viên.
ALTER TRIGGER DEL_NHHANVIEN ON NHANVIEN INSTEAD OF DELETE 
AS
BEGIN 
	
		DECLARE @MA VARCHAR(9)
		SELECT  @MA = MANV FROM deleted  
		DELETE FROM PHANCONG WHERE MA_NVIEN = @MA
		DELETE FROM THANNHAN WHERE MA_NVIEN = @MA
		UPDATE PHONGBAN SET TRPHG = '009' WHERE TRPHG = @MA
		DELETE FROM NHANVIEN WHERE MANV = @MA 
		PRINT 'DELETE SUCCELL'
	
END
DELETE FROM NHANVIEN WHERE MANV ='007'
SELECT * FROM NHANVIEN

SELECT * FROM PHANCONG 
GO
-- 3.2  Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA
 --là 1.
ALTER TRIGGER ADD_NV_PHANCONG ON NHANVIEN INSTEAD OF INSERT
 AS
 BEGIN 
	INSERT INTO NHANVIEN SELECT *  FROM inserted
	INSERT INTO PHANCONG VALUES (( SELECT MANV FROM inserted),1,2,30)
	PRINT 'SUCCESS'
 END
 INSERT INTO NHANVIEN VALUES(N'Nguyễn',N'Ngọc',N'Ngân',N'083','1986-02-09',N'Tân An , Long An',N'Nữ',34000,N'003',1)

 -- 4.1 Tạo bảng nv_Delete gồm: các thông tin của nhanvien, ngày xóa
 CREATE TABLE NV_DELETE 
 (
	HONV NVARCHAR(15) NOT NULL,
	TENLOT NVARCHAR(15) NOT NULL,
	TENNV NVARCHAR(15) NOT NULL,
	MANV NVARCHAR(9) NOT NULL PRIMARY KEY ,
	NGSINH DATE NOT NULL,
	DCHI NVARCHAR(30)  NULL,
	PHAI NVARCHAR(15) NOT NULL,
	LUONG FLOAT  NULL,
	MA_NQL NVARCHAR(9) REFERENCES NHANVIEN(MANV) ,
	PHG INT  NOT NULL ,
	NGAYXOA DATE
 )
 GO
-- 4.2 Viết trigger thực thi mỗi khi xóa 1 nhân viên sẽ chuyển thông tin nhân viên bị xóa vào
-- bảng nv_delete với ngày xóa là ngày hiện hành
ALTER TRIGGER SAVE_DELNV ON NHANVIEN AFTER DELETE 
AS 
BEGIN
  --DECLARE @MA VARCHAR(9)
  --SELECT @MA =  MANV FROM deleted
  INSERT INTO NV_DELETE  SELECT *,GETDATE() FROM DELETED -- WHERE MANV = @MA
  -- SELECT THI KHÔNG CÓ VALUES
END 

DELETE FROM NHANVIEN WHERE MANV = '23'
SELECT * FROM NHANVIEN

