-- Ecommerce Decision Diagnosis — Case #1
-- Analysis 04: Behavioral Comparison | Finding #3

-- A. Bounce comparison. Synthetic-case definition: one-pageview session.
WITH session_behavior AS (
  SELECT
    session_id,
    MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp,
    COUNT(pageview_id) AS pageviews
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
),
session_with_bounce AS (
  SELECT session_id, reached_pdp, pageviews,
         CASE WHEN pageviews = 1 THEN 1 ELSE 0 END AS bounced
  FROM session_behavior
)
SELECT
  reached_pdp,
  COUNT(*) AS sessions,
  SUM(bounced) AS bounced_sessions,
  SAFE_DIVIDE(SUM(bounced), COUNT(*)) AS bounce_rate
FROM session_with_bounce
GROUP BY reached_pdp
ORDER BY reached_pdp;

-- B. Page-type browsing composition. Flags overlap across page types.
WITH session_behavior AS (
  SELECT
    session_id,
    MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp,
    MAX(CASE WHEN page_type = 'homepage' THEN 1 ELSE 0 END) AS visited_homepage,
    MAX(CASE WHEN page_type = 'collection' THEN 1 ELSE 0 END) AS visited_collection,
    MAX(CASE WHEN page_type = 'content' THEN 1 ELSE 0 END) AS visited_content
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
)
SELECT
  reached_pdp,
  COUNT(*) AS sessions,
  SUM(visited_homepage) AS homepage_sessions,
  SAFE_DIVIDE(SUM(visited_homepage), COUNT(*)) AS homepage_rate,
  SUM(visited_collection) AS collection_sessions,
  SAFE_DIVIDE(SUM(visited_collection), COUNT(*)) AS collection_rate,
  SUM(visited_content) AS content_sessions,
  SAFE_DIVIDE(SUM(visited_content), COUNT(*)) AS content_rate
FROM session_behavior
GROUP BY reached_pdp
ORDER BY reached_pdp;

-- Results: bounce 43% No-PDP vs 42% Reached-PDP.
-- No-PDP browsing: Homepage 80.6%, Collection 61.4%, Content 39.4%.
-- Note: exact original SQL for pages/session (2.58 vs 2.67) and duration (96s vs 117s)
-- was not recovered, so it is intentionally not reconstructed here as original evidence.
