use QLDA2034
-- 1. Tìm các nhân viên làm việc ở phòng số 4
select MANV, TENNV from NHANVIEN
WHERE PHG = 4

-- 2. Tìm các nhân viên có mức lương trên 30000
SELECT MANV,HONV,TENLOT, TENNV , LUONG FROM NHANVIEN 
WHERE LUONG >3000

-- 3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
-- viên có mức lương trên 30,000 ở phòng 5
SELECT * FROM NHANVIEN
 WHERE (LUONG >250000 AND PHG =4) OR (LUONG >300000 AND PHG =5)

-- 4. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
SELECT HONV + '' + TENLOT+''+ TENNV AS N'Họ và tên' FROM NHANVIEN 
WHERE DCHI LIKE '%TPHCM%'

-- 5. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự 'N'
SELECT HONV + '' + TENLOT+''+ TENNV AS N'Họ và tên' FROM NHANVIEN 
WHERE HONV LIKE 'N%';

-- 6. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien.
SELECT NGSINH , DCHI ,HONV + '' + TENLOT+''+ TENNV AS N'Họ và tên'
 FROM NHANVIEN WHERE 'Họ và tên'  = 'Dinh Ba Tien';
-- phan 2: 
-- 1. Đếm số nhân viên làm việc ở phòng số 4.


SELECT COUNT(MANV) FROM NHANVIEN
WHERE PHG = 4;


-- 2. Tìm nhân viên có mức lương cao nhất.
--Tất cả luong
select luong
from NhanVien;
--Lấy rA MAX
select max(luong)
from (select luong
from NhanVien) as A;

select *
from NhanVien
where luong >= ALL
(
select luong
from NhanVien)


-- 3. Tìm phòng ban chưa có nhân viên
SELECT MAPHG,TENPHG FROM PHONGBAN
 WHERE MAPHG NOT IN 
(
	SELECT PHG FROM  NHANVIEN
	INNER JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG 
)

 
SELECT MAPHG,TENPHG FROM PHONGBAN 
LEFT join NHANVIEN ON  PHONGBAN.MAPHG = NHANVIEN.PHG 

-- 4. Lập danh sách nhân viên gồm các thông tin: MANV, HOVATEN,
-- HOTEN_TRPHG
	select NV.MANV,NV.HONV + '' + NV.TENLOT + '' + NV.TENNV AS HOTENNV,
	TP.MANV,TP.HONV + '' + TP.TENLOT + '' + TP.TENNV
	FROM NHANVIEN NV JOIN PHONGBAN PB ON PB.MAPHG = NV.PHG
	JOIN NHANVIEN TP ON TP.MANV = PB.TRPHG
	



