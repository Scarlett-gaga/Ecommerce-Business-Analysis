-- After bidding our gsearch nonbrand desktop campaigns , we want to see weekly trends for website sessions on both desktop and mobile 

SELECT 
	-- YEAR(created_at),
    -- WEEK(created_at),
    MIN(DATE(created_at)),
    COUNT(CASE WHEN device_type='desktop' THEN website_session_id END) AS dtop_session,
    COUNT(CASE WHEN device_type='mobile' THEN website_session_id END) AS mob_session
FROM website_sessions
WHERE 
	utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand' AND 
	created_at > '2012-04-15' AND
    created_at < '2012-06-09'
GROUP BY YEAR(created_at),WEEK(created_at)

