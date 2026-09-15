-- Ecommerce Decision Diagnosis — Case #1
-- Analysis 01: Funnel Diagnosis | Grain: distinct session | Finding #1
SELECT
  COUNT(DISTINCT s.session_id) AS total_sessions,
  COUNT(DISTINCT CASE WHEN e.event_name = 'product_view' THEN e.session_id END) AS product_view_sessions,
  COUNT(DISTINCT CASE WHEN e.event_name = 'add_to_cart' THEN e.session_id END) AS add_to_cart_sessions,
  COUNT(DISTINCT CASE WHEN e.event_name = 'begin_checkout' THEN e.session_id END) AS begin_checkout_sessions,
  COUNT(DISTINCT CASE WHEN e.event_name = 'purchase' THEN e.session_id END) AS purchase_sessions
FROM `ecommerce-analytics-case01.ecommerce_case01.sessions` s
LEFT JOIN `ecommerce-analytics-case01.ecommerce_case01.funnel_events` e
  ON s.session_id = e.session_id;

-- Results: 1,500 -> 600 -> 30 -> 18 -> 12
-- Rates: Session->PDP 40%; PDP->ATC 5%; Session->ATC 2%; ATC->Checkout 60%; Checkout->Purchase 66.7%.
