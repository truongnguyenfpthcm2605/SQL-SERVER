DECLARE @HOTEN VARCHAR(30) 
SET @HOTEN = 'Nguyen VAn Truong'
SELECT LEN(@HOTEN) , UPPER(@HOTEN) , LOWER(@HOTEN), REVERSE(@HOTEN)
-- LAY HO, TENLOT, TEN
DECLARE @VITRIDAU INT , @VITRICUOI INT

 SET @VITRIDAU = CHARINDEX(' ',@HOTEN) 
 SELECT @VITRIDAU

 SET @VITRICUOI = LEN(@HOTEN) - CHARINDEX(' ',REVERSE(@HOTEN))
 DECLARE @HO VARCHAR(15) , @TEN VARCHAR(15) ,@TENLOT VARCHAR(20)

 SET @HO = LEFT(@HOTEN,@VITRIDAU-1)
 SET @TEN = RIGHT(@HOTEN,CHARINDEX(' ',REVERSE(@HOTEN))-1)
 SET @TENLOT = SUBSTRING(@HOTEN,@VITRIDAU+1,@VITRICUOI-@VITRIDAU)
 SELECT @HO, @TEN, @TENLOT
 