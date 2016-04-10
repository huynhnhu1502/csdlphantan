Use QuanLyBenhNhan

Create Table BENHNHAN(
		MaBN varchar(20) primary key not null,
		TenBN nvarchar(50),
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30));

alter table BENHNHAN alter column MaBN varchar(20) not null;
alter table BENHNHAN alter column TenBN nvarchar(50) not null;
----------

Create table BHYT(
		SoThe varchar(20) primary key,
		MaBN varchar(20),
		NgayCap datetime,
		NgayHHan datetime,
		Foreign key (MaBN) References BENHNHAN(MaBN));

alter table BHYT alter column SoThe varchar(20) not null;
alter table BHYT alter column MaBN varchar(20) not null;
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
		MaLoaiXN varchar(20) not null,
		MaBN varchar(20),
		NgayXN datetime,
		KetQuaXN nvarchar(max),
		LyDoXN nvarchar(max),
		Foreign key (MaLoaiXN) References LOAIXETNGHIEM(MaLoaiXN),
		Foreign key (MaBN) References BENHNHAN(MaBN))
-----------------

Create table SUDUNGDICHVU(
		MaSD varchar(20) primary key not null,
		NgaySD datetime,
		SoLuongDV int,
		MaBN varchar(20),
		MaDV varchar(20),
		Foreign key (MaBN) References BENHNHAN(MaBN),
		Foreign key (MaDV) References DICHVU(MaDV))

alter table SUDUNGDICHVU alter column MaBN varchar(20) not null
alter table SUDUNGDICHVU alter column MaDV varchar(20) not null
-------------

Create table DONTHUOC(
		MaDon varchar(20) primary key not null,
		TenThuoc nvarchar(50) not null,
		SoLuong int,
		MaBN varchar(20) not null,
		CachDung nvarchar(max) not null,
		Foreign key (MaBN) References BENHNHAN(MaBN))