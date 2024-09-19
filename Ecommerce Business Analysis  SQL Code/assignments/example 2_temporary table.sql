-- create temporary table to see what is the most fequent entry pages

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id  -- 因为website_pageview_id是按照从小到大顺序排的
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY 1;

-- the temporary table only exists in this current workbench
SELECT 
    wp.pageview_url AS landing_page, -- aka'entry page'
    COUNT(DISTINCT fp.website_session_id) AS sessions_hitting_this_lander
FROM first_pageview fp
LEFT JOIN website_pageviews wp
	ON fp.min_pv_id = wp.website_pageview_id
GROUP BY 1

