############## UNION 실습 ########################
### 두개 테이블을 위아래로 합치자!

CREATE TABLE KOPO_PRODUCT_VOLUME_ST0001 AS
SELECT *
FROM KOPO_PRODUCT_VOLUME
WHERE PRODUCTGROUP = 'ST0001'

CREATE TABLE KOPO_PRODUCT_VOLUME_ST0002 AS
SELECT *
FROM KOPO_PRODUCT_VOLUME
WHERE PRODUCTGROUP = 'ST0002'

-- 265
SELECT COUNT(*)
FROM(
	-- 133
	SELECT *
	FROM KOPO_PRODUCT_VOLUME_ST0001
	UNION ALL
	-- 132
	SELECT *
	FROM KOPO_PRODUCT_VOLUME_ST0002
	UNION ALL
	SELECT *
	FROM KOPO_PRODUCT_VOLUME
)B

SELECT COUNT(*)
FROM KOPO_PRODUCT_VOLUME

SELECT * 
FROM KOPO_CHANNEL_SEASONALITY_NEW
ORDER BY REGIONID, PRODUCT, YEARWEEK

############## 함수 + 그룹바이 + 조인 통합 실습 ########################

### 지역 상품 연도별로 평균을 구한다!!!
### STEP1 연도가없다 -> 연도를 만든다 
### STEP2 지역/상품,연도별로 집계한다
### 원래 있던 KOPO_CHANNEL_SEASONALITY_NEW

SELECT * 
FROM KOPO_CHANNEL_SEASONALITY_NEW

SELECT A.*,
	B.*
FROM 
KOPO_CHANNEL_SEASONALITY_NEW A
LEFT JOIN (
	### 지역 상품 연도별 평균 거래량!!!
	SELECT B.REGIONID,
		B.PRODUCT,
		B.YEAR,
		AVG(B.QTY) AS AVG_QTY
	FROM(
		SELECT A.REGIONID, 
			A.PRODUCT,
			A.YEARWEEK,
			SUBSTR(A.YEARWEEK,1,4) AS YEAR,
			A.QTY
		FROM KOPO_CHANNEL_SEASONALITY_NEW A
	)B
	GROUP BY B.REGIONID, B.PRODUCT, B.YEAR 
)B
ON A.REGIONID = B.REGIONID
AND A.PRODUCT = B.PRODUCT
AND SUBSTR(A.YEARWEEK,1,4)  = B.YEAR
ORDER BY A.REGIONID, A.PRODUCT, A.YEARWEEK

############## WITH 서브쿼리  ########################
WITH A AS
( 
	SELECT A.REGIONID, 
		A.PRODUCT,
		A.YEARWEEK,
		SUBSTR(A.YEARWEEK,1,4) AS YEAR,
		A.QTY
	FROM KOPO_CHANNEL_SEASONALITY_NEW A
)
SELECT * FROM A;

############## 기본키 생성 실습 ########################

DROP TABLE KEY_TABLE

CREATE TABLE KEY_TABLE (
    id INT AUTO_INCREMENT,
    name VARCHAR(255),
    age INT,
    PRIMARY KEY (id)
)

INSERT INTO KEY_TABLE (name, age) VALUES ('haiteam2','43')

INSERT INTO KEY_TABLE (id,name, age) VALUES (3, 'haiteam3','43')

SELECT * 
FROM KEY_TABLE

############## 무결성 제약조건 실습 ########################
DROP TABLE KOPO_PRODUCT_VOLUME

CREATE TABLE KOPO_PRODUCT_VOLUME(
REGIONID VARCHAR(20),
PRODUCTGROUP VARCHAR(20),
YEARWEEK VARCHAR(8),
VOLUME DOUBLE NOT NULL,
PRIMARY KEY(REGIONID,PRODUCTGROUP, YEARWEEK) )

-- 도메인 무결성 제약조건 * 삽입 시
INSERT INTO KOPO_PRODUCT_VOLUME
VALUES('REGIONID','PRODUCTGROUP','202401',NULL)

-- 개체 무결성 제약조건 (기본키 중복값 위배) * 삽입 시
INSERT INTO KOPO_PRODUCT_VOLUME
VALUES ('A01','ST0002','202403',50)

-- 개체 무결성 제약조건 (기본키 중복값 위배) * 삽입 시
INSERT INTO KOPO_PRODUCT_VOLUME
VALUES ('A01','ST0002','202404',50)

-- 개체 무결성 제약조건 (기본키 중복값 위배) * 업데이트 시
UPDATE KOPO_PRODUCT_VOLUME 
SET YEARWEEK = '202403'
WHERE YEARWEEK = '202404'

# 참조 무결성 제약조건 위배
CREATE TABLE KOPO_EVENT_INFO_FOREIGN(
EVENTID VARCHAR(20),
EVENTPERIOD VARCHAR(20),
PROMOTION_RATIO DOUBLE,
PRIMARY KEY(EVENTID))

CREATE TABLE KOPO_PRODUCT_VOLUME_FOREIGN(
REGIONID VARCHAR(20),
PRODUCTGROUP VARCHAR(20),
YEARWEEK VARCHAR(8),
VOLUME DOUBLE NOT NULL,
EVENTID VARCHAR(20),
PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK),
FOREIGN KEY(EVENTID) REFERENCES KOPO_EVENT_INFO_FOREIGN(EVENTID) )

-- 참조 무결성 예제: (부모키가 없는 경우)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('A01','ST00002','202401',50,'EVTEST')

## 삭제 오류!!!
-- 참조 무결성 예제: (부모키가 없는 경우)
INSERT INTO KOPO_EVENT_INFO_FOREIGN
VALUES ('EV00001',5,0.5)

-- 참조 무결성 예제: (부모키가 없는 경우)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('A01','ST00002','202401',50,'EV00001')

DELETE FROM KOPO_EVENT_INFO_FOREIGN
WHERE EVENTID = 'EV00001'


DESCRIBE KOPO_PRODUCT_VOLUME

SELECT * 
FROM KOPO_PRODUCT_VOLUME_FOREIGN


















