# Netflix Case Study: Subscriber Churn & Price Impact Analysis

## Project Overview
This project explores the relationship between price adjustments, content consumption, and subscriber retention. Utilizing the **netflix_users.csv** dataset, I built an end-to-end analytics pipeline to predict churn risk and model revenue stability following a price hike.

## Technical Stack
*   **Data Cleaning & Schema:** SQL (PostgreSQL)
*   **Predictive Modeling & Statistical Analysis:** SQL & Excel
*   **Data Visualization:** Tableau (Dark Mode Theme)
*   **Version Control:** GitHub

---

## 1. The ETL Pipeline & Predictive Modeling
The core of this project was transforming raw subscriber logs into a predictive schema that could identify users at high risk of canceling their service.

### Data Engineering (SQL)
*   **Schema Transformation:** Processed `netflix_users.csv` into a structured database, calculating rolling averages for "Content Hours Watched."
*   **Feature Engineering:** Created flags for "Churn Risk" based on historical engagement drops and subscription plan tiers.
*   **Data Integrity:** Implemented constraints to handle inconsistent age-group labeling and ensured timestamps were normalized for accurate month-over-month trend analysis.

### Statistical Forecasting
*   **Revenue Prediction:** Developed a predictive revenue model using 95% confidence intervals to forecast fiscal stability post-price hike.
*   **Churn Risk Scoring:** Utilized historical demographics to create a risk heat map, identifying which age groups were most sensitive to price changes across different plan types.

---

## 2. Dashboard Breakdown: Strategic Insights
The dashboard provides a high-level view of how price increases impact different segments of the Netflix user base.

### A. User Retention & Engagement
*   **Engagement Stability:** Despite price changes, the "Avg. Content Hours Watched" remained relatively stable, fluctuating between ~486 and ~511 hours per month.
*   **Consumption by Plan:** The **Standard Plan** significantly outperformed Basic and Premium in total content consumption, totaling over 8,000,000 hours watched.

### B. Churn Risk & Revenue Modeling
*   **Demographic Sensitivity:** The **Churn Risk Analysis** heat map reveals high risk (80%–100%) among specific segments, particularly the "Under 18" group across all plans and the "45-54" group on the Standard plan.
*   **Revenue Resilience:** The predictive model shows a sharp initial recovery in revenue after an early dip, stabilizing around the $47K–$49K range per period with a tight 95% confidence interval.

---

## 3. Business Impact & Recommendations
*   **Targeted Retention:** Implement "Stay Offers" or content recommendations specifically for the 45–54 age demographic on Standard plans, as they show the highest price sensitivity.
*   **Plan Optimization:** Investigate why the **Premium Plan** has lower total watch hours than the Standard plan despite the higher price point; this may suggest a need to re-bundle features or content.
*   **Revenue Confidence:** Based on the 95% confidence intervals, the business can proceed with price adjustments with a high degree of certainty regarding long-term revenue floors.

---

