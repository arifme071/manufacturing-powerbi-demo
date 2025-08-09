# manufacturing-powerbi-demo

# Manufacturing Power BI Demo Dataset & Dashboard

## Overview
This repository provides a complete solution for generating a synthetic manufacturing dataset and building a Power BI dashboard with key KPIs.  
You get:

- SQL code that creates three main tables (`Products`, `ProductionTeams`, `ProductionTransactions`), inserts sample metadata, and bulk-generates 10,000 production records—with deliberate data quality issues (date formats, nulls, outliers, mixed units, typos).
- Columns include product size, production cost breakdown (raw, labor, overhead), supply/demand/sales data, and geographical location.
- Cleaning steps (date standardization).
- Creation of a combined dataset for direct import into Power BI.
- Dashboard instructions with KPI recommendations and DAX formulas.

## Usage Instructions

1. **Run `manufacturing_dataset.sql` in SQL Server Management Studio (SSMS).**
2. **Open Power BI Desktop → Get Data → SQL Server.**  
   Load the table `CombinedManufacturingDataset`.
3. **Design dashboard pages:**
    - Page 1: Output & Efficiency — Throughput, Downtime, OEE, Overtime Ratio, Material & Cost breakdown.
    - Page 2: Quality & Region — Defect Rate, Supply vs Demand, Sales by Region, Cost by Location.
4. **Recommended cleaning/transformations in Power Query:**
    - Standardize units (convert grams to kg)
    - Trim whitespace, fix text casing
    - Remove duplicate records (if needed)
5. **Create visuals for the provided KPIs with DAX calculations (see below).**
6. **Publish or share your Power BI report.**

---

## KPI Visuals & DAX Formulas

| KPI                      | Description                      | Chart   | DAX Formula Example                                       |
|--------------------------|----------------------------------|---------|-----------------------------------------------------------|
| Throughput               | Total units produced             | Line/Col| Throughput = SUM(QuantityProduced)                        |
| Defect Rate (%)          | % defects of total produced      | Card    | DefectRate = DIVIDE(SUM(QuantityDefective), SUM(QuantityProduced)) |
| Avg Total Production Cost| Mean of all production costs     | Gauge   | AvgCost = AVERAGE(TotalProductionCost)                    |
| Production Cost Breakdown| Raw, Labor, Overhead             | Bar/Stack| Use RawMaterialCost, LaborCost, OverheadCost columns      |
| Supply-Demand Gap        | Surplus or shortage              | Line/Bar| SupplyDemandGap = SUM(SupplyQty) - SUM(DemandQty)         |
| Sales by Location        | Sale units per region            | Map/Col | SalesGeo = SUM(SaleUnits)                                 |
| Overtime Ratio           | Overtime vs regular hours        | KPI/Col | OvertimeRatio = DIVIDE(SUM(OvertimeHours), SUM(RegularHours)) |
| Downtime                 | Total downtime minutes           | Col     | TotalDowntime = SUM(DowntimeMinutes)                      |

---

## License
MIT License — Free for academic, training, and demo use.
