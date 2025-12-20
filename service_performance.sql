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
-- (Day 9 – CASE statement)
-- Add your query here



/* =========================================================
   SECTION 6: SERVICE TREND ANALYSIS
   ---------------------------------------------------------
   Objective:
   - Analyze weekly trends in admissions and satisfaction
   ========================================================= */

-- Weekly admissions trend per service
-- (Day 10 – ORDER BY + trends)
-- Add your query here


-- Moving average of satisfaction per service
-- (Day 20 – Window Functions)
-- Add your query here



/* =========================================================
   SECTION 7: SERVICE RANKING & COMPARISON
   ---------------------------------------------------------
   Objective:
   - Rank services based on admissions or satisfaction
   ========================================================= */

-- Rank services by total patients admitted
-- (Day 19 – RANK / DENSE_RANK)
-- Add your query here



/* =========================================================
   SECTION 8: SERVICE PERFORMANCE SUMMARY (CTE)
   ---------------------------------------------------------
   Objective:
   - Create a consolidated service performance report
   - Used later in the FINAL DASHBOARD query
   ========================================================= */

-- Service-level summary using CTE
-- (Day 21 – CTEs)
-- Add your query here



/* =========================================================
   END OF FILE
   ========================================================= */

