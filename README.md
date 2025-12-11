# 📊 Hospital Performance SQL Analytics Project

End-to-end SQL project analyzing hospital operations, patient satisfaction, and staff utilization

## 📌 Project Overview

This project is a comprehensive SQL analytics case study built using a multi-table hospital dataset.
It simulates real-world healthcare analytics by combining:

✔ Patient records

✔ Weekly service metrics

✔ Staff data

✔ Staff attendance schedules

Using SQL, I developed service-level dashboards, staffing insights, patient demographic reports, and operational KPIs.
The project consolidates all analysis into a final hospital performance dashboard using multi-CTE logic.

## 🛠 Skills Demonstrated
SQL Fundamentals

Filtering & sorting

Aggregations (SUM, AVG, COUNT, MIN/MAX)

DISTINCT queries

Intermediate SQL

GROUP BY + HAVING

JOINs (INNER, LEFT JOIN)

Subqueries

Derived tables

Advanced SQL

Window functions:

RANK(), DENSE_RANK()

ROW_NUMBER()

Running totals

Moving averages

CASE statements for classification

CTE-based dashboard development

Multi-CTE data modeling

Analytics & Business Skills

Admission & refusal rate analysis

Patient satisfaction trends

Staff utilization measurement

Event impact analysis

Service performance scoring

Trend & variance analysis

## 📁 Dataset Structure
### 1. patients

patient_id, name, age, arrival_date, departure_date

satisfaction score

service

### 2. services_weekly

week, service

patients_request

patients_admitted

patients_refused

patient_satisfaction

staff_morale

event, available_beds

### 3. staff

staff_id, staff_name

role (doctor/nurse/support)

service

### 4. staff_schedule

staff_id, staff_name

service, role

week, present (1/0)

## 📌 Key Analytical Components

### ⭐ 1. Patient Demographics & Behavior Analysis

Age distribution & service-wise segmentation

Arrival date trends

Length of stay calculation

Satisfaction categorization

High vs. low satisfaction cohorts

Patient counts by service

Identifying services with below/above average satisfaction

Skills Used:
CASE, DATEDIFF, GROUP BY, HAVING, ORDER BY, window functions.

### ⭐ 2. Service Performance Analysis

Total patients admitted & refused

Weekly trends (week 1–52)

Top services by admissions & satisfaction

Services with poor performance: high refusals + low satisfaction

Admission rate calculation

Event impact analysis on staff morale & satisfaction

Skills Used:
SUM, AVG, RANK(), moving averages, PARTITION BY.

### ⭐ 3. Staffing & Utilization Insights

Staff count per service

Medical vs Support categorization

Staff presence weekly

Staff utilization metrics:

total days present

total weeks present

average attendance per service

Staff-to-patient service mapping

Skills Used:
JOIN, LEFT JOIN, aggregation subqueries, derived tables.

### ⭐ 4. Multi-table Analysis

Linking patient → service → staff → schedule

Understanding staffing availability per patient

Service-week alignment

Identifying services with understaffing

Skills Used:
Complex JOINs, multi-level joins, NULL handling.

### ⭐ 5. Advanced SQL Window Function Applications

Weekly cumulative admissions

3-week & 4-week moving averages

Ranking best-performing services & weeks

Row numbering for staff & patients

Trend analysis using window frames

Skills Used:
WINDOW FUNCTIONS, ROWS BETWEEN, ORDER BY, PARTITION BY.

### ⭐ 6. Final Hospital Performance Dashboard (CTE-driven)

A 4-CTE final dashboard summarizing:

Service-Level Metrics

Total admissions

Total refusals

Average satisfaction

Admission rate

Staff Metrics

Total staff assigned

Average weeks present

Total staff days present

Patient Demographics

Average patient age

Patient count per service

Performance Score

A weighted score combining:

0.6 × Admission Rate  + 0.4 × Average Satisfaction Score

## 📈 Key Insights from the Analysis

✔ Services with highest patient satisfaction
✔ Underperforming services with low admission rates
✔ Staff availability vs patient volume
✔ Long-stay services vs short-stay services
✔ Event impact (festivals, emergencies) on satisfaction & morale
✔ Services with high refusal rates needing attention
✔ High-utilization vs low-utilization staff


## 🎯 Why This Project Stands Out

This project demonstrates:

Strong SQL engineering skills

Ability to build multi-layer analytics

Practical business intelligence thinking

Clean data modeling with CTEs + window functions

Real-world healthcare analytics understanding

It is resume-ready and perfect for a GitHub portfolio.
