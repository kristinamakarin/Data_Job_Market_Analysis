# 📊 Data Analyst Job Market Analysis

## Introduction
This project explores the job market for Data Analysts using SQL, focusing on the highest-paying roles and the skills that are both in-demand and well-compensated. The goal is to answer the question: **which skills are most worth learning to maximize both demand and salary?**

The data comes from [Luke Barousse's SQL course](https://lukebarousse.com/sql) and includes job postings, companies, and the skills associated with them.

The queries I wrote can be found in the [`project_sql/`](./project_sql/) folder.

## Questions I wanted to answer
1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn (high demand AND high paying)?

## Tools I used
- **SQL** — for querying and analyzing the data
- **PostgreSQL** — database management system
- **VS Code** — for writing queries and version control
- **Git & GitHub** — for version control and sharing the project

## The Analysis

### 1. Top Paying Jobs

To identify the highest-paying opportunities, I filtered remote (`Anywhere`) Data Analyst postings with a non-null salary and joined with `company_dim` to include the company name, sorting by `salary_year_avg` in descending order.

**Key finding:** Salaries for the top 10 positions vary widely, from $184,000 to over $650,000 — showing that even within a single job title, compensation depends heavily on factors like seniority, company, and specialization.

### 2. Skills for Top Paying Jobs

To understand what skills are required for the highest-paying roles, I joined the top 10 highest-paying jobs (from the previous query) with the skills tables, using a CTE to keep the query readable.

**Key finding:** SQL was the most frequently required skill among the top 10 highest-paying jobs, appearing in 8 out of 10 postings, followed closely by Python (7) and Tableau (6). This shows that even at the very top of the salary range, the same core skills from the broader "in-demand" list remain essential — high pay doesn't necessarily require exotic or niche skills.

### 3. In-Demand Skills

To find the most in-demand skills, I joined job postings with the skills tables and counted how many postings require each skill, grouping by skill and filtering for Data Analyst roles.

**Key finding:** The top 5 most in-demand skills were SQL, Excel, Python, Tableau, and Power BI, with SQL appearing in 92,628 postings — over 25,000 more than the next closest skill (Excel). This highlights that querying ability remains by far the most consistently required skill across the Data Analyst job market, well ahead of visualization tools like Tableau and Power BI.

### 4. Top Paying Skills

To find which individual skills pay the most, I joined job postings with the skills tables and calculated the average salary per skill, filtered for remote Data Analyst roles with a specified salary.

**Key finding:** The highest-paying skills were dominated by niche, specialized tools like PySpark, Bitbucket, and Couchbase — rather than the widely-used skills from the in-demand list (SQL, Excel, Python). This suggests these top results are likely driven by a small number of high-paying postings for specialized roles, rather than reflecting the broader market. This is exactly the kind of outlier effect that Query 5 addresses by filtering for skills with more than 10 postings.

### 5. Most Optimal Skills to Learn

Combining the demand data from Query 3 with the salary data from Query 4, I used two CTEs — `skills_demand` and `average_salary` — joined together to find skills that are both frequently requested and well-paid. I filtered to skills with more than 10 postings to avoid outliers skewing the results (e.g. a rare skill appearing in just one high-paying posting).

**Key finding:** After filtering out low-demand outliers, the most optimal skills were Go, Confluence, Hadoop, Snowflake, and Azure — a noticeably different list from both the "in-demand" skills (SQL, Excel, Python) and the raw "top-paying" skills (PySpark, Bitbucket, Couchbase). This shows that the sweet spot between demand and salary favors specialized data engineering and cloud tools over both the most common tools and the rarest, highest-paying niche ones.

## What I Learned

Throughout this project, I strengthened my SQL skills in several key areas:

- **Complex query building:** Constructing multi-step queries using **CTEs** (`WITH` clauses) to break down complex problems into readable, logical steps — especially useful when combining results from multiple aggregations (Query 5).
- **Joins:** Combining data across multiple related tables (`job_postings_fact`, `company_dim`, `skills_dim`, `skills_job_dim`) using `LEFT JOIN` and `INNER JOIN` to bring together job details, company names, and required skills.
- **Aggregation:** Using `GROUP BY`, `COUNT()`, and `AVG()` to summarize data — for example, counting how many postings require each skill, and calculating average salaries per skill.
- **Query alternatives:** Learning that the same analytical question can often be solved multiple ways (e.g. CTEs vs. a single query with `HAVING`), and that the right choice depends on readability and reusability, not just correctness.
- **Filtering out noise:** Recognizing that raw rankings (like "top-paying skills") can be misleading due to small sample sizes, and using thresholds (`demand_count > 10`) to surface more reliable insights.

## Conclusions

This analysis revealed that the "best" skill to learn depends entirely on what you're optimizing for:

- **In-demand skills** (SQL, Excel, Python, Tableau, Power BI) are the safest bet — they appear across the widest range of job postings.
- **Top-paying skills** (PySpark, Bitbucket, Couchbase) pay the most on average, but are tied to a small, niche subset of highly specialized roles.
- **Most optimal skills** (Go, Confluence, Hadoop, Snowflake, Azure) strike a balance — well-paid *and* requested often enough to be a realistic, strategic learning target.

For someone starting out, the in-demand skills remain the essential foundation. But for someone looking to stand out and increase earning potential, the "most optimal" list points toward cloud and data engineering adjacent tools as a strong next step beyond the basics.

## Bonus: Additional Practice Queries

Alongside the main 5 questions, I wrote a few extra queries to practice variations on the same concepts.

### Top Paying Jobs Without a Degree Requirement
Explores whether high salaries are achievable without a formal degree by filtering on `job_no_degree_mention`.

### Top Paying Jobs by Hourly Rate
Same approach as the main "Top Paying Jobs" query, but ranked by `salary_hour_avg` instead of annual salary — useful for contract/freelance roles.

### Most Optimal Skills (Alternative Approach)
As a variation on Query 5, I rewrote the same logic without CTEs — combining demand count and average salary in a single query, using a `HAVING` clause instead of a `WHERE` filter on a pre-aggregated CTE to exclude skills with 10 or fewer postings.

**Key finding:** This version returns the exact same results as Query 5, demonstrating that the same analytical question can be answered with different SQL approaches — CTEs improve readability for multi-step logic, while a single aggregated query with `HAVING` can be more concise when the steps don't need to be reused separately.

### Do Top-Paying Skills Shift Month to Month?
Extending the top-paying skills analysis from Query 4, I broke the results down by posting month (January–March) to see whether the list of top-paying skills stays consistent over time.

**Key finding:** Without a demand filter, the top-paying skills per month were dominated by niche outliers (dplyr, Bitbucket, Flask, Django) — the same small-sample effect seen in Query 4. Applying the same `demand_count > 10` filter used in Query 5 produced a more stable, realistic list (NoSQL, Hadoop, Jira), with Hadoop notably appearing in both this monthly breakdown and the overall Query 5 results — reinforcing it as a consistently valuable skill to learn, not just a one-off high-paying anomaly.

### Remote vs. On-site Salary Comparison

Using a `CASE` statement to categorize postings into "Remote" and "On-site" groups, I compared the number of postings and average salary between the two.

**Key finding:** Remote postings pay slightly more on average ($94,770 vs. $93,765) — only about a 1% difference, which isn't meaningful in practice. The bigger story is the volume gap: on-site postings (4,859) vastly outnumber remote ones (604), roughly 8-to-1. This suggests remote flexibility doesn't come with a significant pay premium or penalty — it's simply a much smaller slice of the overall Data Analyst job market.

### Salary Distribution by Level

Using a `CASE` statement, I bucketed Data Analyst salaries into Entry, Mid, and Senior level brackets to see how postings are distributed across pay ranges, rather than looking at a single average.

**Key finding:** Most postings fall into the Mid level bracket (2,773 postings, avg. $80,744), followed by Senior level (1,981 postings, avg. $127,400), with Entry level roles being the smallest group (709 postings, avg. $51,566). This suggests the Data Analyst job market skews toward candidates with some experience already — entry-level opportunities exist but make up a relatively small share (about 13%) of postings compared to mid and senior roles.