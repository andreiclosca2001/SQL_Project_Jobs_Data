-- In this query I aim to solve the following question:
/*

    What are the most optimal skills to learn (high demand and high paying)?
        Objective:
                    1. Identify skills in high demand and associated with high average salaries for Data Analyst roles.
                    2. Focuses on remote positions with specified salaries.
    Why? To reveal which skills are the most demanded and return the best financial benefits, offering insights for career development in data analysis.
    
*/

-- The first CTE uses the query run previously for skills in demand.

WITH 
    skills_demand AS (
        SELECT
            sd.skill_id,
            sd.skills,
            COUNT(sjd.job_id) AS demand_count
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
        AND
            jpf.salary_year_avg IS NOT NULL
        GROUP BY 
            sd.skill_id
),

-- The second CTE uses the query for the top paying skills

    average_salary AS (
        SELECT
            sjd.skill_id,
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
            sjd.skill_id
)

SELECT 
    skills_demand.skill_id AS "Skill ID",
    skills_demand.skills AS "Skill Name",
    skills_demand.demand_count AS "Job Offers per Skill",
    average_salary.salary_avg AS "Average Salary per Skill"
FROM
    skills_demand
INNER JOIN
    average_salary ON average_salary.skill_id = skills_demand.skill_id
ORDER BY
    skills_demand.demand_count DESC,
    average_salary.salary_avg DESC;



