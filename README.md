
#  International Soccer Results – Big Data Analysis Project  
### Databricks (Free Edition) | PySpark | Spark SQL | Lakeview Dashboards

---

##  1. Project Overview

This project analyzes **international football match results** using an end-to-end Big Data pipeline in **Databricks Free Edition** with **PySpark**, **Spark SQL**, and **Lakeview Dashboards**.

The goal is to extract insights such as:

- 📈 How goal scoring trends have changed over time  
- 🏆 Which national teams win the most  
- ⚖ The distribution of match outcomes (home win, away win, draw)  
- 🌍 Tournament-wise patterns (World Cup, Friendlies, Euro Cup, etc.)

The pipeline includes:

- Data ingestion  
- Cleaning & feature engineering  
- Exploratory analysis using PySpark + SQL  
- KPI-based dashboard creation  
- Global filters for interactive insights  

This project demonstrates the end-to-end Lakehouse workflow for your Big Data final assignment.

---

##  2. Dataset Description

**Source:** Public Kaggle dataset — International Football Results 1872–2023.

### Columns Used:
- `date` – Match date  
- `home_team` – Home nation  
- `away_team` – Away nation  
- `home_score` – Home team goals  
- `away_score` – Away team goals  
- `tournament` – Competition type  
- `country` – Host country  
- `city` – Match city  
- `neutral` – Whether match was held at a neutral venue  

---

##  3. Technologies Used

- Databricks Free Edition  
- PySpark  
- Spark SQL  
- Lakehouse architecture  
- Databricks Lakeview Dashboards  
- GitHub for documentation  

---

##  4. Data Pipeline

### **4.1 Ingestion**

Performed in `01_ingest_and_clean_football.ipynb`

Steps:
1. Uploaded the CSV file into Databricks.  
2. Created raw Delta table:

international_football_matches.default.raw_football

`

---

### **4.2 Cleaning & Feature Engineering**

Performed in the same notebook.

Key transformations:

#### ✔ Convert date column

df = df.withColumn("date", to_date(col("date")))
`

#### ✔ Derive year for trend analysis

df = df.withColumn("year", year(col("date")))


#### ✔ Convert scores to integers

df = df.withColumn("home_score", col("home_score").cast("int"))
df = df.withColumn("away_score", col("away_score").cast("int"))


#### ✔ Create outcome fields

* **goal_diff**
* **total_goals**
* **result** (Home Win / Away Win / Draw)
* **winner** (team name or “Draw”)

df = df.withColumn("goal_diff", col("home_score") - col("away_score"))
df = df.withColumn("total_goals", col("home_score") + col("away_score"))
df = df.withColumn(
    "result",
    when(col("home_score") > col("away_score"), "Home Win")
    .when(col("away_score") > col("home_score"), "Away Win")
    .otherwise("Draw")
)
df = df.withColumn(
    "winner",
    when(col("home_score") > col("away_score"), col("home_team"))
    .when(col("away_score") > col("home_score"), col("away_team"))
    .otherwise("Draw")
)


Cleaned table saved as:


international_football_matches.default.clean_football


All dashboard tiles and filters use **this same clean dataset**, ensuring global filtering works.

---

##  5. Exploratory Analysis

Performed in: `02_analysis_notebook.ipynb`

### **5.1 PySpark Examples**

####  Top teams by number of wins

df.filter(col("winner") != "Draw")
  .groupBy("winner")
  .count()
  .orderBy(col("count").desc())
  .show(10)


####  Average goals per match by year

df.groupBy("year")
  .agg(avg("total_goals").alias("avg_goals"))
  .orderBy("year")
  .show()


####  Distribution of match results

df.groupBy("result").count().show()


---

### **5.2 SQL Examples (saved in `sql_queries.sql`)**

#### 1️ Top teams by wins

sql
SELECT winner, COUNT(*) AS total_wins
FROM main.default.clean_football
WHERE winner <> 'Draw'
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 10;


#### 2️ Average goals per match by year

sql
SELECT year, AVG(total_goals) AS avg_goals
FROM main.default.clean_football
GROUP BY year
ORDER BY year;


#### 3️ Result distribution

sql
SELECT result, COUNT(*) AS matches
FROM main.default.clean_football
GROUP BY result;


---

##  6. Dashboard (Lakeview)

Dashboard Name: **International Soccer Dashboard**

All tiles use the **clean_football** table to allow **global filters**.

---

###  TILE 1 – Top 10 Teams by Wins (Bar Chart)

* Data source: `clean_football`
* Group by: `winner`
* Metric: `COUNT(*)`
* Filter: `winner != 'Draw'`
* Sort: Desc
* Title: **Top 10 Teams by Wins**
* Chart Type: Bar Chart

---

###  TILE 2 – Average Goals per Match by Year (Line Chart)

* Data source: `clean_football`
* Group by: `year`
* Metric: `AVG(total_goals)`
* Title: **Average Goals per Match by Year**
* Chart Type: Line Chart

---

###  TILE 3 – Match Result Distribution (Pie or Donut Chart)

* Data source: `clean_football`
* Group by: `result`
* Metric: `COUNT(*)`
* Title: **Match Result Distribution**
* Chart Type: Pie / Donut

---

## 7. Global Dashboard Filters

All filters use dataset:


international_football_matches.default.clean_football


and are applied to **all tiles**.

### 🟡 Filter 1 – Year

* Field: `year`
* Type: Dropdown
* Purpose: Filter results for the selected time range.

### 🟡 Filter 2 – Tournament

* Field: `tournament`
* Type: Dropdown
* Purpose: Compare competitions like World Cup, Friendly, Euro Cup.

### 🟡 Filter 3 – Host Country

* Field: `country`
* Type: Dropdown
* Purpose: Explore results based on match location.

---

##  8. How to Run the Project

1. Import all `.ipynb` notebooks into Databricks.
2. Attach to a running cluster.
3. Run notebook `01_ingest_and_clean_football.ipynb`
4. Run notebook `02_analysis_notebook.ipynb`
5. Create Lakeview dashboard:

   * Add 3 tiles
   * Add 3 global filters
6. Test dashboard interactivity.

---

##  9. Repository Structure


international-soccer-bigdata-final/
│
├── 01_ingest_and_clean_football.ipynb
├── 02_analysis_notebook.ipynb
├── 03_dashboard_notebook.ipynb
├── sql_queries.sql
└── README.md


---

##  10. Conclusion

This project demonstrates how to:

* Process real-world sports data at scale
* Build meaningful KPIs (wins, goals per match, result distribution)
* Use PySpark + SQL for analytical queries
* Create professional dashboards using Databricks Lakeview
* Apply global filters for rich interactive insights

The dashboard provides valuable insights into over a century of international football.
