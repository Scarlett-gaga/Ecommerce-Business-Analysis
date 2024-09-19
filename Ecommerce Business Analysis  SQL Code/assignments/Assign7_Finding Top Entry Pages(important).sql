-- we want a list of the top entry page and rank them on entry volume

-- step 1: find the first pageview for each session
-- step 2: find the url that customer saw on that first page_view

DROP TEMPORARY TABLE landing;
CREATE TEMPORARY TABLE landing
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS first_pageview
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY 1;

SELECT 
	wp.pageview_url AS landing_page,
    COUNT(l.website_session_id) AS sessions_hitting_this_landing_page
FROM landing l
LEFT JOIN website_pageviews wp
	ON l.first_pageview = wp.website_pageview_id
GROUP BY 1


