/*
Question: How are Data Analyst salaries distributed across pay brackets?
- Use a CASE statement to bucket salaries into Entry/Mid/Senior levels,
  then count postings and calculate average salary within each bracket.
- Why? Gives a clearer picture of salary distribution than a single
  overall average, and shows how many postings fall into each range.
*/

SELECT
    CASE
        WHEN salary_year_avg < 60000 THEN 'Entry Level'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Mid Level'
        ELSE 'Senior Level'
    END AS salary_bracket,
    COUNT(*) AS number_of_postings,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY    
    salary_bracket;