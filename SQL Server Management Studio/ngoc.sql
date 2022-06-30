/*
	Người thực hiện: NgocDM - PS24121
	Giảng viên: NgaHTH
*/

create database QLNHATRO_PS24121
go
use QLNHATRO_PS24121
go

create table LOAINHA(
	maloai int primary key not null,
	tenloai nvarchar(50) not null
)

create table NGUOIDUNG(
	manguoidung int primary key not null,
	tennguoidung nvarchar(50) not null,
	gioitinh nvarchar(5) not null,
	dienthoai varchar(15) not null,
	email varchar(50),
	diachi nvarchar(50) not null
)

create table NHATRO(
	manhatro int not null,
	maloai int not null,
	dientich float not null,
	giaphong money not null,
	diachi nvarchar(50) not null,
	thongtin nvarchar(50),
	nguoilienhe int not null,
	ngaydang date not null,
	constraint PK_NHATRO primary key(manhatro),
	constraint FK_NHATRO_LOAINHA foreign key(maloai) references LOAINHA(maloai),
	constraint FK_NHATRO_NGUOIDUNG foreign key(nguoilienhe) references NGUOIDUNG(manguoidung),
	constraint CHK_dientich check(dientich >= 10),
	constraint CHK_giaphong check(giaphong >= 0)
)

create table DANHGIA(
	manhatro int not null,
	nguoidanhgia int not null,
	danhgia nvarchar(50) not null,
	noidung nvarchar(500),
	constraint PK_DANHGIA primary key(manhatro,nguoidanhgia),
	constraint FK_DANHGIA_NHATRO foreign key(manhatro) references NHATRO(manhatro),
	constraint FK_DANHGIA_NGUOIDUNG foreign key(nguoidanhgia) references NGUOIDUNG(manguoidung)
)

insert into LOAINHA values
	(1,N'Phòng trọ khép kín'),
	(2,N'Căn hộ'),
	(3,N'Nhà riêng')

insert into NGUOIDUNG values
	(01,N'Dương Minh Ngọc',N'Nam','0934112607','ngocdmps24121@fpt.edu.vn',N'276/81/16 Thống Nhất,TPHCM'),
	(02,N'Trương Nguyễn Ngọc Hà',N'Nữ','0869890307','hatruong@gmail.com',N'2 Nguyễn Chí Thanh,Đơn Dương,Lâm Đồng'),
	(03,N'Nguyễn Văn Nam',N'Nam','0908390576','namvipro@gmail.com',N'34 Lê Văn Thọ,TPHCM'),
	(04,N'Lê Văn Trung',N'Nam','0900324657','trungvipro@gmail.com',N'245 Nguyễn Văn Khối,TPHCM'),
	(05,N'Nguyễn Cẩm Tiên',N'Nữ','0931453573','camtien@gmail.com',N'72 Nguyễn Văn Lượng,TPHCM'),
	(06,N'Lê Mỹ Hằng',N'Nữ','0932165753','myhang@gmail.com',N'34 Quang Trung,Vũng Tàu'),
	(07,N'Hồ Bá Nhật',N'Nam','0908543157','banhat@gmail.com',N'276 Nguyễn Văn Lượng,TPHCM'),
	(08,N'Nguyễn Nam Trung',N'Nam','0908542165','namtrung@gmail.com',N'28B Trường Sơn,TPHCM'),
	(09,N'Lê Hữu Thắng',N'Nam','0931546364','huuthang@gmail.com',N'18 Lý Thái Tổ,TPHCM'),
	(10,N'Nguyễn Hà My',N'Nữ','0935676524','hamy@gmail.com',N'24 Nguyễn Văn Khối,TPHCM')

insert into NHATRO values
	(001,3,'10','2000000',N'119 Cống Quỳnh, Tp HCM',N'Sạch sẽ,Thoáng mát',01,'05/10/2022'),
	(002,2,'10','2500000',N'222 Nguyễn Văn Cừ, Tp HCM',N'Nhà mới xây',02,'05/01/2022'),
	(003,3,'10','2300000',N'332 Nguyễn Thái Học, Tp HCM',N'Chung chủ, an ninh',03,'01/05/2022'),
	(004,2,'15','2700000',N'291 Hồ Văn Huê, Tp HCM',N'Giờ giấc tự do',04,'12/20/2021'),
	(005,2,'10','2100000',N'34 Mai Thị Lựu, Tp HCM',N'Miễn phí giữ xe',05,'01/30/2022'),
	(006,1,'20','3500000',N'80 Lê Hồng Phong, Tp HCM',N'Đầy đủ nội thất',06,'07/28/2021'),
	(007,1,'17','3000000',N'332 Nguyễn An Ninh, Tp HCM',N'Rộng rãi, thoáng mát',07,'04/20/2022'),
	(008,3,'10','2300000',N'332 Nguyễn Văn Khối, Tp HCM',N'Nhà mới xây',08,'02/02/2022'),
	(009,1,'15','2600000',N'332 Trần Văn Ơn, Tp HCM',N'Miễn phí giữ xe',09,'03/04/2022'),
	(010,2,'27','4500000',N'83 Năm Châu, Tp HCM',N'Giờ giấc tự do',10,'06/30/2021')

insert into DANHGIA values
	(01,01,N'Tốt',N'Nội thất đầy đủ, nhà trọ sạch đẹp. Nên thuê'),
	(02,02,N'Không tốt',N'Nhà cũ, cửa không chắc chắn'),
	(03,03,N'Tạm',N'Phù hợp mức giá'),
	(04,04,N'Không tốt',N'Tường bong tróc, trần bị thấm nước'),
	(05,05,N'Không tốt',N'Cống bị tắc nước, nước chảy yếu'),
	(06,06,N'Ổn',N'Phù hợp mức giá'),
	(07,07,N'Tốt',N'Yên tĩnh sạch sẽ'),
	(08,08,N'Tốt',N'An ninh tốt, thoáng mát'),
	(09,09,N'Tốt',N'Có bảo vệ giữ xe, thang máy, phòng rộng'),
	(010,010,N'Tạm',N'Phù hợp mức giá')