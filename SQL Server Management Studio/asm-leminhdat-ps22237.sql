CREATE DATABASE NHATRO_PS22237_LEMINHDAT
USE NHATRO_PS22237_LEMINHDAT
GO
-- TAO BẢNG LOẠI NHÀ TRỌ
CREATE TABLE LOAINHATRO 
(
	MALOAITRO INT PRIMARY KEY NOT NULL,
	TENLOAITRO NVARCHAR(30) NOT NULL  
	
)
-- TẠO BẢNG NGƯỜI DÙNG
CREATE TABLE NGUOIDUNG 
(
	MANGUOIDUNG NVARCHAR(15) PRIMARY KEY NOT NULL,
	TENNGUOIDUNG NVARCHAR(30) NOT NULL,
	DCHIA NVARCHAR(100) NOT NULL,
	GIOITINH BIT NOT NULL,
	DIENTHOAI NVARCHAR(12) ,
	EMAIL NVARCHAR(20),
	NGAYSINH DATE
	
)
-- TẠO BẢNG NHÀ TRỌ
CREATE TABLE NHATRO
(
	MANHATRO INT PRIMARY KEY NOT NULL,
	MOTA NVARCHAR(100) ,
	DCHIA NVARCHAR(100) NOT NULL,
	GIAPHONG FLOAT NOT NULL CHECK(GIAPHONG > 1000),
	DIENTICH FLOAT NOT NULL CHECK ( DIENTICH > 8),
	NGAYDANG DATE NOT NULL,
	NGLIENHE NVARCHAR(15) NOT NULL,
	TRANGTHAI NVARCHAR(20) NOT NULL,
	LOAITRO INT ,
	CONSTRAINT FK_LOAITRO FOREIGN KEY( LOAITRO) REFERENCES LOAINHATRO(MALOAITRO),
	CONSTRAINT FK_NGUOIDUNG FOREIGN KEY( NGLIENHE) REFERENCES NGUOIDUNG(MANGUOIDUNG),
)
-- TẠO BẢNG ĐÁNH GIÁ
CREATE TABLE DANHGIA
(
	NGDANHGIA NVARCHAR(15) NOT NULL ,
	NHATRO INT NOT NULL,
	DANHGIA NVARCHAR(15),
	NOIDUNGDANHGIA NVARCHAR(150),
	CONSTRAINT PK_DANHGIA PRIMARY KEY (NGDANHGIA,NHATRO),
	CONSTRAINT FK_NGUOIDANGGIA FOREIGN KEY( NGDANHGIA) REFERENCES NGUOIDUNG(MANGUOIDUNG),
	CONSTRAINT FK_NHATRO FOREIGN KEY(NHATRO) REFERENCES NHATRO(MANHATRO)
)
ALTER TABLE NGUOIDUNG DROP COLUMN EMAIL
ALTER TABLE NGUOIDUNG ADD  EMAIL NVARCHAR(30)
INSERT INTO LOAINHATRO VALUES
(445,N'VINHOME'),
(331,N'Trọ bình dân'),
(665,N'Trọ cao cấp'),
(890,N'Trọ chung cư')

INSERT INTO NGUOIDUNG(MANGUOIDUNG,TENNGUOIDUNG,DCHIA,GIOITINH,DIENTHOAI,EMAIL,NGAYSINH) VALUES
(N'ND001',N'Nguyễn Văn Nam',N'26 Võ Văn Ngân , Thủ Đức ,TPHCM',1,N'0367345982',N'nam123@gmail.com','1990-04-23'),
(N'ND002',N'Nguyễn Văn Minh',N'13 Dakao ,Quận 1 ,TPHCM',1,N'0389123678',N'minhridkid99@outlook.com','1997-02-13'),
(N'ND003',N'Đoàn Thị Như',N'123 Nguyễn Phú Xuân , Bà Rịa-Vũng Tàu',0,N'0093456533',N'nhưdoan23@yahoo.com','1995-03-03'),
(N'ND004',N'Lê Minh Đạt',N'Chợ Thủ Đức, Thủ Đức ,TPHCM',1,N'0234564234',N'cuongcanda2003@gmail.com'	,'2003-01-23'),
(N'ND005',N'Lê Võ Phú'	,N'Tô Kí , Quận 12, TPHCM',	1,	N'0232389438',N'phuthien56@gmail.com','2003-04-29'),
(N'ND006',N'Võ Văn Nam',N'Quang Trung  ,Quận 12,TPHCM',1	,N'0332393456',N'hauvan2000@gmail.com','2000-05-21'),
(N'ND007',N'Dương Văn Ngọc',N'23 Phan Văn Trị, Quận Gò Vấp,TPHCM',1,N'0823923923',N'minhngoc@gmail.com','2000-04-16'),
(N'ND008',N'Nguyễn Văn Thắng',N'236 Lê Văn Việt, Quận 9 ,TPHCM',1,N'0377379249',N'truongnvps24083@fpt.edu.vn','2001-05-26'),
(N'ND009',N'Nguyễn Anh Thư',N'DX28 Phú Mỹ,Thủ Dầu Một, Bình Dương',0,N'0988324244',N'nguyenthu12@facebook.com','1989-11-08'),
(N'ND010',	N'Nguyễn Thùy Trang',N'Tân Kiều,Tháp Mười,Đồng Tháp',0,N'0126463499',N'thuytrangbeautiful@gmail.com','2001-04-27')

INSERT INTO NHATRO VALUES
(4545,N'Trọ Tầng 10 ,Trung cư GoWay,Đầy đủ nội thất',N'Xa Lộ Hà Nội , Thủ Đức ,TPHCM',7500,80,'2022-01-17',N'ND001',N'còn 5 Phòng Trống',890),
(8999,N'ở Khu VinHome, Tầng 7 ,toàn Vin C, đầy đủ tiện nghi',N'1232 Nam Kỳ Khởi Nghĩa, Quận 1, TPHCM',8500,70,'2022-03-18',N'ND006',N'còn 35 Phòng Trống',445),
(1002,N'cạnh khu công nghiệp Mỹ Phước 2 ,dãy đối diện nhau, đường ra 2M',N'DB9, Phường Mỹ Phước ,Tx Bến Cát, Bình Dương',1200,12,'2021-03-25',N'ND003',N'Còn 14 Phòng Trống',331),
(5623,N'Trong Landmark 81 , Tầng 17 ',N'208 Đ. Nguyễn Hữu Cảnh, Phường 22, Bình Thạnh,TPHCM',20000,	60,	'2022-03-11',N'ND008',N'Tạm Thời Hết Phòng'	,	445),
(7462,N'tro tiền nghi, gần quốc lộ , có vĩa hè buôn bán',N'Quốc Lộ 1A, Linh Xuân ,Thủ Đức ,TPHCM',2500,24,'2022-05-10',N'ND010',N'Còn 2 Phòng',665),
(3538,N'trong hẻm nhỏ, trong đường DT23',N'Quang Trung  ,Quận 12,TPHCM',1800,16,'2022-07-02',N'ND006',N'Còn 1 Phòng Thuê Gấp',331),
(3142,N'Tòa Mường Thanh C , Tầng 21',N'12 Dakao ,Quận 1 ,TPHCM',8000,65,'2021-12-04',N'ND001',N'Còn 2 Phòng',890),
(1242,N'canh khu công nghệ cao ,cầu vành đai',N'N12, Khuc C , KCN Công Nghệ Cao, Quận 9 , TPHCM',3000,20,'2022-03-01',N'ND005',N'Còn  3 Phòng  Trống',665),
(9996,N'tro moi xay,Nhưng đường chạy vào hay ngập nước',N'18 Đường Hiệp Bình, Linh Xuân , Thủ Đức , TPHCM',1500,14,'2022-01-30',N'ND009',N'Còn 2 Phòng trống',331)

INSERT INTO DANHGIA VALUES
(N'ND001',4545,N'Rất Tốt',N'Phong rất tiện nghi, dịch vụ rất tốt , nhân viên than thiện,an ninh, giá cả hợp lý'),
(N'ND006',8999,N' RấtTốt',N'Vinhome rất tốt ,hệ thông dịch vụ , giao thông ,thông tin qua tốt , giá cả cũng hợp lý'),
(N'ND003',1002,N'Quá Tệ',N'trọ , toàn là nhậu , ca hát , tới 1 2h chưa đi ngủ được, thật là chán nản, chủ trọ không xử lý'),
(N'ND008',5623,N'Rất Tốt',N'view trong landmark tuyệt đẹp , very good'),
(N'ND010',7462,N'Tạm được',N'Nhiều vấn đề về điện nước chưa được xử lý, cũng như mạng wifi'),
(N'ND005',1242,N'Rất Tốt',N'Khu này im lặng dễ ngủ, hay la ca hát cũng không phiền tới ai'),
(N'ND009',9996,N'Quá Tệ',N'Cái đường vô trọ như cái xong vậy co mấy lần ngập tới phòng lun')


