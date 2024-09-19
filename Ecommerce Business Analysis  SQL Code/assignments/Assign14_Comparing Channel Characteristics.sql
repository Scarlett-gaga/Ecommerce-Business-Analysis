-- we want to figure out the percentage of traffic coming on mobile, comparing that to gsearch.

SELECT 
	utm_source,
    COUNT(website_session_id) AS sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN 1 ELSE NULL END) AS mobile_sessions,
    COUNT(CASE WHEN device_type = 'mobile' THEN 1 ELSE NULL END) / COUNT(website_session_id) AS pct_mobile
FROM website_sessions
WHERE utm_source IN ('gsearch','bsearch') AND created_at > '2012-08-22' AND created_at < '2012-11-30' AND utm_campaign = 'nonbrand'
GROUP BY 1