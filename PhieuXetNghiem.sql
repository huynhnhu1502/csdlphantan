-- proc phiếu xét nghiệm
Create Proc ThemPHIEUXETNGHIEM (
	@MaPhieuXN varchar(20),
	@MaBN varchar(20),
	@NgayXN datetime,
	@LyDoXN nvarchar(max)
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

	--Thêm hồ sơ bệnh nhân máy chủ theo bệnh nhân
	if (exists (select MaBN from BENHNHAN where MaBN=@MaBN))
	Begin
		insert into PHIEUXETNGHIEM values(@MaPhieuXN, @MaBN, @NgayXN, @LyDoXN)		
		select @TenBN = TenBN from BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End

	--Thêm hồ sơ bệnh nhân máy trạm theo bệnh nhân
	else
	Begin
		insert into SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM values(@MaPhieuXN, @MaBN, @NgayXN, @LyDoXN)
		select @TenBN = TenBN from SQL_Home.QuanLyBenhNhan.dbo.BENHNHAN where MaBN=@MaBN
		print N'Thêm thành công phiếu xét nghiệm bệnh nhân: ' + @TenBN
	End
End
GO
