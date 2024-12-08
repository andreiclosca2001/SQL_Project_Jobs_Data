-- In this query I aim to solve the following question:
/*

    What are the skills required for the top-paying data analyst jobs?
        Objective:
                    1. Use the previous query where I identified the top 10 best paying Data Analyst remote jobs
                    2. Add the specific skills required for these jobs
    Why? To provide a more detailed look into the requirements for these top paying jobs.
*/

WITH top_paying_jobs AS (
    SELECT
        cd.name,
        jpf.job_id,
        jpf.job_title,
        jpf.salary_year_avg
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
    LIMIT 10
)

SELECT
    tpj.name AS "Company Name",
    tpj.job_title AS "Job Title",
    tpj.salary_year_avg AS "Yearly Salary",
    sd.skills AS "Skill Required"
FROM 
    top_paying_jobs AS tpj
INNER JOIN 
    skills_job_dim AS sjd ON sjd.job_id = tpj.job_id
INNER JOIN
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
ORDER BY 
    tpj.salary_year_avg DESC;

-- to do  breakdown of the results