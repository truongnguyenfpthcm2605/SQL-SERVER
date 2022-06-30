SELECT TENDA, SUM(THOIGIAN) AS 'TONG GIO',
CAST(SUM(THOIGIAN) AS DECIMAL(7,2)) AS 'DECIMAL', -- TONG CHIEU DAI 7 SO VAF 2SO THP PHAN
CAST(SUM(THOIGIAN) AS VARCHAR) AS 'VARCHAR' -- CHUYEN SANG CHUOI LAY 4CHUX SO THAP PHAN
FROM DEAN JOIN PHANCONG ON DEAN.MADA = PHANCONG.MADA
GROUP BY TENDA

-- Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm
--việc cho phòng ban đó.
-- Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu
--phẩy để phân biệt phần nguyên và phần thập phân.
-- Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3
--chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
--CACH 1
SELECT TENPHG,HONV,TENLOT,TENNV,
CAST(AVG(LUONG) AS DECIMAL(7,2)) AS 'LUONG DECIMAL',
LEFT(CAST(AVG(LUONG) AS VARCHAR(10)),3) +
REPLACE(CAST(AVG(LUONG) AS VARCHAR(10)),LEFT(CAST(AVG(LUONG) AS VARCHAR(10)),3),',')
FROM PHONGBAN
INNER JOIN NHANVIEN ON NHANVIEN.PHG= PHONGBAN.MAPHG GROUP BY TENPHG,HONV,TENLOT,TENNV
-- CACH 2 
SELECT TENPHG,
CAST(AVG(LUONG) AS DECIMAL(7,2)) AS 'LUONG DECIMAL',
REPLACE(CAST(AVG(LUONG) AS VARCHAR(10)),RIGHT(CAST(AVG(LUONG) AS VARCHAR(10)),3),',')+
RIGHT(CAST(AVG(LUONG) AS VARCHAR(10)),3)
FROM PHONGBAN
INNER JOIN NHANVIEN ON NHANVIEN.PHG= PHONGBAN.MAPHG GROUP BY TENPHG
-- CAU 2
--2.1 Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
--tham dự đề án đó.
-- Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
-- Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
-- Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân

SELECT TENDA, 
CEILING(SUM(THOIGIAN) ) AS 'CEILING',
FLOOR(SUM(THOIGIAN) ) AS 'FLOOR',
CAST(SUM(THOIGIAN) AS DECIMAL(7,2))
FROM DEAN INNER JOIN PHANCONG ON PHANCONG.MADA = DEAN.MADA
GROUP BY TENDA
SELECT * FROM NHANVIEN

--2.2 Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương
--trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"

-- LAY LUONG TRUNG BINH 
DECLARE @LUONGTB INT
SET @LUONGTB =
(SELECT AVG(LUONG) 
FROM NHANVIEN  INNER JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
WHERE TENPHG LIKE N'Nghiên cứu')

SELECT HONV ,TENLOT, TENNV, CAST(LUONG AS DECIMAL(7,2))
FROM NHANVIEN WHERE  LUONG > @LUONGTB

-- BAI 3
-- Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân,
--thỏa các yêu cầu
-- Dữ liệu cột HONV được viết in hoa toàn bộ
-- Dữ liệu cột TENLOT được viết chữ thường toàn bộ
-- Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết
--thường (ví dụ: kHanh)
-- Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác
--như số nhà hay thành phố.

SELECT UPPER(HONV),LOWER(TENLOT),LOWER(LEFT(TENNV,1))+ UPPER(SUBSTRING(TENNV,2,1))+ SUBSTRING(TENNV,3,LEN(TENNV) -2),
SUBSTRING(DCHI,CHARINDEX(' ',DCHI)+1,CHARINDEX(',',DCHI)-CHARINDEX(' ',DCHI)-1)
FROM NHANVIEN INNER JOIN THANNHAN ON THANNHAN.MA_NVIEN = NHANVIEN.MANV
GROUP BY HONV,TENLOT,TENNV ,DCHI HAVING COUNT(MANV) > 2

--Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất,
--hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
DECLARE @TEN VARCHAR(10),@MAXSL INT

SET @TEN = 'Fpoly'
-- TIM RA PHONG ĐÔNG NHÂN VIÊN NHÂN VIÊN
SET @MAXSL = (SELECT MAX(SL) FROM (SELECT COUNT(MANV) AS SL FROM PHONGBAN PB JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG GROUP BY MAPHG) AS B)
SELECT MAPHG,TP.HONV + ' '+TP.TENLOT +' '+TP.TENNV,TP.HONV + ' '+TP.TENLOT +' '+@TEN,
COUNT(NV.MANV) AS 'SL' FROM PHONGBAN PB INNER JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
JOIN NHANVIEN TP ON TP.MANV = PB.TRPHG
GROUP BY MAPHG,TP.HONV + ' '+TP.TENLOT +' '+TP.TENNV,TP.HONV + ' '+TP.TENLOT +' '+@TEN  HAVING COUNT(NV.MANV)>= @MAXSL

-- BAI4
-- 4.1 Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.

SELECT HONV ,TENLOT, TENNV ,NGSINH
FROM  NHANVIEN WHERE YEAR(NGSINH) >= '1960' AND YEAR(NGSINH) <= 1965

-- 4.2 Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
SELECT HONV, TENLOT,TENNV , NGSINH, (YEAR(GETDATE()) -YEAR(NGSINH)  )AS TUOI
FROM NHANVIEN

-- 4.3 Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.

SELECT HONV,TENLOT,TENNV , YEAR(NGSINH) AS 'NAM SINH' 
FROM NHANVIEN

-- 4.4 Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày
-- nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)

SELECT
COUNT(NV.MANV) AS 'SLNV',
TP.HONV + TP.TENLOT + TP.TENNV AS 'TENTP',
CONVERT(VARCHAR(15),NG_NHANCHUC,105) AS 'NGAY NHAN CHUC'
FROM NHANVIEN NV INNER JOIN PHONGBAN PB ON PB.MAPHG = NV.PHG
INNER JOIN NHANVIEN TP ON PB.TRPHG = TP.MANV GROUP BY  TP.HONV , TP.TENLOT , TP.TENNV ,NG_NHANCHUC

-- BAI5 
-- 1  Cho biết các nhân viên nhỏ tuổi nhất có tham gia dự án

-- TIM RA NHAN VIEN NHO TUOI NHAT
DECLARE @MINAGE INT 
SET @MINAGE = (
SELECT MIN(MINAGE) FROM (
SELECT (YEAR(GETDATE()) - YEAR(NGSINH))  AS MINAGE FROM NHANVIEN
) AS A)

SELECT HONV + TENLOT + TENNV,(YEAR(GETDATE()) - YEAR(NGSINH)) AS 'NHAN VIEN TUOI NHO NHAT'
FROM  NHANVIEN INNER JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
INNER JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG 
GROUP BY HONV , TENLOT , TENNV, (YEAR(GETDATE()) - YEAR(NGSINH))  HAVING (YEAR(GETDATE()) - YEAR(NGSINH)) = @MINAGE

-- 2 Cho biết khoảng cách giữa lương cao nhất và lương thấp nhất là bao nhiêu. Thông tin
--hiển thị gồm: LuongCaoNhat, LuongThapNhat, ChenhLech. Định dạng lương theo mẫu
--(#,##0 triệu đồng).

DECLARE @MAXLUONG FLOAT, @MINLUONG FLOAT ,@TRENLET SMALLMONEY, @TIEN NVARCHAR(20)
SET @TIEN = N'Triệu Đồng'
-- LAY  LUONG LON NHAT
SET @MAXLUONG = (SELECT MAX(LUONG) FROM (
SELECT LUONG FROM NHANVIEN
) AS A)
-- LAY LUONG NHO NHAT
SET @MINLUONG = (SELECT MIN(LUONG) FROM (
SELECT LUONG FROM NHANVIEN
) AS A)
-- TREN LET
SET @TRENLET =@MAXLUONG -@MINLUONG


SELECT
REPLACE(@MAXLUONG,RIGHT(@MAXLUONG,3),',')+ RIGHT(@MAXLUONG,3) + @TIEN AS 'MAXLUONG'
,REPLACE(@MINLUONG,RIGHT(@MINLUONG,3),',')+ RIGHT(@MINLUONG,3) + @TIEN AS 'MINLUONG',
REPLACE(@TRENLET,RIGHT(@TRENLET,5),',')+ RIGHT(@TRENLET,6) + @TIEN AS 'TRENLET'


-- 3 Hiển thị danh sách nhân viên gồm các thông tin: Mã nhân viên, họ và tên, Năm sinh, Độ
--tuổi
--Được xét dựa trên tuổi:
--- Tuổi >50 : Cao tuổi
--- Tuổi từ 25 – 50: Trung bình
--- Tuổi <25: Nhỏ tuổi

-- >50 TUOI
SELECT
MANV, HONV + TENLOT + TENNV AS 'HO VA TEN',
YEAR(NGSINH) AS 'NAM SINH',
(YEAR(GETDATE()) - YEAR(NGSINH)) AS 'TUOI'
FROM NHANVIEN WHERE (YEAR(GETDATE()) - YEAR(NGSINH)) > 50
-- 25-50 TUOI
SELECT
MANV, HONV + TENLOT + TENNV AS 'HO VA TEN',
YEAR(NGSINH) AS 'NAM SINH',
(YEAR(GETDATE()) - YEAR(NGSINH)) AS 'TUOI'
FROM NHANVIEN WHERE (YEAR(GETDATE()) - YEAR(NGSINH)) <= 50
AND (YEAR(GETDATE()) - YEAR(NGSINH)) >= 25
 -- <25
 SELECT
MANV, HONV + TENLOT + TENNV AS 'HO VA TEN',
YEAR(NGSINH) AS 'NAM SINH',
(YEAR(GETDATE()) - YEAR(NGSINH)) AS 'TUOI'
FROM NHANVIEN WHERE 
(YEAR(GETDATE()) - YEAR(NGSINH)) < 25




















