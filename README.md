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
Engagement Stability (The "Value" Check)
Key Finding: Despite the price increase, the Average Content Hours Watched remained consistently high, hovering around 500 hours per user.

Analysis: This indicates that the perceived value of the content library successfully offset the cost increase for the majority of the active user base. The stable trend line suggests that "High-Engagement" users are inelastic—meaning they are unlikely to cancel because the service is deeply integrated into their daily habits.

2. Market Share & Volume (The "Exposure" Check)
Key Finding: The Standard Plan accounts for over 8.2 million hours of consumption, nearly double that of the Basic and Premium tiers.

Analysis: This plan is the "backbone" of your revenue. Any churn detected in this specific group is a high-priority threat because it represents the largest volume of platform activity. From a business perspective, the Standard tier is where retention efforts will have the highest ROI.

3. Future Revenue Outlook (The "Risk" Check)
Key Finding: While the revenue forecast predicts a plateau at $47,816, the 95% Confidence Interval shows a significant "downside risk" shaded area.

Analysis: The model suggests that while the initial price hike boosted revenue, we are entering a phase of uncertainty. If the churn trends identified in our segments are not addressed, the business could see a revenue dip toward the lower bound of that shaded interval by late 2025.

4. Segmented Churn Risk (The "Data Mining" Insight)
Key Finding: Churn risk is not uniform. The Under 18 demographic shows a 100% risk intensity across all plan types, and Premium users aged 35–44 show high sensitivity.

Analysis: This is the most critical finding for your research question. It proves that:

Younger users are highly price-sensitive and are the most likely to cancel or "account hop."

Premium users (35–44) may feel the "price-to-value" ratio is thinning, as they exhibit higher churn than their peers on cheaper plans.

The "Big Picture" Presentation Conclusion
Our research confirms that while Netflix maintains high overall engagement, the price increase has created pockets of vulnerability. Specifically, the Standard plan's massive volume is safe for now, but the high churn risk among younger demographics and mid-life Premium users threatens our long-term revenue stability. To mitigate future cancellations, I propose targeted retention strategies for these high-intensity risk segments





💡 Strategic Recommendations
Targeted Retention: Launch re-engagement campaigns specifically for the 45–54 segment using personalized content recommendations.

Loyalty Rewards: Implement early-access features for the 35–44 segment to protect this high-value core.

Predictive Monitoring: Use monthly engagement hours as a Leading Indicator—flagging users whose watch time drops 20% below their historical average for proactive outreach.
