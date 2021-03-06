﻿USE QLCB
GO

--Q51. Cho biết mã những chuyến bay đã bay tất cả các máy bay của hãng "Boeing".
----EXCEPT - phép trừ
SELECT DISTINCT lb.MACB
FROM LICHBAY lb, MAYBAY mb
WHERE lb.MALOAI = mb.MALOAI
AND NOT EXISTS( 
                (SELECT MALOAI FROM LOAIMB 
				 WHERE HANGSX = 'Boeing')   
                EXCEPT 
				(SELECT mb1.MALOAI FROM MAYBAY mb1
				 WHERE mb.MALOAI = mb1.MALOAI))
----NOT EXISTS - phép chia
SELECT DISTINCT lb.MACB
FROM LICHBAY lb, MAYBAY mb
WHERE lb.MALOAI = mb.MALOAI
AND NOT EXISTS(  
               SELECT * FROM LOAIMB lmb
			   WHERE lmb.HANGSX = 'Boeing'
			   AND NOT EXISTS (SELECT *
			                     FROM MAYBAY mb1
				                 WHERE mb.MALOAI = mb1.MALOAI
								 AND lmb.MALOAI = mb1.MALOAI))
---- NOT IN
SELECT DISTINCT LB1.MACB
FROM LICHBAY LB1
WHERE NOT EXISTS (
				  SELECT MALOAI FROM LOAIMB 
				  WHERE HANGSX = 'Boeing' AND
						MALOAI NOT IN (SELECT LB2.MALOAI FROM LICHBAY LB2
									   WHERE LB1.MACB = LB2.MACB))  
----COUNT - gom nhóm
SELECT  DISTINCT LB.MACB 
FROM LICHBAY LB ,LOAIMB LMB, MAYBAY MB 
WHERE LMB.HANGSX ='Boeing' AND MB.MALOAI=LMB.MALOAI AND LB.MALOAI=MB.MALOAI AND LB.SOHIEU = MB.SOHIEU 
GROUP BY LB.MACB
HAVING COUNT (DISTINCT LB.MALOAI) = 
(SELECT COUNT( DISTINCT MB1.MALOAI) 
FROM MAYBAY MB1, LOAIMB LMB1
 WHERE LMB1.HANGSX='Boeing' AND LMB1.MALOAI=MB1.MALOAI)

--Q52. Cho biết mã và tên phi công có khả năng lái tất cả các máy bay của hãng "Airbus". 
-- EXCEPT
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 
AND NOT EXISTS ((SELECT MALOAI FROM LOAIMB WHERE HANGSX = 'Airbus')
				 EXCEPT
				(SELECT KN.MALOAI FROM KHANANG KN WHERE NV.MANV = KN.MANV))

---- NOT EXISTS
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 AND NOT EXISTS (
									 SELECT LMB.MALOAI FROM LOAIMB LMB
									 WHERE LMB.HANGSX = 'Airbus' AND
										   NOT EXISTS (SELECT KN.MALOAI FROM KHANANG KN 
													   WHERE NV.MANV = KN.MANV AND KN.MALOAI = LMB.MALOAI))
---- NOT IN
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 AND NOT EXISTS (
									 SELECT LMB.MALOAI FROM LOAIMB LMB
									 WHERE LMB.HANGSX = 'Airbus' AND
										   LMB.MALOAI NOT IN (SELECT KN.MALOAI FROM KHANANG KN 
															  WHERE NV.MANV = KN.MANV))
---- COUNT
SELECT NV.MANV,NV.TEN 
FROM NHANVIEN NV,KHANANG KN, LOAIMB LMB 
WHERE NV.MANV=KN.MANV AND KN.MALOAI= LMB.MALOAI AND LMB.HANGSX='Airbus'
GROUP BY NV.MANV,NV.TEN
HAVING COUNT (DISTINCT KN.MALOAI)= 
(SELECT COUNT(DISTINCT KN1.MALOAI)  
FROM KHANANG KN1, LOAIMB LMB1 
WHERE KN1.MALOAI=LMB1.MALOAI AND LMB1.HANGSX='Airbus')

--Q53. Cho biết tên nhân viên (không phải là phi công) được phân công bay vào tất cả các chuyến bay có mã 100. 
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									(SELECT NGAYDI FROM LICHBAY WHERE MACB = '100')
									 EXCEPT
									(SELECT PC.NGAYDI FROM PHANCONG PC WHERE PC.MACB = '100' AND PC.MANV = NV.MANV))
---- NOT EXISTS
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									 SELECT LB.NGAYDI FROM LICHBAY LB
									 WHERE LB.MACB = '100' AND
										   NOT EXISTS (SELECT PC.NGAYDI FROM PHANCONG PC
													   WHERE PC.MACB = '100' AND PC.MANV = NV.MANV AND LB.NGAYDI = PC.NGAYDI))
---- NOT IN
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									 SELECT LB.NGAYDI FROM LICHBAY LB
									 WHERE LB.MACB = '100' AND
										   LB.NGAYDI NOT IN (SELECT PC.NGAYDI FROM PHANCONG PC
															 WHERE PC.MACB = '100' AND PC.MANV = NV.MANV))
----COUNT
SELECT DISTINCT PC.MANV,NV.TEN 
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB 
WHERE LB.MACB=N'100' AND LB.MACB=PC.MACB AND PC.MANV=NV.MANV AND PC.NGAYDI=LB.NGAYDI AND NV.LOAINV=0
GROUP BY PC.MANV,NV.TEN
HAVING COUNT(DISTINCT PC.NGAYDI) = 
(SELECT COUNT(*) FROM LICHBAY LB1 WHERE LB1.MACB=N'100')
--Q54. Cho biết ngày đi nào mà có tất cả các loại máy bay của hãng "Boeing" tham gia. 
---- EXCEPT
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB
WHERE LB1.MALOAI = LMB.MALOAI AND LMB.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				  (SELECT MALOAI FROM LOAIMB WHERE HANGSX = 'Boeing')
				   EXCEPT
				  (SELECT LB2.MALOAI FROM LICHBAY LB2 WHERE LB1.NGAYDI = LB2.NGAYDI))

---- NOT EXISTS
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB1
WHERE LB1.MALOAI = LMB1.MALOAI AND LMB1.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				   SELECT LMB2.MALOAI FROM LOAIMB LMB2
				   WHERE LMB2.HANGSX = 'Boeing' AND
						 NOT EXISTS (SELECT LB2.MALOAI FROM LICHBAY LB2
									 WHERE LB1.NGAYDI = LB2.NGAYDI AND LMB2.MALOAI = LB2.MALOAI))

---- NOT IN
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB
WHERE LB1.MALOAI = LMB.MALOAI AND LMB.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				   SELECT MALOAI FROM LOAIMB
				   WHERE HANGSX = 'Boeing' AND
						 MALOAI NOT IN (SELECT LB2.MALOAI FROM LICHBAY LB2
											WHERE LB1.NGAYDI = LB2.NGAYDI))
----COUNT
SELECT DISTINCT LB.NGAYDI 
FROM LICHBAY LB,LOAIMB LMB,MAYBAY MB 
WHERE MB.MALOAI=LB.MALOAI AND LMB.MALOAI=MB.MALOAI AND LMB.HANGSX=N'Boeing'
GROUP BY LB.NGAYDI
HAVING COUNT(DISTINCT MB.MALOAI) =
(SELECT COUNT(DISTINCT MB1.MALOAI ) 
FROM MAYBAY MB1, LOAIMB LMB1 
WHERE LMB1.HANGSX=N'Boeing' AND LMB1.MALOAI=MB1.MALOAI )

--Q55. Cho biết loại máy bay của hãng "Boeing" nào có tham gia vào tất cả các ngày đi. 
---- EXCEPT
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										(SELECT DISTINCT NGAYDI FROM LICHBAY)
										 EXCEPT
										(SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
										 WHERE LB.MALOAI = LMB.MALOAI))

---- NOT EXISTS
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										SELECT DISTINCT LB1.NGAYDI FROM LICHBAY LB1
										WHERE NOT EXISTS (SELECT DISTINCT LB2.NGAYDI FROM LICHBAY LB2
														  WHERE LB2.MALOAI = LMB.MALOAI AND LB1.NGAYDI = LB2.NGAYDI))
---- NOT IN
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										SELECT DISTINCT LB1.NGAYDI FROM LICHBAY LB1
										WHERE LB1.NGAYDI NOT IN (SELECT DISTINCT LB2.NGAYDI FROM LICHBAY LB2
														  WHERE LB2.MALOAI = LMB.MALOAI))
---- COUNT
SELECT LMB.MALOAI 
FROM LOAIMB LMB, LICHBAY LB
WHERE LMB.HANGSX=N'Boeing' AND LMB.MALOAI=LB.MALOAI 
GROUP BY LMB.MALOAI
HAVING COUNT(DISTINCT LB.NGAYDI) =
(SELECT COUNT(DISTINCT LB1.NGAYDI) FROM LICHBAY LB1)
--Q56. Cho biết mã và tên các khách hàng có đặt chổ trong tất cả các ngày từ 31/10/2000 đến 1/1/2000 
---- EXCEPT
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  (SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000')
				   EXCEPT
				  (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC WHERE DC.MAKH = KH.MAKH))
---- NOT EXISTS
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
				  WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000' AND
						NOT EXISTS (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC
									WHERE DC.MAKH = KH.MAKH AND DC.NGAYDI = LB.NGAYDI))
---- NOT IN
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
				  WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000' AND
						LB.NGAYDI NOT IN (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC
										  WHERE DC.MAKH = KH.MAKH)
				  )
----COUNT
SELECT DISTINCT KH.MAKH,KH.TEN 
FROM KHACHHANG KH, DATCHO DT, LICHBAY LB 
WHERE LB.MACB=DT.MACB AND KH.MAKH=DT.MAKH AND LB.NGAYDI BETWEEN N'2000-01-01' AND N'2000-10-31'
GROUP BY KH.MAKH,KH.TEN
HAVING COUNT (DISTINCT LB.MACB) =
(SELECT COUNT(DISTINCT LB1.MACB) 
FROM LICHBAY LB1,DATCHO DT1 
WHERE DT1.MACB=LB1.MACB AND LB1.NGAYDI BETWEEN N'2000-01-01' AND N'2000-10-31' )

--Q57. Cho biết mã và tên phi công không có khả năng lái được tất cả các máy bay của hãng "Airbus" 
--COUNT có 2 trường hợp là đếm những đứa chỉ biết lái airbus nhưng lái không hết và TH2: đếm những đứa không lái tất cả airbus bao gồm cả những đứa không lái chiếc airbus nào
SELECT NV.MANV,NV.TEN 
FROM NHANVIEN NV,KHANANG KN, LOAIMB LMB 
WHERE NV.MANV=KN.MANV AND KN.MALOAI= LMB.MALOAI AND LMB.HANGSX=N'Airbus'
GROUP BY NV.MANV,NV.TEN
HAVING COUNT (DISTINCT KN.MALOAI) != 
(SELECT COUNT(DISTINCT LMB1.MALOAI)  
FROM  LOAIMB LMB1 WHERE  LMB1.HANGSX=N'Airbus')

--C2
SELECT KN.MANV,NV.TEN 
FROM NHANVIEN NV , KHANANG KN, LOAIMB LMB 
WHERE KN.MANV = NV.MANV AND	LMB.MALOAI = KN.MALOAI AND NV.LOAINV = 1 
GROUP BY KN.MANV,NV.TEN 
HAVING (SELECT COUNT(DISTINCT KN1.MALOAI) 
FROM KHANANG KN1, LOAIMB LMB1 
WHERE LMB1.MALOAI = kn1.MALOAI AND lmb1.HANGSX = 'Airbus' AND kn1.MANV = kn.MANV) != 
(SELECT COUNT(LMB1.MALOAI) FROM LOAIMB LMB1 
WHERE LMB1.HANGSX = 'Airbus') 

--Q58. Cho biết sân bay nào đã có tất cả các loại máy bay của hãng "Boeing" xuất phát.
SELECT DISTINCT CB.SBDI 
FROM CHUYENBAY CB,LICHBAY LB, MAYBAY MB, LOAIMB LMB 
WHERE LMB.HANGSX=N'Boeing' AND LMB.MALOAI=MB.MALOAI AND MB.MALOAI=LB.MALOAI AND CB.MACB=LB.MACB
GROUP BY CB.SBDI
HAVING COUNT(DISTINCT LMB.MALOAI) = 
(SELECT COUNT(DISTINCT LMB1.MALOAI) 
FROM LOAIMB LMB1 WHERE LMB1.HANGSX=N'Boeing'  )
