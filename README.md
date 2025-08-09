# SmartFactory-Analytics-Manufacturing-PowerBI-Demo

## Overview  
This repository provides a comprehensive demo project to generate a synthetic manufacturing dataset optimized for Power BI analytics.  
It focuses on a **single product with multiple sizes**, multiple production teams and shifts, detailed production cost breakdowns, supply & demand data, and geographic locations.  

The dataset includes intentional data quality issues such as mixed date formats, typos, nulls, duplicates, outliers, and unit inconsistencies to enable realistic data cleaning and analysis practice.

---

## Key Features

- SQL scripts to create and populate:
  - `Products` table (with sizes)
  - `ProductionTeams` table (multiple shifts and teams)
  - `ProductionTransactions` table (10,000+ synthetic records with messy data)
- Data cleaning scripts standardizing dates
- Combined manufacturing dataset ready for Power BI import
- Power BI KPI recommendations and DAX formulas included

---

## Power BI Dashboard KPIs

| KPI                      | Description                      | Chart Type     | Sample DAX Formula                                          |
|--------------------------|--------------------------------|----------------|-------------------------------------------------------------|
| Throughput               | Total produced units           | Line/Column    | `Throughput = SUM(QuantityProduced)`                         |
| Defect Rate (%)          | Percentage defective units     | KPI Card      | `DefectRate = DIVIDE(SUM(QuantityDefective), SUM(QuantityProduced))`  |
| Downtime Minutes          | Total downtime reported        | Column         | `TotalDowntime = SUM(DowntimeMinutes)`                       |
| Overtime Ratio           | Overtime hours vs regular hours | Column/KPI    | `OvertimeRatio = DIVIDE(SUM(OvertimeHours), SUM(RegularHours))`        |
| Average Production Cost  | Average total production cost  | Gauge          | `AvgProdCost = AVERAGE(TotalProductionCost)`                 |
| Supply-Demand Gap         | Difference between supply & demand | Line/Bar   | `SupplyDemandGap = SUM(SupplyQty) - SUM(DemandQty)`          |
| Sales by Location         | Units sold by geographical region | Map/Column | `SalesGeo = SUM(SaleUnits)`                                  |

---

## Getting Started

1. Run `manufacturing_dataset.sql` in SQL Server Management Studio.
2. Open Power BI Desktop and load the `CombinedManufacturingDataset` table from your SQL Server.
3. Clean data as needed using Power Query (e.g., convert units, trim text, handle duplicates).
4. Build reports using recommended KPIs and visualizations above.
5. Publish or share as desired.

---

## License  
MIT License — Free to use for educational, demonstration, and training purposes.

---

*Last Updated: [Insert Date]*
