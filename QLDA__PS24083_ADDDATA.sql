USE QLDA_PS24083_TRUONG
GO
INSERT INTO PHONGBAN VALUES
(N'Nghiên Cứu',5,N'005','1978-05-22'),
(N'Điều Hành',4,N'008','1985-01-01'),
(N'Quản Lý',1,N'006','1971-06-19')
GO
INSERT INTO NHANVIEN VALUES
(N'Đinh',N'Bá',N'Tiên',N'009','1960-02-11',N'119 Cống Quỳnh,Tp HCM',N'Nam',30000,N'005',5),
(N'Nguyễn',N'Thanh',N'Tùng',N'005','1962-08-20',N'222 Nguyễn Văn Cừ,Tp HCM',N'Nam',40000,N'006',5),
(N'Bùi',N'Ngọc',N'Hằng',N'007','1954-03-11',N'332 Nguyễn Thái Học,Tp HCM',N'Nam',25000,N'001',4),
(N'Lê',N'Quỳnh',N'Như',N'001','1967-02-01',N'291 Hồ Văn Huế,Tp HCM',N'Nữ',43000,N'006',4),
(N'Nguyễn',N'Mạnh',N'Hùng',N'004','1967-03-04',N'95 Bà Rịa , Vũng Tàu',N'Nam',38000,N'005',5),
(N'Trần',N'Thanh',N'Tâm',N'003','1957-05-04',N'Mai Thị Lự,Tp HCM',N'Nam',25000,N'005',5),
(N'Trần',N'Hồng',N'Quang',N'008','1967-09-01',N'80 Lê Hồng Phong,Tp HCM',N'Nam',25000,N'001',4),
(N'Phạm',N'Văn',N'Vinh',N'006','1965-01-01',N'45 Trương Vương, Hà Nội',N'Nữ',30000,null,5)
GO
INSERT INTO DEAN VALUES
(N'Sản Phẩm X',1,N'Vũng Tàu',5),
(N'Sản Phẩm Y',2,N'Nha Trang',5),
(N'Sản Phẩm Z',3,N'TP HCM',5),
(N'tin Học Hóa',10,N'Hà Nội',4),
(N'Cáp Quang',20,N'TP HCM',1),
(N'Đào Tạo',30,N'Hà Nội',4)
GO

INSERT INTO DIADIEM VALUES
(1,N'TP HCM'),
(4,N'Hà Nội'),
(5,N'TAU'),
(5,N'Nha Trang'),
(5,N'TP HCM')
GO

INSERT INTO THANNHAN VALUES
(N'005',N'Trinh',N'Nữ','1976-04-05',N'Con gái'),
(N'005',N'Khang',N'Nam','1973-10-25',N'Con trai'),
(N'005',N'Phương',N'Nữ','1948-05-03',N'Vợ chồng'),
(N'001',N'Minh',N'Nam','1932-02-29',N'Vợ chồng'),
(N'009',N'Tiến',N'Nam','1978-01-01',N'Con trai'),
(N'009',N'Châu',N'Nữ','1978-12-30',N'Con gái'),
(N'009',N'Phương',N'Nữ','1957-05-05',N'Vợ chồng')
GO

INSERT INTO CONGVIEC VALUES
(1,1,N'Thiết kế sản phẩm X'),
(1,2,N'Thủ nghiệm sản phẩm X'),
(2,1,N'Sản xuất sản phẩm Y'),
(2,2,N'Quảng cáo sản phẩm Y '),
(3,1,N'Khuyến mãi sản phẩm Z'),
(10,1,N'Tin học hóa phồng nhân sự'),
(10,2,N'Tin học hóa phòng kinh doanh'),
(20,1,N'Lắp đặt cáp quang'),
(30,1,N'Đào tạo nhân viên Marketing'),
(30,2,N'Đào tạo chuyên viên thiết kế')
GO

INSERT INTO PHANCONG VALUES 
(N'009',1,1,32),
(N'009',2,2,8),
(N'004',3,1,40),
(N'003',1,2,20.0),
(N'003',2,1,20.0),
(N'008',10,1,35),
(N'008',30,2,5),
(N'001',30,1,20),
(N'001',20,1,15),
(N'006',20,1,30),
(N'005',3,1,10),
(N'005',10,2,10),
(N'005',20,1,10),
(N'007',30,2,30),
(N'007',10,2,10)






