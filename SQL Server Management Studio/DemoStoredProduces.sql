-- hien thi danh sach nhan vien mot phong ban
USE QLDA_PS24083_TRUONG
GO

CREATE PROCEDURE USP_NVPB @MAPHG INT = 4 --KHAI BAO STORE PRODUCEDURE
AS 
SELECT MANV,TENNV FROM NHANVIEN WHERE PHG =  @MAPHG
EXECUTE USP_NVPB
go

-------
-- VIET CUNG CAP CAC THONG TIN 1 PHONG BAN . KIEM TRA NEU DA CO MAPHONG TRONG  PHONGBAN 
-- THI CAP NHAT CAC PHONG TIN CUA PHONGBAN DO. NEU CHUA THI THEM PHONG DO VA PHONGBAN
--if OBJECT_ID(USP_PHGBAN) is not null
--DROP PROCEDURE USP_PHGBAN 
--GO
-- KIEM TRA NEU CO THI XOA VA TAO MOI CAP NHAT
CREATE PROCEDURE USP_PHGBAN @MA INT , @TEN NVARCHAR(15) , @TRP NVARCHAR(9) ,@NGAY date
AS 
BEGIN
 IF EXISTS (SELECT MAPHG FROM PHONGBAN WHERE MAPHG = @MA)
 BEGIN 
 PRINT 'UPDATE' + CAST(@MA AS CHAR)
 UPDATE PHONGBAN
 SET TENPHG = @TEN,TRPHG =@TRP ,NG_NHANCHUC = @NGAY
 WHERE MAPHG = @MA
 END
 ELSE 
 BEGIN 
 PRINT 'ADD NEW PHONGBAN'
 INSERT INTO PHONGBAN VALUES 
 (@TEN,@MA,@TRP,@NGAY)
 END 
END
EXECUTE USP_PHGBAN 1000, N'KINH DOANH', '001','2022-05-28'

EXECUTE USP_PHGBAN @TEN= N'KINH DOANH', @TRP= N'004', @MA = 100, @NGAY ='2021-01-05'
GO
SP_HELPTEXT USP_PHGBAN -- XEM LAI PROCEDURE VIET GI



