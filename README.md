# ✈️ SkyRoutes Profit Lab
### Identifying Profitable Airline Routes — Business-Oriented Data Analysis


---

## 🎯 Project Overview

You are hired as a data analyst for **SkyRoutes Airlines**, which operates across various international and domestic routes. Your task is to **analyze the profitability** of routes based on:

- 🧳 Passenger Volume
- 💰 Cost & Revenue
- 📊 Operational Metrics

The deliverable is a complete SQL analysis **+** a visual Excel/Power BI dashboard.

---


---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Dataset Schema](#-dataset-schema)
- [Project Structure](#-project-structure)
- [Step-by-Step Setup Guide](#-step-by-step-setup-guide)
- [Part 1 — SQL Analysis](#-part-1--sql-analysis)
- [Part 2 — Excel Dashboard](#-part-2--excel-dashboard)
- [Key Insights](#-key-insights)
- [Final Submission Checklist](#-final-submission-checklist)



## 🗂️ Dataset Schema

**File:** `AirlineRoutesData.csv` — 5,000 flight records across 20 routes

| Column Name         | Type    | Description                              |
|---------------------|---------|------------------------------------------|
| `FlightID`          | Integer | Unique identifier for each flight        |
| `RouteCode`         | Text    | Route code (e.g., BOM-DEL)               |
| `Origin`            | Text    | Departure airport (IATA code)            |
| `Destination`       | Text    | Arrival airport (IATA code)              |
| `FlightDate`        | Date    | Date of the flight (YYYY-MM-DD)          |
| `FlightDurationMins`| Integer | Total flight duration in minutes         |
| `AircraftType`      | Text    | Type of aircraft used                    |
| `SeatsAvailable`    | Integer | Total seats offered on the flight        |
| `SeatsSold`         | Integer | Number of tickets sold                   |
| `Revenue`           | Float   | Total revenue from ticket sales (₹)      |
| `OperationalCost`   | Float   | Cost to operate the flight (₹)           |

**Routes covered:** 10 Domestic + 10 International  
**Date range:** Jan 2023 – Dec 2023  
**Aircraft types:** Boeing 737, Airbus A320, Boeing 777, Airbus A380, ATR 72

---

## 📁 Project Structure

```
SkyRoutesProfitLab/
│
├── AirlineRoutesData.csv         # Generated dataset (5,000 records)
├── SkyRoutesAnalysis.sql         # All 7 SQL queries + bonus query
├── RouteProfitDashboard.xlsx     # Excel dashboard with charts
├── RouteInsights.txt             # 5–6 line findings summary
├── generate_dataset.py           # Python script to regenerate CSV
└── README.md                     # This file
```

---

## 🚀 Step-by-Step Setup Guide

### Prerequisites

| Tool | Purpose | Download |
|------|---------|----------|
| Python 3.x | Generate dataset | [python.org](https://python.org) |
| DB Browser for SQLite | Run SQL queries | [sqlitebrowser.org](https://sqlitebrowser.org) |
| Microsoft Excel 2016+ | Build dashboard | Office Suite |
| `pandas`, `openpyxl` | Python libraries | `pip install pandas openpyxl` |

---

### Step 1 — Generate the Dataset

```bash
pip install pandas openpyxl
python generate_dataset.py
# Output: AirlineRoutesData.csv (5,000 rows)
```

---

### Step 2 — Load Data into SQLite

1. Open **DB Browser for SQLite**
2. Click **"New Database"** → name it `SkyRoutesAnalysis.db`
3. Go to **Execute SQL** tab
4. Run the `CREATE TABLE` block from `SkyRoutesAnalysis.sql`
5. Import the CSV:
   - Go to **File → Import → Table from CSV**
   - Select `AirlineRoutesData.csv`
   - Table name: `airlineroutesdata`
   - Check "First row contains column names" ✅
6. Click **OK** → data is loaded

> **MySQL alternative:**
> ```sql
> LOAD DATA INFILE '/path/AirlineRoutesData.csv'
> INTO TABLE airlineroutesdata
> FIELDS TERMINATED BY ','
> LINES TERMINATED BY '\n'
> IGNORE 1 ROWS;
> ```

---

### Step 3 — Run SQL Queries

Open `SkyRoutesAnalysis.sql` in your SQL client and execute **each query block** one by one:

| Query # | Description |
|---------|-------------|
| Q1 | Top 10 most frequent routes |
| Q2 | Avg revenue, cost & profit per route |
| Q3 | Underperforming routes (negative avg profit) |
| Q4 | Seat occupancy % per route |
| Q5 | Monthly profit trend per route |
| Q6 | Domestic vs international profitability |
| Q7 | Routes ranked by revenue per minute of flight |

**Export each result:**
- In DB Browser: **File → Export → Results to CSV**
- Save each as `Q1_result.csv`, `Q2_result.csv`, etc.

---

### Step 4 — Open the Excel Dashboard

1. Open `RouteProfitDashboard.xlsx`
2. Navigate to the **DASHBOARD** sheet (first tab)
3. You will see:
   - **Bar Chart** — Top 10 most profitable routes
   - **Line Chart** — Monthly profit trend
4. Individual query results are in tabs: `Q1_FreqRoutes` through `Q7_RevPerMin`

**To add slicers (filters) in Excel:**
1. Click any cell in a data table
2. Go to **Insert → Slicer**
3. Select: `AircraftType`, `RouteCode`
4. For month filter: add a slicer on `FlightDate`

---

### Step 5 — Power BI Alternative (Optional)

1. Open **Power BI Desktop**
2. **Home → Get Data → Text/CSV** → load `AirlineRoutesData.csv`
3. In Power Query Editor, add a calculated column:
   ```
   Profit = [Revenue] - [OperationalCost]
   OccupancyPct = [SeatsSold] / [SeatsAvailable] * 100
   RouteType = IF([Origin] IN {"BOM","DEL","BLR",...}, "Domestic", "International")
   ```
4. Build visuals:
   - **Clustered Bar** → Top 10 routes by avg profit
   - **Map** → Origin/Destination plotted by IATA lat-long
   - **Line Chart** → Monthly profit trend
   - **Gauge** → Average occupancy %
   - **Stacked Column** → Cost vs Revenue per route
5. Add slicers for: `AircraftType`, `FlightDate` (Month), `RouteCode`
6. Save as `RouteProfitDashboard.pbix`

---

## 🔍 Part 1 — SQL Analysis

All 7 queries are in `SkyRoutesAnalysis.sql`. Key highlights:

```sql
-- Example: Profit per route
SELECT RouteCode,
       ROUND(AVG(Revenue), 2)                     AS AvgRevenue,
       ROUND(AVG(OperationalCost), 2)              AS AvgCost,
       ROUND(AVG(Revenue - OperationalCost), 2)    AS AvgProfit
FROM airlineroutesdata
GROUP BY RouteCode
ORDER BY AvgProfit DESC;
```

```sql
-- Example: Revenue per minute ranking
SELECT RouteCode,
       ROUND(AVG(Revenue) / AVG(FlightDurationMins), 2) AS RevenuePerMin,
       RANK() OVER (ORDER BY AVG(Revenue)/AVG(FlightDurationMins) DESC) AS Rank
FROM airlineroutesdata
GROUP BY RouteCode;
```

---

## 📊 Part 2 — Excel Dashboard

The dashboard (`RouteProfitDashboard.xlsx`) includes:

| Chart | Type | Data Source |
|-------|------|-------------|
| Top 10 Profitable Routes | Clustered Bar | Q2 results |
| Monthly Profit Trend | Line Chart | Aggregated monthly |
| Occupancy by Route | Donut/Gauge | Q4 results |
| Cost vs Revenue | Stacked Column | Q2 results |
| Dom vs Intl | Comparison Bar | Q6 results |

**Slicers configured for:**  `Flight Month` · `RouteCode`

---

## 💡 Key Insights

1. **BOM-BKK** is the top-performing route by total profit — high-ticket international demand with manageable costs.
2. **International routes** average **8.6× higher profit** than domestic routes per flight.
3. **CCU-DEL** shows the weakest average margin — candidate for schedule reduction or yield management.
4. **Network occupancy** sits at **71.2%** — healthy but with room to optimize on underperforming legs.
5. **Boeing 777 / A380** drive international profitability; **ATR 72** is efficient only on short domestic hops.
6. **Q4 (Oct–Dec)** shows peak profitability — airlines should deploy larger aircraft and plan capacity expansions in advance.

---

## ✅ Final Submission Checklist

| File | Description | Status |
|------|-------------|--------|
| `AirlineRoutesData.csv` | Generated dataset (5,000 records) | ✅ |
| `SkyRoutesAnalysis.sql` | All 7 SQL queries + bonus | ✅ |
| `RouteProfitDashboard.xlsx` | Excel visual dashboard | ✅ |
| `RouteInsights.txt` | 5–6 line findings summary | ✅ |
| `README.md` | Project documentation | ✅ |

---

## 🛠️ Tech Stack

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-SQLite-lightblue?logo=sqlite)
![Excel](https://img.shields.io/badge/Excel-2016+-green?logo=microsoftexcel)
![pandas](https://img.shields.io/badge/pandas-latest-purple?logo=pandas)

---

*Red & White Skill Education — Since 2008 | Shaping Skills for Scaling Higher*
