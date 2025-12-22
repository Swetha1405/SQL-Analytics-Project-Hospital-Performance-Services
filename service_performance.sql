/* =========================================================
   PROJECT: SQL Hospital Performance Analysis
   FILE: service_performance.sql
   AUTHOR: Swetha Avadanam
   DESCRIPTION:
   This file focuses on SERVICE-LEVEL PERFORMANCE analysis
   across the hospital using SQL.

   The queries in this file analyze:
   - Patient admissions & refusals
   - Admission rates
   - Service-wise satisfaction
   - High-performing vs low-performing services
   - Service trends over time
   - Ranking and comparison of services

   DATA SOURCES:
   - services_weekly
   - patients
   - staff (when required)

   SKILLS DEMONSTRATED:
   - Aggregations (SUM, AVG, COUNT)
   - GROUP BY & HAVING
   - CASE expressions
   - Subqueries & derived tables
   - Window functions
   - CTEs
   - Performance metric calculations

   ========================================================= */


/* =========================================================
   SECTION 1: BASIC SERVICE EXPLORATION
   ---------------------------------------------------------
   Objective:
   - Understand available services
   - Explore weekly service-level data
   ========================================================= */

select distinct service from services_weekly;



/* =========================================================
   SECTION 2: SERVICE-LEVEL AGGREGATIONS
   ---------------------------------------------------------
   Objective:
   - Total patients admitted per service
   - Total patients refused per service
   - Average patient satisfaction per service
   ========================================================= */

-- Total admissions and refusals per service

select sum(patients_admitted) as total_patients_admitted,
sum(patients_refused) as total_patients_refused ,
round(avg(patient_satisfaction),2) as avg_patient_satisfaction
from services_weekly;


-- Average patient satisfaction per service

select service,sum(patients_admitted) as total_patients_admitted,
sum(patients_refused) as total_patients_refused ,
round(avg(patient_satisfaction),2) as avg_patient_satisfaction
from services_weekly
group by service;



/* =========================================================
   SECTION 3: SERVICE ADMISSION RATE ANALYSIS
   ---------------------------------------------------------
   Objective:
   - Calculate admission rate per service
   ========================================================= */

-- Admission rate = admitted / requested * 100
select service,
sum(patients_admitted) as total_number_of_patients_admitted,
sum(patients_refused)  as total_patients_refused,
round(sum(patients_admitted)*100/ sum(patients_request),2) as admission_rate
from services_weekly
group by service
order by admission_rate desc;




/* =========================================================
   SECTION 4: HIGH & LOW PERFORMING SERVICES
   ---------------------------------------------------------
   Objective:
   - Identify services with:
     • High refusals
     • Low satisfaction
     • Poor admission rates
   ========================================================= */

-- Services with total refusals greater than a threshold
SELECT 
    service,
    SUM(patients_refused) AS total_refused,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING 
    SUM(patients_refused) > 100
    AND AVG(patient_satisfaction) < 80
ORDER BY total_refused DESC;




-- Services with average satisfaction below hospital average

select distinct p.patient_id,p.name,p.service,p.satisfaction as personal_satisfaction_score
from patients p
where p.service in (
 -- Condition 1: Services with at least 1 refused week
                  select distinct service 
                  from services_weekly
                  where patients_refused>0
                  )
and p.service in (
  -- Condition 2: Services with below-average satisfaction
			      select service 
                  from services_weekly
                  group by service
                  having avg(patient_satisfaction)<
                  ( select avg(patient_satisfaction)
                  from services_weekly
                  )
                  
                );




/* =========================================================
   SECTION 5: SERVICE PERFORMANCE CATEGORIZATION
   ---------------------------------------------------------
   Objective:
   - Classify services into performance buckets
     (Excellent / Good / Fair / Needs Improvement)
   ========================================================= */

-- Categorize services based on average satisfaction
select service,
count(patient_admitted) as total_patients_admitted,
avg(satisfaction) as avg_satisfaction,
case
    when satisfaction>=85 then 'Excellent'
    when satisfaction>=75 then 'Good'
	when satisfaction>=65 then 'Fair'
else  'Needs Improvement' 
end as performance_category
from services_weekly
group by service
order by avg_satisfaction desc;



/* =========================================================
   SECTION 6: SERVICE TREND ANALYSIS
   ---------------------------------------------------------
   Objective:
   - Analyze weekly trends in admissions and satisfaction
   ========================================================= */

-- Weekly admissions trend per service
SELECT
    service,
    week,
    patients_admitted
FROM services_weekly
ORDER BY service, week;



-- Moving average of satisfaction per service
SELECT
    service,
    week,
    patient_satisfaction,
    AVG(patient_satisfaction) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS moving_avg_4_week
FROM services_weekly
ORDER BY service, week;




/* =========================================================
   SECTION 7: SERVICE RANKING & COMPARISON
   ---------------------------------------------------------
   Objective:
   - Rank services based on admissions or satisfaction
   ========================================================= */

-- Rank services by total patients admitted
select service, patients_admitted,
rank() over (order by patients_admitted desc) as rnk,
dense_rank() over (order by patients_admitted desc) as dense_rnk from services_weekly;



/* =========================================================
   SECTION 8: SERVICE PERFORMANCE SUMMARY (CTE)
   ---------------------------------------------------------
   Objective:
   - Create a consolidated service performance report
   - Used later in the FINAL DASHBOARD query
   ========================================================= */

-- Service-level summary using CTE
WITH 
-- 1) SERVICE-LEVEL METRICS
service_metrics AS (
    SELECT
        s.service_id,
        s.service_name,
        COUNT(p.patient_id) AS total_patients,
        SUM(CASE WHEN p.admission_status = 'Admitted' THEN 1 ELSE 0 END) AS total_admissions,
        SUM(CASE WHEN p.admission_status = 'Refused' THEN 1 ELSE 0 END) AS total_refusals,
        AVG(p.satisfaction_score) AS avg_satisfaction,
        -- Admission rate = admitted / total
        AVG(CASE WHEN p.admission_status = 'Admitted' THEN 1.0 ELSE 0.0 END) AS admission_rate
    FROM services s
    LEFT JOIN patients p ON s.service_id = p.service_id
    GROUP BY s.service_id, s.service_name
),

-- 2) STAFF METRICS
staff_metrics AS (
    SELECT
        s.service_id,
        COUNT(st.staff_id) AS total_staff,
        AVG(st.weeks_present) AS avg_weeks_present
    FROM services s
    LEFT JOIN staff st ON s.service_id = st.service_id
    GROUP BY s.service_id
),

-- 3) PATIENT DEMOGRAPHICS
patient_demo AS (
    SELECT
        s.service_id,
        AVG(p.age) AS avg_age,
        COUNT(p.patient_id) AS patient_count
    FROM services s
    LEFT JOIN patients p ON s.service_id = p.service_id
    GROUP BY s.service_id
),

-- 4) FINAL COMBINED REPORT
final_report AS (
    SELECT
        sm.service_name,
        sm.total_admissions,
        sm.total_refusals,
        sm.avg_satisfaction,
        sm.admission_rate,
        stm.total_staff,
        stm.avg_weeks_present,
        pd.avg_age,
        pd.patient_count,

        -- Performance Score = Weighted average
        -- 70% weight → Admission rate
        -- 30% weight → Satisfaction score normalized to 0–1
        (0.7 * sm.admission_rate) + 
        (0.3 * (sm.avg_satisfaction / 100)) AS performance_score
    FROM service_metrics sm
    LEFT JOIN staff_metrics stm ON sm.service_id = stm.service_id
    LEFT JOIN patient_demo pd ON sm.service_id = pd.service_id
)

SELECT *
FROM final_report
ORDER BY performance_score DESC;




/* =========================================================
   END OF FILE
   ========================================================= */

