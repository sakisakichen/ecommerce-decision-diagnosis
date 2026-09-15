-- Ecommerce Decision Diagnosis — Case #1
-- Analysis 03: PDP Progression | Grain: session | Finding #2
WITH session_behavior AS (
  SELECT
    session_id,
    MAX(CASE WHEN is_landing_page = TRUE THEN page_type END) AS landing_page_type,
    MAX(CASE WHEN page_type = 'product' THEN 1 ELSE 0 END) AS reached_pdp
  FROM `ecommerce-analytics-case01.ecommerce_case01.behavioral_pageviews`
  GROUP BY session_id
)
SELECT
  reached_pdp,
  COUNT(*) AS sessions,
  SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()) AS pct_of_sessions
FROM session_behavior
GROUP BY reached_pdp
ORDER BY reached_pdp DESC;

-- Results: 600 reached PDP (40%); 900 did not (60%).
-- Product View means entering a PDP; seeing a product card does not count.
