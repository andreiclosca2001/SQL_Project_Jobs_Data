-- In this query I aim to solve the following question:
/*

    What are the top-paying data analyst jobs?
        Objective:
                    1. Identify the top 10 highest-paying Data Analyst roles that are available remotely.
                    2. Focus on job postings with specified salaries (remove NULLS).
    Why? To highlight the top-paying opportunities for Data Analysts, offering insights into employers and companies.
*/

SELECT
    cd.name AS "Company Name",
    jpf.job_title AS "Job Title",
    jpf.job_location AS "Job Location",
    jpf.job_schedule_type AS "Job Schedule",
    jpf.salary_year_avg AS "Yearly Salary",
    jpf.job_posted_date::DATE AS "Job Posted Date"
FROM 
    job_postings_fact AS jpf
LEFT JOIN 
    company_dim AS cd ON cd.company_id = jpf.company_id
WHERE 
    jpf.job_work_from_home = TRUE
AND 
    jpf.job_title_short = 'Data Analyst'
AND 
    jpf.salary_year_avg IS NOT NULL
ORDER BY 
    jpf.salary_year_avg DESC
LIMIT 10;

