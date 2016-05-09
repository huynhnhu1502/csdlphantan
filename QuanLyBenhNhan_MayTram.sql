Create DATABASE QuanLyBenhNhan;
Use QuanLyBenhNhan

Create Table BENHNHAN(
		MaBN varchar(20) primary key not null,
		TenBN nvarchar(50) not null,
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30));
-----------------

Create table BHYT(
		SoThe varchar(20) primary key not null,
		MaBN varchar(20) not null,
		NgayCap datetime,
		NgayHHan datetime,
		Foreign key (MaBN) References BENHNHAN(MaBN));
-----------------

/*Nhân bảng*/
Create table KHOA(
		MaKhoa varchar(20) primary key not null,
		TenKhoa nvarchar(50) unique not null)
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

/*Nhân bảng*/
Create table DICHVU(
		MaDV varchar(20) primary key not null,
		TenDV nvarchar(50) unique not null,
		GiaDV decimal)
----------------

Create table SUDUNGDICHVU(
		MaSD varchar(20) primary key not null,
		NgaySD datetime,
		MaBN varchar(20) not null,
		TongTien decimal,
		Foreign key (MaBN) References BENHNHAN(MaBN))
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

/*Nhân bảng*/
Create table LOAIXETNGHIEM(
		MaLoaiXN varchar(20) primary key not null,
		TenLoaiXN nvarchar(50) unique not null,
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

/*Phân mảnh dọc*/
Create table THUOC(
		MaThuoc varchar(20) primary key not null,
		MoTa nvarchar(max),
		XuatXu nvarchar(max))
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

--Tạo thủ tục thêm dữ liệu bảng BENHNHAN
Create Proc ThemBenhNhan (
	@MaBN varchar(20),
	@TenBN nvarchar(50),
	@NgSinh datetime,
	@GioiTinh int,
	@DiaChi nvarchar(max),
	@SoDT varchar(30))
As
Begin
	--kiem tra ma ko duoc rong
	if (@MaBN is null or @MaBN='')
	Begin
		print N'Mã bệnh nhân không được rỗng'
		return
	End

	--kiem tra ma ko duoc trung
	if exists (Select * from BENHNHAN where MaBN=@MaBN) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where Mabn=@MaBN)
	Begin
		print N'Mã bệnh nhân đã tồn tại'
		return
	End

	if (@TenBN is null or @TenBN='')--ktra ten ko duoc rong
	Begin
		print N'Tên bệnh nhân không được rỗng'
		return
	End  

	if (@GioiTinh != 0 and @GioiTinh !=1)--ktra nhap gioi tinh
	Begin
		print N'Giới tính nữ: 0, giới tính nam: 1'
		return
	End

	if (@GioiTinh=0)
	Begin
		insert into BENHNHAN values(@MaBN, @TenBN, @NgSinh, @GioiTinh, @DiaChi, @SoDT)
		print N'Thêm thành công bệnh nhân ' + @TenBN
	End

	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN 
		values (@MaBN, @TenBN, @NgSinh, @GioiTinh, @DiaChi, @SoDT)
		print N'Thêm thành công bệnh nhân ' + @TenBN
	End
End
GO

--Tạo thủ tục thêm dữ liệu bảng BHYT
Create Proc ThemBHYT (
	@SoThe varchar(20),
	@MaBN varchar(20),
	@NgayCap datetime,
	@NgayHHan datetime)
As
Begin
	--kiem tra so the ko duoc rong
	if (@MaBN is null or @MaBN='')
	Begin
		print N'Số thẻ BHYT không được rỗng'
		return
	End

	--kiem tra so the ko duoc trung
	if exists (Select * from BHYT where SoThe=@SoThe) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT where SoThe=@SoThe)
	Begin
		print N'Số thẻ đã tồn tại'
		return
	End

	--kiem tra  MaBN co ton tai ko
	if (not exists (select * from BENHNHAN where MaBN=@MaBN)
	or not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN))
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End 
	
	declare @TenBN nvarchar(255) --bien tam

	--Them BHYT may chu theo benh nhan 
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into BHYT values(@SoThe, @MaBN, @NgayCap, @NgayHHan)		
		select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công BHYT của ' +  @TenBN
	End

	--Them BHYT may tram theo benh nhan 
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.BHYT values(@SoThe, @MaBN, @NgayCap, @NgayHHan)		
		select @TenBN=TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công BHYT của ' +  @TenBN
	End
End
GO