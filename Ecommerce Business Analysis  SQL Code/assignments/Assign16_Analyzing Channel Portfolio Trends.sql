-- we want weekly session volume for gsearch and bsearch nonbrand, broken down by device.

SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN 1 ELSE NULL END) AS g_dtop_sessions,
    COUNT(CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN 1 ELSE NULL END) AS b_dtop_sessions,
    COUNT(CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN 1 ELSE NULL END)/COUNT(CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN 1 ELSE NULL END) AS b_pct_of_g_dtop,
    COUNT(CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN 1 ELSE NULL END) AS g_mob_sessions,
    COUNT(CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN 1 ELSE NULL END) AS b_mob_sessions,
    COUNT(CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN 1 ELSE NULL END)/COUNT(CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN 1 ELSE NULL END) AS b_pct_of_g_mob
FROM website_sessions
WHERE created_at > '2012-11-04' AND created_at < '2012-12-22' AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at)