-- In this query I aim to solve the following question:
/*

    What are the most in-demand skills required for the role I am interested in (Data Analyst)?
        Objective:
                    1. Find the number of job postings per skill for the Data Analyst roles.
                    2. Only select the jobs where you can work remotely.
    Why? To provide job seekers an insight into the most sought after skills in the domain of Data Analytics.

    OPTION 1 (using CTEs):
*/

WITH remote_job_skills AS (
    SELECT
        sjd.skill_id,
        COUNT(*) AS demand_count
    FROM
        skills_job_dim AS sjd
    INNER JOIN 
        job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE 
        jpf.job_work_from_home = TRUE
    AND 
        jpf.job_title_short = 'Data Analyst'
    GROUP BY 
        sjd.skill_id
)

SELECT
    sd.skills AS "Skill Name",
    rjs.demand_count AS "Jobs per Skill"
FROM
    remote_job_skills AS rjs
INNER JOIN 
    skills_dim AS sd ON sd.skill_id = rjs.skill_id
ORDER BY 
    rjs.demand_count DESC;

-- to do  breakdown of the results