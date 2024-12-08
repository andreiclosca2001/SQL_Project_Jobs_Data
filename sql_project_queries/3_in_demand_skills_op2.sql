-- In this query I aim to solve the following question:
/*

    What are the most in-demand skills required for the role I am interested in (Data Analyst)?
        Objective:
                    1. Find the number of job postings per skill for the Data Analyst roles.
                    2. Only select the jobs where you can work remotely.
    Why? To provide job seekers an insight into the most sought after skills in the domain of Data Analytics.

    OPTION 2 (better optimized):
*/

SELECT
    COUNT(jpf.job_id) AS "Job Postings Per Skill",
    sd.skills AS "Skill Name"
FROM 
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE
    jpf.job_work_from_home = TRUE
AND
    jpf.job_title_short = 'Data Analyst'
GROUP BY 
    sd.skills
ORDER BY COUNT(jpf.job_id) DESC;