Create DATABASE QuanLyBenhNhan;
Use QuanLyBenhNhan

Create Table BENHNHAN(
		MaBN varchar(20) primary key not null,
		TenBN nvarchar(50) not null,
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30));

/*alter table BENHNHAN alter column MaBN varchar(20) not null;
alter table BENHNHAN alter column TenBN nvarchar(50) not null;*/
----------

Create table BHYT(
		SoThe varchar(20) primary key not null,
		MaBN varchar(20) not null,
		NgayCap datetime,
		NgayHHan datetime,
		Foreign key (MaBN) References BENHNHAN(MaBN));

/*alter table BHYT alter column SoThe varchar(20) not null;
alter table BHYT alter column MaBN varchar(20) not null;*/
-------------

Create table BACSI(
		MaBS varchar(20) primary key not null,
		TenBS nvarchar(50) not null,
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30))
----------------

Create table KHOA(
		MaKhoa varchar(20) primary key not null,
		TenKhoa nvarchar(50) not null)
----------------

Create table DICHVU(
		MaDV varchar(20) primary key not null,
		TenDV nvarchar(50) not null,
		GiaDV decimal)
----------------

Create table HOSOBENHAN(
		MaHS varchar(20) primary key not null,
		NgayBatDau datetime,
		NgayKetThuc datetime,
		KetQuaDieuTri nvarchar(max),
		ChiPhi decimal,
		MaKhoa varchar(20) not null,
		MaBN varchar(20) not null,
		MaBS varchar(20) not null,
		ChanDoan nvarchar(max),
		NoiTru int,
		Foreign key (MaKhoa) References KHOA(MaKhoa),
		Foreign key (MaBN) References BENHNHAN(MaBN),
		Foreign key (MaBS) References BACSI(MaBS));
---------------

Create table LOAIXETNGHIEM(
		MaLoaiXN varchar(20) primary key not null,
		TenLoaiXN nvarchar(50) not null,
		DonGia decimal)
---------------

Create table PHIEUXETNGHIEM(
		MaPhieuXN varchar(20) primary key not null,
		MaBN varchar(20),
		NgayXN datetime,
		LyDoXN nvarchar(max),
		Foreign key (MaBN) References BENHNHAN(MaBN))
-----------------

Create table CHITIETXETNGHIEM(
		MaPhieuXN varchar(20) not null,
		MaLoaiXN varchar(20) not null,
		KetQuaXN nvarchar(max),
		Foreign key (MaPhieuXN) References PHIEUXETNGHIEM(MaPhieuXN),
		Foreign key (MaLoaiXN) References LOAIXETNGHIEM(MaLoaiXN))

alter table CHITIETXETNGHIEM add primary key(MaPhieuXN, MaLoaiXN);
-----------------

Create table SUDUNGDICHVU(
		MaSD varchar(20) primary key not null,
		NgaySD datetime,
		MaBN varchar(20) not null,
		TongTien decimal,
		Foreign key (MaBN) References BENHNHAN(MaBN))

/*alter table SUDUNGDICHVU alter column MaBN varchar(20) not null
alter table SUDUNGDICHVU alter column MaDV varchar(20) not null*/
-------------

Create table CHITIETSDDICHVU(
		MaSD varchar(20) not null,
		MaDV varchar(20) not null,
		SoLuongDV int,
		ThanhTien decimal,
		Foreign key (MaSD) References SUDUNGDICHVU(MaSD),
		Foreign key (MaDV) References DICHVU(MaDV),
		Primary key (MaSD, MaDV));
--------------

Create table DONTHUOC(
		MaDon varchar(20) primary key not null,
		TenThuoc nvarchar(50) not null,
		SoLuong int,
		MaBN varchar(20) not null,
		CachDung nvarchar(max) not null,
		Foreign key (MaBN) References BENHNHAN(MaBN))
---------------

insert into BENHNHAN(MaBN, TenBN, NgSinh, GioiTinh, DiaChi, SoDT) 
values('BN000001', N'Phạm Minh Vũ', '9/1/1992', 1, N'19 Nguyễn Trọng Trí, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01204845707'), 
('BN000002', N'Phạm Nguyễn Bình', '5/4/1992', 1, N'35 Nguyễn Bỉnh Khiêm, Phường Đa Kao, Quận 1, TP Hồ Chí Minh', '01212022030'), 
('BN000003', N'Trần Thị Bút', '11/8/1991', 0, N'301F Bình Đông, Phường 14, Quận 8, TP Hồ Chí Minh', '01212097597'), 
('BN000004', N'Phạm Thị Kim Cương', '2/4/1992', 0, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'), 
('BN000005', N'Đỗ Mỹ Hằng', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'), 
('BN000006', N'Dương Thị Thanh Hương', '1/2/1990', 0, N'47 Phạm Viết Chánh, Phường Nguyễn Cư Trinh, Quận 1, TP Hồ Chí Minh', '01212568080'), 
('BN000007', N'Lê Thị Kiều Hạnh', '2/1/1991', 0, N'109/24 Trương Phước Phan, Phường Bình Trị Đông, Quận Bình Tân, TP Hồ Chí Minh', '01212084352'), 
('BN000008', N'Chung Yến Loan', '1/1/1993', 0, N'28/22A đường Đỗ Quang Đẩu, Phường Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '01212777768'), 
('BN000009', N'Trương Thị Mỹ Ngọc', '6/1/1991', 0, N'83/27/4 Phạm Văn Bạch, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01212882279'), 
('BN000010', N'Phan Thị Hồng Phúc', '3/1/1994', 0, N'141 Nguyễn Đức Cảnh, Khu phố Mỹ Phúc, Phường Tân Phong, Quận 7, TP Hồ Chí Minh', '01213141655') 

		
insert into BHYT(SoThe, MaBN, NgayCap, NgayHHan) 
values('SV0001BH', 'BN000001', '1/1/2016', '1/1/2017'), 
('SV0002BH', 'BN000002', '2/1/2016', '2/1/2017'), 
('SV0003BH', 'BN000003', '3/1/2016', '3/1/2017'), 
('SV0004BH', 'BN000004', '4/1/2016', '4/1/2017'), 
('SV0005BH', 'BN000005', '5/1/2016', '5/1/2017'), 
('SV0006BH', 'BN000006', '6/1/2016', '6/1/2017'), 
('SV0007BH', 'BN000007', '7/1/2016', '7/1/2017'), 
('SV0008BH', 'BN000008', '8/1/2016', '8/1/2017'), 
('SV0009BH', 'BN000009', '9/1/2016', '9/1/2017'), 		
('SV0010BH', 'BN000010', '10/1/2016', '10/1/2017') 

		
insert into BACSI(MaBS, TenBS, NgSinh, GioiTinh, DiaChi, SoDT) 
values('BS001', N'Vũ Duy Đông', '3/1/1982', 1, N'78/23/3 đường Cống Lở, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01228867678'), 	
('BS002', N'Dương Cẩm Giang', '3/1/1981', 0, N'153/54 Trần Hưng Đạo, Phường Cầu Ông Lãnh, Quận 1, TP Hồ Chí Minh', '01229478717'),
('BS003', N'Võ Thị Quỳnh Giao', '3/1/1980', 0, N'152 Đường số 1, Phường Tân Phú, Quận 7, TP Hồ Chí Minh', '01229677954'),
('BS004', N'Lương Thị Thu Hà', '3/1/1979', 0, N'168 Đường số 1, Phường 16, Quận Gò Vấp, TP Hồ Chí Minh', '01229799523'),
('BS005', N'Trần Phi Hổ', '12/1/1961', 1, N'81/11 Nguyễn Bỉnh Khiêm, Phường 1, Quận Gò Vấp, TP Hồ Chí Minh', '01229798783'),
('BS006', N'Nguyễn Văn Huấn', '3/1/1972', 1, N'261/15/80/23 Tổ 5 Đình Phong Phú, Phường Tăng Nhơn Phú B, Quận 9, TP Hồ Chí Minh', '01233688869'),
('BS007', N'Trần Phạm Thanh Huy', '3/7/1962', 1, N'368/15/1 Đường Hà Huy Giáp, phường Thạnh Lộc, Quận 12, TP Hồ Chí Minh', '01234305060'),
('BS008', N'Nguyễn Thị Hàn Huyên', '3/5/1972', 0, N'124A, Đường Nguyễn Lâm, Phường 22, Quận Bình Thạnh, TP Hồ Chí Minh', '01234551240'),
('BS009', N'Hồ Đức Khoa', '3/6/1992', 1, N'945/29 Quốc Lộ 1A, khu phố 1, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01234558191'),
('BS010', N'Huỳnh Thị Mỹ Kim', '3/7/1990', 0, N'221/13 Trần Quang Khải, Phường Tân Định, Quận 1, TP Hồ Chí Minh', '0123472349')

		
insert into KHOA(MaKhoa, TenKhoa) 
values('K001', N'Chấn thương & Chỉnh hình'),
('K002', N'Da liễu & Hoa liễu'), 
('K003', N'Gây mê & Hồi sức'), 
('K004', N'Hô hấp & Dị ứng'), 
('K005', N'Mắt'), 
('K006', N'Nha & Chỉnh nha'), 
('K007', N'Nhi khoa'), 
('K008', N'Nội đa khoa'), 
('K009', N'Nội thần kinh'), 
('K010', N'Phẫu thuật ổ bụng'), 
('K011', N'Phẫu thuật thần kinh'), 
('K012', N'Sản & Phụ khoa'), 
('K013', N'Tai Mũi Họng & Phẫu thuật vùng Mặt và Cổ'),  
('K014', N'Tiết niệu'),  
('K015', N'Tiêu hóa'),  
('K016', N'Tim mạch'),  
('K017', N'Tư vấn tâm lý & Tâm thần')   

		
		
insert into DICHVU(MaDV, TenDV, GiaDV) 
values('DV001', N'Khám lâm sàng (trong giờ làm việc)', 874000),		
('DV002', N'Khám cấp cứu', 1587000),	
('DV003', N'Lưu viện phòng đôi', 3266000),	
('DV004', N'Lưu viện phòng đơn', 5566000),	
('DV005', N'Lưu viện cách ly', 6325000),	
('DV006', N'Lưu viện trong ngày', 1633000),	
('DV007', N'Lưu viện tại ICU', 4370000)	



insert into HOSOBENHAN(MaHS, NgayBatDau, NgayKetThuc, KetQuaDieuTri, ChiPhi, MaKhoa, MaBN, MaBS, ChanDoan) 
values('HS0000001', '1/1/2016', '1/31/2016', N'hết đau nhức các khớp', 875000, 'K001', 'BN000001', 'BS001', N'viêm khớp'),
('HS0000002', '2/1/2016', '1/3/2016', N'hết nổi mẩn ngứa', 530000, 'K002', 'BN000002', 'BS002', N'nổi mẩn ngứa do nấm'),
('HS0000003', '3/1/2016', '1/20/2016', N'hết đau mắt', 220000, 'K005', 'BN000003', 'BS003', N'đau mắt đỏ'),
('HS0000004', '4/1/2016', '1/11/2016', N'hết nhức răng', 180000, 'K006', 'BN000004', 'BS004', N'nhức răng'),
('HS0000005', '5/1/2016', '3/3/2016', N'ổn định', 874000, 'K009', 'BN000005', 'BS005', N'đau nửa đầu'),
('HS0000006', '6/1/2016', '2/2/2016', N'giảm các cơn đau', 350000, 'K015', 'BN000006', 'BS006', N'đau dạ dày'),
('HS0000007', '7/1/2016', '11/15/2016', N'hết sốt', 890000, 'K008', 'BN000007', 'BS007', N'sốt'),
('HS0000008', '8/1/2016', '1/4/2016', N'hết căng thẳng', 760000, 'K009', 'BN000008', 'BS008', N'căng thẳng quá độ'),
('HS0000009', '9/1/2016', '3/4/2016', N'ngủ bình thường', 360000, 'K009', 'BN000009', 'BS009', N'mất ngủ do rối loạn chức năng thần kinh'),
('HS0000010', '10/1/2016', '2/2/2016', N'hết lang beng', 80000, 'K002', 'BN000010', 'BS010', N'lang beng')

		
insert into LOAIXETNGHIEM(MaLoaiXN, TenLoaiXN, DonGia) 
values('LXH0001', N'Xét nghiệm hóa sinh', 450000),	
('LXH0002', N'Xét nghiệm huyết học', 500000),
('LXH0003', N'Xét nghiệm miễn dịch', 455000),
('LXH0004', N'Xét nghiệm tế bào học', 450000),
('LXH0005', N' Xét nghiệm vi khuẩn, ký sinh trùng', 550000),
('LXH0006', N' Xét nghiệm nội tiết', 350000)


insert into PHIEUXETNGHIEM(MaPhieuXN, MaLoaiXN, MaBN, NgayXN, KetQuaXN, LyDoXN) 
values('PXH0000001', 'LXH0001', 'BN000001', '1/4/2016', N'bình thường', N'kiểm tra hàm lượng đường trong máu'),
('PXH0000002', 'LXH0002', 'BN000002', '1/3/2016', N'nhiễm giun', N'mẩn ngứa'),
('PXH0000003', 'LXH0003', 'BN000003', '2/3/2016', N'vẫn còn miễn dịch', N'kiểm tra kháng thể viêm gan B'),
('PXH0000004', 'LXH0004', 'BN000004', '12/2/2016', N'vẫn còn miễn dịch', N'kiểm tra kháng thể sởi'),
('PXH0000005', 'LXH0005', 'BN000005', '9/1/2016', N'bình thường', N'kiểm tra lượng dịch mật'),
('PXH0000006', 'LXH0006', 'BN000006', '4/10/2016', N'không phát hiện', N'kiểm tra virus cúm'),
('PXH0000007', 'LXH0001', 'BN000007', '2/12/2016', N'men gan cao hơn 1.1', N'kiểm tra men gan'),
('PXH0000008', 'LXH0002', 'BN000008', '2/20/2016', N'cao hơn bình thường', N'kiểm tra hàm lượng đường trong máu'),
('PXH0000009', 'LXH0003', 'BN000009', '3/23/2016', N'bình thường', N'xét nghiệm kháng thể viêm gan B'),		
('PXH0000010', 'LXH0004', 'BN000010', '3/19/2016', N'bình thường', N'xét nghiệm lượng hồng cầu trong máu')

		
insert into SUDUNGDICHVU(MaSD, NgaySD, SoLuongDV, MaBN, MaDV) 
values('SDDV0001', '1/4/2016', '1', 'BN000001', 'DV001'),
('SDDV0002', '2/4/2016', '1', 'BN000002', 'DV002'),	
('SDDV0003', '3/4/2016', '1', 'BN000003', 'DV003'),	
('SDDV0004', '4/4/2016', '1', 'BN000004', 'DV004'),	
('SDDV0005', '5/4/2016', '1', 'BN000005', 'DV005'),		
('SDDV0006', '6/4/2016', '1', 'BN000006', 'DV006'),
('SDDV0007', '7/4/2016', '1', 'BN000007', 'DV006'),
('SDDV0008', '8/4/2016', '1', 'BN000008', 'DV001'),
('SDDV0009', '9/4/2016', '1', 'BN000009', 'DV002'),
('SDDV0010', '10/4/2016', '1', 'BN000010', 'DV003')


		
insert into DONTHUOC(MaDon, TenThuoc, SoLuong, MaBN, CachDung) 
values('DON000001','Tetracycline 500mg, Metrogyl Denta Gel 10mg', 180, 'BN000001', N'ngày 3 lần mỗi lần 1 viên'),
('DON000002','Neurontin 300mg, Vinsamin 250mg', 180, 'BN000002', N'ngày 3 lần mỗi lần 1 viên'),
('DON000003','Timolol 0,5%', 1, 'BN000003', N'ngày nhở mắt 3 lần'),
('DON000004','Symbicort Turbuhaler-160/4,5mcg', 1, 'BN000004', N'mỗi ngày xịt 3 lần'),
('DON000005','Oliza – 10 10 mg', 90, 'BN000005', N'ngày 3 lần mỗi lần 1 viên'),
('DON000006','Xatral XL 10mg', 90, 'BN000006', N'ngày 3 lần mỗi lần 1 viên'),
('DON000007','Colocol 500mg', 90, 'BN000007', N'ngày 3 lần mỗi lần 1 viên'),
('DON000008','Digelase', 90, 'BN000008', N'ngày 3 lần mỗi lần 1 viên'),
('DON000009','Topsukan 80mg', 90, 'BN000009', N'ngày 3 lần mỗi lần 1 viên'),
('DON000010','Ibu-acetalvic 300mg', 90, 'BN000010', N'ngày 3 lần mỗi lần 1 viên')

