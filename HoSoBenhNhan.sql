Create Proc ThemHOSOBENHAN (
	@MaHS varchar(20),
	@NgayBatDau datetime,
	@NgayKetThuc datetime,
	@KetQuaDieuTri nvarchar(max),
	@ChiPhi decimal,
	@MaBN varchar(20),
	@MaBS varchar(20),
	@ChanDoan nvarchar(max),
	@NoiTru int
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