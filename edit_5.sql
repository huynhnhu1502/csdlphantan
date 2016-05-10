
-- proc ho so benh nhan
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

--
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


-- proc phiếu xét nghiệm
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

-- proc chi tiết xét nghiệm
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

	--Kiểm tra khóa chính trên máy chủ (MaPhieuXN, MaLoaiXN) có trùng ko
	if exists (select cxn.MaPhieuXN 
			   from CHITIETXETNGHIEM cxn, PHIEUXETNGHIEM pxn
			   where cxn.MaPhieuXN = pxn.MaPhieuXN and cxn.MaPhieuXN=@MaPhieuXN)
	   and exists (select cxn.MaLoaiXN 
				   from CHITIETXETNGHIEM cxn, LOAIXETNGHIEM lxn 
				   where cxn.MaLoaiXN = dv.MaLoaiXN and cxn.MaLoaiXN=@MaLoaiXN)
	Begin
		print N'Chi tiết đã tồn tại'
		return
	End

	--Kiểm tra khóa chính trên máy trạm (MaPhieuXN, MaLoaiXN) có trùng ko
	if exists (select cxn.MaPhieuXN 
			   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM cxn, SQL_Home.QuanLyBenhNhan.dbo.PHIEUXETNGHIEM pxn
			   where cxn.MaPhieuXN = pxn.MaPhieuXN and cxn.MaPhieuXN=@MaPhieuXN)
	   and exists (select cxn.MaLoaiXN 
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETXETNGHIEM cxn, SQL_Home.QuanLyBenhNhan.dbo.LOAIXETNGHIEM lxn 
				   where cxn.MaLoaiXN = dv.MaLoaiXN and cxn.MaLoaiXN=@MaLoaiXN)
	Begin
		print N'Chi tiết đã tồn tại'
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

-- proc don thuoc
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


-- proc chi tiết xét nghiệm
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

	--Kiểm tra khóa chính trên máy chủ (MaDon, MaThuoc) có trùng ko
	if exists (select ct.MaDon 
			   from CHITIETDONTHUOC ct, DONTHUOC dt
			   where ct.MaDon = dt.MaDon and ct.MaDon=@MaDon)
	   and exists (select ct.MaLoaiXN 
				   from CHITIETDONTHUOC ct, THUOC t 
				   where ct.MaThuoc = t.MaThuoc and ct.MaThuoc=@MaThuoc)
	Begin
		print N'Chi tiết đã tồn tại'
		return
	End

	--Kiểm tra khóa chính trên máy trạm (MaDon, MaThuoc) có trùng ko
	if exists (select ct.MaDon 
			   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC ct, SQL_Home.QuanLyBenhNhan.dbo.DONTHUOC dt
			   where ct.MaDon = ct.MaDon and ct.MaDon=@MaDon)
	   and exists (select ct.MaLoaiXN
				   from SQL_Home.QuanLyBenhNhan.dbo.CHITIETDONTHUOC ct, SQL_Home.QuanLyBenhNhan.dbo.THUOC t 
				   where ct.MaThuoc = t.MaThuoc and ct.MaThuoc=@MaThuoc)
	Begin
		print N'Chi tiết đã tồn tại'
		return
	End

	--Thêm chi tiết phiếu xét nghiệm máy chủ theo phiếu xét nghiệm
	if (exists (select MaDon from DONTHUOC where MaDon=@MaDon))
	Begin
		insert into CHITIETDONTHUOC values(@MaDon, @MaThuoc, @SoLuong, @CachDung)		
		print N'Thêm thành công chi tiết'
	End

	--Thêm chi tiết sử dụng dịch vụ máy trạm theo phiếu xét nghiệm
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