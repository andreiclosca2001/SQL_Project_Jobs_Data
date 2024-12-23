# Introduction
This project aims to dive into the data job market. Focusing on the role of a data analyst, this project explores top-paying jobs in the industry, skills that are in high demand, and valuable insights in the world of data.

The SQL queries that explore these ideas can be found here: [sql_project_queries folder](sql_project_queries/)

# The Aim of my Project

Being a recent graduate, eager to crack into the Data Analytics job market, this project was born from a desire to pinpoint highly valued and demanded skills, streamlining the process and being able to make an informed business decision based on the optimal jobs available.

The dataset used in this project is an open-source work that provides insights into job postings from all over the world from 2023. We will be diving in the remote positions for Data Analyst roles, as that is my desired position.

The questions I aim to answer through my SQL queries:

1. What are the best paying Data Analyst roles?
2. What are the skills required for these jobs?
3. What are the most in-demand skills for Data Analyst roles?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn in order to work in this field. (Skills that are both high-paying and highly demanded)

# Tools Used

This project has served as a learning experience for me, gaining valuable experience in working with the following tools:

- SQL: The most vital part of my project, allowing me to query the database and gain critical insights.
- PostgreSQL: The chosen database management system.
- Visual Studio Code: Used for database management and executing SQL queries.
- Git & GitHub: Essential for sharing my SQL queries and analysis.

# The Analysis

Here is how I approached each questions posed previously:

## 1. Top Paying Data Analyst Jobs

In order to identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities for a Data Analyst.

```sql
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
```
### Table Results

![Table 1](assets/sql_table_1.png/)

### Key Insights

- Top-Paying Jobs:
The highest salary is offered by Mantys for the "Data Analyst" role, with an annual salary of $650,000.
This is significantly higher than the second-highest salary of $336,500 offered by Meta for the "Director of Analytics" role.

- Job Titles and Salaries:
The dataset includes a mix of job levels ranging from standard "Data Analyst" roles to more senior titles like "Director of Analytics" and "Principal Data Analyst".
Senior roles (e.g., Director, Principal) generally cluster around the $200,000-$336,500 range, while standard analyst roles vary widely, from $184,000 to $650,000.

- Companies like Meta, AT&T, and Pinterest offer competitive salaries for data-related roles, primarily in senior positions.
Notably, Mantys offers an exceptionally high salary for a standard Data Analyst role, which could indicate a highly specialized or critical position.

![Top Paying Roles](assets/query1.png/)

## 2. Skills required for the top paying jobs

**Here I will be using** the previous query and building upon it, adding the skills required for these top paying jobs using CTEs.

```sql
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
```
### Table Results

![Table 2](assets/sql_table_2.png/)
**Only the results shown on the first page.**

### Key Insights
Top Skills Across Roles:

- **SQL**: Essential for all roles, appearing across every job, emphasizing its importance as a foundational skill in data analytics.
- **Python**: Another frequent skill, often paired with SQL for data manipulation and analysis.
- **Tableau**: Common in roles requiring data visualization and reporting.
- **Specialized tools like**: Snowflake, Azure, AWS, and Gitlab are specific to particular roles or companies, reflecting advanced or niche technical requirements.

### Skills vs. Salary:

- **Higher-paying roles** tend to demand broader skill sets, including advanced tools and platforms like Databricks, Snowflake, and cloud solutions (e.g., AWS, Azure).
- Leadership roles (e.g., "Director, Data Analyst") list additional skills for project management and collaboration (e.g., Confluence, JIRA, SAP).

**Role Specialization**:

- Marketing Analysts (e.g., Pinterest) focus on data visualization tools (e.g., Tableau) and big data platforms (e.g., Hadoop).
- Technical Analysts (e.g., AT&T, Motional) require cloud computing and programming proficiency (e.g., Python, R, PySpark).

## 3. Most in-demand skills

This query aims to find the most demanded skills for a Data Analyst role, offering the number of job postings per skill.

```sql

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
```
### Table Results

![Table 3](assets/sql_table_3.png/)
**Only the results shown on the first page.**

![Most Demanded Skills](assets/query3.png/)

### Key Observations
#### Top Skills by Job Postings:

- **SQL** is overwhelmingly the most requested skill, appearing in over 7,000 job postings, reinforcing its central role in data analysis.
- **Excel, Python, and Tableau** follow, demonstrating the importance of programming, data visualization, and spreadsheet skills.
- Advanced tools like **Power BI, R, and SAS** are also frequently requested, indicating demand for analytics and statistical expertise.

## 4. Top-paying Skills

In this query I aim to find the highest paid skills for a Data Analyst role, judging by the average salary per year in 2023.

```sql
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
```
### Table Results

![Table 4](assets/sql_table_4.png/)
**Only the results shown on the first page.**

### Key insights

#### Top-Paying Skills:

- **Highest**: svn ($400,000), followed by Solidity ($179,000) and Couchbase ($160,515).
Emerging Tech:

- **Machine learning tools**: Hugging Face ($123,950), TensorFlow ($120,647), PyTorch ($125,226).

- **Cloud & DevOps**: Terraform ($146,734), VMware ($147,500), GitLab ($134,126), AWS ($106,440).

- **Programming Languages**: Scala ($115,480), Perl ($124,686), Golang ($155,000), Rust ($107,925).

- **Data Tools**: Cassandra ($118,407), Snowflake ($111,578), Databricks ($112,881).

## 5. Optimal Skills to Learn

This query aims to find the skills and job posting information for the most demanded and highest paid Data Analyst positions.

```sql
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
```
### Table Results

![Table 5](assets/sql_table_5.png/)
**Only the results shown on the first page.**

### Key insights 
- High-Demand Skills:
SQL (398 offers) and Excel (256 offers) dominate in job demand, followed by Python (236 offers) and Tableau (230 offers).

- Data visualization tools like Power BI (110 offers) and Tableau indicate strong demand in business intelligence.

- Top Salaries: Couchbase ($160,515) and Datarobot ($155,486) are associated with the highest average salaries but have minimal job demand (1 offer each).
GitLab ($134,126) and Twilio ($138,500) also offer lucrative salaries despite low demand.

- Skills Balancing Demand and Salary:
Snowflake ($111,578), AWS ($106,440), and Azure ($105,400) show a strong mix of demand and competitive salaries.

- Programming languages like R ($98,708) and Python ($101,512) feature prominently.

- Specialized Tools:
Hadoop (22 offers, $110,888) and Spark (13 offers, $113,002) reflect a niche demand for big data technologies.

- Lower Demand, Competitive Salary:
Technologies like Scala ($115,480), Airflow ($116,387), and Git ($112,250) have fewer offers but provide attractive salaries.

# What I learned

Throughout this project, I've significantly enhanced my analytical and SQL skills:

- **Complex Query Crafting**: Learning the art of advanced SQL, merging tables and using CTEs, Subqueries and Joins.
- **Data Aggregation**: Using GROUP BY and aggregate functions such as COUNT() and AVG() and overall improving my SQL queries.
- **Analytical Skills**: Leveled up my problem-solving skills, turning questions into insightful SQL queries.
- **Other Technical Skills**: Gained valuable knowledge and experience in using Visual Studio Code as well as Git and GitHub.