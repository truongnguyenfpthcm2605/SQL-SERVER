DECLARE @TEN NVARCHAR(30) 

SET @TEN = N'NGUYỄN VĂN TRƯỜNG'
SELECT @TEN = N'PHẠM THỊ NGỌC NGÂN'
SELECT @TEN = TENNV FROM NHANVIEN WHERE MANV = '003' -- GÁN TÊN VÔ BIÊN
SELECT @TEN AS N'HỌ VÀ TÊN'


DECLARE @DAI INT,@RONG INT,@TONG INT -- KHAI BAO BIEN
SET @DAI = 5
SET @RONG = 8
SET @TONG = @DAI + @RONG
SELECT @TONG AS RESULT

DECLARE @NVP4 TABLE (
	MA VARCHAR(9),
	HOTEN NVARCHAR(15),
	PHONG TINYINT
)
INSERT INTO @NVP4

SELECT MANV,HONV + ' ' + TENLOT +  ' ' +  TENNV,PHG FROM NHANVIEN
WHERE PHG = 4

SELECT * FROM @NVP4




