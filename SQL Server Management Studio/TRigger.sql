-- tao trigger KHI LUONG PHAI LON HON 5000 

-- TAO TRIGGER
DROP TRIGGER IF EXISTS ADDNV
GO
CREATE TRIGGER ADDNV ON NHANVIEN FOR INSERT,UPDATE
as
BEGIN 
	IF EXISTS (SELECT LUONG FROM inserted WHERE LUONG < = 5000)
	begin 
		print 'luong nhan vien phai > 5000'
		rollback tran
	end
END
insert into NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values ('1111',N'Trần',N'Văn',N'Hiếu',N'Võ Văn Ngân , TPHCM','2001-01-01',N'Nam',6000,N'001',7)
insert into NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values ('1113',N'Trần',N'Văn',N'Nghĩa',N'Võ Văn Ngân , TPHCM','2001-01-01',N'Nam',6000,N'001',1)
go
-- lhuong < 5000
CREATE TRIGGER ADDNVn ON NHANVIEN FOR INSERT
as
BEGIN 
	IF (SELECT LUONG FROM inserted)  <= 5000
	begin 
		print 'luong nhan vien phai(n) phai  > 5000'
		rollback tran
	end
END
insert into NHANVIEN (MANV,HONV,TENLOT,TENNV,DCHI,NGSINH,PHAI,LUONG,MA_NQL,PHG)
values ('1117',N'Trần',N'Văn',N'Hiếu',N'Võ Văn Ngân , TPHCM','2001-01-01',N'Nam',5500,N'001',7),
 ('1118',N'Trần',N'Văn',N'Hiếu',N'Võ Văn Ngân , TPHCM','2001-01-01',N'Nam',8000,N'001',7)

 GO
 -- tao trigger khi thay doi thong tin nhan vien luong phai lon 5000
 
 CREATE TRIGGER UPNV ON NHANVIEN FOR UPDATE
 AS
BEGIN
	IF EXISTS ( SELECT LUONG FROM inserted WHERE LUONG < 5000)
	begin 
		print 'luong UPDATE phai(n) phai  > 5000'
		rollback tran
	end
END
 UPDATE NHANVIEN 
 SET LUONG= 8000
 WHERE MANV = '1111'
