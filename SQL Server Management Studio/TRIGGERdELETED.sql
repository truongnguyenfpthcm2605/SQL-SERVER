-- KHI XOA NHAN VIEN THI KHONG CHO XOA NHAN VIEN COT SO 4

ALTER TRIGGER DELNV ON NHANVIEN FOR DELETE
AS
BEGIN
		IF EXISTS ( SELECT PHG FROM deleted WHERE PHG = 7)		
		BEGIN
		PRINT 'KHONG THE XOA NHAN VIEN COT SO 7'
		ROLLBACK TRAN
		END
END
DELETE FROM NHANVIEN WHERE MANV = N'1115'
SELECT * FROM NHANVIEN
go
-- bang nhan vien khong cho update thong tin cac nhan vien lam viec phong 4
alter TRIGGER upnv4 ON NHANVIEN FOR update,insert
AS
BEGIN
		IF EXISTS ( SELECT PHG FROM deleted WHERE PHG = 4)		-- deleted khong cho sua du lieu cu
		BEGIN
		PRINT 'KHONG THE THEM VAO PHONG 4'
		ROLLBACK TRAN
		END
END
update NHANVIEN
set phg = 5
where MANV = '001'
SELECT * FROM NHANVIEN

-- bang nhan vien khong cho chuyen nhan vien den lam viec tai phong so 4
go
create TRIGGER upnv5 ON NHANVIEN FOR update,insert
AS
BEGIN
		IF EXISTS ( SELECT PHG FROM inserted WHERE PHG = 5)		
		BEGIN
		PRINT 'KHONG THE THEM va sua VAO PHONG 5'
		ROLLBACK TRAN
		END
END
update NHANVIEN
set phg = 60000
where  manv= '003'