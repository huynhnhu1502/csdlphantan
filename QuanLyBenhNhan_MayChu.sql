Create DATABASE QuanLyBenhNhan;
Use QuanLyBenhNhan

/*------------TẠO BẢNG--------------*/
Create Table BENHNHAN(
		MaBN varchar(20) primary key not null,
		TenBN nvarchar(50) not null,
		NgSinh datetime,
		GioiTinh int,
		DiaChi nvarchar(max),
		SoDT varchar(30));
GO
-----------------

Create table BHYT(
		SoThe varchar(20) primary key not null,
		MaBN varchar(20) not null,
		NgayCap datetime,
		NgayHHan datetime,
		Foreign key (MaBN) References BENHNHAN(MaBN));
GO
-----------------

/*Nhân bảng*/
Create table KHOA(
		MaKhoa varchar(20) primary key not null,
		TenKhoa nvarchar(50) unique not null)
GO
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
GO
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
GO
---------------

/*Nhân bảng*/
Create table DICHVU(
		MaDV varchar(20) primary key not null,
		TenDV nvarchar(50) unique not null,
		GiaDV decimal)
GO
----------------

Create table SUDUNGDICHVU(
		MaSD varchar(20) primary key not null,
		NgaySD datetime,
		MaBN varchar(20) not null,
		TongTien decimal,
		Foreign key (MaBN) References BENHNHAN(MaBN))
GO
-------------

Create table CHITIETSDDICHVU(
		MaSD varchar(20) not null,
		MaDV varchar(20) not null,
		SoLuongDV int,
		ThanhTien decimal,
		Foreign key (MaSD) References SUDUNGDICHVU(MaSD),
		Foreign key (MaDV) References DICHVU(MaDV),
		Primary key (MaSD, MaDV));
GO
--------------

/*Nhân bảng*/
Create table LOAIXETNGHIEM(
		MaLoaiXN varchar(20) primary key not null,
		TenLoaiXN nvarchar(50) unique not null,
		DonGia decimal)
GO
---------------

Create table PHIEUXETNGHIEM(
		MaPhieuXN varchar(20) primary key not null,
		MaBN varchar(20),
		NgayXN datetime,
		LyDoXN nvarchar(max),
		Foreign key (MaBN) References BENHNHAN(MaBN))
GO
-----------------

Create table CHITIETXETNGHIEM(
		MaPhieuXN varchar(20) not null,
		MaLoaiXN varchar(20) not null,
		KetQuaXN nvarchar(max),
		Foreign key (MaPhieuXN) References PHIEUXETNGHIEM(MaPhieuXN),
		Foreign key (MaLoaiXN) References LOAIXETNGHIEM(MaLoaiXN),
		Primary key (MaPhieuXN, MaLoaiXN))
GO

/*alter table CHITIETXETNGHIEM add primary key(MaPhieuXN, MaLoaiXN)*/
-----------------

Create table DONTHUOC(
		MaDon varchar(20) primary key not null,
		NgayKham datetime,
		MaHS varchar(20),
		Foreign key (MaHS) References HOSOBENHAN(MaHS))
GO
---------------

/*Phân mảnh dọc*/
Create table THUOC(
		MaThuoc varchar(20) primary key not null,
		TenThuoc nvarchar(max) not null)
GO
---------------

Create table CHITIETDONTHUOC(
		MaDon varchar(20) not null,
		MaThuoc varchar(20) not null,
		SoLuong int,
		CachDung nvarchar(max),
		Foreign key (MaDon) References DONTHUOC(MaDon),
		Foreign key (MaThuoc) References THUOC(MaThuoc),
		Primary key (MaDon, MaThuoc))
GO
---------------


/*-------------------TẠO KẾT NỐITỪ XA-----------------*/

-- Tạo mới một login tới linked server (từ máy chủ link đến máy ảo)
EXEC sp_addlinkedserver
@server = N'SQL_Home',
@provider=N'SQLOLEDB',
@datasrc= N'192.168.200.103\SQLexpress',
@srvproduct='SQLProduct'
GO

--- Kiểm tra kết nối
EXEC sp_linkedservers
GO

-- Thực hiện kết nối, đăng nhập tới linked server
EXEC master.dbo.sp_addlinkedsrvlogin
@rmtsrvname=N'SQL_Home',
@useself=N'False',
@locallogin=NULL,
@rmtuser=N'sa', 
@rmtpassword='123456'
GO

/*-------------------THÊM DỮ LIỆU------------------*/

---------*********BENHNHAN*********---------
----Tạo thủ tục ===THÊM=== dữ liệu bảng BENHNHAN
Create Proc ThemBenhNhan (
	@MaBN varchar(20),
	@TenBN nvarchar(50),
	@NgSinh datetime,
	@GioiTinh int,
	@DiaChi nvarchar(max),
	@SoDT varchar(30))
As
Begin
	--Kiểm tra mã không được rỗng
	if (@MaBN is null or @MaBN='')
	Begin
		print N'Mã bệnh nhân không được rỗng'
		return
	End

	--Kiểm tra mã không được trùng
	if exists (Select * from BENHNHAN where MaBN=@MaBN) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where Mabn=@MaBN)
	Begin
		print N'Mã bệnh nhân đã tồn tại'
		return
	End

	--Kiểm tra tên không được rỗng
	if (@TenBN is null or @TenBN='')
	Begin
		print N'Tên bệnh nhân không được rỗng'
		return
	End  

	--Kiểm tra nhập giới tính
	if (@GioiTinh != 0 and @GioiTinh !=1)
	Begin
		print N'Giới tính nữ: 0, giới tính nam: 1'
		return
	End

	--Phân mảnh theo giới tính
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

---Thêm dữ liệu vào bảng
Exec ThemBenhNhan 'BN000001', N'Phạm Minh Vũ', '9/1/1992', 1, N'19 Nguyễn Trọng Trí, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01204845707'
Exec ThemBenhNhan 'BN000002', N'Phạm Nguyễn Bình', '5/4/1992', 1, N'35 Nguyễn Bỉnh Khiêm, Phường Đa Kao, Quận 1, TP Hồ Chí Minh', '01212022030'
Exec ThemBenhNhan 'BN000003', N'Trần Thị Bút', '11/8/1991', 0, N'301F Bình Đông, Phường 14, Quận 8, TP Hồ Chí Minh', '01212097597'
Exec ThemBenhNhan 'BN000004', N'Phạm Thị Kim Cương', '2/4/1992', 0, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'
Exec ThemBenhNhan 'BN000005', N'Đỗ Mỹ Hằng', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'
Exec ThemBenhNhan 'BN000006', N'Dương Thị Thanh Hương', '1/2/1990', 0, N'47 Phạm Viết Chánh, Phường Nguyễn Cư Trinh, Quận 1, TP Hồ Chí Minh', '01212568080'
Exec ThemBenhNhan 'BN000007', N'Lê Thị Kiều Hạnh', '2/1/1991', 0, N'109/24 Trương Phước Phan, Phường Bình Trị Đông, Quận Bình Tân, TP Hồ Chí Minh', '01212084352'
Exec ThemBenhNhan 'BN000008', N'Chung Yến Loan', '1/1/1993', 0, N'28/22A đường Đỗ Quang Đẩu, Phường Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '01212777768'
Exec ThemBenhNhan 'BN000009', N'Trương Thị Mỹ Ngọc', '6/1/1991', 0, N'83/27/4 Phạm Văn Bạch, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01212882279'
Exec ThemBenhNhan 'BN000010', N'Phan Thị Hồng Phúc', '3/1/1994', 0, N'141 Nguyễn Đức Cảnh, Khu phố Mỹ Phúc, Phường Tân Phong, Quận 7, TP Hồ Chí Minh', '01213141655'
Exec ThemBenhNhan 'BN000011', N'Trần Minh Thái', '3/1/1956', 1, N'141 Phạm Thế Hiển, Phường 9, Quận 8, TP Hồ Chí Minh', '01213141234'

--Kiểm tra các trường hợp
Exec ThemBenhNhan 'BN000011', N'Đỗ Mỹ Hằng', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'
Exec ThemBenhNhan 'BN0000012', N'', '6/23/1972', 0, N'52 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP Hồ Chí Minh', '01212134184'
Exec ThemBenhNhan 'BN0000013', N'Nguyễn Trương Tiến', '3/23/1988', 2, N'16 Phạm Văn Bạch, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01212100184'
Exec ThemBenhNhan '', N'Nguyễn Trương Tiến', '3/23/1988', 1, N'16 Phạm Văn Bạch, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01212100184'


---Lấy dữ liệu từ 2 bảng phân mảnh ngang trên 2 server SQL
select * from BENHNHAN union
select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN
GO

-- Tạo khung nhìn (trong suốt) cho bảng BENHNHAN
Create view View_BenhNhan as
select * from BENHNHAN 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN
GO

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết thông tin các bệnh nhân có địa chỉ tại quận 1
select * from View_BenhNhan where DiaChi like N'%Quận 1%' 
GO

------------------------
-----Tạo thủ tục ===SỬA=== dữ liệu bảng BENHNHAN
Create Proc SuaBENHNHAN (
	@MaBN varchar(20),
	@TenBN nvarchar(50),
	@NgSinh datetime,
	@GioiTinh int,
	@DiaChi nvarchar(max),
	@SoDT varchar(30))
As
Begin
	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Mã bệnh nhân không tồn tại'
		return
	End 

	--Kiểm tra tên không được rỗng
	if (@TenBN is null or @TenBN='')
	Begin
		print N'Tên bệnh nhân không được rỗng'
		return
	End  

	--Kiểm tra nhập giới tính
	if (@GioiTinh != 0 and @GioiTinh !=1)
	Begin
		print N'Giới tính nữ: 0, giới tính nam: 1'
		return
	End

	--Biến tạm
	declare @MaSD varchar(20)
	declare @MaPhieuXN varchar(20)
	declare @MaHS varchar(20)
	declare @MaDon varchar(20)

	--Sửa bệnh nhân máy chủ
	if exists (select MaBN from BENHNHAN where MaBN=@MaBN)
	Begin
		if(@GioiTinh=1)
		Begin
			--Chuyển dữ liệu từ máy chủ sang máy ảo
			insert into SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN 
				values (@MaBN, @TenBN, @NgSinh, @GioiTinh, @DiaChi, @SoDT)
			--Chuyển các bảng bị ảnh hưởng từ máy chủ sang máy ảo
			insert into SQL_Home.QuanLyBenhNhan.dbo.BHYT
				select * from BHYT where MaBN = @MaBN

			insert into SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU
				select * from SUDUNGDICHVU where MaBN = @MaBN
			
			--Gán mã sử dụng vào biến tạm
			select @MaSD=MaSD from SUDUNGDICHVU where MaBN = @MaBN
			insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU
				select * from CHITIETSDDICHVU where MaSD=@MaSD

			insert into SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM
				select * from PHIEUXETNGHIEM where MaBN = @MaBN

			--Gán mã phiếu xét nghiệm vào biến tạm
			select @MaPhieuXN=MaPhieuXN from PHIEUXETNGHIEM where MaBN=@MaBN
			insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM
				select * from CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN

			insert into SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN
				select * from HOSOBENHAN where MaBN=@MaBN

			--Gán mã hồ sơ bệnh án vào biến tạm
			select @MaHS=MaHS from HOSOBENHAN where MaBN=@MaBN
			insert into SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC
				select * from DONTHUOC where MaHS = @MaHS

			select @MaDon=MaDon from DONTHUOC where MaHS=@MaHS
			insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC
				select * from CHITIETDONTHUOC where MaDon=@MaDon

			delete from BHYT where MaBN=@MaBN
			delete from CHITIETSDDICHVU where MaSD=@MaSD
			delete from SUDUNGDICHVU where MaBN=@MaBN
			delete from CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN
			delete from PHIEUXETNGHIEM where MaBN=@MaBN
			delete from CHITIETDONTHUOC where MaDon=@MaDon
			delete from DONTHUOC where MaHS=@MaHS
			delete from HOSOBENHAN where MaBN=@MaBN
			delete from BENHNHAN where MaBN=@MaBN
			print N'Sửa thành công bệnh nhân ' + @TenBN
		End

		else
		Begin
			update BENHNHAN
			set TenBN=@TenBN, NgSinh=@NgSinh, GioiTinh=@GioiTinh, DiaChi=@DiaChi, SoDT=@SoDT
			where MaBN=@MaBN
			print N'Sửa thành công bệnh nhân ' + @TenBN
		End
		
	End

	--Sửa bệnh nhân máy ảo
	if exists (select MaBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		if(@GioiTinh=0)
		Begin
			--Chuyển dữ liệu từ máy ảo sang máy chủ
			insert into BENHNHAN 
				values (@MaBN, @TenBN, @NgSinh, @GioiTinh, @DiaChi, @SoDT)
			--Chuyển các bảng bị ảnh hưởng từ máy ảo sang máy chủ
			insert into BHYT
				select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT where MaBN = @MaBN

			insert into SUDUNGDICHVU
				select * from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaBN = @MaBN
			
			--Gán mã sử dụng vào biến tạm
			select @MaSD=MaSD from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaBN = @MaBN
			insert into CHITIETSDDICHVU
				select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU where MaSD=@MaSD

			insert into PHIEUXETNGHIEM
				select * from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaBN = @MaBN

			--Gán mã phiếu xét nghiệm vào biến tạm
			select @MaPhieuXN=MaPhieuXN from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaBN=@MaBN
			insert into CHITIETXETNGHIEM
				select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN

			insert into HOSOBENHAN
				select * from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaBN=@MaBN

			--Gán mã hồ sơ bệnh án vào biến tạm
			select @MaHS=MaHS from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaBN=@MaBN
			insert into DONTHUOC
				select * from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaHS = @MaHS

			select @MaDon=MaDon from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaHS=@MaHS
			insert into CHITIETDONTHUOC
				select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC where MaDon=@MaDon

			delete from SQL_Home.QuanLyBenhNhan.dbo.BHYT where MaBN=@MaBN
			delete from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU where MaSD=@MaSD
			delete from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaBN=@MaBN
			delete from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN
			delete from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaBN=@MaBN
			delete from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC where MaDon=@MaDon
			delete from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaHS=@MaHS
			delete from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaBN=@MaBN
			delete from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
			print N'Sửa thành công bệnh nhân ' + @TenBN
		End

		else
		Begin
			update SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN
			set TenBN=@TenBN, NgSinh=@NgSinh, GioiTinh=@GioiTinh, DiaChi=@DiaChi, SoDT=@SoDT
			where MaBN=@MaBN
			print N'Sửa thành công bệnh nhân ' + @TenBN
		End
	End
End
go

---Sửa dữ liệu bệnh nhân
Exec SuaBENHNHAN 'BN000001', N'Phạm Minh Thành', '9/1/1992', 1, N'19 Nguyễn Trọng Trí, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01204845707'
Exec SuaBENHNHAN 'BN000003', N'Trần Thị Kim Chi', '11/8/1991', 0, N'301F Bình Đông, Phường 14, Quận 8, TP Hồ Chí Minh', '01212097597'
Exec SuaBENHNHAN 'BN000004', N'Phạm Thị Kim Cương', '2/4/1992', 0, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'
Exec SuaBENHNHAN 'BN000005', N'Đỗ Mỹ Hằng', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'
Exec SuaBENHNHAN 'BN000006', N'Dương Thị Thanh Hương', '1/2/1990', 0, N'47 Phạm Viết Chánh, Phường Nguyễn Cư Trinh, Quận 1, TP Hồ Chí Minh', '01212568080'
Exec SuaBENHNHAN 'BN000007', N'Lê Thị Kiều Hạnh', '2/1/1991', 0, N'109/24 Trương Phước Phan, Phường Bình Trị Đông, Quận Bình Tân, TP Hồ Chí Minh', '01212084352'
Exec SuaBENHNHAN 'BN000008', N'Chung Yến Loan', '1/1/1993', 0, N'28/22A đường Đỗ Quang Đẩu, Phường Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '01212777768'
Exec ThemBenhNhan 'BN000009', N'Trương Thị Mỹ Ngọc', '6/1/1991', 0, N'83/27/4 Phạm Văn Bạch, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01212882279'
Exec ThemBenhNhan 'BN000010', N'Phan Thị Hồng Phúc', '3/1/1994', 0, N'141 Nguyễn Đức Cảnh, Khu phố Mỹ Phúc, Phường Tân Phong, Quận 7, TP Hồ Chí Minh', '01213141655'
Exec ThemBenhNhan 'BN000011', N'Trần Minh Thái', '3/1/1956', 1, N'141 Phạm Thế Hiển, Phường 9, Quận 8, TP Hồ Chí Minh', '01213141234'

--Kiểm tra các trường hợp
Exec SuaBENHNHAN 'BN000020', N'Phạm Thị Kim Cương', '2/4/1992', 0, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'
Exec SuaBENHNHAN 'BN000005', N'', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'
Exec SuaBENHNHAN 'BN000008', N'Chung Yến Loan', '1/1/1993', 3, N'28/22A đường Đỗ Quang Đẩu, Phường Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '01212777768'
Exec SuaBENHNHAN 'BN000010', N'Phan Hồng Phúc', '3/1/1990', 1, N'141 Nguyễn Đức Cảnh, Khu phố Mỹ Phúc, Phường Tân Phong, Quận 7, TP Hồ Chí Minh', '01213141655'



---------*********BHYT********---------
--Tạo thủ tục thêm dữ liệu bảng BHYT
Create Proc ThemBHYT (
	@SoThe varchar(20),
	@MaBN varchar(20),
	@NgayCap datetime,
	@NgayHHan datetime)
As
Begin
	--Kiểm tra số thẻ ko được rỗng
	if (@SoThe is null or @SoThe='')
	Begin
		print N'Số thẻ BHYT không được rỗng'
		return
	End

	--Kiểm tra số thẻ ko được trùng
	if exists (Select * from BHYT where SoThe=@SoThe) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT where SoThe=@SoThe)
	Begin
		print N'Số thẻ đã tồn tại'
		return
	End

	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End 
	
	declare @TenBN nvarchar(255) --bien tam

	--Thêm BHYT máy chủ theo bệnh nhân
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into BHYT values(@SoThe, @MaBN, @NgayCap, @NgayHHan)		
		select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Thêm thành công BHYT của ' +  @TenBN
	End

	--Thêm BHYT máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.BHYT values(@SoThe, @MaBN, @NgayCap, @NgayHHan)		
		select @TenBN=TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Thêm thành công BHYT của ' +  @TenBN
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemBHYT 'SV0001BH', 'BN000001', '1/1/2016', '1/1/2017'
Exec ThemBHYT 'SV0002BH', 'BN000002', '2/1/2016', '2/1/2017'
Exec ThemBHYT 'SV0003BH', 'BN000003', '3/1/2016', '3/1/2017'
Exec ThemBHYT 'SV0004BH', 'BN000004', '4/1/2016', '4/1/2017'
Exec ThemBHYT 'SV0005BH', 'BN000005', '5/1/2016', '5/1/2017'
Exec ThemBHYT 'SV0006BH', 'BN000006', '6/1/2016', '6/1/2017'
Exec ThemBHYT 'SV0007BH', 'BN000007', '7/1/2016', '7/1/2017'
Exec ThemBHYT 'SV0008BH', 'BN000008', '8/1/2016', '8/1/2017'
Exec ThemBHYT 'SV0009BH', 'BN000009', '9/1/2016', '9/1/2017'
Exec ThemBHYT 'SV0010BH', 'BN000010', '10/1/2016', '10/1/2017'
Exec ThemBHYT 'SV0011BH', 'BN000010', '10/1/2015', '10/1/2016'

--Kiểm tra các trường hợp
Exec ThemBHYT '', 'BN000010', '10/1/2016', '10/1/2017'
Exec ThemBHYT 'SV0009BH', 'BN000010', '9/1/2016', '9/1/2017'
Exec ThemBHYT 'SV0011BH', 'BN000020', '9/1/2016', '9/1/2017'

-- Tạo khung nhìn (trong suốt) cho bảng BHYT
Create view View_BHYT as
select * from BHYT 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT
GO

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết thông tin các thẻ BHYT của bệnh nhân có mã số BN000010 và thông tin của bệnh nhân đó 
select * 
from View_BenhNhan bn, View_BHYT bh 
where bn.MaBN = bh.MaBN
	and bn.MaBN = 'BN000010'
GO


---------*********KHOA********---------
--Tạo thủ tục thêm dữ liệu bảng KHOA
Create Proc ThemKHOA (
	@MaKhoa varchar(20),
	@TenKhoa nvarchar(50))
As
Begin
	--kiem tra MaKhoa ko duoc rong
	if (@MaKhoa is null or @MaKhoa='')
	Begin
		print N'Mã khoa không được rỗng'
		return
	End

	--kiem tra MaKhoa ko duoc trung
	if exists (Select * from KHOA where MaKhoa=@MaKhoa) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.KHOA where MaKhoa=@MaKhoa)
	Begin
		print N'Mã khoa đã tồn tại'
		return
	End

	--kiem tra TenKhoa ko dc rong
	if (@TenKhoa is null or @TenKhoa='')
	Begin
		print N'Tên khoa không được rỗng'
		return
	End
	
	--kiem tra TenKhoa ko duoc trung
	if exists (Select * from KHOA where TenKhoa=@TenKhoa) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.KHOA where TenKhoa=@TenKhoa)
	Begin
		print N'Tên khoa đã tồn tại'
		return
	End

	--Them khoa (nhan bang)
	else
	Begin
		insert into KHOA values(@MaKhoa, @TenKhoa)		
		insert into SQL_Home.QuanLyBenhNhan.dbo.KHOA values (@MaKhoa, @TenKhoa)
		print N'Thêm thành công Khoa ' +  @TenKhoa
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemKHOA 'K001', N'Chấn thương & Chỉnh hình'
Exec ThemKHOA 'K002', N'Da liễu & Hoa liễu'
Exec ThemKHOA 'K003', N'Gây mê & Hồi sức'
Exec ThemKHOA 'K004', N'Hô hấp & Dị ứng'
Exec ThemKHOA 'K005', N'Mắt'
Exec ThemKHOA 'K006', N'Nha & Chỉnh nha'
Exec ThemKHOA 'K007', N'Nhi khoa'
Exec ThemKHOA 'K008', N'Nội đa khoa'
Exec ThemKHOA 'K009', N'Nội thần kinh'
Exec ThemKHOA 'K010', N'Phẫu thuật ổ bụng'
Exec ThemKHOA 'K011', N'Phẫu thuật thần kinh'
Exec ThemKHOA 'K012', N'Sản & Phụ khoa'
Exec ThemKHOA 'K013', N'Tai Mũi Họng & Phẫu thuật vùng Mặt và Cổ'
Exec ThemKHOA 'K014', N'Tiết niệu'
Exec ThemKHOA 'K015', N'Tiêu hóa'
Exec ThemKHOA 'K016', N'Tim mạch'
Exec ThemKHOA 'K017', N'Tư vấn tâm lý & Tâm thần'

--Kiểm tra các trường hợp
Exec ThemKHOA 'K006', N'Nha'
Exec ThemKHOA '', N'Nha'
Exec ThemKHOA 'K018', N'Mắt'
Exec ThemKHOA 'K019', N''


---------*********BACSI*********---------
--Tạo thủ tục thêm dữ liệu bảng BACSI
Create Proc ThemBacSi (
	@MaBS varchar(20),
	@TenBS nvarchar(50),
	@NgSinh datetime,
	@GioiTinh int,
	@DiaChi nvarchar(max),
	@SoDT varchar(30),
	@MaKhoa varchar(20))
As
Begin
	--Kiểm tra mã bác sĩ ko được rỗng
	if (@MaBS is null or @MaBS='')
	Begin
		print N'Mã bác sĩ không được rỗng'
		return
	End

	--Kiểm tra mã bác sĩ ko được trùng
	if exists (Select * from BACSI where MaBS=@MaBS) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaBS=@MaBS)
	Begin
		print N'Mã bác sĩ đã tồn tại'
		return
	End

	--Kiểm tra tên bác sĩ ko được rỗng
	if (@TenBS is null or @TenBS='')
	Begin
		print N'Tên bác sĩ không được rỗng'
		return
	End  

	--Kiểm tra nhập giới tính
	if (@GioiTinh != 0 and @GioiTinh !=1)
	Begin
		print N'Giới tính nữ: 0, giới tính nam: 1'
		return
	End

	--Kiểm tra MaKhoa có tồn tại không
	if not exists (select * from KHOA where MaKhoa=@MaKhoa)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.KHOA where MaKhoa=@MaKhoa)
	Begin
		print N'Khoa không tồn tại'
		return
	End 

	--Thêm bác sĩ, phân mảnh theo giới tính
	if (@GioiTinh=0)
	Begin
		insert into BACSI values(@MaBS, @TenBS, @NgSinh, @GioiTinh, @DiaChi, @SoDT, @MaKhoa)
		print N'Thêm thành công bác sĩ ' + @TenBS
	End

	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.BACSI 
		values(@MaBS, @TenBS, @NgSinh, @GioiTinh, @DiaChi, @SoDT, @MaKhoa)
		print N'Thêm thành công bác sĩ ' + @TenBS
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemBacSi 'BS001', N'Vũ Duy Đông', '3/1/1982', 1, N'78/23/3 đường Cống Lở, Phường 15, Quận Tân Bình, TP Hồ Chí Minh', '01228867678', 'K002'
Exec ThemBacSi 'BS002', N'Dương Cẩm Giang', '3/1/1981', 0, N'153/54 Trần Hưng Đạo, Phường Cầu Ông Lãnh, Quận 1, TP Hồ Chí Minh', '01229478717', 'K003'
Exec ThemBacSi 'BS003', N'Võ Thị Quỳnh Giao', '3/1/1980', 0, N'152 Đường số 1, Phường Tân Phú, Quận 7, TP Hồ Chí Minh', '01229677954', 'K004'
Exec ThemBacSi 'BS004', N'Lương Thị Thu Hà', '3/1/1979', 0, N'168 Đường số 1, Phường 16, Quận Gò Vấp, TP Hồ Chí Minh', '01229799523', 'K006'
Exec ThemBacSi 'BS005', N'Trần Phi Hổ', '12/1/1961', 1, N'81/11 Nguyễn Bỉnh Khiêm, Phường 1, Quận Gò Vấp, TP Hồ Chí Minh', '01229798783', 'K007'
Exec ThemBacSi 'BS006', N'Nguyễn Văn Huấn', '3/1/1972', 1, N'261/15/80/23 Tổ 5 Đình Phong Phú, Phường Tăng Nhơn Phú B, Quận 9, TP Hồ Chí Minh', '01233688869', 'K008'
Exec ThemBacSi 'BS007', N'Trần Phạm Thanh Huy', '3/7/1962', 1, N'368/15/1 Đường Hà Huy Giáp, phường Thạnh Lộc, Quận 12, TP Hồ Chí Minh', '01234305060', 'K009'
Exec ThemBacSi 'BS008', N'Nguyễn Thị Hàn Huyên', '3/5/1972', 0, N'124A, Đường Nguyễn Lâm, Phường 22, Quận Bình Thạnh, TP Hồ Chí Minh', '01234551240', 'K010'
Exec ThemBacSi 'BS009', N'Hồ Đức Khoa', '3/6/1962', 1, N'945/29 Quốc Lộ 1A, khu phố 1, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01234558191', 'K011'
Exec ThemBacSi 'BS010', N'Huỳnh Thị Mỹ Kim', '3/7/1990', 0, N'221/13 Trần Quang Khải, Phường Tân Định, Quận 1, TP Hồ Chí Minh', '0123472349', 'K012'

--Kiểm tra các trường hợp
Exec ThemBacSi '', N'Huỳnh Thị Kim', '3/7/1990', 0, N'221/13 Trần Quang Khải, Phường Tân Định, Quận 1, TP Hồ Chí Minh', '0123472349', 'K012'
Exec ThemBacSi 'BS005', N'Hồ Đức Khoa', '3/6/1962', 1, N'945/29 Quốc Lộ 1A, khu phố 1, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01234558191', 'K011'
Exec ThemBacSi 'BS0011', N'', '3/1/1979', 0, N'168 Đường số 1, Phường 11, Quận 9, TP Hồ Chí Minh', '01229788523', 'K004'
Exec ThemBacSi 'BS0012', N'Trần Thanh Huy', '3/7/1982', 2, N'368/15/1 Đường Hà Huy Giáp, phường Thạnh Lộc, Quận 12, TP Hồ Chí Minh', '01234305070', 'K009'
Exec ThemBacSi 'BS0012', N'Trần Thanh Minh', '3/7/1980', 1, N'368/15/1 Đường Hà Huy Giáp, phường Thạnh Lộc, Quận 12, TP Hồ Chí Minh', '01234305070', 'K018'

-- Tạo khung nhìn (trong suốt) cho bảng BACSI
Create view View_BacSi as
select * from BACSI 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI
GO

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết thông tin các bác sĩ có họ Nguyễn và họ Trần
select * 
from View_BacSi
where TenBS like N'Nguyễn%'
	or TenBS like N'Trần%'
GO


---------*********DICHVU********---------
--Tạo thủ tục thêm dữ liệu bảng DICHVU
Create Proc ThemDICHVU (
	@MaDV varchar(20),
	@TenDV nvarchar(50),
	@GiaDV decimal)
As
Begin
	--Kiểm tra MaDV không được rỗng
	if (@MaDV is null or @MaDV='')
	Begin
		print N'Mã dịch vụ không được rỗng'
		return
	End

	--Kiểm tra MaDV không được trùng
	if exists (Select * from DICHVU where MaDV=@MaDV) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.DICHVU where MaDV=@MaDV)
	Begin
		print N'Mã dịch vụ đã tồn tại'
		return
	End

	--Kiểm tra TenDV không được rỗng
	if (@TenDV is null or @TenDV='')
	Begin
		print N'Tên dịch vụ không được rỗng'
		return
	End

	--Kiểm tra TenDV không được trùng
	if exists (select * from DICHVU where TenDV=@TenDV)
	or exists (select * from SQL_Home.QuanLyBenhNhan.dbo.DICHVU where TenDV=@TenDV)
	Begin
		print N'Tên dịch vụ đã tồn tại'
		return
	End 
	
	--Thêm dịch vụ (nhân bảng)
	else
	Begin
		insert into DICHVU values(@MaDV, @TenDV, @GiaDV)		
		insert into SQL_Home.QuanLyBenhNhan.dbo.DICHVU values (@MaDV, @TenDV, @GiaDV)
		print N'Thêm thành công dịch vụ ' +  @TenDV
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemDICHVU 'DV001', N'Khám lâm sàng (trong giờ làm việc)', 874000
Exec ThemDICHVU 'DV002', N'Khám cấp cứu', 1587000
Exec ThemDICHVU 'DV003', N'Lưu viện phòng đôi', 3266000
Exec ThemDICHVU 'DV004', N'Lưu viện phòng đơn', 5566000
Exec ThemDICHVU 'DV005', N'Lưu viện cách ly', 6325000
Exec ThemDICHVU 'DV006', N'Lưu viện trong ngày', 1633000
Exec ThemDICHVU 'DV007', N'Lưu viện tại ICU', 4370000

--Kiểm tra các trường hợp
Exec ThemDICHVU '', N'Lưu viện tại...', 4370000
Exec ThemDICHVU 'DV002', N'Lưu viện tại...', 4370000
Exec ThemDICHVU 'DV008', N'Lưu viện phòng đơn', 5566000
Exec ThemDICHVU 'DV009', N'', 5566000


---------*********SUDUNGDICHVU********---------
--Tạo thủ tục thêm dữ liệu bảng SUDUNGDICHVU
Create Proc ThemSUDUNGDICHVU (
	@MaSD varchar(20),
	@NgaySD datetime,
	@MaBN varchar(20),
	@TongTien decimal)
As
Begin
	--Kiểm tra MaSD ko được rỗng
	if (@MaSD is null or @MaSD='')
	Begin
		print N'Mã không được rỗng'
		return
	End

	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End 

	--Thêm phiếu sử dụng dịch vụ máy chủ theo bệnh nhân
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into SUDUNGDICHVU values(@MaSD, @NgaySD, @MaBN, @TongTien)		
		print N'Thêm thành công'
	End

	--Thêm phiếu sử dụng dịch vụ máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU values(@MaSD, @NgaySD, @MaBN, @TongTien)		
		print N'Thêm thành công'
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemSUDUNGDICHVU 'SDDV0001', '1/4/2016', 'BN000001', 874000
Exec ThemSUDUNGDICHVU 'SDDV0002', '2/4/2016', 'BN000002', 1587000
Exec ThemSUDUNGDICHVU 'SDDV0003', '3/4/2016', 'BN000003', 3266000
Exec ThemSUDUNGDICHVU 'SDDV0004', '4/4/2016', 'BN000004', 5566000
Exec ThemSUDUNGDICHVU 'SDDV0005', '5/4/2016', 'BN000005', 3266000
Exec ThemSUDUNGDICHVU 'SDDV0006', '6/4/2016', 'BN000006', 3266000
Exec ThemSUDUNGDICHVU 'SDDV0007', '7/4/2016', 'BN000007', 3266000
Exec ThemSUDUNGDICHVU 'SDDV0008', '8/4/2016', 'BN000008', 874000
Exec ThemSUDUNGDICHVU 'SDDV0009', '9/4/2016', 'BN000009', 1587000
Exec ThemSUDUNGDICHVU 'SDDV0010', '10/4/2016', 'BN000010', 3266000

--Kiểm tra các trường hợp
Exec ThemSUDUNGDICHVU '', '10/4/2016', 'BN000002', 3266000
Exec ThemSUDUNGDICHVU 'SDDV0008', '7/4/2016', 'BN000008', 874000
Exec ThemSUDUNGDICHVU 'SDDV0011', '10/4/2016', 'BN000015', 3266000

-- Tạo khung nhìn (trong suốt) cho bảng SUDUNGDICHVU
Create view View_SuDungDichVu as
select * from SUDUNGDICHVU 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU
GO

select * from View_SuDungDichVu

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết các phiếu sử dụng dịch vụ có tổng tiền nhỏ hơn 3 triệu và thông tin của bệnh nhân tương ứng
select * 
from View_SuDungDichVu dv, View_BenhNhan bn
where bn.MaBN = dv.MaBN
	and dv.TongTien <3000000
GO


---------*********CHITIETSDDICHVU********---------
--Tạo thủ tục thêm dữ liệu bảng CHITIETSDDICHVU
Create Proc ThemCHITIETSDDICHVU (
	@MaSD varchar(20),
	@MaDV varchar(20),
	@SoLuongDV int,
	@ThanhTien decimal)
As
Begin
	--Kiểm tra MaSD ko được rỗng
	if (@MaSD is null or @MaSD='')
	Begin
		print N'Mã sử dụng dịch vụ không được rỗng'
		return
	End

	--Kiểm tra MaSD có tồn tại ko
	if not exists (select * from SUDUNGDICHVU where MaSD=@MaSD)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaSD=@MaSD)
	Begin
		print N'Mã sử dụng dịch vụ không tồn tại'
		return
	End

	--Kiểm tra MaDV không được rỗng
	if (@MaDV is null or @MaDV='')
	Begin
		print N'Mã dịch vụ không được rỗng'
		return
	End

	--Kiểm tra MaDV có tồn tại ko
	if not exists (select * from DICHVU where MaDV=@MaDV)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.DICHVU where MaDV=@MaDV)
	Begin
		print N'Dịch vụ không tồn tại'
		return
	End 

	--Kiểm tra khóa chính trên máy chủ (MaSD, MaDV) có trùng ko
	if exists (select ct.MaSD 
			   from CHITIETSDDICHVU ct, SUDUNGDICHVU sd 
			   where ct.MaSD = sd.MaSD and ct.MaSD=@MaSD)
	   and exists (select ct.MaDV 
				   from CHITIETSDDICHVU ct, DICHVU dv 
				   where ct.MaDV = dv.MaDV and ct.MaDV=@MaDV)
	Begin
		print N'Chi tiết đã tồn tại'
		return
	End

	--Kiểm tra khóa chính trên máy trạm (MaSD, MaDV) có trùng ko
	if exists (select ct.MaSD 
			   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU ct, SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU sd 
			   where ct.MaSD = sd.MaSD and ct.MaSD=@MaSD)
	   and exists (select ct.MaDV 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU ct, SQL_Home.QuanLyBenhNhan.dbo.DICHVU dv 
				   where ct.MaDV = dv.MaDV and ct.MaDV=@MaDV)
	Begin
		print N'Chi tiết đã tồn tại'
		return
	End

	--Thêm chi tiết sử dụng dịch vụ máy chủ theo phiếu sử dụng dịch vụ
	if (exists (select MaSD from SUDUNGDICHVU where MaSD=@MaSD))
	Begin
		insert into CHITIETSDDICHVU values(@MaSD, @MaDV, @SoLuongDV, @ThanhTien)		
		print N'Thêm thành công chi tiết'
	End

	--Thêm chi tiết sử dụng dịch vụ máy trạm theo phiếu sử dụng dịch vụ
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU values(@MaSD, @MaDV, @SoLuongDV, @ThanhTien)		
		print N'Thêm thành công chi tiết'
	End
End
GO

---Thêm dữ liệu vào bảng
Exec ThemCHITIETSDDICHVU 'SDDV0001', 'DV001', 1, 874000
Exec ThemCHITIETSDDICHVU 'SDDV0002', 'DV002', 1, 1587000
Exec ThemCHITIETSDDICHVU 'SDDV0003', 'DV003', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0004', 'DV004', 1, 5566000
Exec ThemCHITIETSDDICHVU 'SDDV0005', 'DV005', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0006', 'DV006', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0007', 'DV006', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0008', 'DV001', 1, 874000
Exec ThemCHITIETSDDICHVU 'SDDV0009', 'DV002', 1, 1587000
Exec ThemCHITIETSDDICHVU 'SDDV0010', 'DV003', 1, 3266000

--Kiểm tra các trường hợp
Exec ThemCHITIETSDDICHVU '', 'DV006', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0011', 'DV005', 1, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0004', '', 1, 5566000
Exec ThemCHITIETSDDICHVU 'SDDV0004', 'DV009', 1, 5566000
Exec ThemCHITIETSDDICHVU 'SDDV0007', 'DV006', 2, 3266000
Exec ThemCHITIETSDDICHVU 'SDDV0002', 'DV002', 3, 1587000


-- Tạo khung nhìn (trong suốt) cho bảng SUDUNGDICHVU
Create view View_ChiTietSDDichVu as
select * from CHITIETSDDICHVU 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU 
GO

select * from View_ChiTietSDDichVu

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết các chi tiết sử dụng dịch vụ MaDV=DV001 và thông tin của bệnh nhân tương ứng. Lấy ra MaBN, TenBN và thông tin chi tiết sử dụng dịch vụ
select bn.MaBN, bn.TenBN, ct.MaSD, ct.MaDV, ct.SoLuongDV, ct.ThanhTien 
from View_ChiTietSDDichVu ct, View_BenhNhan bn, View_SuDungDichVu sd
where ct.MaDV='DV001'
	and ct.MaSD = sd.MaSD
	and sd.MaBN = bn.MaBN
GO

