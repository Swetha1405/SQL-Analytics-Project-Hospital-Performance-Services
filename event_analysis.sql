/* =========================================================
   FILE: event_analysis.sql
   PROJECT: SQL Hospital Performance Dashboard
   SECTION: Event Impact Analysis
   =========================================================
   Objective:
   - Analyze the impact of special events on hospital services
   - Compare patient satisfaction, staff morale, and workload
     during event weeks vs non-event weeks
   ========================================================= */


/* ---------------------------------------------------------
   1. Identify weeks WITH and WITHOUT special events
   ---------------------------------------------------------
   Logic:
   - Treat event as valid if NOT NULL, NOT empty, and NOT 'none'
---------------------------------------------------------- */

SELECT
    week,
    service,
    event
FROM services_weekly
WHERE event IS NOT NULL
  AND event <> ''
  AND event <> 'none';


/* ---------------------------------------------------------
   2. Count how many weeks had events vs no events
   ---------------------------------------------------------
   Business Question:
   - How frequently do special events occur?
---------------------------------------------------------- */

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    COUNT(*) AS total_weeks
FROM services_weekly
GROUP BY event_status;


/* ---------------------------------------------------------
   3. Average patient satisfaction during
      Event weeks vs Non-event weeks
   ---------------------------------------------------------
   Business Question:
   - Do events improve or reduce patient satisfaction?
---------------------------------------------------------- */

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    ROUND(AVG(patient_satisfaction), 2) AS avg_patient_satisfaction
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;


/* ---------------------------------------------------------
   4. Average staff morale during
      Event weeks vs Non-event weeks
   ---------------------------------------------------------
   Business Question:
   - Do events impact staff morale positively or negatively?
---------------------------------------------------------- */

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    ROUND(AVG(staff_morale), 2) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_staff_morale DESC;


/* ---------------------------------------------------------
   5. Event impact on patient admissions
   ---------------------------------------------------------
   Business Question:
   - Do events increase hospital workload?
---------------------------------------------------------- */

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    SUM(patients_admitted) AS total_patients_admitted,
    SUM(patients_refused) AS total_patients_refused
FROM services_weekly
GROUP BY event_status;


/* ---------------------------------------------------------
   6. Comprehensive Event Impact Summary
   ---------------------------------------------------------
   Combines:
   - Event status
   - Week count
   - Avg patient satisfaction
   - Avg staff morale
---------------------------------------------------------- */

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    COUNT(*) AS total_weeks,
    ROUND(AVG(patient_satisfaction), 2) AS avg_patient_satisfaction,
    ROUND(AVG(staff_morale), 2) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;

