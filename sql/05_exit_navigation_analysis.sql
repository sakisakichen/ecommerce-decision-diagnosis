-- Ecommerce Decision Diagnosis — Case #1
-- Analysis 05: Exit & Navigation Analysis | Finding #4

-- A. Exit page distribution among all No-PDP sessions.
WITH session_behavior AS (
  SELECT session_id,
         MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
),
last_page AS (
  SELECT session_id, page_type AS exit_page_type, page_path AS exit_page_path,
         ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY page_sequence DESC) AS rn
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
)
SELECT
  l.exit_page_type,
  COUNT(*) AS exit_sessions,
  ROUND(SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()) * 100, 1) AS pct_of_no_pdp_sessions
FROM last_page l
JOIN session_behavior s ON l.session_id = s.session_id
WHERE s.reached_pdp = 0 AND l.rn = 1
GROUP BY l.exit_page_type
ORDER BY exit_sessions DESC;

-- B. Top navigation paths among No-PDP sessions.
WITH session_behavior AS (
  SELECT session_id,
         MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
),
session_paths AS (
  SELECT p.session_id,
         STRING_AGG(p.page_type, ' → ' ORDER BY p.page_sequence) AS navigation_path
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews` p
  JOIN session_behavior s ON p.session_id = s.session_id
  WHERE s.reached_pdp = 0
  GROUP BY p.session_id
)
SELECT
  navigation_path,
  COUNT(*) AS sessions,
  ROUND(SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()) * 100, 1) AS pct_of_no_pdp_sessions
FROM session_paths
GROUP BY navigation_path
ORDER BY sessions DESC
LIMIT 15;

-- C. Collection-level exit validation.
WITH session_behavior AS (
  SELECT
    session_id,
    MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp,
    MAX(CASE WHEN page_type = 'collection' THEN 1 ELSE 0 END) AS visited_collection
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
),
last_page AS (
  SELECT session_id, page_type AS exit_page_type,
         ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY page_sequence DESC) AS rn
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
)
SELECT
  l.exit_page_type,
  COUNT(*) AS sessions,
  ROUND(SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()) * 100, 1) AS pct_of_collection_no_pdp_sessions
FROM last_page l
JOIN session_behavior s ON l.session_id = s.session_id
WHERE s.reached_pdp = 0
  AND s.visited_collection = 1
  AND l.rn = 1
GROUP BY l.exit_page_type
ORDER BY sessions DESC;

-- Results: 553 No-PDP sessions visited Collection; 329 ended there = 59.5%.
-- This localizes the next measurement priority but does not establish causal UX/merchandising factors.
