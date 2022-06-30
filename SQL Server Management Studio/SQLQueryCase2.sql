-- hien thi danh sach  hoten nv
-- cach 1
select CASE PHAI 
	when N'Nam' then 'chao ong'
	when N'Nữ' then 'chao ba'
	else 'chao'
end+
 '' +honv + TENLOT + TENNV AS TEN FROM NHANVIEN



 -- cach 2 
 select iif(phai = N'Nam','chao ong',iif(phai = N'Nữ', 'chao ba','chao'))  +honv + TENLOT + TENNV AS TEN FROM NHANVIEN