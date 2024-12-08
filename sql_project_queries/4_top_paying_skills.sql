-- In this query I aim to solve the following question:
/*

    What are the top skills based on salary?
        Objective:
                    1. Look at the average salary associated with each skill for Data Analyst positions.
                    2. Focuses on roles with specified salaries, regardless of location.
    Why? To reveal how different skills impact salary levels for Data Analysts and to identify the most financially rewarding skills to learn.

   
*/

SELECT
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg), 0) AS salary_avg
FROM 
    job_postings_fact AS jpf
INNER JOIN 
    skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
ORDER BY 
    salary_avg DESC;

-- to do  breakdown of the results
