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

Create table KHOA(
		MaKhoa varchar(20) primary key not null,
		TenKhoa nvarchar(50) not null)
----------------

Create table BACSI(
		MaBS varchar(20) primary key not null,
		TenBS nvarchar(50) not null,
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30),
		MaKhoa varchar(20) not null,
		Foreign key (MaKhoa) References KHOA(MaKhoa));
----------------

Create table HOSOBENHAN(
		MaHS varchar(20) primary key not null,
		NgayBatDau datetime,
		NgayKetThuc datetime,
		KetQuaDieuTri nvarchar(max),
		ChiPhi decimal,
		MaBN varchar(20) not null,
		MaBS varchar(20) not null,
		ChanDoan nvarchar(max),
		NoiTru int,
		Foreign key (MaBN) References BENHNHAN(MaBN),
		Foreign key (MaBS) References BACSI(MaBS));
---------------

Create table DICHVU(
		MaDV varchar(20) primary key not null,
		TenDV nvarchar(50) not null,
		GiaDV decimal)
----------------

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

Create table DONTHUOC(
		MaDon varchar(20) primary key not null,
		NgayKham datetime,
		MaHS varchar(20),
		Foreign key (MaHS) References HOSOBENHAN(MaHS))
---------------

Create table THUOC(
		MaThuoc varchar(20) primary key not null,
		TenThuoc nvarchar(50) not null)

alter table THUOC alter column TenThuoc nvarchar(max) not null
alter table THUOC add MoTa nvarchar(max)
alter table THUOC add XuatXu nvarchar(max)
---------------

Create table CHITIETDONTHUOC(
		MaDon varchar(20) not null,
		MaThuoc varchar(20) not null,
		SoLuong int,
		CachDung nvarchar(max),
		Foreign key (MaDon) References DONTHUOC(MaDon),
		Foreign key (MaThuoc) References THUOC(MaThuoc),
		Primary key (MaDon, MaThuoc))
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


insert into BACSI(MaBS, TenBS, NgSinh, GioiTinh, DiaChi, SoDT, MaKhoa)
values('BS001', N'Vũ Duy Đông', '3/1/1982', 1, N'78/23/3 đường Cống Lở, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01228867678', 'K002'),
('BS002', N'Dương Cẩm Giang', '3/1/1981', 0, N'153/54 Trần Hưng Đạo, Phường Cầu Ông Lãnh, Quận 1, TP Hồ Chí Minh', '01229478717', 'K003'),
('BS003', N'Võ Thị Quỳnh Giao', '3/1/1980', 0, N'152 Đường số 1, Phường Tân Phú, Quận 7, TP Hồ Chí Minh', '01229677954', 'K004'),
('BS004', N'Lương Thị Thu Hà', '3/1/1979', 0, N'168 Đường số 1, Phường 16, Quận Gò Vấp, TP Hồ Chí Minh', '01229799523', 'K006'),
('BS005', N'Trần Phi Hổ', '12/1/1961', 1, N'81/11 Nguyễn Bỉnh Khiêm, Phường 1, Quận Gò Vấp, TP Hồ Chí Minh', '01229798783', 'K007'),
('BS006', N'Nguyễn Văn Huấn', '3/1/1972', 1, N'261/15/80/23 Tổ 5 Đình Phong Phú, Phường Tăng Nhơn Phú B, Quận 9, TP Hồ Chí Minh', '01233688869', 'K008'),
('BS007', N'Trần Phạm Thanh Huy', '3/7/1962', 1, N'368/15/1 Đường Hà Huy Giáp, phường Thạnh Lộc, Quận 12, TP Hồ Chí Minh', '01234305060', 'K009'),
('BS008', N'Nguyễn Thị Hàn Huyên', '3/5/1972', 0, N'124A, Đường Nguyễn Lâm, Phường 22, Quận Bình Thạnh, TP Hồ Chí Minh', '01234551240', 'K010'),
('BS009', N'Hồ Đức Khoa', '3/6/1992', 1, N'945/29 Quốc Lộ 1A, khu phố 1, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01234558191', 'K011'),
('BS010', N'Huỳnh Thị Mỹ Kim', '3/7/1990', 0, N'221/13 Trần Quang Khải, Phường Tân Định, Quận 1, TP Hồ Chí Minh', '0123472349', 'K012')



insert into DICHVU(MaDV, TenDV, GiaDV)
values('DV001', N'Khám lâm sàng (trong giờ làm việc)', 874000),
('DV002', N'Khám cấp cứu', 1587000),
('DV003', N'Lưu viện phòng đôi', 3266000),
('DV004', N'Lưu viện phòng đơn', 5566000),
('DV005', N'Lưu viện cách ly', 6325000),
('DV006', N'Lưu viện trong ngày', 1633000),
('DV007', N'Lưu viện tại ICU', 4370000)



insert into HOSOBENHAN(MaHS, NgayBatDau, NgayKetThuc, KetQuaDieuTri, ChiPhi, MaBN, MaBS, ChanDoan, NoiTru)
values('HS0000001', '1/1/2016', '1/31/2016', N'hết đau nhức các khớp', 875000, 'BN000001', 'BS001', N'viêm khớp', 1),
('HS0000002', '2/1/2016', '1/3/2016', N'hết nổi mẩn ngứa', 530000, 'BN000002', 'BS002', N'nổi mẩn ngứa do nấm', 0),
('HS0000003', '3/1/2016', '1/20/2016', N'hết đau mắt', 220000, 'BN000003', 'BS003', N'đau mắt đỏ', 1),
('HS0000004', '4/1/2016', '1/11/2016', N'hết nhức răng', 180000, 'BN000004', 'BS004', N'nhức răng', 0),
('HS0000005', '5/1/2016', '3/3/2016', N'ổn định', 874000, 'BN000005', 'BS005', N'đau nửa đầu', 1),
('HS0000006', '6/1/2016', '2/2/2016', N'giảm các cơn đau', 350000, 'BN000006', 'BS006', N'đau dạ dày', 0),
('HS0000007', '7/1/2016', '11/15/2016', N'hết sốt', 890000, 'BN000007', 'BS007', N'sốt', 1),
('HS0000008', '8/1/2016', '1/4/2016', N'hết căng thẳng', 760000, 'BN000008', 'BS008', N'căng thẳng quá độ', 0),
('HS0000009', '9/1/2016', '3/4/2016', N'ngủ bình thường', 360000, 'BN000009', 'BS009', N'mất ngủ do rối loạn chức năng thần kinh', 1),
('HS0000010', '10/1/2016', '2/2/2016', N'hết lang beng', 80000, 'BN000010', 'BS010', N'lang beng', 0)


insert into LOAIXETNGHIEM(MaLoaiXN, TenLoaiXN, DonGia)
values('LXH0001', N'Xét nghiệm hóa sinh', 450000),
('LXH0002', N'Xét nghiệm huyết học', 500000),
('LXH0003', N'Xét nghiệm miễn dịch', 455000),
('LXH0004', N'Xét nghiệm tế bào học', 450000),
('LXH0005', N' Xét nghiệm vi khuẩn, ký sinh trùng', 550000),
('LXH0006', N' Xét nghiệm nội tiết', 350000)


insert into PHIEUXETNGHIEM(MaPhieuXN, MaBN, NgayXN, LyDoXN)
values('PXH0000001', 'BN000001', '1/4/2016', N'kiểm tra hàm lượng đường trong máu'),
('PXH0000002', 'BN000002', '1/3/2016', N'mẩn ngứa'),
('PXH0000003', 'BN000003', '2/3/2016', N'kiểm tra kháng thể viêm gan B'),
('PXH0000004', 'BN000004', '12/2/2016', N'kiểm tra kháng thể sởi'),
('PXH0000005', 'BN000005', '9/1/2016', N'kiểm tra lượng dịch mật'),
('PXH0000006', 'BN000006', '4/10/2016', N'kiểm tra virus cúm'),
('PXH0000007', 'BN000007', '2/12/2016', N'kiểm tra men gan'),
('PXH0000008', 'BN000008', '2/20/2016', N'kiểm tra hàm lượng đường trong máu'),
('PXH0000009', 'BN000009', '3/23/2016', N'xét nghiệm kháng thể viêm gan B'),
('PXH0000010', 'BN000010', '3/19/2016', N'xét nghiệm lượng hồng cầu trong máu')


insert into CHITIETXETNGHIEM(MaPhieuXN, MaLoaiXN, KetQuaXN)
values('PXH0000001', 'LXH0001', N'bình thường'),
('PXH0000002', 'LXH0002', N'nhiễm giun'),
('PXH0000002', 'LXH0003', N'vẫn còn miễn dịch'),
('PXH0000003', 'LXH0004', N'vẫn còn miễn dịch'),
('PXH0000004', 'LXH0005', N'bình thường'),
('PXH0000005', 'LXH0005', N'bình thường'),
('PXH0000006', 'LXH0006', N'không phát hiện'),
('PXH0000007', 'LXH0001', N'men gan cao hơn 1.1'),
('PXH0000008', 'LXH0002', N'cao hơn bình thường'),
('PXH0000009', 'LXH0003', N'bình thường'),
('PXH0000010', 'LXH0004', N'bình thường'),
('PXH0000010', 'LXH0001', N'bình thường')


insert into SUDUNGDICHVU(MaSD, NgaySD, MaBN, TongTien)
values('SDDV0001', '1/4/2016', 'BN000001', 874000),
('SDDV0002', '2/4/2016', 'BN000002', 1587000),
('SDDV0003', '3/4/2016', 'BN000003', 3266000),
('SDDV0004', '4/4/2016', 'BN000004', 5566000),
('SDDV0005', '5/4/2016', 'BN000005', 3266000),
('SDDV0006', '6/4/2016', 'BN000006', 3266000),
('SDDV0007', '7/4/2016', 'BN000007', 3266000),
('SDDV0008', '8/4/2016', 'BN000008', 874000),
('SDDV0009', '9/4/2016', 'BN000009', 1587000),
('SDDV0010', '10/4/2016', 'BN000010', 3266000)


insert into CHITIETSDDICHVU(MaSD, MaDV, SoLuongDV, ThanhTien)
values('SDDV0001', 'DV001', 1, 874000),
('SDDV0002', 'DV002', 1, 1587000),
('SDDV0003', 'DV003', 1, 3266000),
('SDDV0004', 'DV004', 1, 5566000),
('SDDV0005', 'DV005', 1, 3266000),
('SDDV0006', 'DV006', 1, 3266000),
('SDDV0007', 'DV006', 1, 3266000),
('SDDV0008', 'DV001', 1, 874000),
('SDDV0009', 'DV002', 1, 1587000),
('SDDV0010', 'DV003', 1, 3266000)


insert into DONTHUOC(MaDon, NgayKham, MaHS)
values('DON000001', '2016-03-12', 'HS0000001'),
('DON000002', '2016-02-10', 'HS0000002'),
('DON000003', '2016-01-15', 'HS0000003'),
('DON000004', '2016-03-15', 'HS0000004'),
('DON000005', '2016-03-16', 'HS0000005'),
('DON000006', '2016-03-17', 'HS0000006'),
('DON000007', '2016-03-18', 'HS0000007'),
('DON000008', '2016-03-19', 'HS0000008'),
('DON000009', '2016-03-20', 'HS0000009'),
('DON000010', '2016-03-21', 'HS0000010')


insert into THUOC(MaThuoc, TenThuoc, MoTa, XuatXu)
values('T0000001', 'EMTRIVA ORAL CAPSULE', N'Trị đau nửa đầu', N'Ấn Độ'),
('T0000002', 'EPIVIR HBV ORAL SOLUTION', N'Trị đau dạ dày', N'Pháp'),
('T0000003', 'FUZEON SUBCUTANEOUS RECON SOLN', N'Trị đau nhức khớp', N'Pháp'),
('T0000004', 'GENVOYA', N'Trị đau nhức cơ', N'Hàn Quốc'),
('T0000005', 'INTELENCE ORAL TABLET 100 MG', N'Hỗ trợ men gan', N'Pháp'),
('T0000006', 'KALETRA ORAL TABLET 100-25 MG', N'Hỗ trợ tuần hoàn máu', N'Ấn Độ'),
('T0000007', 'PREZISTA ORAL TABLET 150 MG', N'Hỗ trợ hệ thần kinh', N'Pháp'),
('T0000008', 'REYATAZ ORAL CAPSULE 150 MG', N'Hỗ trợ thoái hóa xương khớp', N'Pháp'),
('T0000009', 'SUSTIVA ORAL CAPSULE 200 MG ', N'Hỗ trợ hệ miễn dịch', N'Ấn Độ'),
('T0000010', 'VIDEX 2 GRAM PEDIATRIC', N'Hỗ trợ tim mạch', N'Pháp'),
('T0000011', 'VIRACEPT ORAL TABLET 250 MG', N'Tăng cường dịch mật', N'Ấn Độ'),
('T0000012', 'CEFTRIAXONE INJECTION RECON SOLN 100 $0-7.40 (Tier 2) GRAM', N'Tăng cường máu lên não', N'Pháp'),
('T0000013', 'ERYTHROCIN INTRAVENOUS RECON SOLN $0-7.40 (Tier 2) 500 MG', N'Hỗ trợ hệ thần kinh ngoại biên', N'Pháp'),
('T0000014', 'ALINIA ORAL SUSPENSION FOR $0-7.40 (Tier 2) MO; QLL (180 per 3 days) RECONSTITUTION', N'Diệt virus EV', N'Pháp'),
('T0000015', 'AZACTAM IN DEXTROSE (ISO-OSM)', N'Hỗ trợ điều trị trầm cảm', N'Hàn Quốc'),
('T0000016', 'CAPASTAT', N'Trị sỏi thận', N'Pháp'),
('T0000017', 'DAPSONE', N'Diệt giun', N'Ấn Độ'),
('T0000018', 'NEBUPENT', N'Hỗ trợ ổn định huyết áp', N'Pháp'),
('T0000019', 'PENTAM', N'Chống đông máu', N'Pháp'),
('T0000020', 'PRIMAQUINE', N'Tăng cường miễn dịch tuyến tụy', N'Ấn Độ')


insert into CHITIETDONTHUOC(MaDon, MaThuoc, SoLuong, CachDung)
values('DON000001', 'T0000001', 90, N'Ngày 3 lần'),
('DON000001', 'T0000002', 30, N'Ngày 1 lần'),
('DON000001', 'T0000003', 60, N'Ngày 2 lần'),
('DON000002', 'T0000001', 90, N'Ngày 3 lần'),
('DON000002', 'T0000006', 60, N'Ngày 2 lần'),
('DON000003', 'T0000007', 30, N'Ngày 1 lần'),
('DON000003', 'T0000009', 60, N'Ngày 2 lần'),
('DON000003', 'T0000011', 90, N'Ngày 3 lần'),
('DON000004', 'T0000002', 60, N'Ngày 2 lần'),
('DON000004', 'T0000005', 30, N'Ngày 1 lần'),
('DON000005', 'T0000003', 60, N'Ngày 2 lần'),
('DON000005', 'T0000012', 60, N'Ngày 2 lần'),
('DON000005', 'T0000010', 90, N'Ngày 3 lần'),
('DON000006', 'T0000014', 30, N'Ngày 1 lần'),
('DON000006', 'T0000016', 30, N'Ngày 1 lần'),
('DON000006', 'T0000018', 60, N'Ngày 2 lần'),
('DON000007', 'T0000019', 90, N'Ngày 3 lần'),
('DON000007', 'T0000013', 60, N'Ngày 2 lần'),
('DON000008', 'T0000011', 90, N'Ngày 3 lần'),
('DON000008', 'T0000001', 60, N'Ngày 2 lần'),
('DON000009', 'T0000004', 90, N'Ngày 3 lần'),
('DON000009', 'T0000006', 90, N'Ngày 3 lần'),
('DON000010', 'T0000008', 60, N'Ngày 2 lần'),
('DON000010', 'T0000017', 90, N'Ngày 3 lần'),
('DON000010', 'T0000019', 30, N'Ngày 1 lần')