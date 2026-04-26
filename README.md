# 🚛 Bangalore Logistics Network Analysis

> **A full-stack data analytics project** analysing Bangalore's logistics infrastructure using SQL Server, Power BI, and Excel — identifying hub concentration risks, corridor bottlenecks, and freight coverage gaps across the city.

---

## 📌 Project Summary

Bangalore is India's fastest-growing logistics market, yet its freight infrastructure is dangerously concentrated. This project maps **20 logistics hubs**, **5 freight corridors**, and **12 industrial zones** across Bangalore to answer one critical question:

> *"Where is Bangalore's logistics network most vulnerable — and where should the next hub be built?"*

---

## 🎯 Business Problems Solved

| Problem | Finding |
|---|---|
| Hub over-concentration | 40% of all hubs in just 2 locations |
| Single point of failure | NH 48 carries 15,000 trucks/day with no alternative |
| Coverage gap | Anekal Industrial Area has zero hub presence |
| Underinvested corridor | NH 44 North serves airport but only 1 company present |
| Vehicle demand surge | Multi Axled vehicles grew 60% in 2025 vs 2024 |

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Microsoft SQL Server** | Database design, querying, analysis |
| **Power BI Desktop** | Interactive 5-page dashboard |
| **Microsoft Excel** | Data preparation and ETL |
| **GitHub** | Version control and portfolio |

---

## 🗄️ Database Structure

### Tables (7 Total — 799+ Rows)

```
BangaloreLogistics/
├── Industrial_Zones       (12 rows)  — zones, districts, coordinates
├── Freight_Corridors      (5 rows)   — highways, truck volumes
├── Logistics_Hubs         (20 rows)  — hubs, companies, locations
├── corridor_trends        (30 rows)  — yearly truck volumes 2020-2025
├── vehicle_reg_historical (528 rows) — RTO regional data 2020-2021
├── vehicle_reg_trends     (168 rows) — city-wide data 2021-2025
└── vehicle_reg_2025       (36 rows)  — current state Apr-Dec 2025
```

### Views (5 Total — for Power BI)

```
├── vw_hubs_zones_corridors    — master hub view (Pages 1,2,3)
├── vw_vehicle_trends          — combined vehicle data (Page 4)
├── vw_corridor_risk           — risk summary per corridor (Page 3)
├── vw_rto_growth              — RTO regional breakdown (Page 4)
└── vw_logistics_time_series   — corridor growth 2020-2025 (Page 3)
```

---

## 📊 Power BI Dashboard — 5 Pages

### Page 1 — Executive Summary (KPI Overview)
- Total Hubs, Peak Corridor Volume, Avg Distance, YoY Growth
- Trucks Per Day by Highway (bar chart)
- Hub Count by Type (donut chart)
- Hub Distribution Map

### Page 2 — Hub Network Map
- Interactive Bangalore map with 20 hubs
- Color coded by hub type
- Filter by Company, Hub Type, District
- Hub details table with conditional formatting

### Page 3 — Freight Corridor Risk Analysis
- Hub Count per Corridor (color coded by risk)
- Truck Volume Growth 2020-2025 (line chart)
- Corridor Risk Summary table
- E-commerce Hub Distribution (donut)

### Page 4 — Vehicle Registration Trends
- Registration Trends 2021-2025 (line chart)
- YoY Growth % 2022-2025 (line chart)
- Total Registrations by Vehicle Type (bar)
- Interactive slicers — vehicle type and year range

### Page 5 — Strategic Recommendations
- Investment Priority Matrix (5 priorities)
- Hub Gap Analysis by Area (bar chart)
- E-commerce Hub Density by Corridor
- Key Findings (Critical Risk, Coverage Gap, Opportunity)

---

## 🔍 Key Findings

### 1. 🔴 Critical Risk — NH 48 Tumakuru Road
```
15,000 trucks/day on ONE highway
4 hubs ALL in Nelamangala — zero geographic spread
Single road closure = 40% of Bangalore e-commerce fails
```

### 2. 🟠 Coverage Gap — South Bangalore
```
Anekal Industrial Area — manufacturing zone with ZERO hub
South Bangalore has only 3 hubs across 5 industrial zones
0.6 hubs per zone vs city average of 1.67
```

### 3. 🟢 Opportunity — NH 44 North Airport Corridor
```
Multi Axled vehicles grew +60% in 2025 vs 2024
KIAL cargo terminal expanding rapidly
Only Amazon has hub presence — high ROI zone!
```

### 4. 📈 Vehicle Trends
```
Light Goods Three Wheeler → +24.17% (2023-2024)
Multi Axled Articulated   → +22.07% (2023-2024)
Light Goods Four Wheeler  → +6.45%  (2023-2024)
Trucks and Lorries        → -3.69%  (2023-2024)
```

---

## 💼 7 Business Questions Answered

| # | Question | Answer |
|---|---|---|
| Q1 | Highest RTO growth region? | Electronic City +4.63% |
| Q2 | Hub type with most concentration risk? | Fulfillment — 6 hubs, 2 locations |
| Q3 | Zone distance vs hub density? | Peripheral 2.0 > Mid-Ring 1.5 > Outer 1.0 |
| Q4 | Strongest YoY vehicle growth? | Light Goods Three Wheeler +24.17% |
| Q5 | 2025 vs 2024 comparison? | Multi Axled +60.30% full year |
| Q6 | Most critical e-commerce corridor? | NH 75 Old Madras Road — Critical |
| Q7 | Urban hubs without industrial zone? | HUB_13, HUB_18, HUB_19 |

---

## 🗂️ Repository Structure

```
Bangalore-Logistics-Network-Analysis/
│
├── README.md                                    ← this file
│
├── sql/
│   └── BangaloreLogistics_Complete.sql          ← all SQL queries
│
├── data/
│   ├── bangalore_logistics_MASTER.xlsx          ← logistics data
│   ├── Bangalore_Vehicle_Registration_CLEAN.xlsx← vehicle data
│   ├── Historical_Zonal.csv                     ← RTO 2020-2021
│   ├── City_Trends.csv                          ← city 2021-2025
│   └── Current_State_2025.csv                   ← 2025 data
│
├── powerbi/
│   └── BangaloreLogistics.pbix                  ← dashboard file
│
└── docs/
    └── Bangalore_Project_Context.docx           ← full documentation
```

---

## 🧠 SQL Concepts Demonstrated

### DDL
- `CREATE TABLE` with PRIMARY KEY, FOREIGN KEY, CONSTRAINTS
- `ALTER TABLE` — ADD columns, ALTER COLUMN
- `DROP TABLE`, `TRUNCATE TABLE`
- `CREATE INDEX` — CLUSTERED vs NONCLUSTERED (19 indexes)
- `CREATE VIEW`, `CREATE OR ALTER VIEW`

### DML
- `INSERT INTO` — single and multi-row
- `BULK INSERT` from CSV files
- `UPDATE SET WHERE` — single and batch updates
- `SELECT` with aliases, ORDER BY, TOP, DISTINCT

### Joins & Aggregates
- `INNER JOIN` across 2 and 3 tables
- `LEFT JOIN` for finding missing data
- `GROUP BY` with COUNT, SUM, AVG, MIN, MAX
- `HAVING` for post-aggregation filtering
- `UNION ALL` for combining result sets

### Advanced SQL
- `CASE WHEN` for conditional logic
- `CAST`, `NULLIF`, `ROUND` for calculations
- Window function: `LAG()` with `PARTITION BY`
- `sys.indexes` for index verification
- Composite `PRIMARY KEY` on vehicle tables

---

## 📉 Data Limitations & Methodology

| Data Point | Type | Notes |
|---|---|---|
| Hub locations | Simulated | Based on real Bangalore geography |
| Vehicle registrations | Real | Karnataka RTO records |
| Corridor 2024 baseline | Real | NHAI Traffic Census + Bangalore CMP |
| Corridor yearly figures | Modeled | NHAI baseline + 7-9% CAGR |
| COVID period 2020-21 | Modeled | 25% reduction factor applied |
| RTO regional data | Real | Available 2020-2021 only |
| 2022 April-October | Real | Published as aggregate only |

> **Note:** Simulated hub data is standard practice for fresher portfolios. All data sources and modeling assumptions are clearly documented above.

---

## 🚀 Strategic Recommendations

| Priority | Area | Action | Impact | Timeline |
|---|---|---|---|---|
| 1 | South Bangalore (JP Nagar) | Build Fulfillment Hub | High | 2025-26 |
| 2 | NH 44 North (Devanahalli) | Expand Airport Corridor | High | 2025-26 |
| 3 | Anekal Zone | First Hub in Area | Medium | 2026 |
| 4 | NH 48 (Nelamangala) | Alternative Route Planning | High | 2026-27 |
| 5 | Kolar District | Improve NH 75 Connectivity | Medium | 2026-27 |

---

## 👤 About the Author

**Pavan** — Aspiring Data Analyst based in Bengaluru, Karnataka

- 🎓 BCom Graduate
- 🛠️ Skills: SQL Server, Power BI, Excel, Power Query
- 📍 Location: Bengaluru, Karnataka, India
- 🎯 Target Role: Data Analyst

---

## 📎 How to Run This Project

### SQL Setup
```sql
-- 1. Create database
CREATE DATABASE BangaloreLogistics;

-- 2. Run complete SQL file
-- Open BangaloreLogistics_Complete.sql in SSMS
-- Update BULK INSERT paths to your local CSV location:
-- FROM 'C:\YourPath\Historical_Zonal.csv'

-- 3. Verify data loaded
SELECT 'Industrial_Zones', COUNT(*) FROM Industrial_Zones
UNION ALL SELECT 'Logistics_Hubs', COUNT(*) FROM Logistics_Hubs
UNION ALL SELECT 'vehicle_reg_historical', COUNT(*) FROM vehicle_reg_historical;
```

### Power BI Setup
```
1. Open BangaloreLogistics.pbix
2. Transform Data → Data source settings
3. Update SQL Server connection:
   Server   → localhost\SQLEXPRESS
   Database → BangaloreLogistics
4. Refresh data
5. All 5 pages load automatically!
```

---
