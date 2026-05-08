CREATE DATABASE SkyRoutesAnalysis;
USE SkyRoutesAnalysis;

CREATE TABLE airlineroutesdata (
    FlightID INTEGER PRIMARY KEY,
    RouteCode VARCHAR(50),
    Origin VARCHAR(50),
    Destination VARCHAR(50),
    FlightDate DATE,
    FlightDurationMins  INTEGER,
    AircraftType VARCHAR(50),
    SeatsAvailable INTEGER,
    SeatsSold INTEGER,
    Revenue REAL,
    OperationalCost REAL
);

-- LOAD CSV FILE VIA MYSQL WORKBENCH

-- VIEW DATA
SELECT * FROM airlineroutesdata;

-- Top 10 Most Frequent Routes
SELECT RouteCode, COUNT(*) AS TotalFlights
FROM airlineroutesdata
GROUP BY RouteCode
ORDER BY TotalFlights DESC
LIMIT 10;

-- Average Revenue, Cost, and Profit per Route
SELECT RouteCode, ROUND(AVG(Revenue), 2) AS AvgRevenue,
ROUND(AVG(OperationalCost), 2) AS AvgCost,
ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM airlineroutesdata
GROUP BY RouteCode
ORDER BY AvgProfit DESC;

-- Underperforming Routes Where Average Profit is Negative
SELECT RouteCode, ROUND(AVG(Revenue), 2) AS AvgRevenue,
ROUND(AVG(OperationalCost), 2) AS AvgCost,
ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM airlineroutesdata
GROUP BY RouteCode
HAVING AVG(Revenue - OperationalCost) < 0
ORDER BY AvgProfit ASC;
-- Above Query give empty set as my dataset not containg such columns.COMMENT


-- Seat Occupancy % per Route
SELECT RouteCode,
ROUND(SUM(SeatsSold) / SUM(SeatsAvailable) * 100, 2) AS OccupancyPct
FROM airlineroutesdata
GROUP BY RouteCode
ORDER BY OccupancyPct DESC;

-- Monthly Profit Trend per Route
SELECT RouteCode,
DATE_FORMAT(STR_TO_DATE(FlightDate, '%d-%m-%Y'), '%m-%Y') AS YearMonth,
ROUND(SUM(Revenue - OperationalCost), 2) AS MonthlyProfit
FROM airlineroutesdata
GROUP BY RouteCode, DATE_FORMAT(STR_TO_DATE(FlightDate, '%d-%m-%Y'), '%m-%Y')
ORDER BY RouteCode, DATE_FORMAT(STR_TO_DATE(FlightDate, '%d-%m-%Y'), '%m-%Y');

-- Domestic vs International Profitability
SELECT CASE
        WHEN Origin IN ('BOM','DEL','BLR','HYD','CCU','MAA','GOI','AMD')
        AND Destination IN ('BOM','DEL','BLR','HYD','CCU','MAA','GOI','AMD')
        THEN 'Domestic'
        ELSE 'International'
    END AS RouteType,
COUNT(*) AS TotalFlights,
ROUND(AVG(Revenue), 2) AS AvgRevenue,
ROUND(AVG(OperationalCost), 2) AS AvgCost,
ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit,
ROUND(SUM(Revenue - OperationalCost), 2) AS TotalProfit
FROM airlineroutesdata
GROUP BY RouteType;

-- Routes Ranked by Revenue per Minute of Flight
SELECT RouteCode,
ROUND(AVG(FlightDurationMins), 1) AS AvgDurationMins,
ROUND(AVG(Revenue), 2) AS AvgRevenue,
ROUND(AVG(Revenue) / AVG(FlightDurationMins), 2) AS RevenuePerMin,
RANK() OVER (ORDER BY AVG(Revenue)/AVG(FlightDurationMins) DESC) AS RevenuePerMinRank
FROM airlineroutesdata
GROUP BY RouteCode
ORDER BY RevenuePerMinRank;