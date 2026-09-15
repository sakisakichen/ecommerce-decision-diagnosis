-- Ecommerce Decision Diagnosis — Case #1
-- Analysis 02: Device Validation | Grain: device | Finding #1 validation
WITH funnel_by_device AS (
  SELECT
    a.device,
    COUNT(DISTINCT a.session_id) AS session_cnt,
    COUNT(DISTINCT CASE WHEN b.event_name = 'add_to_cart' THEN a.session_id END) AS atc_session_cnt
  FROM `ecommerce-analytics-case01.ecommerce_case01.sessions` a
  LEFT JOIN `ecommerce-analytics-case01.ecommerce_case01.funnel_events` b
    ON a.session_id = b.session_id
  GROUP BY a.device
)
SELECT
  device,
  session_cnt,
  atc_session_cnt,
  SAFE_DIVIDE(atc_session_cnt, session_cnt) AS session_to_atc_rate
FROM funnel_by_device
ORDER BY session_to_atc_rate;

-- Results: Mobile 2.05%; Desktop 2.17%; Tablet 0% on only 60 sessions.
-- Interpretation: mobile vs desktop does not explain the broad weakness.
