create database com2034_IT1730_DoanHuynhDuyCuong_ASM
go
use com2034_IT1730_DoanHuynhDuyCuong_ASM

CREATE TABLE LOAINHA(
	MALOAI VARCHAR(3) NOT NULL,
	TENLOAINHA NVARCHAR(30) NOT NULL,
	THONGTIN NVARCHAR(40),
	CONSTRAINT PK_LOAINHA PRIMARY KEY (MALOAI)
)

CREATE TABLE NGUOIDUNG(
	MANGUOIDUNG VARCHAR(4) NOT NULL,
	TENNGUOIDUNG NVARCHAR(40) NOT NULL,
	GIOITINH BIT NOT NULL,
	DIENTHOAI VARCHAR(12) NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	NGAYSINH DATE NOT NULL
	CONSTRAINT PK_NGUOIDUNG PRIMARY KEY (MANGUOIDUNG)
)

CREATE TABLE NHATRO(
	MANHATRO VARCHAR(4) NOT NULL,
	MALOAINHA VARCHAR(3) NOT NULL,
	NGUOILIENHE VARCHAR(4) NOT NULL,
	DIENTICH FLOAT NOT NULL,
	GIAPHONG MONEY CHECK(GIAPHONG>0) NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	THONGTINNHATRO NVARCHAR(60) NOT NULL,
	NGAYDANG DATE
	CONSTRAINT PK_NHATRO PRIMARY KEY (MANHATRO)
	CONSTRAINT FK_NHATRO_LOAINHA FOREIGN KEY(MALOAINHA) REFERENCES LOAINHA(MALOAI),
	CONSTRAINT FK_NHATRO_NGUOIDUNG FOREIGN KEY(NGUOILIENHE) REFERENCES NGUOIDUNG(MANGUOIDUNG),
	CONSTRAINT CHK_DIENTICH CHECK(DIENTICH>0),
	CONSTRAINT CHK_GIAPHONG CHECK(GIAPHONG>0)
)

CREATE TABLE DANHGIA(
	NGUOIDANHGIA VARCHAR(4),
	MANHATRO VARCHAR(4),
	NOIDUNGDANHGIA NVARCHAR(50),
	DANHGIA NVARCHAR(20),
	CONSTRAINT PK_DANHGIA PRIMARY KEY(NGUOIDANHGIA,MANHATRO),
	CONSTRAINT FK_DANHGIA_NGUOIDUNG FOREIGN KEY(NGUOIDANHGIA) REFERENCES NGUOIDUNG(MANGUOIDUNG),
	CONSTRAINT FK_DANHGIA_NHATRO FOREIGN KEY(MANHATRO) REFERENCES NHATRO(MANHATRO),
)

INSERT INTO LOAINHA VALUES
('001',N'Chung cư',N'Căn hộ'),
('002',N'Nha trọ cao cấp',N'Điện nước đầy đủ,diện tích thoải mái'),
('003',N'Trọ bình dân',N'Đủ ở,sạch đẹp')

INSERT INTO NGUOIDUNG VALUES
('0001',N'Đoàn Huỳnh Duy Cương',1,'0936249840',N'Đường 12,p Trường Thọ,Thủ Đức','cuongdhdps25442@gmail.com','01/16/2003'),
('0002',N'Nguyễn Văn Trường',1,'0124123412',N'Đường Lê Văn Việt,Thủ Đức','truongnvps23423@gmail.com','2/20/2001'),
('0004',N'Lê Võ Phú Thiện',1,'0891276542',N'Quang Trung,Quận 12','thienlvpps23412@gmail.com','10/20/2003'),
('0005',N'Võ Văn Hậu',1,'0987654321',N'Quang Trung,Quận 12','hauvvps20122@gmail.com','10/22/2003'),
('0006',N'Bình An Quá',0,'0876512349',N'Xa quá,Khỏi trái đất','xaquaps23412@gmail.com','5/12/1999'),
('0007',N'Đoàn Huỳnh Duy Cương',1,'0936249840',N'Đường 12,p Trường Thọ,Thủ Đức','cuongdhdps25442@gmail.com','01/16/2003'),
('0008',N'Nguyễn Văn Trường',1,'0987654321',N'Quang Trung,Quận 12','hauvvps20122@gmail.com','5/12/1999'),
('0009',N'Tại Sao Vậy Hả',0,'1234567890',N'Đường 12,p Trường Thọ,Thủ Đức','saovayha24242@gmail.com','07/16/2003'),
('0010',N'Bình An Quá Vậy',0,'0125122349',N'Xa quá,Bay luôn,Khỏi trái đất','xaquavayps23412@gmail.com','5/12/1999')

INSERT INTO NHATRO VALUES
('N001','002','0005',23,2600000,N'23 Quang Trung,Quận 12',N'Bao đẹp, bao xịn,full nội thất','05/20/2022'),
('N002','001','0001',23.5,2300000,N'42 Quang Trung,Quận 12',N'Bao đẹp,vipro, bao xịn,full nội thất','05/20/2022'),
('N003','001','0007',28,2900000,N'256 Quang Trung,Quận Gò vấp',N'Bao xịn,full nội thất','05/20/2022'),
('N004','002','0008',19.2,1900000,N'87 Quang Trung,Quận Bình Thạnh',N'Bao đẹp,full nội thất','05/20/2022'),
('N005','003','0009',25,2300000,N'65 Lê văn Việt,Quận 12',N'Bao đẹp, bao xịn','05/20/2022'),
('N006','001','0001',17,1800000,N'89 Trường Thọ,Thủ Đức',N'Auto vipro','05/20/2022'),
('N007','002','0002',24.5,2300000,N'23 Quang Trung,Quận 12',N'Đẹp trong mơ','05/20/2022'),
('N008','003','0006',21,2200000,N'23 Lê Văn Việt,Quận 12',N'Full nội thất','05/20/2022'),
('N009','001','0002',27.1,2800000,N'123 Quang Trung,Quận 12',N'Nhìn là mê','05/20/2022'),
('N010','002','0005',29,3200000,N'45 Quang Trung,Quận Thủ Đức',N'Tiện lợi','05/20/2022')

INSERT INTO NHATRO VALUES
('N011','002','0005',23,2600000,N'23 Quang Trung,Quận 12',N'Bao đẹp, bao xịn,full nội thất','05/20/2022'),
('N012','001','0001',23.5,2300000,N'42 Quang Trung,Quận 12',N'Bao đẹp,vipro, bao xịn,full nội thất','05/20/2022'),
('N013','001','0007',28,2900000,N'256 Quang Trung,Quận Gò vấp',N'Bao xịn,full nội thất','05/20/2022'),
('N014','002','0008',19.2,1900000,N'87 Quang Trung,Quận Bình Thạnh',N'Bao đẹp,full nội thất','05/20/2022'),
('N015','003','0009',25,2300000,N'65 Lê văn Việt,Quận 12',N'Bao đẹp, bao xịn','05/20/2022'),
('N016','001','0001',17,1800000,N'89 Trường Thọ,Thủ Đức',N'Auto vipro','05/20/2022'),
('N017','002','0002',24.5,2300000,N'23 Quang Trung,Quận 12',N'Đẹp trong mơ','05/20/2022'),
('N018','003','0006',21,2200000,N'23 Lê Văn Việt,Quận 12',N'Full nội thất','05/20/2022'),
('N019','001','0002',27.1,2800000,N'123 Quang Trung,Quận 12',N'Nhìn là mê','05/20/2022')


INSERT INTO DANHGIA VALUES
('0001','N006',N'Ngon,Tuyệt',N'LIKE'),
('0005','N008',N'Quá Tuyệt',N'LIKE'),
('0002','N006',N'Bình Thường',N'DISLIKE'),
('0001','N008',N'Tệ',N'DISLIKE'),
('0008','N005',N'Tuyệt',N'LIKE'),
('0001','N005',N'Quá tuyệt vời',N'LIKE'),
('0006','N002',N'Tệ',N'DISLIKE'),
('0002','N002',N'Tuyệt vời thật',N'LIKE'),
('0007','N001',N'Gian dối',N'DISLIKE'),
('0005','N001',N'Ngon',N'LIKE')

INSERT INTO DANHGIA VALUES
('0002','N011',N'Ngon,Tuyệt',N'LIKE'),
('0005','N011',N'Quá Tuyệt',N'LIKE'),
('0002','N015',N'Bình Thường',N'LIKE'),
('0001','N015',N'Ngon,Tuyệt',N'LIKE'),
('0008','N013',N'Tuyệt',N'LIKE'),
('0001','N013',N'Quá tuyệt vời',N'LIKE'),
('0006','N013',N'Ngon,Tuyệt',N'LIKE'),
('0002','N012',N'Tuyệt vời thật',N'LIKE'),
('0007','N007',N'Ngon,Tuyệt',N'LIKE'),
('0005','N015',N'Ngon',N'LIKE')
INSERT INTO DANHGIA VALUES
('0002','N013',N'Ngon,Tuyệt',N'LIKE'),
('0005','N013',N'Quá Tuyệt',N'LIKE'),
('0002','N016',N'Bình Thường',N'LIKE'),
('0001','N007',N'Ngon,Tuyệt',N'LIKE'),
('0008','N009',N'Tuyệt',N'LIKE'),
('0001','N011',N'Quá tuyệt vời',N'LIKE'),
('0006','N015',N'Ngon,Tuyệt',N'LIKE'),
('0002','N014',N'Tuyệt vời thật',N'LIKE'),
('0007','N018',N'Ngon,Tuyệt',N'LIKE'),
('0005','N014',N'Ngon',N'LIKE')

INSERT INTO DANHGIA VALUES
('0002','N007',N'Ngon,Tuyệt',N'LIKE'),
('0005','N016',N'Quá Tuyệt',N'LIKE'),
('0004','N011',N'Bình Thường',N'LIKE'),
('0001','N019',N'Ngon,Tuyệt',N'LIKE'),
('0008','N015',N'Tuyệt',N'LIKE'),
('0001','N012',N'Quá tuyệt vời',N'LIKE'),
('0004','N005',N'Ngon,Tuyệt',N'LIKE'),
('0008','N004',N'Tuyệt vời thật',N'LIKE'),
('0007','N006',N'Ngon,Tuyệt',N'LIKE'),
('0005','N012',N'Ngon',N'LIKE')

INSERT INTO DANHGIA VALUES
('0004','N015',N'Ngon,Tuyệt',N'LIKE'),
('0004','N016',N'Quá Tuyệt',N'LIKE'),
('0004','N019',N'Ngon,Tuyệt',N'LIKE'),
('0004','N010',N'Tuyệt',N'LIKE'),
('0006','N012',N'Quá tuyệt vời',N'LIKE'),
('0007','N005',N'Ngon,Tuyệt',N'LIKE'),
('0005','N004',N'Tuyệt vời thật',N'LIKE'),
('0002','N018',N'Ngon,Tuyệt',N'LIKE'),
('0004','N018',N'Ngon',N'LIKE')