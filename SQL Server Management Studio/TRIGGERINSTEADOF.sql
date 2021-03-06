USE QLDA_PS24083_TRUONG
GO
-- THUC HIEN OA NHAN VIEN  001. XAO CA THANNHAN VA PHANCONG NEU C?

ALTER TRIGGER DEL_NHHANVIEN ON NHANVIEN INSTEAD OF DELETE 
AS
BEGIN 
	
		DECLARE @MA VARCHAR(9)
		SELECT  @MA = MANV FROM deleted 
		DELETE FROM PHANCONG WHERE  MA_NVIEN = @MA  
		DELETE FROM THANNHAN WHERE MA_NVIEN = @MA
		UPDATE PHONGBAN SET TRPHG = '003'  WHERE TRPHG = @MA --XOA TRUONG PHONG
		UPDATE NHANVIEN SET MA_NQL = NULL WHERE MA_NQL =@MA
		DELETE FROM NHANVIEN WHERE MANV = @MA 
		PRINT 'DELETE SUCCELL'
	
END
ALTER TABLE PHONGBAN ALTER COLUMN TRPHG IS NULL
DELETE FROM NHANVIEN WHERE MANV = '001'
SELECT * FROM NHANVIEN WHERE MANV = '002'
SELECT * FROM THANNHAN WHERE MA_NVIEN = '002'
SELECT * FROM PHANCONG WHERE MA_NVIEN = '002'