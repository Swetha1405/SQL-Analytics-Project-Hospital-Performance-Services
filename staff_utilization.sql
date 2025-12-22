/* =========================================================
   PROJECT: Hospital Performance Analysis
   FILE: staff_utilization.sql
   AUTHOR: Swetha Avadanam
   DESCRIPTION:
   This file focuses on analyzing staff availability, utilization,
   attendance patterns, and staff-to-service distribution.
   ========================================================= */


/* =========================================================
   SECTION 1: STAFF OVERVIEW & DISTRIBUTION
   ---------------------------------------------------------
   Objective:
   - Understand staff distribution across services and roles
   - Identify services with high or low staff availability
   ========================================================= */

-- Total staff count by service
-- Insight: Helps identify well-staffed vs understaffed services
-- (Derived from early aggregation practice)
SELECT 
    service,
    COUNT(staff_id) AS total_staff
FROM staff
GROUP BY service
ORDER BY total_staff DESC;

-- Staff count by role
-- Insight: Understand role distribution (doctors, nurses, assistants)
SELECT
    role,
    COUNT(*) AS staff_count
FROM staff
GROUP BY role
ORDER BY staff_count DESC;



/* =========================================================
   SECTION 2: STAFF ATTENDANCE & UTILIZATION
   ---------------------------------------------------------
   Objective:
   - Measure staff presence across weeks
   - Identify consistency and workload distribution
   ========================================================= */

-- Count of weeks each staff member was present
-- Insight: Measures individual staff utilization
SELECT
    staff_id,
    staff_name,
    service,
    COUNT(week) AS weeks_present
FROM staff_schedule
WHERE present = 1
GROUP BY staff_id, staff_name, service
ORDER BY weeks_present DESC;

-- Total staff present per week (hospital-wide)
-- Insight: Detect low-staffing weeks
SELECT
    week,
    SUM(present) AS total_staff_present
FROM staff_schedule
GROUP BY week
ORDER BY week;



/* =========================================================
   SECTION 3: SERVICE-LEVEL STAFF UTILIZATION
   ---------------------------------------------------------
   Objective:
   - Aggregate staff utilization at service level
   - Support capacity and workload analysis
   ========================================================= */

-- Average weeks present per staff by service
-- Insight: Indicates staff consistency within each service
SELECT
    service,
    AVG(weeks_present) AS avg_weeks_present
FROM (
    SELECT
        staff_id,
        service,
        COUNT(week) AS weeks_present
    FROM staff_schedule
    WHERE present = 1
    GROUP BY staff_id, service
) t
GROUP BY service
ORDER BY avg_weeks_present DESC;

-- Staff availability vs patient load (staff-to-patient view)
-- Insight: Helps evaluate workload pressure
SELECT
    sw.service,
    COUNT(DISTINCT s.staff_id) AS total_staff,
    SUM(sw.patients_admitted) AS total_patients_admitted
FROM services_weekly sw
LEFT JOIN staff s
    ON sw.service = s.service
GROUP BY sw.service
ORDER BY total_patients_admitted DESC;



/* =========================================================
   SECTION 4: LOW & HIGH UTILIZATION SCENARIOS
   ---------------------------------------------------------
   Objective:
   - Identify services or staff with unusually low or high utilization
   - Flag potential risk or overwork situations
   ========================================================= */

-- Weeks with low overall staff presence
-- Insight: Useful for operational risk analysis
SELECT
    week,
    SUM(present) AS total_staff_present
FROM staff_schedule
GROUP BY week
HAVING total_staff_present < 50
ORDER BY week;

-- Staff working in services with above-average staff count
-- Insight: Identifies resource-heavy services
SELECT
    p.patient_id,
    p.name,
    p.service
FROM patients p
JOIN (
    SELECT service
    FROM staff
    GROUP BY service
    HAVING COUNT(*) >
        (SELECT AVG(staff_count)
         FROM (
              SELECT service, COUNT(*) AS staff_count
              FROM staff
              GROUP BY service
         ) x)
) high_staff_services
ON p.service = high_staff_services.service;



/* =========================================================
   SECTION 5: STAFF UTILIZATION USING CTEs (ADVANCED)
   ---------------------------------------------------------
   Objective:
   - Build reusable staff utilization logic
   - Support dashboard-level analysis
   ========================================================= */

WITH staff_util AS (
    SELECT
        staff_id,
        service,
        COUNT(week) AS total_weeks_present,
        SUM(present) AS total_days_present
    FROM staff_schedule
    GROUP BY staff_id, service
),
service_util AS (
    SELECT
        service,
        COUNT(*) AS staff_count,
        AVG(total_weeks_present) AS avg_weeks_present,
        SUM(total_days_present) AS total_service_days_present
    FROM staff_util
    GROUP BY service
)
SELECT
    service,
    staff_count,
    avg_weeks_present,
    total_service_days_present
FROM service_util
ORDER BY staff_count DESC;


/* =========================================================
   END OF FILE: staff_utilization.sql
   ========================================================= */

