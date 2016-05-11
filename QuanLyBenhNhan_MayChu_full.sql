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

/*Phân mảnh dọc*/
Create table BACSI(
		MaBS varchar(20) primary key not null,
		TenBS nvarchar(50) not null,
		GioiTinh int,		
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

Select * from View_BenhNhan

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
	--if exists (select MaBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	else
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
GO

---Sửa dữ liệu bệnh nhân 
Exec SuaBENHNHAN 'BN000001', N'Phạm Minh Thành', '9/1/1992', 1, N'19 Nguyễn Trọng Trí, Phường An Lạc, Quận Bình Tân, TP Hồ Chí Minh', '01204845707'

--Kiểm tra các trường hợp
Exec SuaBENHNHAN 'BN000020', N'Phạm Thị Kim Cương', '2/4/1992', 0, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'
Exec SuaBENHNHAN 'BN000005', N'', '9/1/1992', 0, N'111/1211 Lê Đức Thọ, Phường 12, Quận Gò Vấp, TP Hồ Chí Minh', '01212452011'
Exec SuaBENHNHAN 'BN000008', N'Chung Yến Loan', '1/1/1993', 3, N'28/22A đường Đỗ Quang Đẩu, Phường Phạm Ngũ Lão, Quận 1, TP Hồ Chí Minh', '01212777768'
Exec SuaBENHNHAN 'BN000010', N'Phan Hồng Phúc', '3/1/1990', 1, N'141 Nguyễn Đức Cảnh, Khu phố Mỹ Phúc, Phường Tân Phong, Quận 7, TP Hồ Chí Minh', '01213141655'
--sửa tên và giới tính bệnh nhân mã BN000004
Exec SuaBENHNHAN 'BN000004', N'Phạm Bảo An', '2/4/1992', 1, N'52 Nguyễn Du, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh', '01212128184'

------------------------
-----Tạo thủ tục ===XÓA=== dữ liệu bảng BENHNHAN
Create Proc XoaBENHNHAN (@MaBN varchar(20))
As
Begin
	--Kiểm tra MaBN nhập vào có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Mã bệnh nhân không tồn tại'
		return
	End 

	--Kiểm tra MaBN nhập vào có tồn tại ở BHYT ko
	if exists (select * from BHYT where MaBN=@MaBN)
	or exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT where MaBN=@MaBN)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng BHYT'
		return
	End 

	--Kiểm tra MaBN nhập vào có tồn tại bảng sử dụng dịch vụ ko
	if exists (select * from SUDUNGDICHVU where MaBN=@MaBN)
	or exists (select * from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaBN=@MaBN)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng Sử dụng dịch vụ'
		return
	End 

	--Kiểm tra MaBN nhập vào có tồn tại bảng phiếu xét nghiệm ko
	if exists (select * from PHIEUXETNGHIEM where MaBN=@MaBN)
	or exists (select * from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaBN=@MaBN)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng Phiếu xét nghiệm'
		return
	End

	--Kiểm tra MaBN nhập vào có tồn tại bảng hồ sơ bệnh án ko
	if exists (select * from HOSOBENHAN where MaBN=@MaBN)
	or exists (select * from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaBN=@MaBN)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng Hồ sơ bệnh án'
		return
	End

	declare @TenBN nvarchar(50)
	select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN
	if exists (select * from BENHNHAN where MaBN=@MaBN)
	Begin
		delete from BENHNHAN where MaBN=@MaBN
		print N'Xóa thành công bệnh nhân có mã ' + @TenBN
	End

	else
	Begin
		delete from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Xóa thành công bệnh nhân có mã ' + @TenBN
	End
End
GO

--Kiểm tra các trường hợp xóa BN
Exec XoaBENHNHAN 'BN000015'
Exec XoaBENHNHAN 'BN000001'
Exec XoaBENHNHAN 'BN000011'




---------*********BHYT*********---------
--Tạo thủ tục ===THÊM=== dữ liệu bảng BHYT
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
	
	--Kiểm tra mã không được rỗng
	if (@MaBN is null or @MaBN='')
	Begin
		print N'Mã bệnh nhân không được rỗng'
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
Exec ThemBHYT 'SV0012BH', 'BN000020', '9/1/2016', '9/1/2017'

-- Tạo khung nhìn (trong suốt) cho bảng BHYT
Create view View_BHYT as
select * from BHYT 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT
GO

select * from View_BHYT

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết thông tin các thẻ BHYT của bệnh nhân có mã số BN000010 và thông tin của bệnh nhân đó 
select * 
from View_BenhNhan bn, View_BHYT bh 
where bn.MaBN = bh.MaBN
	and bn.MaBN = 'BN000010'
GO


-----Tạo thủ tục ===SỬA=== dữ liệu bảng BHYT
Create Proc SuaBHYT (
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
	
	-- kiểm tra BHYT có tồn tại không
	if not exists (select * from BHYT where SoThe=@SoThe)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BHYT where SoThe=@SoThe)
	Begin
		print N'BHTY không tồn tại'
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

	--Sửa BHYT máy chủ
	if (exists (select SoThe from BHYT where SoThe=@SoThe))
	Begin
		update BHYT
				set MaBN = @MaBN, NgayCap = @NgayCap, NgayHHan = @NgayHHan
				where SoThe = @SoThe
		select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Sửa thành công BHYT của ' +  @TenBN
	End

	--Sửa BHYT máy trạm
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.BHYT
				set MaBN = @MaBN, NgayCap = @NgayCap, NgayHHan = @NgayHHan
				where SoThe = @SoThe
		select @TenBN=TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Sửa thành công BHYT của ' +  @TenBN
	End
End
GO


--------- xóa BHYT -----------
Create Proc XoaBHYT (
	@SoThe varchar(20)
As
Begin
	--Kiểm tra số thẻ ko được rỗng
	if (@SoThe is null or @SoThe='')
	Begin
		print N'Số thẻ BHYT không được rỗng'
		return
	End	

	--Kiểm tra BHYT có tồn tại ko
	if not exists (select SoThe from BHYT where SoThe=@SoThe)
	and not exists (select SoThe from SQL_Home.QuanLyBenhNhan.dbo.BHYT where SoThe=@SoThe)
	Begin
		print N'BHYT không tồn tại'
		return
	End 
	
	declare @TenBN nvarchar(255) --bien tam

	--Xóa BHYT máy chủ
	if (exists (select SoThe from BHYT where SoThe=@SoThe))
	Begin
		delete from BHYT where SoThe=@SoThe
		select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Xóa thành công BHYT của ' +  @TenBN
	End

	--Xóa BHYT máy trạm
	else
	Begin
		delete from SQL_Home.QuanLyBenhNhan.dbo.BHYT where SoThe=@SoThe
		select @TenBN=TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN --Hiển thị tên bệnh nhân trong thông báo
		print N'Xóa thành công BHYT của ' +  @TenBN
	End
End
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

------ Sửa KHOA --------
Create Proc SuaKHOA (
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

	--kiem tra KHOA có tồn tại không
	if not exists (Select * from KHOA where MaKhoa=@MaKhoa) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.KHOA where MaKhoa=@MaKhoa)
	Begin
		print N'KHOA không tồn tại'
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

	--Sua khoa
	else
	Begin
		update KHOA 
		set TenKhoa = @TenKhoa 
		where MaKhoa = @MaKhoa
		
		update SQL_Home.QuanLyBenhNhan.dbo.KHOA 
		set TenKhoa = @TenKhoa 
		where MaKhoa = @MaKhoa
		
		print N'Sửa thành công Khoa ' +  @TenKhoa
	End
End
GO

------- Xóa khoa ------------
Create Proc XoaKHOA (
	@MaKhoa varchar(20)
As
Begin
	--kiem tra MaKhoa ko duoc rong
	if (@MaKhoa is null or @MaKhoa='')
	Begin
		print N'Mã khoa không được rỗng'
		return
	End

	--kiem tra KHOA có tồn tại không
	if not exists (Select * from KHOA where MaKhoa=@MaKhoa) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.KHOA where MaKhoa=@MaKhoa)
	Begin
		print N'KHOA không tồn tại'
		return
	End
	
	if(exists (Select maBS from BACSI where MaKhoa=@MaKhoa) or exists (Select maBS from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaKhoa=@MaKhoa))
	Begin
		print N'Đang tồn tại ràng buộc tại bảng BACSI'
		return
	End
	
	--Xoa KHOA
	else
	Begin
		declare @TenKhoa nvarchar(255)
		
		select @TenKhoa = TenKhoa 
		from KHOA 
		where MaKhoa=@MaKhoa
		
		--thuc hien xoa
		delete from KHOA
		where MaKhoa = @MaKhoa
		
		delete from SQL_Home.QuanLyBenhNhan.dbo.KHOA
		where MaKhoa = @MaKhoa
		
		print N'Xóa thành công Khoa ' +  @TenKhoa
	End
End
GO

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

	--Thêm bác sĩ
	--may chu
	insert into BACSI values(@MaBS, @TenBS, @NgSinh, @MaKhoa)
	--may tram
	insert into SQL_Home.QuanLyBenhNhan.dbo.BACSI 
		values(@MaBS, @GioiTinh, @DiaChi, @SoDT, @MaKhoa)
		
	print N'Thêm thành công bác sĩ ' + @TenBS	
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
select * from BACSI mc Inner join SQL_Home.QuanLyBenhNhan.dbo.BACSI mt
on (mc.MaBS=mt.MaBS)
GO

-- Thực hiện truy vấn trên khung nhìn trong suốt phân mảnh
  --Cho biết thông tin các bác sĩ có họ Nguyễn và họ Trần
select * 
from View_BacSi
where TenBS like N'Nguyễn%'
	or TenBS like N'Trần%'
GO

------- Sua BACSI ----------
Create Proc SuaBacSi (
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

	--Kiểm tra mã bác sĩ có tồn tại
	if not exists (Select * from BACSI where MaBS=@MaBS) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaBS=@MaBS)
	Begin
		print N'Mã bác sĩ không tồn tại'
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

	--Sửa bác sĩ
	--máy chủ
	update BACSI
	set TenBS=@TenBS, GioiTinh=@GioiTinh, MaKhoa=@MaKhoa
	where MaBS=@MaBS
	
	--máy trạm
	update SQL_Home.QuanLyBenhNhan.dbo.BACSI
	set NgSinh=@NgSinh, DiaChi=@DiaChi, SoDT=@SoDT, MaKhoa=@MaKhoa
	where MaBS=@MaBS
	print N'Đã cập nhật bác sĩ ' + @TenBS
End
GO

------- Xoa BACSI ----------
Create Proc XoaBacSi (
	@MaBS varchar(20)
As
Begin
	--Kiểm tra mã bác sĩ ko được rỗng
	if (@MaBS is null or @MaBS='')
	Begin
		print N'Mã bác sĩ không được rỗng'
		return
	End

	--Kiểm tra mã bác sĩ có tồn tại
	if not exists (Select * from BACSI where MaBS=@MaBS) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaBS=@MaBS)
	Begin
		print N'Mã bác sĩ không tồn tại'
		return
	End

	--Kiểm tra MaBS nhập vào có tồn tại HOSOBENHAN ko
	if exists (select MaBS from HOSOBENHAN where MaBS=@MaBS)
	or exists (select MaBS from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaBS=@MaBS)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng HOSOBENHAN'
		return
	End 

	--Xóa bác sĩ
	delete from BACSI
	where MaBS=@MaBS
	
	delete from SQL_Home.QuanLyBenhNhan.dbo.BACSI
	where MaBS=@MaBS
End
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


--Tạo thủ tục sửa dữ liệu bảng DICHVU
Create Proc SuaDICHVU (
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

	--Kiểm tra MaDV tồn tại
	if not exists (Select * from DICHVU where MaDV=@MaDV) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.DICHVU where MaDV=@MaDV)
	Begin
		print N'Mã dịch vụ không tồn tại'
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
	
	--Sửa dịch vụ
	else
	Begin
		update DICHVU
		set TenDV=@TenDV, GiaDV=@GiaDV
		where MaDV=@MaDV
		
		update SQL_Home.QuanLyBenhNhan.dbo.DICHVU
		set TenDV=@TenDV, GiaDV=@GiaDV
		where MaDV=@MaDV
		print N'Sửa thành công dịch vụ ' +  @TenDV
	End
End
GO

--Tạo thủ tục xóa dữ liệu bảng DICHVU
Create Proc XoaDICHVU (
	@MaDV varchar(20)
As
Begin
	--Kiểm tra MaDV không được rỗng
	if (@MaDV is null or @MaDV='')
	Begin
		print N'Mã dịch vụ không được rỗng'
		return
	End

	--Kiểm tra MaDV tồn tại
	if not exists (Select * from DICHVU where MaDV=@MaDV) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.DICHVU where MaDV=@MaDV)
	Begin
		print N'Mã dịch vụ không tồn tại'
		return
	End
	
	-- kiểm tra tồn tại ở bảng CHITIETSDDICHVU
	if exists (select * from CHITIETSDDICHVU where MaDV=@MaDV)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng CHITIETSDDICHVU'
		return
	End 
	--Xóa dịch vụ
	else
	Begin
		declare @TenDV nvarchar(255)
		
		select @TenDV = TenDV 
		from DICHVU 
		where MaDV=@MaDV
	
		delete from DICHVU
		where MaDV=@MaDV
		
		delete from SQL_Home.QuanLyBenhNhan.dbo.DICHVU
		where MaDV=@MaDV
		print N'Xóa thành công dịch vụ ' +  @TenDV
	End
End
GO


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

--Tạo thủ tục thêm dữ liệu bảng SUDUNGDICHVU
Create Proc SuaSUDUNGDICHVU (
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
	
	--Kiểm tra MaSD có tồn tại ko
	if not exists (select MaSD from SUDUNGDICHVU where MaSD=@MaSD)
	and not exists (select MaSD from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaSD=@MaSD)
	Begin
		print N'Mã sử dụng dịch vụ không tồn tại'
		return
	End 

	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End 

	--Sửa phiếu sử dụng dịch vụ máy chủ
	if (exists (select MaSD from SUDUNGDICHVU where MaSD=@MaSD))
	Begin
		declare @TenBN nvarchar(255)
		select @TenBN=TenBN from BENHNHAN where MaBN=@MaBN
		
		update SUDUNGDICHVU
		set  NgaySD=@NgaySD, MaBN=@MaBN, TongTien=@TongTien
		where MaSD=@MaSD
		print N'Sửa thành công dịch vụ của bệnh nhân ' + @TenBN
	End

	--Sửa phiếu sử dụng dịch vụ máy trạm
	else
	Begin
		declare @TenBN nvarchar(255)
		select @TenBN=TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		
		update SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU
		set  NgaySD=@NgaySD, MaBN=@MaBN, TongTien=@TongTien
		where MaSD=@MaSD
		print N'Sửa thành công dịch vụ của bệnh nhân ' + @TenBN
	End
End
GO

--Tạo thủ tục xóa dữ liệu bảng SUDUNGDICHVU
Create Proc XoaSUDUNGDICHVU (
	@MaSD varchar(20)
As
Begin
	--Kiểm tra MaDV không được rỗng
	if (@MaSD is null or @MaSD='')
	Begin
		print N'Mã không được rỗng'
		return
	End

	--Kiểm tra MaSD tồn tại
	if not exists (Select * from SUDUNGDICHVU where MaSD=@MaSD) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU where MaSD=@MaSD)
	Begin
		print N'Mã không tồn tại'
		return
	End
	
	-- kiểm tra tồn tại ở bảng CHITIETSDDICHVU
	if exists (select * from CHITIETSDDICHVU where MaDV=@MaDV)
	Begin
		print N'Đang tồn tại ràng buộc tại bảng CHITIETSDDICHVU'
		return
	End 
	
	--Xóa dịch vụ
	else
	Begin
		If(exists (Select * from SUDUNGDICHVU where MaSD=@MaSD))
		Begin
			delete from SUDUNGDICHVU
			where MaSD=@MaSD
			
			print N'Xóa thành công sử dụng dịch vụ'
		End
		else
		Begin
			delete from SQL_Home.QuanLyBenhNhan.dbo.SUDUNGDICHVU
			where MaSD=@MaSD
			
			print N'Xóa thành công sử dụng dịch vụ'
		End		
	End
End
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

	--Kiểm tra khóa chính (MaSD, MaDV) có trùng ko
	if exists (select MaSD 
			   from CHITIETSDDICHVU
			   where MaDV = @MaDV and MaSD = @MaSD)
	   or exists (select MaSD 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU
				   where MaDV = @MaDV and MaSD = @MaSD)
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

--Tạo thủ tục sửa dữ liệu bảng CHITIETSDDICHVU
Create Proc SuaCHITIETSDDICHVU (
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

	--Kiểm tra khóa chính (MaSD, MaDV) có tồn tại ko
	if not exists (select MaSD 
			   from CHITIETSDDICHVU
			   where MaDV = @MaDV and MaSD = @MaSD)
	   and not exists (select MaSD 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU
				   where MaDV = @MaDV and MaSD = @MaSD)
	Begin
		print N'Chi tiết không tồn tại'
		return
	End

	--Sửa chi tiết sử dụng dịch vụ máy chủ 
	if (exists (select MaSD from CHITIETSDDICHVU where MaSD=@MaSD))
	Begin
		update CHITIETSDDICHVU
		set SoLuongDV=@SoLuongDV, ThanhTien=@ThanhTien
		where MaSD=@MaSD and MaDV=@MaDV
		print N'Sửa thành công chi tiết máy chủ'
	End

	--Sửa chi tiết sử dụng dịch vụ máy trạm
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU
		set SoLuongDV=@SoLuongDV, ThanhTien=@ThanhTien
		where MaSD=@MaSD and MaDV=@MaDV
		print N'Sửa thành công chi tiết máy trạm'
	End
End
GO

--Tạo thủ tục xóa dữ liệu bảng CHITIETSDDICHVU
Create Proc XoaCHITIETSDDICHVU (
	@MaSD varchar(20),
	@MaDV varchar(20)
As
Begin
	--Kiểm tra MaSD ko được rỗng
	if (@MaSD is null or @MaSD='')
	Begin
		print N'Mã sử dụng dịch vụ không được rỗng'
		return
	End

	--Kiểm tra MaDV không được rỗng
	if (@MaDV is null or @MaDV='')
	Begin
		print N'Mã dịch vụ không được rỗng'
		return
	End

	--Kiểm tra khóa chính (MaSD, MaDV) có tồn tại ko
	if not exists (select MaSD 
			   from CHITIETSDDICHVU
			   where MaDV = @MaDV and MaSD = @MaSD)
	   and not exists (select MaSD 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETSDDICHVU
				   where MaDV = @MaDV and MaSD = @MaSD)
	Begin
		print N'Chi tiết không tồn tại'
		return
	End

	--Xóa chi tiết sử dụng dịch vụ máy chủ 
	if (exists (select MaSD from CHITIETSDDICHVU where MaSD=@MaSD))
	Begin
		delete from CHITIETSDDICHVU
		where MaSD=@MaSD and MaDV=@MaDV
		print N'Xóa thành công chi tiết máy chủ'
	End

	--Xóa chi tiết sử dụng dịch vụ máy trạm
	else
	Begin
		delete from CHITIETSDDICHVU
		where MaSD=@MaSD and MaDV=@MaDV
		print N'Xóa thành công chi tiết máy trạm'
	End
End
GO

---------*********HOSOBENHAN*********---------
-- Tạo thủ tục thêm dữ liệu bảng HOSOBENHAN
Create Proc ThemHOSOBENHAN (
	@MaHS varchar(20),
	@NgayBatDau datetime,
	@NgayKetThuc datetime,
	@KetQuaDieuTri nvarchar(max),
	@ChiPhi decimal,
	@MaBN varchar(20),
	@MaBS varchar(20),
	@ChanDoan nvarchar(max),
	@NoiTru int)
As
Begin
	--Kiểm tra MaHS ko được rỗng
	if (@MaHS is null or @MaHS='')
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

	-- kiểm tra BS có tồn tại không
	if not exists (select * from BACSI where MaBS=@MaBS)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaBS=@MaBS)
	Begin
		print N'Bác sĩ không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Thêm hồ sơ bệnh nhân máy chủ theo bệnh nhân
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into HOSOBENHAN values(@MaHS, @NgayBatDau, @NgayKetThuc, @KetQuaDieuTri, @ChiPhi, @MaBN, @MaBS, @ChanDoan, @NoiTru)		
		select @TenBN = TenBN from BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công hồ sơ bệnh nhân: ' + @TenBN
	End

	--Thêm hồ sơ bệnh nhân máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN values(@MaHS, @NgayBatDau, @NgayKetThuc, @KetQuaDieuTri, @ChiPhi, @MaBN, @MaBS, @ChanDoan, @NoiTru)
		select @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công hồ sơ bệnh nhân: ' + @TenBN
	End
End
GO

-- them du lieu
Exec ThemHOSOBENHAN 'HS0000001', '1/1/2016', '1/31/2016', N'hết đau nhức các khớp', 875000, 'BN000001', 'BS001', N'viêm khớp', 1
Exec ThemHOSOBENHAN 'HS0000002', '2/1/2016', '1/3/2016', N'hết nổi mẩn ngứa', 530000, 'BN000002', 'BS002', N'nổi mẩn ngứa do nấm', 0
Exec ThemHOSOBENHAN 'HS0000003', '3/1/2016', '1/20/2016', N'hết đau mắt', 220000, 'BN000003', 'BS003', N'đau mắt đỏ', 1
Exec ThemHOSOBENHAN 'HS0000004', '4/1/2016', '1/11/2016', N'hết nhức răng', 180000, 'BN000004', 'BS004', N'nhức răng', 0
Exec ThemHOSOBENHAN 'HS0000005', '5/1/2016', '3/3/2016', N'ổn định', 874000, 'BN000005', 'BS005', N'đau nửa đầu', 1
Exec ThemHOSOBENHAN 'HS0000006', '6/1/2016', '2/2/2016', N'giảm các cơn đau', 350000, 'BN000006', 'BS006', N'đau dạ dày', 0
Exec ThemHOSOBENHAN 'HS0000007', '7/1/2016', '11/15/2016', N'hết sốt', 890000, 'BN000007', 'BS007', N'sốt', 1
Exec ThemHOSOBENHAN 'HS0000008', '8/1/2016', '1/4/2016', N'hết căng thẳng', 760000, 'BN000008', 'BS008', N'căng thẳng quá độ', 0
Exec ThemHOSOBENHAN 'HS0000009', '9/1/2016', '3/4/2016', N'ngủ bình thường', 360000, 'BN000009', 'BS009', N'mất ngủ do rối loạn chức năng thần kinh', 1
Exec ThemHOSOBENHAN 'HS0000010', '10/1/2016', '2/2/2016', N'hết lang beng', 80000, 'BN000010', 'BS010', N'lang beng', 0

-- Tạo khung nhìn (trong suốt) cho bảng HOSOBENHAN
Create view View_HOSOBENHAN as
select * from HOSOBENHAN 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN
GO

-- Tạo thủ tục sửa dữ liệu bảng HOSOBENHAN
Create Proc SuaHOSOBENHAN (
	@MaHS varchar(20),
	@NgayBatDau datetime,
	@NgayKetThuc datetime,
	@KetQuaDieuTri nvarchar(max),
	@ChiPhi decimal,
	@MaBN varchar(20),
	@MaBS varchar(20),
	@ChanDoan nvarchar(max),
	@NoiTru int)
As
Begin
	--Kiểm tra MaHS ko được rỗng
	if (@MaHS is null or @MaHS='')
	Begin
		print N'Mã không được rỗng'
		return
	End
	
	-- kiểm tra MaHS có tồn tại không
	if not exists (select MaHS from HOSOBENHAN where MaHS=@MaHS)
	and not exists (select MaHS from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaHS=@MaHS)
	Begin
		print N'Hồ sơ không tồn tại'
		return
	End

	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End

	-- kiểm tra BS có tồn tại không
	if not exists (select * from BACSI where MaBS=@MaBS)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BACSI where MaBS=@MaBS)
	Begin
		print N'Bác sĩ không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Sửa hồ sơ bệnh nhân máy chủ
	if (exists (select MaHS from HOSOBENHAN where MaHS=@MaHS))
	Begin
		update HOSOBENHAN 
		set NgayBatDau=@NgayBatDau, NgayKetThuc=@NgayKetThuc, KetQuaDieuTri=@KetQuaDieuTri, ChiPhi=@ChiPhi, MaBN=@MaBN, MaBS=@MaBS, ChanDoan=@ChanDoan, NoiTru=@NoiTru
		where MaHS=@MaHS
		
		select @TenBN = TenBN from BENHNHAN where MaBN=@MaBN
		print N'Sửa thành công hồ sơ bệnh nhân: ' + @TenBN
	End

	--Sửa hồ sơ bệnh nhân máy trạm 
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN 
		set NgayBatDau=@NgayBatDau, NgayKetThuc=@NgayKetThuc, KetQuaDieuTri=@KetQuaDieuTri, ChiPhi=@ChiPhi, MaBN=@MaBN, MaBS=@MaBS, ChanDoan=@ChanDoan, NoiTru=@NoiTru
		where MaHS=@MaHS
		
		select @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Sửa thành công hồ sơ bệnh nhân: ' + @TenBN
	End
End
GO

-- Tạo thủ tục xóa dữ liệu bảng HOSOBENHAN
Create Proc XoaHOSOBENHAN (
	@MaHS varchar(20)
As
Begin
	--Kiểm tra MaHS ko được rỗng
	if (@MaHS is null or @MaHS='')
	Begin
		print N'Mã không được rỗng'
		return
	End

	--Kiểm tra MaHS có tồn tại ko
	if not exists (select MaHS from HOSOBENHAN where MaHS=@MaHS)
	and not exists (select MaHS from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaHS=@MaHS)
	Begin
		print N'Hồ sơ không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Sửa hồ sơ bệnh nhân máy chủ
	if (exists (select MaHS from HOSOBENHAN where MaHS=@MaHS))
	Begin
		select @TenBN = TenBN 
		from BENHNHAN bn, HOSOBENHAN hs 
		where MaHS=@MaHS and bn.MaBN=hs.MaBN
		
		--xóa
		delete form HOSOBENHAN 
		where MaHS=@MaHS		
		
		print N'Xóa thành công hồ sơ bệnh nhân: ' + @TenBN
	End

	--Sửa hồ sơ bệnh nhân máy trạm 
	else
	Begin
		select @TenBN = TenBN 
		from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN bn, SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN hs 
		where MaHS=@MaHS and bn.MaBN=hs.MaBN
		
		--xóa
		delete form SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN 
		where MaHS=@MaHS		
		
		print N'Xóa thành công hồ sơ bệnh nhân: ' + @TenBN
	End
End
GO

---------*********PHIEUXETNGHIEM*********---------
-- Tạo thủ tục thêm dữ liệu bảng PHIEUXETNGHIEM
Create Proc ThemPHIEUXETNGHIEM (
	@MaPhieuXN varchar(20),
	@MaBN varchar(20),
	@NgayXN datetime,
	@LyDoXN nvarchar(max))
As
Begin
	--Kiểm tra MaPhieuXN ko được rỗng
	if (@MaPhieuXN is null or @MaPhieuXN='')
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
	
	declare @TenBN nvarchar(255)

	--Thêm phiếu xét nghiệm máy chủ theo bệnh nhân
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into PHIEUXETNGHIEM values(@MaPhieuXN, @MaBN, @NgayXN, @LyDoXN)		
		select @TenBN = TenBN from BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End

	--Thêm phiếu xét nghiệm máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM values(@MaPhieuXN, @MaBN, @NgayXN, @LyDoXN)
		select @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End
End
GO

-- them du lieu
Exec ThemPHIEUXETNGHIEM 'PXH0000001', 'BN000001', '1/4/2016', N'kiểm tra hàm lượng đường trong máu'
Exec ThemPHIEUXETNGHIEM 'PXH0000002', 'BN000002', '1/3/2016', N'mẩn ngứa'
Exec ThemPHIEUXETNGHIEM 'PXH0000003', 'BN000003', '2/3/2016', N'kiểm tra kháng thể viêm gan B'
Exec ThemPHIEUXETNGHIEM 'PXH0000004', 'BN000004', '12/2/2016', N'kiểm tra kháng thể sởi'
Exec ThemPHIEUXETNGHIEM 'PXH0000005', 'BN000005', '9/1/2016', N'kiểm tra lượng dịch mật'
Exec ThemPHIEUXETNGHIEM 'PXH0000006', 'BN000006', '4/10/2016', N'kiểm tra virus cúm'
Exec ThemPHIEUXETNGHIEM 'PXH0000007', 'BN000007', '2/12/2016', N'kiểm tra men gan'
Exec ThemPHIEUXETNGHIEM 'PXH0000008', 'BN000008', '2/20/2016', N'kiểm tra hàm lượng đường trong máu'
Exec ThemPHIEUXETNGHIEM 'PXH0000009', 'BN000009', '3/23/2016', N'xét nghiệm kháng thể viêm gan B'
Exec ThemPHIEUXETNGHIEM 'PXH0000010', 'BN000010', '3/19/2016', N'xét nghiệm lượng hồng cầu trong máu'

-- Tạo khung nhìn (trong suốt) cho bảng PHIEUXETNGHIEM
Create view View_PhieuXetNhiem as
select * from PHIEUXETNGHIEM 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM
GO

-- Tạo thủ tục sửa dữ liệu bảng PHIEUXETNGHIEM
Create Proc SuaPHIEUXETNGHIEM (
	@MaPhieuXN varchar(20),
	@MaBN varchar(20),
	@NgayXN datetime,
	@LyDoXN nvarchar(max))
As
Begin
	--Kiểm tra MaPhieuXN ko được rỗng
	if (@MaPhieuXN is null or @MaPhieuXN='')
	Begin
		print N'Mã không được rỗng'
		return
	End
	
	--Kiểm tra MaPhieuXN có tồn tại ko
	if not exists (select MaPhieuXN from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	and not exists (select MaPhieuXN from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	Begin
		print N'Phiếu xét nghiệm không tồn tại'
		return
	End

	--Kiểm tra MaBN có tồn tại ko
	if not exists (select * from BENHNHAN where MaBN=@MaBN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN)
	Begin
		print N'Bệnh nhân không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Sửa phiếu xét nghiệm máy chủ 
	if (exists (select MaPhieuXN from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN))
	Begin
		update PHIEUXETNGHIEM 
		set MaBN=@MaBN, NgayXN=@NgayXN, LyDoXN=@LyDoXN
		where MaPhieuXN=@MaPhieuXN
		
		select @TenBN = TenBN from BENHNHAN where MaBN=@MaBN
		print N'Sửa thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End

	--Thêm phiếu xét nghiệm máy trạm
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM 
		set MaBN=@MaBN, NgayXN=@NgayXN, LyDoXN=@LyDoXN
		where MaPhieuXN=@MaPhieuXN
		
		select @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Sửa thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End
End
GO

-- Tạo thủ tục xóa dữ liệu bảng PHIEUXETNGHIEM
Create Proc XoaPHIEUXETNGHIEM (
	@MaPhieuXN varchar(20)
As
Begin
	--Kiểm tra MaPhieuXN ko được rỗng
	if (@MaPhieuXN is null or @MaPhieuXN='')
	Begin
		print N'Mã không được rỗng'
		return
	End
	
	--Kiểm tra MaPhieuXN có tồn tại ko
	if not exists (select MaPhieuXN from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	and not exists (select MaPhieuXN from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	Begin
		print N'Phiếu xét nghiệm không tồn tại'
		return
	End

	--Kiểm tra có chitietxetnghiem không
	if exists (select MaPhieuXN from CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	or exists (select MaPhieuXN from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	Begin
		print N'đã tồn tại CHITIETXETNGHIEM'
		return
	End
	
	declare @TenBN nvarchar(255)
	
	--Xóa phiếu xét nghiệm máy chủ 
	if (exists (select MaPhieuXN from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN))
	Begin
		select @TenBN = TenBN 
		from PHIEUXETNGHIEM xn, BENHNHAN bn
		where MaPhieuXN=@MaPhieuXN and bn.MaBN=xn.MaBN
	
		delete from PHIEUXETNGHIEM 
		where MaPhieuXN=@MaPhieuXN
		
		print N'Xóa thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End

	--Thêm phiếu xét nghiệm máy trạm
	else
	Begin
		select @TenBN = TenBN 
		from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM xn, SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN bn
		where MaPhieuXN=@MaPhieuXN and bn.MaBN=xn.MaBN
	
		delete from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM 
		where MaPhieuXN=@MaPhieuXN
		
		print N'Xóa thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End
End
GO

---------*********CHITIETXETNGHIEM*********---------
-- Tạo thủ tục thêm dữ liệu bảng CHITIETXETNGHIEM
Create Proc ThemCHITIETXETNGHIEM (
	@MaPhieuXN varchar(20),
	@MaLoaiXN varchar(20),
	@KetQuaXN nvarchar(max))
As
Begin
	--Kiểm tra MaPhieuXN ko được rỗng
	if (@MaPhieuXN is null or @MaPhieuXN='')
	Begin
		print N'Mã phiếu xét nghiệm không được rỗng'
		return
	End
	
	
	--Kiểm tra MaPhieuXN có tồn tại ko
	if not exists (select * from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	Begin
		print N'Phiếu xét nghiệm không tồn tại'
		return
	End

	--Kiểm tra MaLoaiXN ko được rỗng
	if (@MaLoaiXN is null or @MaLoaiXN='')
	Begin
		print N'Mã loại XN không được rỗng'
		return
	End

	--Kiểm tra MaLoaiXN có tồn tại ko
	if not exists (select * from LOAIXETNGHIEM where MaLoaiXN=@MaLoaiXN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.LOAIXETNGHIEM where MaLoaiXN=@MaLoaiXN)
	Begin
		print N'Loại xét nghiệm không tồn tại'
		return
	End 

	--Kiểm tra khóa chính (MaPhieuXN, MaLoaiXN) có trùng ko
	if exists (select MaPhieuXN 
			   from CHITIETXETNGHIEM
			   where MaPhieuXN = @MaPhieuXN and MaLoaiXN = @MaLoaiXN)
	   or exists (select MaPhieuXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM
				   where MaPhieuXN = @MaPhieuXN and MaLoaiXN = @MaLoaiXN)
	Begin
		print N'Chi tiết trùng mã'
		return
	End

	--Thêm chi tiết phiếu xét nghiệm máy chủ theo phiếu xét nghiệm
	if (exists (select MaPhieuXN from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN))
	Begin
		insert into CHITIETXETNGHIEM values(@MaPhieuXN, @MaLoaiXN, @KetQuaXN)		
		print N'Thêm thành công chi tiết'
	End

	--Thêm chi tiết sử dụng dịch vụ máy trạm theo phiếu xét nghiệm
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM values(@MaPhieuXN, @MaLoaiXN, @KetQuaXN)		
		print N'Thêm thành công chi tiết'
	End
End
GO

Exec ThemCHITIETXETNGHIEM 'PXH0000001', 'LXH0001', N'bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000002', 'LXH0002', N'nhiễm giun'
Exec ThemCHITIETXETNGHIEM 'PXH0000002', 'LXH0003', N'vẫn còn miễn dịch'
Exec ThemCHITIETXETNGHIEM 'PXH0000003', 'LXH0004', N'vẫn còn miễn dịch'
Exec ThemCHITIETXETNGHIEM 'PXH0000004', 'LXH0005', N'bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000005', 'LXH0005', N'bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000006', 'LXH0006', N'không phát hiện'
Exec ThemCHITIETXETNGHIEM 'PXH0000007', 'LXH0001', N'men gan cao hơn 1.1'
Exec ThemCHITIETXETNGHIEM 'PXH0000008', 'LXH0002', N'cao hơn bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000009', 'LXH0003', N'bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000010', 'LXH0004', N'bình thường'
Exec ThemCHITIETXETNGHIEM 'PXH0000010', 'LXH0001', N'bình thường'

-- Tạo khung nhìn (trong suốt) cho bảng CHITIETXETNGHIEM
Create view View_CHITIETXETNGHIEM as
select * from CHITIETXETNGHIEM 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM
GO


-- Tạo thủ sửa thêm dữ liệu bảng CHITIETXETNGHIEM
Create Proc SuaCHITIETXETNGHIEM (
	@MaPhieuXN varchar(20),
	@MaLoaiXN varchar(20),
	@KetQuaXN nvarchar(max))
As
Begin
	--Kiểm tra MaPhieuXN ko được rỗng
	if (@MaPhieuXN is null or @MaPhieuXN='')
	Begin
		print N'Mã phiếu xét nghiệm không được rỗng'
		return
	End
	
	
	--Kiểm tra MaPhieuXN có tồn tại ko
	if not exists (select * from PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM where MaPhieuXN=@MaPhieuXN)
	Begin
		print N'Phiếu xét nghiệm không tồn tại'
		return
	End

	--Kiểm tra MaLoaiXN ko được rỗng
	if (@MaLoaiXN is null or @MaLoaiXN='')
	Begin
		print N'Mã loại XN không được rỗng'
		return
	End

	--Kiểm tra MaLoaiXN có tồn tại ko
	if not exists (select * from LOAIXETNGHIEM where MaLoaiXN=@MaLoaiXN)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.LOAIXETNGHIEM where MaLoaiXN=@MaLoaiXN)
	Begin
		print N'Loại xét nghiệm không tồn tại'
		return
	End 

	--Kiểm tra khóa chính (MaPhieuXN, MaLoaiXN) có tồn tại ko
	if not exists (select MaPhieuXN 
			   from CHITIETXETNGHIEM
			   where MaPhieuXN = @MaPhieuXN and MaLoaiXN = @MaLoaiXN)
	   and not exists (select MaPhieuXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM
				   where MaPhieuXN = @MaPhieuXN and MaLoaiXN = @MaLoaiXN)
	Begin
		print N'Chi tiết không tồn tại'
		return
	End

	--Sửa chi tiết phiếu xét nghiệm máy chủ
	if (exists (select MaPhieuXN from CHITIETXETNGHIEM where MaPhieuXN=@MaPhieuXN))
	Begin
		update CHITIETXETNGHIEM 
		set  KetQuaXN=@KetQuaXN
		where MaPhieuXN=@MaPhieuXN and MaLoaiXN=@MaLoaiXN
		
		print N'Sửa thành công chi tiết'
	End

	--Sửa chi tiết phiếu xét nghiệm máy trạm
	else
	Begin		
		update SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM 
		set  KetQuaXN=@KetQuaXN
		where MaPhieuXN=@MaPhieuXN and MaLoaiXN=@MaLoaiXN
		
		print N'Sửa thành công chi tiết'
	End
End
GO


---------*********DONTHUOC*********---------
-- Tạo thủ tục thêm dữ liệu bảng DONTHUOC
Create Proc ThemDONTHUOC (
	@MaDon varchar(20),
	@NgayKham datetime,
	@MaHS varchar(20))
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã không được rỗng'
		return
	End

	--Kiểm tra MaHS có tồn tại ko
	if not exists (select * from HOSOBENHAN where MaHS=@MaHS)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaHS=@MaHS)
	Begin
		print N'Hồ sơ không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Thêm đơn thuốc máy chủ theo bệnh nhân
	if (exists (select MaHS from HOSOBENHAN where MaHS=@MaHS))
	Begin
		insert into DONTHUOC values(@MaDon, @NgayKham, @MaHS)		
		select distinct @TenBN = TenBN from BENHNHAN bn, HOSOBENHAN hs where MaHS=@MaHS and hs.MaBN=hs.MaBN
		print N'Thêm thành công đơn thuốc bệnh nhân: ' + @TenBN
	End

	--Thêm đơn thuốc máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC values(@MaDon, @NgayKham, @MaHS)		
		select distinct @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN bn, SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN hs where MaHS=@MaHS and hs.MaBN=hs.MaBN
		print N'Thêm thành công đơn thuốc bệnh nhân: ' + @TenBN
	End
End
GO

Exec ThemDONTHUOC 'DON000001', '2016-03-12', 'HS0000001'
Exec ThemDONTHUOC 'DON000002', '2016-02-10', 'HS0000002'
Exec ThemDONTHUOC 'DON000003', '2016-01-15', 'HS0000003'
Exec ThemDONTHUOC 'DON000004', '2016-03-15', 'HS0000004'
Exec ThemDONTHUOC 'DON000005', '2016-03-16', 'HS0000005'
Exec ThemDONTHUOC 'DON000006', '2016-03-17', 'HS0000006'
Exec ThemDONTHUOC 'DON000007', '2016-03-18', 'HS0000007'
Exec ThemDONTHUOC 'DON000008', '2016-03-19', 'HS0000008'
Exec ThemDONTHUOC 'DON000009', '2016-03-20', 'HS0000009'
Exec ThemDONTHUOC 'DON000010', '2016-03-21', 'HS0000010'

-- Tạo khung nhìn (trong suốt) cho bảng DONTHUOC
Create view View_DONTHUOC as
select * from DONTHUOC 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC
GO

-- Tạo thủ tục sửa dữ liệu bảng DONTHUOC
Create Proc SuaDONTHUOC (
	@MaDon varchar(20),
	@NgayKham datetime,
	@MaHS varchar(20))
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã không được rỗng'
		return
	End
	
	--Kiểm tra MaDon có tồn tại ko
	if not exists (select MaDon from DONTHUOC where MaDon=@MaDon)
	and not exists (select MaDon from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaDon=@MaDon)
	Begin
		print N'Đơn thuốc không tồn tại'
		return
	End

	--Kiểm tra MaHS có tồn tại ko
	if not exists (select * from HOSOBENHAN where MaHS=@MaHS)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN where MaHS=@MaHS)
	Begin
		print N'Hồ sơ không tồn tại'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Sửa đơn thuốc máy chủ 
	if (exists (select MaDon from DONTHUOC where MaDon=@MaDon))
	Begin
		update DONTHUOC
		set NgayKham=@NgayKham, MaHS=@MaHS
		where MaDon=@MaDon
		
		select distinct @TenBN = TenBN from BENHNHAN bn, HOSOBENHAN hs where MaHS=@MaHS and hs.MaBN=hs.MaBN
		print N'Sửa thành công đơn thuốc bệnh nhân: ' + @TenBN
	End

	--Sửa đơn thuốc máy trạm 
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC
		set NgayKham=@NgayKham, MaHS=@MaHS
		where MaDon=@MaDon
		
		select distinct @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN bn, SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN hs where MaHS=@MaHS and hs.MaBN=hs.MaBN
		print N'Sửa thành công đơn thuốc bệnh nhân: ' + @TenBN
	End
End
GO


-- Tạo thủ tục xóa dữ liệu bảng DONTHUOC
Create Proc XoaDONTHUOC (
	@MaDon varchar(20)
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã không được rỗng'
		return
	End
	
	--Kiểm tra MaDon có tồn tại ko
	if not exists (select MaDon from DONTHUOC where MaDon=@MaDon)
	and not exists (select MaDon from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaDon=@MaDon)
	Begin
		print N'Đơn thuốc không tồn tại'
		return
	End
	
	--Kiểm tra có tồn tại bảng chitietdonthuoc không
	if  exists (select MaDon from CHITIETDONTHUOC where MaDon=@MaDon)
	or exists (select MaDon from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC where MaDon=@MaDon)
	Begin
		print N'đã tồn tại đơn thuốc trong bảng CHITIETDONTHUOC'
		return
	End
	
	declare @TenBN nvarchar(255)

	--Xóa đơn thuốc máy chủ 
	if (exists (select MaDon from DONTHUOC where MaDon=@MaDon))
	Begin
		select distinct @TenBN = TenBN 
		from BENHNHAN bn, HOSOBENHAN hs, DONTHUOC dt 
		where MaDon=@MaDon and hs.MaBN=hs.MaBN and dt.MaHS=hs.MaHS
	
		delete from DONTHUOC
		set NgayKham=@NgayKham, MaHS=@MaHS
		where MaDon=@MaDon		
		
		print N'Xóa thành công đơn thuốc bệnh nhân: ' + @TenBN
	End

	--Xóa đơn thuốc máy trạm 
	else
	Begin
		select distinct @TenBN = TenBN 
		from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN bn, SQL_Home.QuanLyBenhNhan.dbo.HOSOBENHAN hs, SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC dt 
		where MaDon=@MaDon and hs.MaBN=hs.MaBN and dt.MaHS=hs.MaHS
	
		delete from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC
		set NgayKham=@NgayKham, MaHS=@MaHS
		where MaDon=@MaDon
		print N'Xóa thành công đơn thuốc bệnh nhân: ' + @TenBN
	End
End
GO


---------*********THUOC*********---------
---- Tạo thủ tục thêm dữ liệu bảng THUOC
Create Proc ThemTHUOC (
	@MaThuoc varchar(20),
	@TenThuoc nvarchar(max),
	@MoTa nvarchar(max),
	@XuatXu nvarchar(max))
As
Begin
	--Kiểm tra mã Thuốc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã thuốc không được rỗng'
		return
	End

	--Kiểm tra mã Thuốc ko được trùng
	if exists (Select * from THUOC where MaThuoc=@MaThuoc) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.THUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Mã thuốc đã tồn tại'
		return
	End

	--Kiểm tra tên Thuốc ko được rỗng
	if (@TenThuoc is null or @TenThuoc='')
	Begin
		print N'Mã thuốc không được rỗng'
		return
	End

	--Kiểm tra tên Thuốc ko được trùng
	if exists (Select TenThuoc from THUOC where TenThuoc=@TenThuoc)
	Begin
		print N'Tên thuốc đã tồn tại'
		return
	End

	--Thêm vào bảng thuốc
	--may chu
	insert into THUOC values(@MaThuoc, @TenThuoc)
	--may tram
	insert into SQL_Home.QuanLyBenhNhan.dbo.THUOC 
		values(@MaThuoc, @MoTa, @XuatXu)
		
	print N'Thêm thành công thuốc ' + @TenThuoc	
End
GO

--thêm dữ liệu
Exec ThemTHUOC 'T0000001', 'EMTRIVA ORAL CAPSULE', N'Trị đau nửa đầu', N'Ấn Độ'
Exec ThemTHUOC 'T0000002', 'EPIVIR HBV ORAL SOLUTION', N'Trị đau dạ dày', N'Pháp'
Exec ThemTHUOC 'T0000003', 'FUZEON SUBCUTANEOUS RECON SOLN', N'Trị đau nhức khớp', N'Pháp'
Exec ThemTHUOC 'T0000004', 'GENVOYA', N'Trị đau nhức cơ', N'Hàn Quốc'
Exec ThemTHUOC 'T0000005', 'INTELENCE ORAL TABLET 100 MG', N'Hỗ trợ men gan', N'Pháp'
Exec ThemTHUOC 'T0000006', 'KALETRA ORAL TABLET 100-25 MG', N'Hỗ trợ tuần hoàn máu', N'Ấn Độ'
Exec ThemTHUOC 'T0000007', 'PREZISTA ORAL TABLET 150 MG', N'Hỗ trợ hệ thần kinh', N'Pháp'
Exec ThemTHUOC 'T0000008', 'REYATAZ ORAL CAPSULE 150 MG', N'Hỗ trợ thoái hóa xương khớp', N'Pháp'
Exec ThemTHUOC 'T0000009', 'SUSTIVA ORAL CAPSULE 200 MG ', N'Hỗ trợ hệ miễn dịch', N'Ấn Độ'
Exec ThemTHUOC 'T0000010', 'VIDEX 2 GRAM PEDIATRIC', N'Hỗ trợ tim mạch', N'Pháp'
Exec ThemTHUOC 'T0000011', 'VIRACEPT ORAL TABLET 250 MG', N'Tăng cường dịch mật', N'Ấn Độ'
Exec ThemTHUOC 'T0000012', 'CEFTRIAXONE INJECTION RECON SOLN 100 $0-7.40 (Tier 2) GRAM', N'Tăng cường máu lên não', N'Pháp'
Exec ThemTHUOC 'T0000013', 'ERYTHROCIN INTRAVENOUS RECON SOLN $0-7.40 (Tier 2) 500 MG', N'Hỗ trợ hệ thần kinh ngoại biên', N'Pháp'
Exec ThemTHUOC 'T0000014', 'ALINIA ORAL SUSPENSION FOR $0-7.40 (Tier 2) MO; QLL (180 per 3 days) RECONSTITUTION', N'Diệt virus EV', N'Pháp'
Exec ThemTHUOC 'T0000015', 'AZACTAM IN DEXTROSE (ISO-OSM)', N'Hỗ trợ điều trị trầm cảm', N'Hàn Quốc'
Exec ThemTHUOC 'T0000016', 'CAPASTAT', N'Trị sỏi thận', N'Pháp'
Exec ThemTHUOC 'T0000017', 'DAPSONE', N'Diệt giun', N'Ấn Độ'
Exec ThemTHUOC 'T0000018', 'NEBUPENT', N'Hỗ trợ ổn định huyết áp', N'Pháp'
Exec ThemTHUOC 'T0000019', 'PENTAM', N'Chống đông máu', N'Pháp'
Exec ThemTHUOC 'T0000020', 'PRIMAQUINE', N'Tăng cường miễn dịch tuyến tụy', N'Ấn Độ'


Create view View_Thuoc as
select * from THUOC mc Inner join SQL_Home.QuanLyBenhNhan.dbo.THUOC mt
on (mc.MaThuoc=mt.MaThuoc)
GO


---- Tạo thủ tục ===SỬA=== dữ liệu bảng THUOC
Create Proc SuaTHUOC (
	@MaThuoc varchar(20),
	@TenThuoc nvarchar(max),
	@MoTa nvarchar(max),
	@XuatXu nvarchar(max))
As
Begin
	--Kiểm tra mã Thuốc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã thuốc không được rỗng'
		return
	End	

	--Kiểm tra mã Thuốc tồn tại
	if not exists (Select * from THUOC where MaThuoc=@MaThuoc) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.THUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Mã thuốc không tồn tại'
		return
	End

	--Kiểm tra tên Thuốc ko được rỗng
	if (@TenThuoc is null or @TenThuoc='')
	Begin
		print N'Mã thuốc không được rỗng'
		return
	End

	--Kiểm tra tên Thuốc ko được trùng
	if exists (Select TenThuoc from THUOC where TenThuoc=@TenThuoc)
	Begin
		print N'Tên thuốc đã tồn tại'
		return
	End

	--Thêm vào bảng thuốc
	--may chu
	update THUOC 
	set TenThuoc=@TenThuoc
	where MaThuoc=@MaThuoc
	--may tram
	update SQL_Home.QuanLyBenhNhan.dbo.THUOC 
	set MoTa=@MoTa, XuatXu=@XuatXu
	where MaThuoc=@MaThuoc
		
	print N'Sửa thành công thuốc ' + @TenThuoc	
End
GO

---- Tạo thủ tục ===XÓA=== dữ liệu bảng THUOC
Create Proc XoaTHUOC (
	@MaThuoc varchar(20)
As
Begin
	--Kiểm tra mã Thuốc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã thuốc không được rỗng'
		return
	End	

	--Kiểm tra mã Thuốc tồn tại
	if not exists (Select * from THUOC where MaThuoc=@MaThuoc) and not exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.THUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Mã thuốc không tồn tại'
		return
	End
	
	--kiểm tra mã thuốc có trong bảng chitietdonthuoc
	if exists (Select * from CHITIETDONTHUOC where MaThuoc=@MaThuoc) or exists ( select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Mã thuốc đã tồn tại trong bảng CHITIETDONTHUOC'
		return
	End
	
	declare @TenThuoc nvarchar(255)
	select @TenThuoc=TenThuoc from THUOC where MaThuoc=@MaThuoc

	--Thêm vào bảng thuốc
	--may chu
	delete from THUOC
	where MaThuoc=@MaThuoc
	--may tram
	delete from SQL_Home.QuanLyBenhNhan.dbo.THUOC 
	where MaThuoc=@MaThuoc
		
	print N'Xóa thành công thuốc ' + @TenThuoc	
End
GO


---------*********CHITIETDONTHUOC*********---------
-- Tạo thủ tục thêm dữ liệu bảng CHITIETDONTHUOC
Create Proc ThemCHITIETDONTHUOC (
	@MaDon varchar(20),
	@MaThuoc varchar(20),
	@SoLuong int,
	@CachDung nvarchar(max))
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã đơn không được rỗng'
		return
	End
	
	
	--Kiểm tra MaDon có tồn tại ko
	if not exists (select * from MaDon where MaDon=@MaDon)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaDon=@MaDon)
	Begin
		print N'Đơn thuốc không tồn tại'
		return
	End

	--Kiểm tra MaThuoc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã loại XN không được rỗng'
		return
	End

	--Kiểm tra MaThuoc có tồn tại ko
	if not exists (select * from THUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Thuốc không tồn tại'
		return
	End 

	--Kiểm tra khóa chính (MaDon, MaThuoc) có trùng ko
	if exists (select MaPhieuXN 
			   from CHITIETDONTHUOC
			   where MaDon = @MaDon and MaThuoc = @MaThuoc)
	   or exists (select MaPhieuXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC
				   where MaDon = @MaDon and MaThuoc = @MaThuoc)

	--Thêm chi tiết đơn thuốc máy chủ
	if (exists (select MaDon from DONTHUOC where MaDon=@MaDon))
	Begin
		insert into CHITIETDONTHUOC values(@MaDon, @MaThuoc, @SoLuong, @CachDung)		
		print N'Thêm thành công chi tiết'
	End

	--Thêm chi tiết đơn thuốc máy trạm
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC values(@MaDon, @MaThuoc, @SoLuong, @CachDung)		
		print N'Thêm thành công chi tiết'
	End
End
GO

Exec ThemCHITIETDONTHUOC 'DON000001', 'T0000001', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000001', 'T0000002', 30, N'Ngày 1 lần'
Exec ThemCHITIETDONTHUOC 'DON000001', 'T0000003', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000002', 'T0000001', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000002', 'T0000006', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000003', 'T0000007', 30, N'Ngày 1 lần'
Exec ThemCHITIETDONTHUOC 'DON000003', 'T0000009', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000003', 'T0000011', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000004', 'T0000002', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000004', 'T0000005', 30, N'Ngày 1 lần'
Exec ThemCHITIETDONTHUOC 'DON000005', 'T0000003', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000005', 'T0000012', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000005', 'T0000010', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000006', 'T0000014', 30, N'Ngày 1 lần'
Exec ThemCHITIETDONTHUOC 'DON000006', 'T0000016', 30, N'Ngày 1 lần'
Exec ThemCHITIETDONTHUOC 'DON000006', 'T0000018', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000007', 'T0000019', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000007', 'T0000013', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000008', 'T0000011', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000008', 'T0000001', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000009', 'T0000004', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000009', 'T0000006', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000010', 'T0000008', 60, N'Ngày 2 lần'
Exec ThemCHITIETDONTHUOC 'DON000010', 'T0000017', 90, N'Ngày 3 lần'
Exec ThemCHITIETDONTHUOC 'DON000010', 'T0000019', 30, N'Ngày 1 lần'


-- Tạo khung nhìn (trong suốt) cho bảng CHITIETDONTHUOC
Create view View_CHITIETDONTHUOC as
select * from CHITIETDONTHUOC 
union
select * from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC
GO


-- Tạo thủ tục Sửa dữ liệu bảng CHITIETDONTHUOC
Create Proc SuaCHITIETDONTHUOC (
	@MaDon varchar(20),
	@MaThuoc varchar(20),
	@SoLuong int,
	@CachDung nvarchar(max))
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã đơn không được rỗng'
		return
	End
	
	
	--Kiểm tra MaDon có tồn tại ko
	if not exists (select * from MaDon where MaDon=@MaDon)
	and not exists (select * from SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC where MaDon=@MaDon)
	Begin
		print N'Đơn thuốc không tồn tại'
		return
	End

	--Kiểm tra MaThuoc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã loại XN không được rỗng'
		return
	End

	--Kiểm tra MaThuoc có tồn tại ko
	if not exists (select * from THUOC where MaThuoc=@MaThuoc)
	Begin
		print N'Thuốc không tồn tại'
		return
	End 

	--Kiểm tra khóa chính (MaDon, MaThuoc) có tồn tại ko
	if not exists (select MaPhieuXN 
			   from CHITIETDONTHUOC
			   where MaDon = @MaDon and MaThuoc = @MaThuoc)
	   and not exists (select MaPhieuXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC
				   where MaDon = @MaDon and MaThuoc = @MaThuoc)

	--Sửa chi tiết đơn thuốc máy chủ
	if (exists (select MaDon from CHITIETDONTHUOC where MaDon=@MaDon))
	Begin
		update CHITIETDONTHUOC 
		set  MaThuoc=@MaThuoc, SoLuong=@SoLuong, CachDung=@CachDung
		where MaDon=@MaDon
		
		print N'Sửa thành công chi tiết'
	End

	--Sửa chi tiết đơn thuốc máy trạm
	else
	Begin
		update SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC 
		set  MaThuoc=@MaThuoc, SoLuong=@SoLuong, CachDung=@CachDung
		where MaDon=@MaDon
		
		print N'Sửa thành công chi tiết'
	End
End
GO

-- Tạo thủ tục Sửa dữ liệu bảng CHITIETDONTHUOC
Create Proc XoaCHITIETDONTHUOC (
	@MaDon varchar(20),
	@MaThuoc varchar(20)
As
Begin
	--Kiểm tra MaDon ko được rỗng
	if (@MaDon is null or @MaDon='')
	Begin
		print N'Mã đơn không được rỗng'
		return
	End	
	
	--Kiểm tra MaThuoc ko được rỗng
	if (@MaThuoc is null or @MaThuoc='')
	Begin
		print N'Mã loại XN không được rỗng'
		return
	End

	--Kiểm tra khóa chính (MaDon, MaThuoc) có tồn tại ko
	if not exists (select MaPhieuXN 
			   from CHITIETDONTHUOC
			   where MaDon = @MaDon and MaThuoc = @MaThuoc)
	   and not exists (select MaPhieuXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC
				   where MaDon = @MaDon and MaThuoc = @MaThuoc)

	--Xóa chi tiết đơn thuốc máy chủ
	if (exists (select MaDon from CHITIETDONTHUOC where MaDon=@MaDon))
	Begin
		delete from CHITIETDONTHUOC
		where MaDon=@MaDon and MaThuoc=@MaThuoc
		
		print N'Xóa thành công chi tiết'
	End

	--Xóa chi tiết đơn thuốc máy trạm
	else
	Begin
		delete from CHITIETDONTHUOC
		where MaDon=@MaDon and MaThuoc=@MaThuoc
		
		print N'Xóa thành công chi tiết'
	End
End
GO

