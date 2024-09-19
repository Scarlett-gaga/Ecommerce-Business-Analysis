-- we want to pull gsearch nonbrand trended session volume bu week to see if the bid changes have caused volume to drop at all

SELECT 
	-- YEAR(created_at) AS year,
    -- WEEK(created_at) AS week,
    MIN(DATE(created_at)) AS week_started_at,   -- it returns the first date in a week
	COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE 
	created_at < '2012-05-10' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'	
GROUP BY                 -- YEAR和WEEK的分组每一行表示某年中的某一周的所有会话
	YEAR(created_at),
    WEEK(created_at)