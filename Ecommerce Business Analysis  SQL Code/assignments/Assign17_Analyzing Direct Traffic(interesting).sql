-- we want to see if we are building any momentum with out brand 
-- by showing the sessions of organic search, direct type in, paid brand search and paid nonbrand search as a % of paid search nonbrand. 

SELECT 
	YEAR(created_at) AS year, 
    MONTH(created_at) AS month,
	COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END) AS paid_nonbrand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN 1 ELSE NULL END) AS paid_brand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN 1 ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END) AS brand_pct_of_nonbrand,
    COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN 1 ELSE NULL END) AS direct_type_in,
    -- 没有付费跟踪参数，也没有在哪个网站上先搜索关键词或点击广告，说明是直接搜索官网
    COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN 1 ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END) AS direct_pct_of_nonbrand,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IN('https://www.gsearch.com','http://www.bsearch.com') THEN 1 ELSE NULL END) AS organic,
    -- 来自搜索引擎但是没有付费跟踪参数，所以是organic search
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IN('https://www.gsearch.com','http://www.bsearch.com') THEN 1 ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE NULL END) AS organic_pct_of_nonbrand
FROM website_sessions
WHERE created_at <'2012-12-23'
GROUP BY 1,2


-- 1. Paid nonbrand search 通常代表着你品牌广告投放的效果，尤其是针对那些还不熟悉品牌的新用户。这类广告通过通用关键词吸引没有品牌认知的潜在客户。
-- 2. Paid Nonbrand Search 通常是最昂贵的流量渠道
-- 相比之下，paid nonbrand search 由于涉及较广泛的非品牌关键词，竞争通常较为激烈，因此每次点击的成本可能会更高。这意味着：
-- 其他渠道的相对价值：你希望将这些通过昂贵的 nonbrand 广告吸引来的流量，逐渐转化为对品牌有认知的用户，并最终通过较低成本的渠道（如 organic search、direct type-in）回访。
-- 通过将organic search、paid brand search 和 direct type-in 的流量与 paid nonbrand search 比较，你可以评估其他渠道是否开始获得更多的“免费”或“忠实”流量，进而降低对付费非品牌广告的依赖。

-- 为什么选择用paid nonbrand作为算百分比的基准？？？
-- 使用 paid nonbrand search 作为基准可以帮助你回答以下问题：
-- 你是否通过非品牌广告吸引了足够多的新客户？
-- 这些新客户是否逐渐转化为品牌认知的客户？如果是，随着时间的推移，paid brand search、organic search 和 direct type-in 应该会增加，表明用户正在形成品牌偏好。
-- 通过这种方式，你可以评估品牌广告的长期效果，而不仅仅是依赖短期广告投放的直接效果。

-- Paid brand search 主要用于吸引那些已经知道品牌的用户，因此并不能很好地反映新用户的增长或品牌影响力的扩展。