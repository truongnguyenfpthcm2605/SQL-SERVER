-- hien thi danh sach nhan vien phong so 4
-- neu khong co nhan vien nao thi hien thong ba
-- nay cham hon
if (select count(manv)
from nhanvien where phg = 14) > 0
select manv,tennv from nhanvien where phg = 14
else 
print 'Khong co nhan vien nao lam viec o phong so 4'

-- nay nhan hon 
 if exists (select MANV from NHANVIEN WHERE PHG =4)
 select manv,tennv from nhanvien where phg = 4
else 
print 'Khong co nhan vien nao lam viec o phong so 4'

