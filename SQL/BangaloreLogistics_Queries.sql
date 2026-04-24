-- ================================================
-- Project  : Bangalore Logistics Network Analysis
-- Author   : Pavan
-- Date     : March 2026
-- Database : BangaloreLogistics (SQL Server)
-- ================================================

USE BangaloreLogistics;
GO

-- ============================================
-- PHASE 1A: CREATE TABLES
-- ============================================

CREATE TABLE Industrial_Zones (
    zone_id        INT           PRIMARY KEY,
    zone_name      VARCHAR(100)  NOT NULL UNIQUE,
    district       VARCHAR(50)   NOT NULL,
    distance_km    INT           NOT NULL,
    distance_type  VARCHAR(30)   NOT NULL,
    major_sectors  VARCHAR(100)  NOT NULL
);

CREATE TABLE Freight_Corridors (
    corridor_id    CHAR(5)       PRIMARY KEY,
    highway_name   VARCHAR(100)  NOT NULL,
    trucks_per_day INT           NOT NULL,
    direction      VARCHAR(30)   NOT NULL,
    corridor_type  VARCHAR(100)  NOT NULL
);

CREATE TABLE Logistics_Hubs (
    hub_id         CHAR(6)       PRIMARY KEY,
    hub_name       VARCHAR(100)  NOT NULL,
    company        VARCHAR(100)  NOT NULL,
    location       VARCHAR(100)  NOT NULL,
    hub_type_clean VARCHAR(50)   NOT NULL,
    company_type   VARCHAR(50)   NOT NULL,
    nearest_zone   VARCHAR(100)  NOT NULL,
    CONSTRAINT fk_nearest_zone
        FOREIGN KEY (nearest_zone)
        REFERENCES Industrial_Zones(zone_name)
);

CREATE TABLE vehicle_reg_historical (
    vehicle_type  VARCHAR(100)  NOT NULL,
    rto_region    VARCHAR(50)   NOT NULL,
    registrations INT           NOT NULL,
    year          INT           NOT NULL,
    month         VARCHAR(20)   NOT NULL
);

CREATE TABLE vehicle_reg_trends (
    vehicle_type  VARCHAR(100)  NOT NULL,
    registrations INT           NOT NULL,
    year          INT           NOT NULL,
    month         VARCHAR(20)   NOT NULL
);

CREATE TABLE vehicle_reg_2025 (
    vehicle_type  VARCHAR(100)  NOT NULL,
    registrations INT           NOT NULL,
    year          INT           NOT NULL,
    month         VARCHAR(20)   NOT NULL
);

CREATE TABLE corridor_trends (
    corridor_id      CHAR(5)       NOT NULL,
    year             INT           NOT NULL,
    trucks_per_day   INT           NOT NULL,
    period_label     VARCHAR(50)   NOT NULL,
    principal_goods  VARCHAR(100)  NOT NULL,
    PRIMARY KEY (corridor_id, year),
    CONSTRAINT fk_corridor_trends
        FOREIGN KEY (corridor_id)
        REFERENCES Freight_Corridors(corridor_id)
);

-- ============================================
-- PHASE 1B: ALTER TABLES
-- ============================================

ALTER TABLE Industrial_Zones
ALTER COLUMN Zone_Name VARCHAR(100) NOT NULL;

ALTER TABLE Logistics_Hubs ADD corridor_id     CHAR(5);
ALTER TABLE Logistics_Hubs ADD original_hub_id VARCHAR(20);
ALTER TABLE Logistics_Hubs ADD zone_type       VARCHAR(50);
ALTER TABLE Logistics_Hubs ADD latitude        FLOAT;
ALTER TABLE Logistics_Hubs ADD longitude       FLOAT;

ALTER TABLE Industrial_Zones ADD latitude        FLOAT;
ALTER TABLE Industrial_Zones ADD longitude       FLOAT;
ALTER TABLE Industrial_Zones ADD distance_method VARCHAR(20);

ALTER TABLE Freight_Corridors ADD key_logistics_zones VARCHAR(200);

ALTER TABLE vehicle_reg_historical ADD month_num INT;
ALTER TABLE vehicle_reg_trends     ADD month_num INT;
ALTER TABLE vehicle_reg_trends     ADD data_type VARCHAR(10);
ALTER TABLE vehicle_reg_2025       ADD month_num INT;

-- ============================================
-- PHASE 1C: INSERT LOGISTICS DATA
-- ============================================

INSERT INTO Industrial_Zones (zone_id, zone_name, district, distance_km, distance_type, major_sectors)
VALUES
    (1,  'Nelamangala Industrial Area', 'Bangalore Rural', 32, 'Peripheral', 'E-commerce, Retail, 3PL, FMCG'),
    (2,  'Pillagumpe Industrial Area',  'Bangalore Rural', 28, 'Peripheral', 'E-commerce, FMCG'),
    (3,  'Aerospace Park',              'Bangalore Rural', 38, 'Peripheral', 'Aerospace, Logistics'),
    (4,  'Malur Industrial Area',       'Kolar',           46, 'Outer',      'Auto Components, Logistics'),
    (5,  'Whitefield Industrial Area',  'Bangalore Urban', 18, 'Mid-Ring',   'IT, Logistics'),
    (6,  'Bommasandra Industrial Area', 'Bangalore Urban', 22, 'Mid-Ring',   'Pharma, Manufacturing'),
    (7,  'Jigani Industrial Area',      'Bangalore Urban', 29, 'Peripheral', 'Manufacturing, 3PL'),
    (8,  'Hoskote Industrial Area',     'Bangalore Rural', 26, 'Peripheral', 'Logistics, E-commerce'),
    (9,  'Yelahanka Industrial Area',   'Bangalore Urban', 16, 'Mid-Ring',   'Apparel, Logistics'),
    (10, 'Kadugodi Industrial Area',    'Bangalore Urban', 20, 'Mid-Ring',   'IT, Express Cargo'),
    (11, 'Anekal Industrial Area',      'Bangalore Urban', 34, 'Peripheral', 'Manufacturing'),
    (12, 'Narasapura Industrial Area',  'Kolar',           52, 'Outer',      'Auto Manufacturing');

INSERT INTO Freight_Corridors (corridor_id, highway_name, trucks_per_day, direction, corridor_type)
VALUES
    ('BC-01', 'NH 48 (Tumakuru Rd)',        15000, 'Northwest', 'Industrial / Port Connectivity'),
    ('BC-02', 'NH 44 South (Hosur Road)',   12000, 'Southeast', 'Manufacturing / Export'),
    ('BC-03', 'NH 44 North (Ballari Road)',  8000, 'North',     'Airport / Mining'),
    ('BC-04', 'NH 75 (Old Madras Rd)',       9500, 'East',      'Auto / Warehousing'),
    ('BC-05', 'NH 275 (Mysuru Road)',        6000, 'Southwest', 'Regional Distribution');

INSERT INTO Logistics_Hubs (hub_id, hub_name, company, location, hub_type_clean, company_type, nearest_zone)
VALUES
    ('HUB_01', 'Amazon Fulfillment Center',    'Amazon',             'Nelamangala',    'Fulfillment',    'E-commerce',      'Nelamangala Industrial Area'),
    ('HUB_02', 'Amazon Hoskote Hub',           'Amazon',             'Hoskote',        'Fulfillment',    'E-commerce',      'Hoskote Industrial Area'),
    ('HUB_03', 'Amazon Devanahalli Hub',       'Amazon',             'Devanahalli',    'Fulfillment',    'E-commerce',      'Aerospace Park'),
    ('HUB_04', 'Flipkart Mother Hub',          'Flipkart',           'Malur',          'Fulfillment',    'E-commerce',      'Malur Industrial Area'),
    ('HUB_05', 'Whitefield Sortation',         'Flipkart',           'Whitefield',     'Sortation',      'E-commerce',      'Whitefield Industrial Area'),
    ('HUB_06', 'Doddadunnasandra Hub',         'Delhivery',          'Hoskote',        'Sortation',      '3PL Courier',     'Hoskote Industrial Area'),
    ('HUB_07', 'Bommasandra Sort Center',      'Delhivery',          'Bommasandra',    'Sortation',      '3PL Courier',     'Bommasandra Industrial Area'),
    ('HUB_08', 'BB Mother Hub',                'BigBasket',          'Hoskote',        'Fulfillment',    'Q-commerce',      'Hoskote Industrial Area'),
    ('HUB_09', 'Jigani Warehouse',             'BigBasket',          'Jigani',         'Warehousing',    'Q-commerce',      'Jigani Industrial Area'),
    ('HUB_10', 'Pillagumpe Hub',               'Ecom Express',       'Hoskote',        'Last Mile',      '3PL Courier',     'Pillagumpe Industrial Area'),
    ('HUB_11', 'Yelahanka Gateway',            'Ecom Express',       'Yelahanka',      'Sortation',      '3PL Courier',     'Yelahanka Industrial Area'),
    ('HUB_12', 'Kadugodi Facility',            'Blue Dart',          'Whitefield',     'Last Mile',      '3PL Express',     'Kadugodi Industrial Area'),
    ('HUB_13', 'Deepanjali Hub',               'Shadowfax',          'Bangalore West', 'Hyperlocal',     '3PL Last Mile',   'Nelamangala Industrial Area'),
    ('HUB_14', 'Nelamangala Depot',            'TVS SCS',            'Nelamangala',    'Warehousing',    '3PL Warehousing', 'Nelamangala Industrial Area'),
    ('HUB_15', 'Jigani Logistics',             'TVS SCS',            'Jigani',         'Warehousing',    '3PL Warehousing', 'Jigani Industrial Area'),
    ('HUB_16', 'Narasapura Park',              'IndoSpace',          'Narasapura',     'Logistics Park', 'Real Estate',     'Narasapura Industrial Area'),
    ('HUB_17', 'Nelamangala Park',             'Embassy Industrial', 'Nelamangala',    'Logistics Park', 'Real Estate',     'Nelamangala Industrial Area'),
    ('HUB_18', 'HSR Dark Store',               'Zepto',              'HSR',            'Hyperlocal',     'Q-commerce',      'Bommasandra Industrial Area'),
    ('HUB_19', 'Koramangala Dark Store',       'Zepto',              'Koramangala',    'Hyperlocal',     'Q-commerce',      'Bommasandra Industrial Area'),
    ('HUB_20', 'Reliance Retail Hub',          'Reliance',           'Nelamangala',    'Fulfillment',    'Retail',          'Nelamangala Industrial Area');

-- ============================================
-- PHASE 1D: BULK INSERT VEHICLE DATA
-- ============================================

BULK INSERT vehicle_reg_historical
FROM 'C:\Users\Pavan\DA-P2\ALL_BENGALURU_VR\Historical_Zonal.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

BULK INSERT vehicle_reg_trends
FROM 'C:\Users\Pavan\DA-P2\ALL_BENGALURU_VR\City_Trends.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

BULK INSERT vehicle_reg_2025
FROM 'C:\Users\Pavan\DA-P2\ALL_BENGALURU_VR\Current_State_2025.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

-- ============================================
-- PHASE 1E: UPDATE STATEMENTS
-- ============================================

-- Corridor mapping
UPDATE Logistics_Hubs SET corridor_id = 'BC-01' WHERE location = 'Nelamangala';
UPDATE Logistics_Hubs SET corridor_id = 'BC-03' WHERE location = 'Devanahalli';
UPDATE Logistics_Hubs SET corridor_id = 'BC-04' WHERE location = 'Hoskote';
UPDATE Logistics_Hubs SET corridor_id = 'BC-04' WHERE location = 'Whitefield';
UPDATE Logistics_Hubs SET corridor_id = 'BC-02' WHERE location = 'Jigani';
UPDATE Logistics_Hubs SET corridor_id = 'BC-02' WHERE location = 'Bommasandra';
UPDATE Logistics_Hubs SET corridor_id = 'BC-04' WHERE location = 'Malur';
UPDATE Logistics_Hubs SET corridor_id = 'BC-03' WHERE location = 'Bangalore West';
UPDATE Logistics_Hubs SET corridor_id = 'BC-05' WHERE location = 'HSR';
UPDATE Logistics_Hubs SET corridor_id = 'BC-05' WHERE location = 'Koramangala';
UPDATE Logistics_Hubs SET corridor_id = 'BC-02' WHERE location = 'Narasapura';
UPDATE Logistics_Hubs SET corridor_id = 'BC-03' WHERE location = 'Yelahanka';

-- Original hub IDs
UPDATE Logistics_Hubs SET original_hub_id = 'BLR4'        WHERE hub_id = 'HUB_01';
UPDATE Logistics_Hubs SET original_hub_id = 'BLR5'        WHERE hub_id = 'HUB_02';
UPDATE Logistics_Hubs SET original_hub_id = 'BLR8'        WHERE hub_id = 'HUB_03';
UPDATE Logistics_Hubs SET original_hub_id = 'MALUR_BTS'   WHERE hub_id = 'HUB_04';
UPDATE Logistics_Hubs SET original_hub_id = 'BLR_WFD_01'  WHERE hub_id = 'HUB_05';
UPDATE Logistics_Hubs SET original_hub_id = 'DEL_BLR_01'  WHERE hub_id = 'HUB_06';
UPDATE Logistics_Hubs SET original_hub_id = 'DEL_BLR_02'  WHERE hub_id = 'HUB_07';
UPDATE Logistics_Hubs SET original_hub_id = 'BB_BLR_MH'   WHERE hub_id = 'HUB_08';
UPDATE Logistics_Hubs SET original_hub_id = 'BB_BLR_JGN'  WHERE hub_id = 'HUB_09';
UPDATE Logistics_Hubs SET original_hub_id = 'ECOM_BH3'    WHERE hub_id = 'HUB_10';
UPDATE Logistics_Hubs SET original_hub_id = 'ECOM_YLH'    WHERE hub_id = 'HUB_11';
UPDATE Logistics_Hubs SET original_hub_id = 'BD_BLR_KDG'  WHERE hub_id = 'HUB_12';
UPDATE Logistics_Hubs SET original_hub_id = 'SFX_DJN'     WHERE hub_id = 'HUB_13';
UPDATE Logistics_Hubs SET original_hub_id = 'TVS_NMG_01'  WHERE hub_id = 'HUB_14';
UPDATE Logistics_Hubs SET original_hub_id = 'TVS_JGN_02'  WHERE hub_id = 'HUB_15';
UPDATE Logistics_Hubs SET original_hub_id = 'ISP_NRS_01'  WHERE hub_id = 'HUB_16';
UPDATE Logistics_Hubs SET original_hub_id = 'EIP_NMG_05'  WHERE hub_id = 'HUB_17';
UPDATE Logistics_Hubs SET original_hub_id = 'ZEP_HSR_22'  WHERE hub_id = 'HUB_18';
UPDATE Logistics_Hubs SET original_hub_id = 'ZEP_KOR_09'  WHERE hub_id = 'HUB_19';
UPDATE Logistics_Hubs SET original_hub_id = 'REL_NEL_01'  WHERE hub_id = 'HUB_20';

-- Zone type
UPDATE Logistics_Hubs SET zone_type = 'Industrial Zone'
WHERE hub_id NOT IN ('HUB_13','HUB_18','HUB_19');
UPDATE Logistics_Hubs SET zone_type = 'Urban Commercial'
WHERE hub_id IN ('HUB_13','HUB_18','HUB_19');

-- Hub coordinates
UPDATE Logistics_Hubs SET latitude = 13.0910, longitude = 77.4180 WHERE hub_id = 'HUB_01';
UPDATE Logistics_Hubs SET latitude = 13.0730, longitude = 77.7921 WHERE hub_id = 'HUB_02';
UPDATE Logistics_Hubs SET latitude = 13.2466, longitude = 77.7118 WHERE hub_id = 'HUB_03';
UPDATE Logistics_Hubs SET latitude = 13.0020, longitude = 77.9390 WHERE hub_id = 'HUB_04';
UPDATE Logistics_Hubs SET latitude = 12.9698, longitude = 77.7500 WHERE hub_id = 'HUB_05';
UPDATE Logistics_Hubs SET latitude = 13.0755, longitude = 77.7950 WHERE hub_id = 'HUB_06';
UPDATE Logistics_Hubs SET latitude = 12.8000, longitude = 77.7000 WHERE hub_id = 'HUB_07';
UPDATE Logistics_Hubs SET latitude = 12.9753, longitude = 77.7059 WHERE hub_id = 'HUB_08';
UPDATE Logistics_Hubs SET latitude = 12.7830, longitude = 77.6500 WHERE hub_id = 'HUB_09';
UPDATE Logistics_Hubs SET latitude = 13.0600, longitude = 77.8500 WHERE hub_id = 'HUB_10';
UPDATE Logistics_Hubs SET latitude = 13.1020, longitude = 77.5960 WHERE hub_id = 'HUB_11';
UPDATE Logistics_Hubs SET latitude = 13.0070, longitude = 77.7600 WHERE hub_id = 'HUB_12';
UPDATE Logistics_Hubs SET latitude = 12.9550, longitude = 77.5310 WHERE hub_id = 'HUB_13';
UPDATE Logistics_Hubs SET latitude = 13.0870, longitude = 77.4050 WHERE hub_id = 'HUB_14';
UPDATE Logistics_Hubs SET latitude = 12.7760, longitude = 77.6550 WHERE hub_id = 'HUB_15';
UPDATE Logistics_Hubs SET latitude = 13.0530, longitude = 78.0420 WHERE hub_id = 'HUB_16';
UPDATE Logistics_Hubs SET latitude = 13.0900, longitude = 77.4095 WHERE hub_id = 'HUB_17';
UPDATE Logistics_Hubs SET latitude = 12.9120, longitude = 77.6440 WHERE hub_id = 'HUB_18';
UPDATE Logistics_Hubs SET latitude = 12.9352, longitude = 77.6140 WHERE hub_id = 'HUB_19';
UPDATE Logistics_Hubs SET latitude = 13.0855, longitude = 77.4120 WHERE hub_id = 'HUB_20';

-- Zone coordinates
UPDATE Industrial_Zones SET latitude = 13.0975, longitude = 77.3912, distance_method = 'road_km' WHERE zone_id = 1;
UPDATE Industrial_Zones SET latitude = 13.0722, longitude = 77.7995, distance_method = 'road_km' WHERE zone_id = 2;
UPDATE Industrial_Zones SET latitude = 13.2045, longitude = 77.7118, distance_method = 'road_km' WHERE zone_id = 3;
UPDATE Industrial_Zones SET latitude = 12.9982, longitude = 77.9315, distance_method = 'road_km' WHERE zone_id = 4;
UPDATE Industrial_Zones SET latitude = 12.9698, longitude = 77.7500, distance_method = 'road_km' WHERE zone_id = 5;
UPDATE Industrial_Zones SET latitude = 12.8164, longitude = 77.6932, distance_method = 'road_km' WHERE zone_id = 6;
UPDATE Industrial_Zones SET latitude = 12.7845, longitude = 77.6255, distance_method = 'road_km' WHERE zone_id = 7;
UPDATE Industrial_Zones SET latitude = 13.0710, longitude = 77.7980, distance_method = 'road_km' WHERE zone_id = 8;
UPDATE Industrial_Zones SET latitude = 13.1007, longitude = 77.5963, distance_method = 'road_km' WHERE zone_id = 9;
UPDATE Industrial_Zones SET latitude = 12.9975, longitude = 77.7602, distance_method = 'road_km' WHERE zone_id = 10;
UPDATE Industrial_Zones SET latitude = 12.7095, longitude = 77.6952, distance_method = 'road_km' WHERE zone_id = 11;
UPDATE Industrial_Zones SET latitude = 13.0530, longitude = 78.0210, distance_method = 'road_km' WHERE zone_id = 12;

-- Key logistics zones
UPDATE Freight_Corridors SET key_logistics_zones = 'Nelamangala, Dobbaspet MMLP, Peenya'       WHERE corridor_id = 'BC-01';
UPDATE Freight_Corridors SET key_logistics_zones = 'Electronic City, Bommasandra, Attibele'     WHERE corridor_id = 'BC-02';
UPDATE Freight_Corridors SET key_logistics_zones = 'KIA Cargo Hub, Devanahalli, Doddaballapura' WHERE corridor_id = 'BC-03';
UPDATE Freight_Corridors SET key_logistics_zones = 'Hoskote, Narasapura (Kolar), Whitefield'    WHERE corridor_id = 'BC-04';
UPDATE Freight_Corridors SET key_logistics_zones = 'Bidadi Industrial Area, Ramanagara'         WHERE corridor_id = 'BC-05';

-- Month numbers
UPDATE vehicle_reg_historical SET month_num =
    CASE month
        WHEN 'JANUARY' THEN 1 WHEN 'FEBRUARY' THEN 2
        WHEN 'MARCH' THEN 3 WHEN 'APRIL' THEN 4
        WHEN 'MAY' THEN 5 WHEN 'JUNE' THEN 6
        WHEN 'JULY' THEN 7 WHEN 'AUGUST' THEN 8
        WHEN 'SEPTEMBER' THEN 9 WHEN 'OCTOBER' THEN 10
        WHEN 'NOVEMBER' THEN 11 WHEN 'DECEMBER' THEN 12
        ELSE 0
    END;

UPDATE vehicle_reg_trends SET month_num =
    CASE month
        WHEN 'JANUARY' THEN 1 WHEN 'FEBRUARY' THEN 2
        WHEN 'MARCH' THEN 3 WHEN 'APRIL' THEN 4
        WHEN 'MAY' THEN 5 WHEN 'JUNE' THEN 6
        WHEN 'JULY' THEN 7 WHEN 'AUGUST' THEN 8
        WHEN 'SEPTEMBER' THEN 9 WHEN 'OCTOBER' THEN 10
        WHEN 'NOVEMBER' THEN 11 WHEN 'DECEMBER' THEN 12
        WHEN 'APRIL-OCTOBER' THEN 0 ELSE 0
    END;

UPDATE vehicle_reg_trends SET data_type =
    CASE WHEN month LIKE '%-%' THEN 'Partial' ELSE 'Full' END;

UPDATE vehicle_reg_2025 SET month_num =
    CASE month
        WHEN 'JANUARY' THEN 1 WHEN 'FEBRUARY' THEN 2
        WHEN 'MARCH' THEN 3 WHEN 'APRIL' THEN 4
        WHEN 'MAY' THEN 5 WHEN 'JUNE' THEN 6
        WHEN 'JULY' THEN 7 WHEN 'AUGUST' THEN 8
        WHEN 'SEPTEMBER' THEN 9 WHEN 'OCTOBER' THEN 10
        WHEN 'NOVEMBER' THEN 11 WHEN 'DECEMBER' THEN 12
        ELSE 0
    END;

-- Clean month column trailing commas
UPDATE vehicle_reg_historical
SET month = TRIM(REPLACE(month, ',', ''));

-- ============================================
-- PHASE 1F: INSERT CORRIDOR TRENDS
-- ============================================

INSERT INTO corridor_trends
(corridor_id, year, trucks_per_day, period_label, principal_goods)
VALUES
('BC-01',2020, 9000,'Lockdown',        'Port Cargo, FMCG, 3PL'),
('BC-01',2021,11000,'Recovery',        'Port Cargo, FMCG, 3PL'),
('BC-01',2022,14000,'Post-Pandemic',   'Port Cargo, FMCG, 3PL'),
('BC-01',2023,16000,'Peak',            'Port Cargo, FMCG, 3PL'),
('BC-01',2024,17500,'Projected',       'Port Cargo, FMCG, 3PL'),
('BC-01',2025,18500,'Projected',       'Port Cargo, FMCG, 3PL'),
('BC-02',2020, 8000,'Lockdown',        'Electronics, Auto Parts'),
('BC-02',2021,10000,'Recovery',        'Electronics, Auto Parts'),
('BC-02',2022,11000,'Post-Pandemic',   'Electronics, Auto Parts'),
('BC-02',2023,13000,'Peak',            'Electronics, Auto Parts'),
('BC-02',2024,14500,'Projected',       'Electronics, Auto Parts'),
('BC-02',2025,15500,'Projected',       'Electronics, Auto Parts'),
('BC-03',2020, 5000,'Lockdown',        'Airport Cargo, Mining'),
('BC-03',2021, 6000,'Recovery',        'Airport Cargo, Mining'),
('BC-03',2022, 7500,'Post-Pandemic',   'Airport Cargo, Mining'),
('BC-03',2023, 8500,'Peak',            'Airport Cargo, Mining'),
('BC-03',2024, 9500,'Projected',       'Airport Cargo, Mining'),
('BC-03',2025,10500,'Projected',       'Airport Cargo, Mining'),
('BC-04',2020, 6500,'Lockdown',        'Warehouse, Auto Hub'),
('BC-04',2021, 7500,'Recovery',        'Warehouse, Auto Hub'),
('BC-04',2022, 9000,'Post-Pandemic',   'Warehouse, Auto Hub'),
('BC-04',2023,10500,'Peak',            'Warehouse, Auto Hub'),
('BC-04',2024,12000,'Projected',       'Warehouse, Auto Hub'),
('BC-04',2025,13000,'Projected',       'Warehouse, Auto Hub'),
('BC-05',2020, 4000,'Lockdown',        'Regional Dist., Pharma'),
('BC-05',2021, 5500,'Recovery',        'Regional Dist., Pharma'),
('BC-05',2022, 6000,'Post-Pandemic',   'Regional Dist., Pharma'),
('BC-05',2023, 7000,'Expressway Opens','Regional Dist., Pharma'),
('BC-05',2024, 8500,'Projected',       'Regional Dist., Pharma'),
('BC-05',2025, 9500,'Projected',       'Regional Dist., Pharma');

-- ============================================
-- PHASE 1G: PRIMARY KEYS FOR VEHICLE TABLES
-- ============================================

ALTER TABLE vehicle_reg_historical
ADD CONSTRAINT pk_hist
PRIMARY KEY (rto_region, vehicle_type, year, month);

ALTER TABLE vehicle_reg_trends
ADD CONSTRAINT pk_trends
PRIMARY KEY (vehicle_type, year, month);

ALTER TABLE vehicle_reg_2025
ADD CONSTRAINT pk_2025
PRIMARY KEY (vehicle_type, year, month);

-- ============================================
-- PHASE 1H: INDEXES
-- ============================================

CREATE INDEX idx_hubs_company    ON Logistics_Hubs(company);
CREATE INDEX idx_hubs_type       ON Logistics_Hubs(hub_type_clean);
CREATE INDEX idx_hubs_location   ON Logistics_Hubs(location);
CREATE INDEX idx_hubs_zone       ON Logistics_Hubs(nearest_zone);

CREATE INDEX idx_zones_district  ON Industrial_Zones(district);
CREATE INDEX idx_zones_distance  ON Industrial_Zones(distance_km);

CREATE INDEX idx_corridors_direction ON Freight_Corridors(direction);
CREATE INDEX idx_corridors_trucks    ON Freight_Corridors(trucks_per_day);

CREATE INDEX idx_historical_year     ON vehicle_reg_historical(year);
CREATE INDEX idx_historical_region   ON vehicle_reg_historical(rto_region);
CREATE INDEX idx_historical_vehicle  ON vehicle_reg_historical(vehicle_type);
CREATE INDEX idx_historical_month    ON vehicle_reg_historical(month);

CREATE INDEX idx_trends_year     ON vehicle_reg_trends(year);
CREATE INDEX idx_trends_vehicle  ON vehicle_reg_trends(vehicle_type);
CREATE INDEX idx_trends_month    ON vehicle_reg_trends(month);

CREATE INDEX idx_2025_vehicle    ON vehicle_reg_2025(vehicle_type);
CREATE INDEX idx_2025_month      ON vehicle_reg_2025(month);
CREATE INDEX idx_2025_year       ON vehicle_reg_2025(year);

-- ============================================
-- PHASE 2: JOIN QUERIES
-- ============================================

-- JOIN 1: Hubs + Zones
SELECT l.hub_id, l.hub_name, l.company, l.location,
       l.hub_type_clean, i.district, i.distance_km, i.major_sectors
FROM Logistics_Hubs l
JOIN Industrial_Zones i ON l.nearest_zone = i.zone_name
ORDER BY i.distance_km;

-- JOIN 2: Hubs + Corridors
SELECT l.hub_name, l.company, l.location, l.hub_type_clean,
       f.highway_name, f.trucks_per_day, f.direction, f.corridor_type
FROM Logistics_Hubs l
JOIN Freight_Corridors f ON l.corridor_id = f.corridor_id
ORDER BY f.trucks_per_day DESC;

-- JOIN 3: Zones with no Hubs
SELECT i.zone_id, i.zone_name, i.district, i.distance_km,
       l.hub_name, l.company
FROM Industrial_Zones i
LEFT JOIN Logistics_Hubs l ON i.zone_name = l.nearest_zone
WHERE l.hub_id IS NULL
ORDER BY i.distance_km;

-- JOIN 4: All 3 tables together
SELECT l.hub_id, l.hub_name, l.company, l.location,
       l.hub_type_clean, l.company_type,
       i.district, i.distance_km, i.major_sectors,
       f.highway_name, f.trucks_per_day, f.corridor_type
FROM Logistics_Hubs l
JOIN Industrial_Zones i  ON l.nearest_zone = i.zone_name
JOIN Freight_Corridors f ON l.corridor_id  = f.corridor_id
ORDER BY f.trucks_per_day DESC, i.distance_km;

-- ============================================
-- PHASE 3: AGGREGATE QUERIES
-- ============================================

-- AGG 1: Hubs per company
SELECT company, COUNT(*) AS total_hubs
FROM Logistics_Hubs
GROUP BY company ORDER BY total_hubs DESC;

-- AGG 2: Hubs per hub type
SELECT hub_type_clean, COUNT(*) AS total_hubs
FROM Logistics_Hubs
GROUP BY hub_type_clean ORDER BY total_hubs DESC;

-- AGG 3: Trucks and hubs per corridor
SELECT f.highway_name, f.trucks_per_day,
       COUNT(l.hub_id) AS total_hubs,
       SUM(f.trucks_per_day) AS total_truck_load
FROM Freight_Corridors f
LEFT JOIN Logistics_Hubs l ON f.corridor_id = l.corridor_id
GROUP BY f.highway_name, f.trucks_per_day
ORDER BY f.trucks_per_day DESC;

-- AGG 4: Average distance per district
SELECT district, COUNT(*) AS total_zones,
       AVG(distance_km) AS avg_distance,
       MIN(distance_km) AS nearest_zone,
       MAX(distance_km) AS farthest_zone
FROM Industrial_Zones
GROUP BY district ORDER BY avg_distance;

-- AGG 5: Companies with more than 1 hub
SELECT company, COUNT(*) AS total_hubs
FROM Logistics_Hubs
GROUP BY company HAVING COUNT(*) > 1
ORDER BY total_hubs DESC;

-- AGG 6: Corridor risk flag
SELECT f.highway_name, f.trucks_per_day,
       COUNT(l.hub_id) AS total_hubs,
       CASE
           WHEN COUNT(l.hub_id) >= 4 THEN 'High Risk'
           WHEN COUNT(l.hub_id) >= 3 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS concentration_risk
FROM Freight_Corridors f
LEFT JOIN Logistics_Hubs l ON f.corridor_id = l.corridor_id
GROUP BY f.highway_name, f.trucks_per_day
ORDER BY total_hubs DESC;

-- AGG 7: Hub count per district
SELECT i.district, COUNT(l.hub_id) AS total_hubs
FROM Industrial_Zones i
LEFT JOIN Logistics_Hubs l ON i.zone_name = l.nearest_zone
GROUP BY i.district ORDER BY total_hubs DESC;

-- ============================================
-- PHASE 4: BUSINESS QUESTIONS
-- ============================================

-- Q1: RTO Region Growth (Q1 2020 vs Q1 2021)
SELECT rto_region,
    SUM(CASE WHEN year=2020 AND month IN ('APRIL','MAY','JUNE')
        THEN registrations ELSE 0 END) AS reg_2020_q1,
    SUM(CASE WHEN year=2021 AND month IN ('JANUARY','FEBRUARY','MARCH')
        THEN registrations ELSE 0 END) AS reg_2021_q1,
    ROUND((CAST(SUM(CASE WHEN year=2021 AND month IN
        ('JANUARY','FEBRUARY','MARCH')
        THEN registrations ELSE 0 END) AS FLOAT) -
        CAST(SUM(CASE WHEN year=2020 AND month IN
        ('APRIL','MAY','JUNE')
        THEN registrations ELSE 0 END) AS FLOAT)) /
        NULLIF(CAST(SUM(CASE WHEN year=2020 AND month IN
        ('APRIL','MAY','JUNE')
        THEN registrations ELSE 0 END) AS FLOAT),0)*100,2) AS growth_pct
FROM vehicle_reg_historical
GROUP BY rto_region ORDER BY growth_pct DESC;
-- Result: Electronic City highest at 4.63%

-- Q2: Hub Concentration Risk by Hub Type
SELECT l.hub_type_clean,
    COUNT(*) AS total_hubs,
    COUNT(DISTINCT l.location) AS unique_locations,
    ROUND(CAST(COUNT(*) AS FLOAT) /
          NULLIF(COUNT(DISTINCT l.location),0),2) AS hubs_per_location,
    CASE WHEN ROUND(CAST(COUNT(*) AS FLOAT) /
         NULLIF(COUNT(DISTINCT l.location),0),2) >= 2
         THEN 'High Concentration Risk'
         ELSE 'Low Concentration Risk'
    END AS risk_level
FROM Logistics_Hubs l
GROUP BY l.hub_type_clean ORDER BY hubs_per_location DESC;
-- Result: Fulfillment highest concentration risk

-- Q3: Zone Distance vs Hub Density
SELECT i.distance_type,
    COUNT(DISTINCT i.zone_name) AS total_zones,
    COUNT(l.hub_id) AS total_hubs,
    ROUND(CAST(COUNT(l.hub_id) AS FLOAT) /
          NULLIF(COUNT(DISTINCT i.zone_name),0),2) AS hubs_per_zone
FROM Industrial_Zones i
LEFT JOIN Logistics_Hubs l ON i.zone_name = l.nearest_zone
GROUP BY i.distance_type ORDER BY hubs_per_zone DESC;
-- Result: Peripheral 2.0, Mid-Ring 1.5, Outer 1.0

-- Q4: Vehicle Type YoY Growth (2023 vs 2024)
SELECT vehicle_type,
    SUM(CASE WHEN year=2023 THEN registrations ELSE 0 END) AS reg_2023,
    SUM(CASE WHEN year=2024 THEN registrations ELSE 0 END) AS reg_2024,
    ROUND((CAST(SUM(CASE WHEN year=2024
        THEN registrations ELSE 0 END) AS FLOAT) -
        CAST(SUM(CASE WHEN year=2023
        THEN registrations ELSE 0 END) AS FLOAT)) /
        NULLIF(CAST(SUM(CASE WHEN year=2023
        THEN registrations ELSE 0 END) AS FLOAT),0)*100,2)
    AS growth_pct_2023_to_2024
FROM vehicle_reg_trends
WHERE year IN (2023,2024) AND month != 'APRIL-OCTOBER'
GROUP BY vehicle_type ORDER BY growth_pct_2023_to_2024 DESC;
-- Result: Light Goods Three Wheeler +24.17%

-- Q5: 2025 vs 2024 Apr-Dec Comparison
SELECT v25.vehicle_type,
    SUM(v25.registrations) AS reg_2025,
    SUM(vt.registrations)  AS reg_2024,
    ROUND((CAST(SUM(v25.registrations) AS FLOAT) -
           CAST(SUM(vt.registrations) AS FLOAT)) /
           NULLIF(CAST(SUM(vt.registrations) AS FLOAT),0)*100,2) AS growth_pct
FROM vehicle_reg_2025 v25
JOIN vehicle_reg_trends vt
    ON v25.vehicle_type = vt.vehicle_type
    AND v25.month = vt.month
    AND vt.year = 2024
GROUP BY v25.vehicle_type ORDER BY growth_pct DESC;
-- Result: Multi Axled Articulated +102.71%

-- Q6: Most Critical E-commerce Corridor
SELECT f.highway_name, f.trucks_per_day,
    COUNT(l.hub_id) AS total_hubs,
    SUM(CASE WHEN l.company_type='E-commerce' THEN 1 ELSE 0 END) AS ecommerce_hubs,
    SUM(CASE WHEN l.company_type='Q-commerce' THEN 1 ELSE 0 END) AS qcommerce_hubs,
    CASE
        WHEN SUM(CASE WHEN l.company_type IN
            ('E-commerce','Q-commerce') THEN 1 ELSE 0 END) >= 3
        THEN 'Critical'
        WHEN SUM(CASE WHEN l.company_type IN
            ('E-commerce','Q-commerce') THEN 1 ELSE 0 END) >= 2
        THEN 'Important'
        ELSE 'Secondary'
    END AS ecommerce_importance
FROM Freight_Corridors f
LEFT JOIN Logistics_Hubs l ON f.corridor_id = l.corridor_id
GROUP BY f.highway_name, f.trucks_per_day
ORDER BY ecommerce_hubs DESC;
-- Result: NH 75 Old Madras Road = Critical

-- Q7: Urban Commercial Hubs (no industrial zone)
SELECT hub_id, hub_name, company, location,
       hub_type_clean, zone_type
FROM Logistics_Hubs
WHERE zone_type = 'Urban Commercial'
ORDER BY location;
-- Result: HUB_13, HUB_18, HUB_19

-- ============================================
-- PHASE 5: VIEWS FOR POWER BI
-- ============================================

-- VIEW 1: Master hub view
CREATE VIEW vw_hubs_zones_corridors AS
SELECT
    l.hub_id, l.original_hub_id, l.hub_name,
    l.company, l.location, l.hub_type_clean,
    l.company_type, l.zone_type, l.corridor_id,
    l.latitude AS hub_latitude,
    l.longitude AS hub_longitude,
    i.district, i.distance_km, i.distance_type,
    i.major_sectors,
    i.latitude AS zone_latitude,
    i.longitude AS zone_longitude,
    f.highway_name, f.trucks_per_day,
    f.direction, f.corridor_type,
    f.key_logistics_zones
FROM Logistics_Hubs l
JOIN Industrial_Zones i  ON l.nearest_zone = i.zone_name
JOIN Freight_Corridors f ON l.corridor_id  = f.corridor_id;

-- VIEW 2: Vehicle trends combined
CREATE VIEW vw_vehicle_trends AS
SELECT vehicle_type, registrations, year, month,
       month_num, 'City Trends' AS source
FROM vehicle_reg_trends WHERE data_type = 'Full'
UNION ALL
SELECT vehicle_type, registrations, year, month,
       month_num, 'Current 2025' AS source
FROM vehicle_reg_2025;

-- VIEW 3: Corridor risk summary
CREATE OR ALTER VIEW vw_corridor_risk AS
SELECT f.corridor_id, f.highway_name,
    f.trucks_per_day, f.direction, f.key_logistics_zones,
    COUNT(l.hub_id) AS total_hubs,
    COUNT(DISTINCT l.location) AS unique_locations,
    SUM(CASE WHEN l.company_type IN
        ('E-commerce','Q-commerce') THEN 1 ELSE 0 END) AS high_priority_hubs,
    CASE
        WHEN COUNT(l.hub_id) >= 4 THEN 'High Risk'
        WHEN COUNT(l.hub_id) >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM Freight_Corridors f
LEFT JOIN Logistics_Hubs l ON f.corridor_id = l.corridor_id
GROUP BY f.corridor_id, f.highway_name,
         f.trucks_per_day, f.direction, f.key_logistics_zones;

-- VIEW 4: RTO growth summary
CREATE VIEW vw_rto_growth AS
SELECT rto_region, year, vehicle_type,
    SUM(registrations) AS total_registrations
FROM vehicle_reg_historical
GROUP BY rto_region, year, vehicle_type;

-- VIEW 5: Logistics time series with YoY growth
CREATE OR ALTER VIEW vw_logistics_time_series AS
SELECT ct.corridor_id, ct.year, ct.period_label,
    ct.trucks_per_day AS annual_tpd,
    ROUND((CAST(ct.trucks_per_day AS FLOAT) -
        LAG(ct.trucks_per_day) OVER
        (PARTITION BY ct.corridor_id ORDER BY ct.year)) /
        NULLIF(LAG(ct.trucks_per_day) OVER
        (PARTITION BY ct.corridor_id ORDER BY ct.year),0)*100,2)
    AS yoy_growth_pct,
    ct.principal_goods, f.highway_name,
    f.direction, f.corridor_type, f.key_logistics_zones
FROM corridor_trends ct
JOIN Freight_Corridors f ON ct.corridor_id = f.corridor_id;