# Netflix Price Impact Analysis  
Subscriber Churn, Retention & Revenue Modeling

---

## Project Overview

This project analyzes how Netflix price increases impact user retention, churn risk, engagement, and revenue.

live dashboard(https://public.tableau.com/app/profile/tyrese.dieudonne/viz/NetflixPriceImpactSubscriberChurnRententionAnalysis/Dashboard2)

The goal is to simulate a real-world data analyst workflow by:
- Transforming raw user-level data into a structured data warehouse
- Designing a star schema for scalable analytics
- Building an ETL pipeline to clean and enrich the data
- Creating a dashboard that communicates business insights
- Translating findings into actionable recommendations

Key Business Question:
Do price increases negatively impact retention, or does engagement offset churn risk?

---

## Raw Dataset Overview

The original dataset (`netflix_users.csv`) contains user-level activity data with the following fields:

- User_ID
- Name
- Age
- Country
- Subscription_Type
- Watch_Time_Hours
- Favorite_Genre
- Last_Login

### Initial Data Limitations

Before transformation, the dataset had several limitations:

1. No time dimension (no month/quarter analysis possible)
2. No pricing history or price change tracking
3. No user segmentation (all users treated equally)
4. No relational structure (flat table)
5. Missing business context (no churn signals, no behavioral flags)

This required building a full ETL pipeline and data model from scratch.

---

## Data Architecture: Star Schema Design

To enable scalable analytics, the dataset was transformed into a **star schema**.

### Why Star Schema?

- Separates facts (metrics) from dimensions (context)
- Improves query performance
- Enables flexible slicing (by time, region, plan, etc.)
- Mirrors real-world data warehouse design

---

### Fact Table

fact_subscription_performance

This is the central table containing measurable business metrics.

Grain:
One row per user activity per date

Key Metrics:
- content_hours_watched
- monthly_fee_usd
- tenure_days
- is_active_subscription
- is_post_price_increase

---

### Dimension Tables

dim_date
- Created from Last_Login
- Enables time-based analysis
- Includes:
  - day_of_week, month_name, quarter, year
  - is_weekend
  - price hike indicators
  - days_since_last_price_change

dim_user
- Transforms raw users into segments
- Includes:
  - age_group (derived from Age)
  - price sensitivity flag
  - heavy viewer flag
  - tenure bucket

dim_plan
- Normalizes subscription types
- Adds pricing and feature context
- Includes:
  - plan tier
  - monthly price
  - screens and feature availability

dim_region
- Adds geographic business context
- Includes:
  - macro region
  - market maturity
  - competitor density

dim_price_event
- Captures pricing strategy decisions
- Includes:
  - event dates
  - percent change
  - affected plans

---

## ETL Pipeline (End-to-End)

The ETL pipeline transforms raw CSV data into analytics-ready tables.

---

### Step 1: Data Ingestion (Extract)

The raw CSV file is loaded into a staging table:

staging_netflix

Purpose:
- Preserve raw data
- Avoid direct transformation on source
- Enable repeatable pipeline

---

### Step 2: Data Cleaning

Several data quality issues were addressed:

1. Standardizing text fields
- Trimmed whitespace from country and date strings

2. Handling missing attributes
- Gender not available → set as 'Unknown'
- Household size not available → defaulted to 2

3. Removing ambiguity
- Ensured consistent subscription naming (Basic, Standard, Premium)

---

### Step 3: Feature Engineering

This is the most critical part of the pipeline.

#### Time Features
Derived from Last_Login:
- Year, Month, Quarter
- Day of week
- Weekend indicator

Also created:
- days_since_last_price_change
- post-price-increase flags (2022 and 2023)

---

#### User Segmentation

Converted raw engagement into behavioral signals:

Price Sensitivity:
    Watch_Time_Hours < 100 → TRUE

Heavy Viewer:
    Watch_Time_Hours > 500 → TRUE

Tenure Buckets:
- New
- Mid-term
- Long-term

---

#### Age Bucketing

    CASE 
      WHEN Age < 18 THEN 'Under 18'
      WHEN Age < 25 THEN '18-24'
      WHEN Age < 35 THEN '25-34'
      WHEN Age < 45 THEN '35-44'
      WHEN Age < 55 THEN '45-54'
      ELSE '55+'
    END

Purpose:
- Enables churn segmentation by demographic group

---

#### Plan Normalization

Mapped subscription types into structured tiers:
- Basic → Entry
- Standard → Mid
- Premium → High-tier

Added pricing attributes for revenue modeling.

---

#### Price Event Integration

Linked user activity to pricing decisions:

    LEFT JOIN dim_price_event
    ON Subscription_Type = plan_affected
    AND Last_Login >= event_date

Purpose:
- Connects business actions (price hikes) to user behavior

---

### Step 4: Load (Fact Table Creation)

All transformed data is joined into:

fact_subscription_performance

This becomes the single source of truth for analysis.

---

## Dashboard Walkthrough (Business Story)

---

### 1. User Retention & Engagement Trend

Metric:
Average content hours watched over time

Observation:
Engagement remains stable (~495–511 hours)

Business Insight:
Users continue consuming content despite price increases, indicating strong product stickiness.

---

### 2. Content Consumption by Plan

Observation:
- Standard plan dominates (~8M hours)
- Basic and Premium significantly lower

Business Insight:
The Standard plan provides the best balance of price and value and drives the majority of engagement.

---

### 3. Revenue Forecasting

Observation:
Revenue stabilizes between ~47K and 50K with minimal volatility

Business Insight:
Price increases do not significantly impact overall revenue trends, indicating a resilient pricing model.

---

### 4. Churn Risk Analysis

Observation:
- Ages 18–24 → highest churn risk
- Ages 35–44 → lowest churn risk
- Premium users → higher churn in some segments

Business Insight:
Younger users are more price-sensitive, and engagement alone does not prevent churn.

---

## Key Business Insights

1. Engagement does not guarantee retention  
Users may remain active but still churn.

2. Standard plan is the core business driver  
Highest engagement and strongest value perception.

3. Younger users are high-risk  
Most sensitive to pricing changes.

4. Revenue remains stable  
Strong brand and content ecosystem offset pricing pressure.

---

## Business Recommendations

1. Protect high-risk segments  
- Introduce student pricing or flexible plans

2. Strengthen Standard plan positioning  
- Market as best value offering

3. Implement targeted retention strategies  
- Focus on price-sensitive and low-engagement users

4. Use engagement as a leading churn indicator  
- Monitor drops in watch time

---

## Skills Demonstrated

- SQL data modeling (star schema design)
- ETL pipeline development
- Data cleaning and transformation
- Feature engineering
- Analytical thinking and segmentation
- Dashboard design (Power BI / Tableau)
- Business insight generation and storytelling

---

## Final Summary

This project demonstrates the full analytics lifecycle:

Raw Data → Data Cleaning → Data Modeling → Dashboard → Business Insights → Recommendations

It connects a real business decision (price increases) to measurable outcomes (engagement, churn, and revenue), and translates those insights into actionable strategy.
