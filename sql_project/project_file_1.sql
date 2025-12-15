/*
Questions 
1) What are the top-paying jobs for my role?
2) What are the skills required for these top-paying roles?
3) What are the most in-demand skills for my role?
4) What are the top skills based on salary for my role?
5) What are the most optimal skills to learn?
*/

/*
1) What are the top-paying jobs for my role?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely
- Focuses on job posting with specified salaries (remove nulls)
*/

SELECT 
 company_dim.name AS name_company,
 job_title,
 job_schedule_type,
 search_location, 
 job_country,
 salary_year_avg
FROM 
  job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE 
  job_work_from_home = TRUE
  AND
  job_title_short = 'Data Analyst'
  AND
  salary_year_avg IS NOT NULL
ORDER BY
  salary_year_avg DESC
LIMIT 10
;

/*
2) What are the skills required for these top-paying roles?
- Add the specific skills required for these roles
*/

WITH top_paying_job AS (
SELECT 
 job_id,
 company_dim.name AS name_company,
 job_title,
 job_schedule_type,
 search_location, 
 job_country,
 salary_year_avg
FROM 
  job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE 
  job_work_from_home = TRUE
  AND
  job_title_short = 'Data Analyst'
  AND
  salary_year_avg IS NOT NULL
)

SELECT
 name_company,
 job_title,
 job_schedule_type,
 search_location, 
 job_country,
 salary_year_avg,
 skills_dim.skills,
 skills_dim.type
FROM top_paying_job
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_job.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
  salary_year_avg DESC
LIMIT 10
;


/*
3) What are the most in-demand skills for my role?
- In this case for Data Analyst
*/

WITH skills_count AS (

SELECT 
  skill_id,
  COUNT (skill_id) AS number_skill
FROM 
  skills_job_dim
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
  job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY 
  skill_id

)

SELECT
  skills,
  number_skill,
FROM 
  skills_count
INNER JOIN skills_dim ON skills_dim.skill_id = skills_count.skill_id
ORDER BY 
  number_skill DESC
LIMIT 10
;

/*
4) What are the top skills based on salary for my role?
*/

SELECT
 skills_dim.skills,
 ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
 job_postings_fact
INNER JOIN 
 skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
 skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
 job_title_short = 'Data Analyst'
 AND
 salary_year_avg IS NOT NULL
GROUP BY  
 skills_dim.skills
ORDER BY 
 avg_salary DESC
LIMIT 20
;

/*
5) What are the most optimal skills to learn?
*/

WITH demnanded_skills AS (
SELECT 
  skills_dim.skill_id,
  skills_dim.skills,
  COUNT (skill_id) AS demand_skills
FROM 
  job_postings_fact
INNER JOIN 
 skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
 skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
  job_postings_fact.job_title_short = 'Data Analyst'
  AND
  salary_year_avg IS NOT NULL
GROUP BY 
  skill_id
), skills_for_salary AS (
 SELECT
 skills_job_dim.skill_id,
 skills_dim.skills,
 ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM
 job_postings_fact
INNER JOIN 
 skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
 skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
 job_title_short = 'Data Analyst'
 AND
 salary_year_avg IS NOT NULL
GROUP BY  
 skill_id
)

SELECT
 demnanded_skills.skill_id,
 demnanded_skills.skillS,
 demand_skills,
 avg_salary
FROM
 demnanded_skills
INNER JOIN 
 skills_for_salary ON demnanded_skills.skill_id = skills_for_salary.skill_id
WHERE 
 demand_skills > 30
ORDER BY
 avg_salary DESC 
LIMIT 30
;

-- OR

SELECT
 skills_job_dim.skill_id,
 skills_dim.skills,
 ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary,
 COUNT (skill_id) AS demand_skills
FROM
 job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
 job_title_short = 'Data Analyst'
 AND
 salary_year_avg IS NOT NULL
 AND 
 demand_skills > 30
GROUP BY
 skills_job_dim.skill_id
ORDER BY
 avg_salary DESC
LIMIT 30
;
