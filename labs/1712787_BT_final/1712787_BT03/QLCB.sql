﻿USE master
GO

IF DB_ID('QLCB') IS NOT NULL
DROP DATABASE QLCB
GO
--Tạo database quản lý chuyến bay
CREATE DATABASE QLCB
GO

USE QLCB
GO
------------------------------------------------
--Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG(
    MAKH NCHAR(15),
    TEN  NCHAR(50),
    DCHI NCHAR(50),
    DTHOAI NCHAR(12),

	CONSTRAINT PK_KHACHHANG PRIMARY KEY(MAKH)
);
--Tạo bảng NHANVIEN
CREATE TABLE NHANVIEN(
    MANV NCHAR(15),
    TEN  NCHAR(50),
    DCHI NCHAR(50),
    DTHOAI NCHAR(12),
    LUONG FLOAT,
    LOAINV BIT,

	CONSTRAINT PK_NHANVIEN PRIMARY KEY(MANV)
);
--Tạo bảng LOAIMB
CREATE TABLE LOAIMB(
    MALOAI NCHAR(15),
    HANGSX NCHAR(15),

	CONSTRAINT PK_LOAIMB PRIMARY KEY(MALOAI)
);
--Tạo bảng MAYBAY
CREATE TABLE MAYBAY(
    SOHIEU INT,
    MALOAI NCHAR(15),

	CONSTRAINT PK_MAYBAY PRIMARY KEY(SOHIEU, MALOAI)
)
--Tạo bảng CHUYENBAY
CREATE TABLE CHUYENBAY(
    MACB  NCHAR(15),
    SBDI  NCHAR(3),
    SBDEN NCHAR(3),
    GIODI TIME,
    GIODEN TIME,

	CONSTRAINT PK_CHUYENBAY PRIMARY KEY(MACB)
);
--Tạo bảng LICHBAY
CREATE TABLE LICHBAY(
    NGAYDI DATE,
    MACB   NCHAR(15),
    SOHIEU INT,
    MALOAI NCHAR(15)

	CONSTRAINT PK_LICHBAY PRIMARY KEY(NGAYDI, MACB)
);
--Tạo bảng DATCHO
CREATE TABLE DATCHO(
    MAKH NCHAR(15),
    NGAYDI DATE,
    MACB   NCHAR(15),

	CONSTRAINT PK_DATCHO PRIMARY KEY(MAKH, NGAYDI, MACB)
);

--Tạo bảng KHANANG
CREATE TABLE KHANANG(
    MANV NCHAR(15),
    MALOAI NCHAR(15),


	CONSTRAINT PK_KHANANG PRIMARY KEY(MANV, MALOAI)
);
--Tạo bảng PHANCONG
CREATE TABLE PHANCONG(
    MANV NCHAR(15),
    NGAYDI DATE,
    MACB NCHAR(15),

	CONSTRAINT PK_PHANCONG PRIMARY KEY(MANV, NGAYDI, MACB)
);

--------------------------------------------------------------------
--Tạo khóa ngoại từ bảng DATCHO tham chiếu đến bảng KHACHHANG
ALTER TABLE DATCHO
ADD CONSTRAINT FK_DATCHO_KHACHHANG
FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
--Tạo khóa ngoại từ bảng DATCHO tham chiếu đến bảng LICHBAY
ALTER TABLE DATCHO
ADD CONSTRAINT FK_DATCHO_LICHBAY
FOREIGN KEY (NGAYDI, MACB) REFERENCES LICHBAY(NGAYDI, MACB)
--Tạo khóa ngoại từ bảng LICHBAY tham chiếu đến bảng CHUYENBAY
ALTER TABLE LICHBAY
ADD CONSTRAINT FK_LICHBAY_CHUYENBAY
FOREIGN KEY (MACB) REFERENCES CHUYENBAY(MACB)
--Tạo khóa ngoại từ bảng LICHBAY tham chiếu đến bảng MAYBAY
ALTER TABLE LICHBAY
ADD CONSTRAINT FK_LICHBAY_MAYBAY
FOREIGN KEY (SOHIEU, MALOAI) REFERENCES MAYBAY(SOHIEU, MALOAI)
--Tạo khóa ngoại từ bảng MAYBAY tham chiếu đến bảng LOAIMB
ALTER TABLE MAYBAY
ADD CONSTRAINT FK_MAYBAY_LOAIMB
FOREIGN KEY (MALOAI) REFERENCES LOAIMB(MALOAI)
--Tạo khóa ngoại từ bảng PHANCONG tham chiếu đến bảng LICHBAY
ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_LICHBAY
FOREIGN KEY (NGAYDI, MACB) REFERENCES LICHBAY(NGAYDI, MACB)
--Tạo khóa ngoại từ bảng PHANCONG tham chiếu đến bảng NHANVIEN
ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
--Tạo khóa ngoại từ bảng KHANANG tham chiếu đến bảng NHANVIEN
ALTER TABLE KHANANG
ADD CONSTRAINT FK_KHANANG_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
--Tạo khóa ngoại từ bảng KHANANG tham chiếu đến bảng LOAIMB
ALTER TABLE KHANANG
ADD CONSTRAINT FK_KHANANG_LOAIMB
FOREIGN KEY (MALOAI) REFERENCES LOAIMB(MALOAI)
------------------------------------------------------------------------
--Insert giá trị vào bảng NHANVIEN
INSERT INTO NHANVIEN VALUES
('1006', 'CHI', '12/6 NGUYEN KIEM', '8120012', '150000', '0'),
('1005','GIAO','65 NGUYEN THAI SON','8324467','500000','0'),
('1001','HUONG','8 DIEN BIEN PHU','8330733','500000','1'),
('1002','PHONG','1 LY THUONG KIET','8308117','450000','1'),
('1004','PHUONG','351 LAC LONG QUAN','8308155','250000','0'),
('1003','QUANG','78 TRUONG DINH','8324461','350000','1'),
('1007','TAM','36 NGUYEN VAN CU','8458188','500000','0')
--Insert giá trị vào bảng LOAIMB
INSERT INTO LOAIMB VALUES
('A310','AIRBUS'),
('A320','AIRBUS'),
('A330','AIRBUS'),
('A340','AIRBUS'),
('B727','BOEING'),
('B747','BOEING'),
('B757','BOEING'),
('DC10','MD'),
('DC9','MD')
--Insert giá trị vào bảng KHACHHANG
INSERT INTO KHACHHANG VALUES
('0009','NGA','223 NGUYEN TRAI','8932320'),
('0101','ANH','567 TRAN PHU','8826729'),
('0045','THU','285 LE LOI','8932203'),
('0012','HA','435 QUANG TRUNG','8933232'),
('0238','HUNG','456 PASTEUR','9812101'),
('0397','THANH','234 LE VAN SI','8952943'),
('0582','MAI','789 NGUYEN DU',''),
('0934','MINH','678 LE LAI',''),
('0091','HAI','345 HUNG VUONG','8893223'),
('0314','PHUONG','395 VO VAN TAN','8232320'),
('0613','VU','348 CMT8','8343232'),
('0586','SON','123 BACH DANG','8556223'),
('0422','TIEN','75 NGUYEN THONG','8332222')
--Insert giá trị vào bảng KHANANG
INSERT INTO KHANANG VALUES
('1001','B727'),
('1001','B747'),
('1001','DC10'),
('1001','DC9'),
('1002','A320'),
('1002','A340'),
('1002','B757'),
('1002','DC9'),
('1003','A310'),
('1003','DC9')
--Insert giá trị vào bảng MAYBAY
INSERT INTO MAYBAY VALUES
('11','B727'),
('13','B727'),
('10','B747'),
('13','B747'),
('22','B757'),
('93','B757'),
('21','DC9'),
('22','DC9'),
('23','DC9'),
('24','DC9'),
('21','DC10'),
('70','A310'),
('80','A310')
--Insert giá trị vào bảng CHUYENBAY
INSERT INTO CHUYENBAY VALUES
('100','SLC','BOS','08:00:00','17:50:00'),
('112','DCA','DEN','14:00:00','18:07:00'),
('121','STL','SLC','07:00:00','09:13:00'),
('122','STL','YYV','08:30:00','10:19:00'),
('206','DFW','STL','09:00:00','11:40:00'),
('330','JFK','YYV','16:00:00','18:53:00'),
('334','ORD','MIA','12:00:00','14:14:00'),
('335','MIA','ORD','15:00:00','17:14:00'),
('336','ORD','MIA','18:00:00','20:14:00'),
('337','MIA','ORD','20:30:00','23:53:00'),
('394','DFW','MIA','19:00:00','21:30:00'),
('395','MIA','DFW','21:00:00','23:43:00'),
('449','CDG','DEN','10:00:00','19:29:00'),
('930','YYV','DCA','13:00:00','16:10:00'),
('931','DCA','YYV','17:00:00','18:10:00'),
('932','DCA','YYV','18:00:00','19:10:00'),
('991','BOS','ORD','17:00:00','18:22:00')
--Insert giá trị vào bảng LICHBAY
INSERT INTO LICHBAY VALUES 
('2000/11/1','100','80','A310'),
('2000/11/1','112','21','DC10'),
('2000/11/1','206','22','DC9'),
('2000/11/1','334','10','B747'),
('2000/11/1','395','23','DC9'),
('2000/11/1','991','22','B757'),
('2000/11/1','337','10','B747'),
('2000/10/31','100','11','B727'),
('2000/10/31','112','11','B727'),
('2000/10/31','206','13','B727'),
('2000/10/31','334','10','B747'),
('2000/10/31','335','10','B747'),
('2000/10/31','337','24','DC9'),
('2000/10/31','449','70','A310')
--Insert giá trị vào bảng DATCHO
INSERT INTO DATCHO VALUES
('0009','11/1/2000','100'),
('0009','2000/10/31','449'),
('0045','11/1/2000','991'),
('0012','2000/10/31','206'),
('0238','2000/10/31','334'),
('0582','11/1/2000','991'),
('0091','11/1/2000','100'),
('0314','2000/10/31','449'),
('0613','11/1/2000','100'),
('0586','11/1/2000','991'),
('0586','2000/10/31','100'),
('0422','2000/10/31','449')
--Insert giá trị vào bảng PHANCONG
INSERT INTO PHANCONG VALUES
('1001','2000/11/1','100'),
('1001','2000/10/31','100'),
('1002','2000/11/1','100'),
('1002','2000/10/31','100'),
('1003','2000/10/31','100'),
('1003','2000/10/31','337'),
('1004','2000/10/31','100'),
('1004','2000/10/31','337'),
('1005','2000/10/31','337'),
('1006','2000/11/1','991'),
('1006','2000/10/31','337'),
('1007','2000/11/1','112'),
('1007','2000/11/1','991'),
('1007','2000/10/31','206')

SELECT * FROM CHUYENBAY
SELECT * FROM KHACHHANG
SELECT * FROM DATCHO
SELECT * FROM KHANANG 
SELECT * FROM LICHBAY
SELECT * FROM LOAIMB
SELECT * FROM MAYBAY
SELECT * FROM NHANVIEN
SELECT * FROM PHANCONG

-----------------------------------------------------
---------*********TRUY VẤN DỮ LIỆU*********----------
-----------------------------------------------------

--Cau Q1: Cho biết mã số, tên phi công, địa chỉ, điện thoại của các phi công đã từng lái máy bay loại B747
SELECT NV.MANV, NV.TEN, NV.DCHI, NV.DTHOAI
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB
WHERE NV.MANV = PC.MANV AND PC.MACB = LB.MACB
AND LB.MALOAI = 'B747'

--Cau Q2: Cho biết mã số và ngày đi của các chuyến bay xuất phát từ sân bay DCA trong khoảng thời gian từ 14 giờ đến 18 giờ
SELECT CB.MACB, LB.NGAYDI
FROM LICHBAY LB, CHUYENBAY CB
WHERE LB.MACB = CB.MACB 
AND CB.SBDI = 'DCA'
AND CB.GIODI BETWEEN '14:00:00' AND '18:00:00'

--Cau Q3: Cho biết tên những NV được phân công trên chuyến bay có mã số 100 xuất phát tại sân bay SLC.
--Các dòng dữ liệu xuất ra ko được phép trùng lặp
SELECT DISTINCT NV.TEN
FROM NHANVIEN NV,CHUYENBAY CB, PHANCONG PC 
WHERE CB.MACB = '100' 
AND CB.SBDI = 'SLC'
AND NV.MANV = PC.MANV 
AND PC.MACB = CB.MACB

--Cau Q4: Cho biết mã loại và số hiệu máy bay đã từng xuất phát từ sân bay MIA
SELECT DISTINCT lb.MALOAI, LB.SOHIEU
FROM LICHBAY LB
JOIN CHUYENBAY CB
ON CB.MACB = LB.MACB AND CB.SBDI = 'MIA'

--Cau Q5: Cho biết mã chuyến bay, ngày đi, cùng với tên,, địa chỉ, điện thoại của tất cả các hành khách đi trên chuyên bay đó
--Sắp xếp theo thứ tự tăng dần của mã chuyến bay và theo ngày đi giảm dần
SELECT DISTINCT  DC. MACB, DC.NGAYDI, KH.TEN, KH.DCHI, KH.DTHOAI
FROM KHACHHANG KH, DATCHO DC
WHERE KH.MAKH = DC.MAKH
ORDER BY DC.MACB ASC, DC.NGAYDI DESC

--Cau Q6: Cho biết mã chuyến bay, ngày đi, cùng với tên, địa chỉ, địa chỉ, điện thoại của tất cả những nhân viên được phân công trong chuyến bay đó.
--Sắp xếp theo thứ tự tăng dần của mã chuyến bay và theo ngày đi giảm dần
SELECT  PC.MACB, PC.NGAYDI, NV.TEN, NV.DCHI, NV.DTHOAI
FROM PHANCONG PC, NHANVIEN NV
WHERE  PC.MANV = NV.MANV
ORDER BY PC.MACB ASC, PC.NGAYDI DESC

--Cau Q7: Cho biết mã chuyến bay, ngày đi, mã số và tên của những phi công được phân công vào chuyến bay hạ cánh xuống sân bay QRD
SELECT  PC.MACB, PC.NGAYDI, NV.MANV, NV.TEN
FROM PHANCONG PC, NHANVIEN NV, CHUYENBAY CB
WHERE  NV.LOAINV = 1 AND CB.SBDEN = 'ORD' AND NV.MANV = PC.MANV
AND PC.MACB = CB.MACB

--Cau Q8: Cho biết các chuyến bay (Mã số chuyến bay, ngày đi và tên của phi công) trong đó phi công có mã 1001 được phân công lái
SELECT PC.MACB, PC.NGAYDI, NV.TEN
FROM NHANVIEN NV, PHANCONG PC
WHERE PC.MANV = NV.MANV 
AND NV.MANV = '1001'

--Cau Q9: Cho biết thông tin (Mã chuyến bay, sân bay đi, giờ đi, giờ đến, ngày đi) của những chuyến bay hạ cánh xuống DEN.
--Các chuyến bay được liệt kê theo ngày đi giảm dần và sân bay xuất phát (SBDI) tăng dần
SELECT CB.MACB, CB.SBDI, CB.GIODI, CB.GIODEN, LB.NGAYDI
FROM CHUYENBAY CB, LICHBAY LB
WHERE CB.SBDEN = 'DEN' AND CB.MACB = LB.MACB
ORDER BY LB.NGAYDI DESC, CB.SBDI ASC

--Cau Q10: Với mỗi phi công, cho biết hãng SX và mã loại máy bay mà phi công này có khả năng bay được.
--Xuất ra tên phi công, hãng sản xuất và mã loại máy bay.
SELECT  NV.TEN, LMB.HANGSX, KN.MALOAI
FROM NHANVIEN NV, KHANANG KN, LOAIMB LMB
WHERE NV.MANV = KN.MANV AND LMB.MALOAI = KN.MALOAI

--Cau Q11: Cho biết mã phi công, tên phi công đã lái máy bay trong chuyến bay mã số 100 vào ngày 11/01/2000
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV, LICHBAY LB, PHANCONG PC
WHERE LB.MACB = '100' AND LB.NGAYDI = '11-01-2000'
AND NV.MANV = PC.MANV AND PC.MACB = LB.MACB AND LB.NGAYDI = PC.NGAYDI
 

--Cau Q12: Cho biết mã chuyến bay, mã nhân viên, tên nhân viên được phân công vào chuyến bay xuất phát ngày 
--10/31/2000 tại sân bay MIA vào lúc 20:30
SELECT CB.MACB, NV.MANV, NV.TEN
FROM NHANVIEN NV, CHUYENBAY CB, PHANCONG PC
WHERE PC.NGAYDI = '10-31-2000' AND CB.SBDI = 'MIA' AND CB.GIODI = '20:30:00'
AND NV.MANV = PC.MANV AND PC.MACB = CB.MACB

--Cau Q13: Cho biết thông tin về chuyến bay (mã chuyến bay, số hiệu, mã loại, hãng sản xuất) mà phi công "Quang" đã lái
SELECT PC.MACB, LB.SOHIEU, LB.MALOAI, LMB.HANGSX
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB, LOAIMB LMB
WHERE NV.TEN = 'Quang' AND NV.MANV = PC.MANV AND PC.MACB = LB.MACB
AND LMB.MALOAI = LB.MALOAI

--Cau Q14: Cho biết tên của những phi công chưa được phân công lái máy bay nào
SELECT DISTINCT NV.TEN
FROM NHANVIEN NV, PHANCONG PC
WHERE NV.MANV = PC.MANV AND PC.MANV <> NV.MANV

--Cau Q15: Cho biết tên khách hàng đã đi chuyến bay trên máy bay của hãng "Boeing"
SELECT DISTINCT KH.TEN
FROM KHACHHANG KH, LICHBAY LB, DATCHO DC, LOAIMB LMB
WHERE LMB.HANGSX = 'Boeing' AND KH.MAKH = DC.MAKH
AND DC.MACB = LB.MACB AND LMB.MALOAI = LB.MALOAI

--Cau Q16: Cho biết mã các chuyến bay chỉ bay với máy bay số hiệu 10 và mã loại B747
SELECT LB.MACB
FROM LICHBAY LB
WHERE LB.SOHIEU = 10 AND LB.MALOAI = 'B747'

