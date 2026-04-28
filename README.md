This project evaluates the impact of Netflix’s 2024 price increases on user behavior and financial stability. By analyzing a dataset of 25,000+ records. I transitioned from descriptive reporting to predictive analysis, identifying which demographic segments were most resilient and building a data warehouse architecture to support long-term business intelligence

Core Question: How did the Netflix subscription price increase impact subscriber retention and engagement across different customer groups — and will customers continue to cancel in the future?

`[Live Interactive Dashboard](https://public.tableau.com/app/profile/tyrese.dieudonne/viz/NetflixPriceImpactSubscriberChurnRententionAnalysis/Dashboard2)
<img width="1920" height="1080" alt="Screenshot 2026-04-27 at 9 36 14 PM" src="https://github.com/user-attachments/assets/111c4661-536e-4a95-b9fa-a3d69840e2e6" />



## 🗂️ Table of Contents

- [Data Architecture](#data-architecture--warehouse-design)
- [Excel Data Analysis](#excel-data-analysis)
- [SQL Analysis](#sql-analysis)
- [Dashboard & Findings](#dashboard--key-findings)
- [Recommendations](#recommendations-for-netflix)


## 📂 Dataset
The dataset used for this analysis is located in the [/data](data/) folder. 
* **Source:** Raw subscription logs containing 25,000+ records.
* **Fields:** User ID, Subscription Type, Monthly Revenue, Watch Time, and Churn Status.
  <img width="705" height="578" alt="Screenshot 2026-04-25 at 12 02 11 PM" src="https://github.com/user-attachments/assets/d3e25006-c99b-43e8-bbec-0291ef9b9e73" />


🏗️ Data Architecture & Warehouse Design
To analyze Netflix data effectively, the raw data was cleaned, structured, and organized into a Star Schema optimized for fast querying and accurate reporting.
Schema Design

Grain — One record per subscriber per billing cycle
Fact Table — Fact_Engagement (Revenue, Hours Watched, Churn Status)
Dimension Tables — Dim_User (Age, Region), Dim_Plan (Tier, Price), Dim_Date
Integrity — Primary and Foreign Keys enforce referential integrity across all tables

The star schema ensured that every query — whether filtering by age group, subscription tier, or time period — ran efficiently without redundant data across tables.

## 🧠 Data Mining & Predictive Modeling
To move beyond descriptive reporting, I implemented a **classification logic** to predict user churn.
* **Objective:** Predict the likelihood of a user canceling their subscription based on post-increase behavior.
* **Features Used:** * `Avg_Content_Hours`: Lower engagement is a primary indicator of churn.
  * `Plan_Type`: Analyzing if "Basic" users are more price-sensitive than "Premium" users.
  * `Age_Segment`: Identifying generational loyalty trends.
* **Methodology:** Utilized **Logistic Regression** to calculate churn probability scores, identifying a high-risk segment among users with <200 monthly hours.

  ### **The ETL Pipeline (Extract, Transform, Load)**
1. **Extraction:** Ingested raw subscription logs and engagement metrics via SQL.
2. **Transformation:**
   * **Data Cleaning:** Handled null values in demographic fields and removed duplicate entries.
   * **Calculated Fields:** Derived `Avg_Content_Hours` and `Revenue_per_User` using SQL aggregates.
   * **Bucketing:** Categorized raw ages into discrete segments (e.g., 18-24, 25-34) for clearer visualization.
3. **Loading:** Exported optimized datasets into Tableau for final visualization and trend analysis.

Key Visualizations & Insights
Standard Tier Dominance: While the "Standard" plan holds the highest total watch time (8M+ hours), the "Premium" tier showed the highest resilience to price hikes.

Demographic Stability: The 35-44 age segment remains the most engaged, maintaining >500 hours/month despite cost increases.

### 🗄️ Phase 2: SQL Transformation (ETL)
Using SQL, I moved the cleaned data into the warehouse and validated the business logic.
* **Extraction:** Ingested raw logs into a PostgreSQL environment.
* **Transformation:** * Casted data types for financial accuracy.
    * Aggregated demographic segments to normalize skewed age data.
* **Validation:** Cross-checked SQL aggregates against raw totals to confirm **100% data accuracy** prior to visualization.


📈 Key Findings & Business Insights
Engagement Resilience: Subscribers who stayed did not reduce their usage; Average Content Hours remained stable at ~500 hours/month, signaling high brand value.

Loyalty Leaders: The 35–44 age segment emerged as the most loyal and highly engaged group.

At-Risk Segment: The 45–54 age group showed the lowest engagement post-increase, representing the highest churn risk for future cycles.

Revenue Stability: After an initial post-increase dip, revenue stabilized at $47,816/month, with forecasting models projecting no further significant losses.

💡 Strategic Recommendations
Targeted Retention: Launch re-engagement campaigns specifically for the 45–54 segment using personalized content recommendations.

Loyalty Rewards: Implement early-access features for the 35–44 segment to protect this high-value core.

Predictive Monitoring: Use monthly engagement hours as a Leading Indicator—flagging users whose watch time drops 20% below their historical average for proactive outreach.
