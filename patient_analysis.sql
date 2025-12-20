/* ===========================================================
   Project: SQL Hospital Performance Analysis
   File: patient_analysis.sql

   Description:
   This file focuses on patient-level analysis using SQL.
   It covers patient demographics, satisfaction analysis,
   length of stay, categorization, and service-level insights.

   Skills Demonstrated:
   - SELECT, WHERE, ORDER BY, LIMIT
select patient_id,name,age from patients;

select distinct service from services_weekly;

   - Aggregate functions (COUNT, AVG)
select min(age) from patients;

select max(age) from patients;

select sum(patients_admitted) as total_patients_admitted,
sum(patients_refused) as total_patients_refused ,
round(avg(patient_satisfaction),2) as avg_patient_satisfaction
from services_weekly;

   - CASE statements
SELECT 
    patient_id,
    UPPER(name) AS full_name_uppercase,
    LOWER(service) AS service_lowercase,
    CASE 
        WHEN age >= 65 THEN 'Senior'
        WHEN age >= 18 THEN 'Adult'
        ELSE 'Minor'
    END AS age_category,
    LENGTH(name) AS name_length
FROM patients
WHERE LENGTH(name) > 10;

   - Date functions
select service,
avg(DATEDIFF(departure_date, arrival_date)) AS avg_stay_days,
count(patient_id) as patient_count
from patients
group by service
having avg_stay_days>7
order by avg_stay_days desc;

   - JOINs
SELECT 
    s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    COUNT(ss.week) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss
    ON s.staff_name = ss.staff_name
GROUP BY 
    s.staff_id,
    s.staff_name,
    s.role,
    s.service
ORDER BY 
    weeks_present DESC,
    s.staff_name;

   - Subqueries
select p.patient_id,p.name,p.service from patients p
join (

SELECT service
        FROM (
                -- Step 1: staff count per service
                SELECT service, COUNT(*) AS staff_count
                FROM staff
                GROUP BY service
             ) AS service_staff
where staff_count>
             (select avg(staff_count) as avg_staff_count
                from 
                     (select service, count(*)  as staff_count from staff
					   group by service
                       ) 
                       as staff_summary
                       
					)
     ) as high_staff_service 
     on p.service=high_staff_service.service;
   - Window functions (advanced)

   Author: Swetha Avadanam
   ============================================================ */

