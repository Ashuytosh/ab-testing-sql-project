USE ab_testing_project;
select * from ab_campaign_data;

-- 🔁 Common Table Expression to prepare aggregated data
WITH campaign_metrics AS (
    SELECT 
        group_type,
        COUNT(DISTINCT campaign_name) AS total_campaigns,
        COUNT(*) AS total_days,
        SUM(spend_usd) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(reach) AS total_reach,
        SUM(website_clicks) AS total_clicks,
        SUM(searches) AS total_searches,
        SUM(view_content) AS total_views,
        SUM(add_to_cart) AS total_carts,
        SUM(purchase) AS total_purchases,
        SUM(purchase) / NULLIF(SUM(website_clicks), 0) AS purchase_per_click,
        SUM(add_to_cart) / NULLIF(SUM(view_content), 0) AS cart_per_view
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 1: Conversion Rate
conversion_rate AS (
    SELECT 
        group_type,
        ROUND(100 * SUM(purchase) / NULLIF(SUM(website_clicks), 0), 2) AS conversion_rate_pct
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 2: Click-Through Rate (CTR)
ctr AS (
    SELECT 
        group_type,
        ROUND(100 * SUM(website_clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 3: Return on Ad Spend (ROAS)
roas AS (
    SELECT 
        group_type,
        ROUND(SUM(purchase) / NULLIF(SUM(spend_usd), 0), 2) AS roas
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 4: Cost per Purchase (CPP)
cpp AS (
    SELECT 
        group_type,
        ROUND(SUM(spend_usd) / NULLIF(SUM(purchase), 0), 2) AS cost_per_purchase
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 5: Engagement Rate
engagement AS (
    SELECT 
        group_type,
        ROUND(100 * (
            SUM(view_content) + SUM(add_to_cart) + SUM(purchase)
        ) / NULLIF(SUM(impressions), 0), 2) AS engagement_rate_pct
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 6: Daily Average Spend
daily_spend AS (
    SELECT 
        group_type,
        ROUND(SUM(spend_usd) / COUNT(DISTINCT campaign_date), 2) AS avg_daily_spend
    FROM ab_campaign_data
    GROUP BY group_type
),

-- 📊 Metric 7: Ranking Campaigns by Performance (based on purchases)
campaign_rank AS (
    SELECT 
        campaign_name,
        group_type,
        SUM(purchase) AS total_purchases,
        RANK() OVER (PARTITION BY group_type ORDER BY SUM(purchase) DESC) AS purchase_rank
    FROM ab_campaign_data
    GROUP BY campaign_name, group_type
)

-- ✅ Final Output: Combine All Metrics
SELECT 
    cm.group_type,
    cm.total_campaigns,
    cm.total_days,
    cm.total_spend,
    cm.total_impressions,
    cm.total_clicks,
    cm.total_purchases,
    conv.conversion_rate_pct,
    ctr.ctr_pct,
    roas.roas,
    cpp.cost_per_purchase,
    engagement.engagement_rate_pct,
    daily_spend.avg_daily_spend
FROM campaign_metrics cm
JOIN conversion_rate conv ON cm.group_type = conv.group_type
JOIN ctr ON cm.group_type = ctr.group_type
JOIN roas ON cm.group_type = roas.group_type
JOIN cpp ON cm.group_type = cpp.group_type
JOIN engagement ON cm.group_type = engagement.group_type
JOIN daily_spend ON cm.group_type = daily_spend.group_type;

