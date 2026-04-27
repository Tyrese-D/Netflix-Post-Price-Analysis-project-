# Netflix-Post-Price-Analysis-project-
 
Many of Netflix's users have been upset about the price increase for their subscriptions. This summary will explore whether customers cancelled their plan after the price went up, which group of customers was most affected, and whether further cancellations are expected in the future.  The analysis in this report is intended to support business decisions around customer retention, pricing strategy, and subscriber engagement. The key question that needs to be answered is how the Netflix subscription price increase impacts subscriber retention and engagement through different customer groups, and whether customers will cancel their plans in the future due to an increase


The data used in the analysis comprises 25,000 records of Netflix customers from 2024 to 2025. Each record represents one customer and includes information such as their age and country, which subscription plan they have, how many hours of content they watched, and login activity. 

To analyze Netflix data effectively, it was organized into a structured database that allowed for fast, accurate querying and reporting. The raw data was cleaned and sorted into logical categories such as customer profiles, subscription plans, geographic regions, dates, and price change events. Once the data was organized, we presented a dashboard to visualize what was dealt with the data and report the findings and solutions. 


Data Architecture & Warehouse Design
I designed a scalable Star Schema to ensure data integrity and query performance.

The Grain: One record per subscriber per billing cycle.

Schema Design:

Fact Table: Fact_Engagement (Revenue, Hours Watched, Churn Status).

Dimension Tables: Dim_User (Age, Region), Dim_Plan (Tier, Price), Dim_Date.

Relationships: Enforced referential integrity using Primary and Foreign Keys to connect dimensions to the central fact table.

🛠️ ETL Pipeline (Extract, Transform, Load)
Extraction: Processed raw datasets containing subscription logs and user activity.

Transformation (SQL): * Used SQL for data cleaning, including handling NULL values and removing duplicate user IDs.

Performed data type casting and created calculated fields for "Average Content Hours."

Aggregated demographic segments to normalize skewed age data.

Validation: Conducted data auditing to ensure dashboard totals matched raw SQL aggregates with 100% accuracy.

Key finding 
1. Customers who stayed did not watch less. 
After the price increase, the average number of hours watched per month remained the same, around 500 hours. Despite customers being upset, the subscribers who decided to stay with Netflix did not reduce their usage. They continued watching at the same rate as before the price increase. This signifies a strong signal of loyalty among retained customers. 

2. The Younger and Middle-Aged Customers are the Most Loyal
Analyzing the engagement by age group reveals that customers between 35 and 44 years old watched the most content after the price increase, making them the most engaged and loyal segment. Customers between 45-54 showed the lowest engagement levels, which suggests they are at the greatest risk of canceling their plan. 

3. Revenue has stabilized- No Further Drop Expected 
Monthly revenue grew through mid 2024, reaching a peak at the end of 2024, before declining to $47,816 by early 2025  as some customers cancelled following the price increase.  Since then, the revenue has stabilized at that level. The forecast model projects revenue remaining

 The Netflix price increase did lead to some customer cancellations, visible in the revenue decline in early 2025. However, the customers who remained are highly engaged and show no signs of reducing their usage. Forecast modeling confirms that the platform has stabilized and has no significant additional subscriber loss expected in the near future with the price at the moment. 

