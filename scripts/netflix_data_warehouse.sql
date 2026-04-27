-- 1. Date Dimension
CREATE TABLE dim_date (
    date_key         INTEGER PRIMARY KEY,
    full_date        DATE NOT NULL,
    day_of_week      VARCHAR(15),
    month_name       VARCHAR(15),
    quarter          INTEGER,
    year             INTEGER,
    is_weekend       BOOLEAN,
    is_holiday       BOOLEAN DEFAULT FALSE,
    is_post_netflix_price_hike BOOLEAN,
    is_post_netflix_price_hike_2022 BOOLEAN,
    is_post_netflix_price_hike_2023 BOOLEAN,
    days_since_last_price_change    INTEGER DEFAULT 0
);

-- 2. User Dimension
CREATE TABLE dim_user (
    user_key            INTEGER PRIMARY KEY,
    user_id_natural      VARCHAR(50),
    signup_date          DATE,
    age_group            VARCHAR(10),
    gender               VARCHAR(20),
    household_size       INTEGER,
    acquisition_channel  VARCHAR(50),
    is_price_sensitive   BOOLEAN,
    is_heavy_viewer      BOOLEAN,
    tenure_bucket        VARCHAR(20)
);

-- 3. Plan Dimension
CREATE TABLE dim_plan (
    plan_key            INTEGER PRIMARY KEY,
    plan_name            VARCHAR(20),
    plan_tier            VARCHAR(15),
    monthly_price_usd    DECIMAL(5,2),
    max_screens          INTEGER,
    hd_available         BOOLEAN,
    uhd_available        BOOLEAN,
    ads_supported        BOOLEAN,
    is_post_price_increase BOOLEAN DEFAULT FALSE,
    price_change_date    DATE,
    previous_price_usd   DECIMAL(5,2),
    percent_change       DECIMAL(5,2)
);

-- 4. Region Dimension
CREATE TABLE dim_region (
    region_key          INTEGER PRIMARY KEY,
    country             VARCHAR(50),
    macro_region        VARCHAR(50),
    currency_code       CHAR(3),
    market_maturity     VARCHAR(20),
    competitor_density  VARCHAR(20)
);

-- 5. Price Event Dimension (The "Bridge" for your research question)
CREATE TABLE dim_price_event (
    price_event_key      INTEGER PRIMARY KEY,
    event_name           VARCHAR(100),
    event_date           DATE,
    plan_affected        VARCHAR(20),
    old_price_usd        DECIMAL(5,2),
    new_price_usd        DECIMAL(5,2),
    percent_change       DECIMAL(5,2),
    region_affected      VARCHAR(20),
    announcement_date    DATE,
    effective_date       DATE,
    is_major_hike        BOOLEAN
);

-- 6. Fact Table: Subscription Performance
CREATE TABLE fact_subscription_performance (
    subscription_event_id   SERIAL PRIMARY KEY,
    date_key                INTEGER REFERENCES dim_date(date_key),
    user_key                INTEGER REFERENCES dim_user(user_key),
    plan_key                INTEGER REFERENCES dim_plan(plan_key),
    region_key              INTEGER REFERENCES dim_region(region_key),
    price_event_key         INTEGER REFERENCES dim_price_event(price_event_key),
    is_active_subscription  BOOLEAN,
    monthly_fee_usd         DECIMAL(5,2),
    days_since_price_change INTEGER,
    is_post_price_increase  BOOLEAN,
    tenure_days             INTEGER,
    content_hours_watched   DECIMAL(10,2)
);

-- 7. Staging Table 
CREATE TABLE staging_netflix (
    User_ID INT,
    Name VARCHAR(100),
    Age INT,
    Country VARCHAR(50),
    Subscription_Type VARCHAR(20),
    Watch_Time_Hours DECIMAL(10,2),
    Favorite_Genre VARCHAR(50),
    Last_Login DATE
);
-- ==========================================
-- STEP 1: Populate dim_date
-- ==========================================
INSERT INTO dim_date (
    date_key, full_date, day_of_week, month_name, quarter, year, 
    is_weekend, is_holiday, is_post_netflix_price_hike, 
    is_post_netflix_price_hike_2022, is_post_netflix_price_hike_2023, 
    days_since_last_price_change
)
SELECT DISTINCT
    EXTRACT(YEAR FROM Last_Login) * 10000 + EXTRACT(MONTH FROM Last_Login) * 100 + EXTRACT(DAY FROM Last_Login) AS date_key,
    Last_Login AS full_date,
    TRIM(TO_CHAR(Last_Login, 'Day')) AS day_of_week,
    TRIM(TO_CHAR(Last_Login, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM Last_Login)::INT AS quarter,
    EXTRACT(YEAR FROM Last_Login)::INT AS year,
    (EXTRACT(DOW FROM Last_Login) IN (0,6)) AS is_weekend,
    FALSE AS is_holiday,
    (Last_Login >= '2022-01-01')::BOOLEAN AS is_post_netflix_price_hike,
    (Last_Login >= '2022-01-01')::BOOLEAN AS is_post_netflix_price_hike_2022,
    (Last_Login >= '2023-01-01')::BOOLEAN AS is_post_netflix_price_hike_2023,
    GREATEST(0, (Last_Login - '2022-01-01'::DATE))::INTEGER AS days_since_last_price_change
FROM staging_netflix;

-- ==========================================
-- STEP 2: Populate dim_user
-- ==========================================
INSERT INTO dim_user (
    user_key, user_id_natural, signup_date, age_group, gender, 
    household_size, acquisition_channel, is_price_sensitive, 
    is_heavy_viewer, tenure_bucket
)
SELECT
    ROW_NUMBER() OVER (ORDER BY User_ID) AS user_key,
    User_ID::VARCHAR,
    Last_Login - INTERVAL '2 years',
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age < 25 THEN '18-24'
        WHEN Age < 35 THEN '25-34'
        WHEN Age < 45 THEN '35-44'
        WHEN Age < 55 THEN '45-54'
        ELSE '55+'
    END,
    'Unknown', -- CSV lacks gender data
    2,          -- Default household size
    'Direct',   -- Default acquisition channel
    (Watch_Time_Hours < 100)::BOOLEAN,  -- Price sensitive if low engagement
    (Watch_Time_Hours > 500)::BOOLEAN,  -- Heavy viewer if >500 hrs
    CASE 
        WHEN Age > 50 THEN 'Long-term'
        WHEN Age > 30 THEN 'Mid-term'
        ELSE 'New'
    END
FROM staging_netflix;

-- ==========================================
-- STEP 3: Populate dim_plan
-- ==========================================
INSERT INTO dim_plan (
    plan_key, plan_name, plan_tier, monthly_price_usd, max_screens, 
    hd_available, uhd_available, ads_supported, is_post_price_increase, 
    price_change_date, previous_price_usd, percent_change
)
SELECT
    ROW_NUMBER() OVER (ORDER BY Subscription_Type) AS plan_key,
    Subscription_Type,
    CASE Subscription_Type WHEN 'Basic' THEN 'Entry' WHEN 'Standard' THEN 'Mid' ELSE 'Premium' END,
    CASE Subscription_Type WHEN 'Basic' THEN 9.99 WHEN 'Standard' THEN 15.49 ELSE 19.99 END,
    CASE Subscription_Type WHEN 'Basic' THEN 1 WHEN 'Standard' THEN 2 ELSE 4 END,
    TRUE, FALSE, FALSE, FALSE, NULL, NULL, NULL
FROM (SELECT DISTINCT Subscription_Type FROM staging_netflix) t;

-- ==========================================
-- STEP 4: Populate dim_region
-- ==========================================
INSERT INTO dim_region (
    region_key, country, macro_region, currency_code, 
    market_maturity, competitor_density
)
SELECT
    ROW_NUMBER() OVER (ORDER BY Country) AS region_key,
    Country,
    CASE Country
        WHEN 'USA' THEN 'North America' WHEN 'Canada' THEN 'North America' WHEN 'Mexico' THEN 'North America'
        WHEN 'UK' THEN 'EMEA' WHEN 'Germany' THEN 'EMEA' WHEN 'France' THEN 'EMEA'
        WHEN 'Japan' THEN 'APAC' WHEN 'Brazil' THEN 'LATAM' WHEN 'India' THEN 'APAC'
        ELSE 'Other'
    END,
    CASE Country
        WHEN 'USA' THEN 'USD' WHEN 'Canada' THEN 'CAD' WHEN 'UK' THEN 'GBP'
        WHEN 'Germany' THEN 'EUR' WHEN 'France' THEN 'EUR' WHEN 'Brazil' THEN 'BRL'
        WHEN 'Japan' THEN 'JPY' WHEN 'India' THEN 'INR' ELSE 'USD'
    END,
    CASE WHEN Country IN ('USA','UK','Germany','France','Canada','Japan') THEN 'Mature' ELSE 'Growth' END,
    CASE WHEN Country IN ('USA','UK','Germany','Japan') THEN 'High' ELSE 'Medium' END
FROM (SELECT DISTINCT Country FROM staging_netflix) t;

-- ==========================================
-- STEP 5: Populate dim_price_event (Optional Context)
-- ==========================================
INSERT INTO dim_price_event (
    price_event_key, event_name, event_date, plan_affected, 
    old_price_usd, new_price_usd, percent_change, region_affected, 
    announcement_date, effective_date, is_major_hike
) VALUES 
(1, 'Jan 2022 US Price Hike', '2022-01-01', 'Basic', 8.99, 9.99, 11.1, 'USA', '2021-12-15', '2022-01-01', TRUE),
(2, 'Jan 2022 US Price Hike', '2022-01-01', 'Standard', 13.99, 15.49, 10.7, 'USA', '2021-12-15', '2022-01-01', TRUE),
(3, 'Jan 2023 Global Adjustment', '2023-01-01', 'Standard', 15.49, 16.99, 9.7, 'Global', '2022-12-15', '2023-01-01', TRUE);


-- Populate fact_subscription_performance
INSERT INTO fact_subscription_performance (
    date_key, user_key, plan_key, region_key, price_event_key,
    is_active_subscription, monthly_fee_usd, days_since_price_change,
    is_post_price_increase, tenure_days, content_hours_watched
)
SELECT
    d.date_key,
    u.user_key,
    p.plan_key,
    r.region_key,
    pe.price_event_key, -- Now links to your price events
    TRUE,
    p.monthly_price_usd,
    GREATEST(0, (s.Last_Login - '2022-01-01'::DATE))::INTEGER,
    (s.Last_Login >= '2022-01-01')::BOOLEAN,
    730, 
    s.Watch_Time_Hours
FROM staging_netflix s
JOIN dim_date d ON s.Last_Login = d.full_date
JOIN dim_user u ON s.User_ID::VARCHAR = u.user_id_natural
JOIN dim_plan p ON s.Subscription_Type = p.plan_name -- FIXED: changed p.p to p.plan_name
JOIN dim_region r ON s.Country = r.country
LEFT JOIN dim_price_event pe ON s.Subscription_Type = pe.plan_affected 
    AND s.Last_Login >= pe.event_date; -- Bonus: Links the hike to the record

-- Verfication for ETL process. Data loading 
SELECT 
    f.subscription_event_id, 
    u.user_id_natural AS user_id, 
    p.plan_name, 
    r.country, 
    d.full_date,
    f.monthly_fee_usd,
    pe.event_name AS linked_price_hike 
FROM fact_subscription_performance f
JOIN dim_user u ON f.user_key = u.user_key
JOIN dim_plan p ON f.plan_key = p.plan_key
JOIN dim_region r ON f.region_key = r.region_key
JOIN dim_date d ON f.date_key = d.date_key
LEFT JOIN dim_price_event pe ON f.price_event_key = pe.price_event_key

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
