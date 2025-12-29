USE db_cta

---1. DATA UNDERSTANDING & VALIDATION
---(i) Row count & patient count
SELECT 
	COUNT(*) as total_rows,
	COUNT(DISTINCT patient_id) as total_patients
FROM master;

---(ii) Null audit (data quality)
SELECT
    SUM(CASE WHEN enrollment_date IS NULL THEN 1 ELSE 0 END) AS missing_enrollment,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END) AS missing_bmi,
    SUM(CASE WHEN outcome IS NULL THEN 1 ELSE 0 END) AS missing_outcome
FROM master;

---(iii) Data Range Check
SELECT
	MIN(enrollment_date) AS first_enrollment,
	MAX(enrollment_date) AS last_enrollment
FROM master;

---2. DEMOGRAPHIC ANALYSIS
---(i) Gender Distribution
SELECT
	gender,
	COUNT(*) AS patient_count
FROM master
GROUP BY gender
ORDER BY patient_count DESC;

---(ii) Age group segmentation
SELECT
	CASE
		WHEN age<30 THEN '<30'
		WHEN age BETWEEN 30 AND 45 THEN '30-45'
		WHEN age BETWEEN 46 AND 60 THEN '46-60'
		ELSE '60+'
	END AS age_group,
	COUNT(*) AS patients
FROM master
GROUP BY
	CASE
		WHEN age<30 THEN '<30'
		WHEN age BETWEEN 30 AND 45 THEN '30-45'
		WHEN age BETWEEN 46 AND 60 THEN '46-60'
		ELSE '60+'
	END
ORDER BY patients DESC;

---(iii) BMI risk classification
SELECT
	CASE
		WHEN bmi<18.5 THEN 'underweight'
		WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'normal'
		WHEN bmi BETWEEN 25 AND 29.9 THEN 'overweight'
		ELSE 'obese'
	END AS bmi_category,
	COUNT(*) AS patients
FROM master
GROUP BY
	CASE
		WHEN bmi<18.5 THEN 'underweight'
		WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'normal'
		WHEN bmi BETWEEN 25 AND 29.9 THEN 'overweight'
		ELSE 'obese'
	END
ORDER BY patients DESC;

---3. CLINICAL OUTCOME ANALYSIS
---(i) Outcome distribution
SELECT
	outcome,
	COUNT(*) AS patient_count
FROM master
GROUP BY outcome
ORDER BY patient_count DESC;

---(ii) Outcome by risk group
SELECT
	high_risk,
	outcome,
	COUNT(*) AS patient_count
FROM master
GROUP BY high_risk,outcome
ORDER BY high_risk,patient_count DESC;

---(iii) Dropout analysis
SELECT
	dropout_flag,
	COUNT(*) AS patient_count
FROM master
GROUP BY dropout_flag
ORDER BY patient_count DESC;

---(iv) Dropout Reason
SELECT
	dropout_reason,
	COUNT(*) AS cases
FROM master
WHERE dropout_flag =1
GROUP BY dropout_reason
ORDER BY cases DESC;


---4. TIME-TO-EVENT ANALYSIS
---(i) Average time to outcome
SELECT
	AVG(time_to_outcome) AS avg_days_to_outcome
FROM master
WHERE time_to_outcome>=0;

---(ii) Time to outcome by risk
SELECT
	high_risk,
	AVG(time_to_outcome) AS avg_days_to_outcome
FROM master
WHERE time_to_outcome>=0
GROUP BY high_risk;


---5. LAB & AE INSIGHTS
---(i) Lab test burden
SELECT
    AVG(total_lab_tests) AS avg_lab_tests_per_patient
FROM master;

---(ii) Adverse events impact
SELECT
    severe_ae,
    COUNT(*) AS patients
FROM master
GROUP BY severe_ae
ORDER BY patients DESC;

---(iii) Outcome vs severe adverse events
SELECT
    severe_ae,
	outcome,
    COUNT(*) AS patients
FROM master
GROUP BY severe_ae,outcome
ORDER BY patients DESC;
