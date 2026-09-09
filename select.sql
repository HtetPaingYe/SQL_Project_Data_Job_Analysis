select 
    job_title_short as job_title,    
    job_location as location,
    job_posted_date at TIME ZONE 'UTC' at TIME ZONE 'est' as date,
    EXTRACT(MONTH FROM job_posted_date) as date_month,
    EXTRACT(YEAR FROM job_posted_date) as year_month
from job_postings_fact;


select distinct     EXTRACT(month FROM job_posted_date) as year_month
from job_postings_fact
order by year_month;


select count(job_id) as job_count,
    EXTRACT(MONTH FROM job_posted_date) as month_date
from job_postings_fact
where
    job_title_short = 'Data Analyst'
group by month_date
order by job_count desc;

SELECT
    job_schedule_type,
    avg(salary_year_avg),
    avg(salary_hour_avg)

from 
    job_postings_fact
WHERE   
    EXTRACT(MONTH FROM job_posted_date) = 6 and
    EXTRACT(YEAR FROM job_posted_date) = 2023 and 
    EXTRACT(Day FROM job_posted_date) = 1
group by job_schedule_type;

SELECT
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM 
    job_postings_fact
WHERE   
    job_posted_date > '2023-06-01'
GROUP BY 
    job_schedule_type ;

select  
    count(job_id) as job_count,
    EXTRACT(MONTH from job_posted_date at time zone 'UTC' at time Zone 'America/New_York' ) as month
from 
    job_postings_fact
where
    EXTRACT(YEAR from job_posted_date at time zone 'UTC' at time Zone 'America/New_York') = 2023
group BY    
    month
order by month;

select 
    company_id
FROM
    job_postings_fact
where 
    job_health_insurance = true
    and
    EXTRACT(year from job_posted_date) = 2023
    and
    EXTRACT(MONTH from job_posted_date) in (5,6,7,8)

select 
    company_dim.name
FROM
    job_postings_fact
inner join company_dim
on job_postings_fact.company_id = company_dim.company_id
where 
    job_postings_fact.job_health_insurance = true
    and
    EXTRACT(year from job_posted_date) = 2023
    and
    EXTRACT(QUARTER from job_posted_date) = 2;



SELECT 
    c.name
FROM
    job_postings_fact AS j
INNER JOIN 
    company_dim AS c ON j.company_id = c.company_id
WHERE 
    j.job_health_insurance = true
    AND EXTRACT(YEAR FROM j.job_posted_date) = 2023
    AND EXTRACT(QUARTER FROM j.job_posted_date) = 2;

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Create a table for February
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Create a table for March
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select 
    count(job_id),
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where  
    job_title_short = 'Data Analyst'
group by location_category;

select salary_year_avg,
    case
        when salary_year_avg between 10000 and 100000 then 'Low'
        when salary_year_avg between 100000 and 500000 then 'Mid'
        when salary_year_avg between 500000 and 1000000 then 'High'   
        else 'Unknown'
    end as salary_category
from job_postings_fact
where  
    job_title_short = 'Data Analyst' and salary_year_avg is not null
order by salary_category desc;

select avg(salary_year_avg),job_title_short
from job_postings_fact
group by job_title_short;

SELECT *
from(
    SELECT * from 
    job_postings_fact
    where EXTRACT (MONTH from job_posted_date) =1
) as january_jobs;

with january_job as(
    select * from 
    job_postings_fact
    where EXTRACT (MONTH from job_posted_date) =1
)

select * from january_job;


select name as company_name
from company_dim
where company_id in(
    select 
    company_id
from 
    job_postings_fact
where  
    job_no_degree_mention = true
);

select 
    company_id
from 
    job_postings_fact
where  
    job_no_degree_mention = true;


with company_job_count as(
    SELECT 
        company_id,
        count(*) as total_job_counts
    from 
        job_postings_fact
    group BY    
        company_id
)

select company_dim.name as company_name,
    company_job_count.total_job_counts
from company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id
order by total_job_counts desc;


select name, count(company_dim.company_id) as job_count
from company_dim
left join job_postings_fact 
on job_postings_fact.company_id = company_dim.company_id
group by name
order by job_count desc;



with skill_type as(
    select skill_id,
    count(*) as skill_count
from skills_job_dim
group by skill_id
)

select skills_dim.skills, skill_type.skill_count
from skills_dim
left join skill_type
on skill_type.skill_id = skills_dim.skill_id
order by skill_type.skill_count desc
limit 5;

select skill_id,
count(*) as skill_count
from skills_job_dim
group by skill_id
order by skill_count desc

select 
    skills_dim.skills,
    top_skills.skill_count
from skills_dim
inner join(
    select skill_id,
count(*) as skill_count
from skills_job_dim
group by skill_id
order by skill_count desc
limit 5
)as top_skills
on skills_dim.skill_id = top_skills.skill_id
ORDER BY
    top_skills.skill_count DESC;


select skills_dim.skills, count(*) as skill_count
from skills_dim
left join skills_job_dim
on skills_job_dim.skill_id = skills_dim.skill_id
group by skills_dim.skills
order by skill_count desc
limit 5;

select count(*) as skill_count,
    skills_dim.skills
from 
    job_postings_fact as j
inner join skills_job_dim on skills_job_dim.job_id = j.job_id
inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
where 
    job_work_from_home = true and j.job_title_short = 'Data Analyst'
GROUP BY
     skills_dim.skills
order by 
    skill_count desc
limit 5;




select 
    job_title_short,
    company_id,
    job_location
from  
    january_jobs

UNION all

select 
    job_title_short,
    company_id,
    job_location
from  
    february_jobs
UNION all
select 
    job_title_short,
    company_id,
    job_location
from  
    march_jobs

select * from job_postings_fact
where EXTRACT (month from job_posted_date) in (1,2,3);

with q1_jobs as(
    select *
    from january_jobs
    where salary_year_avg > 70000
    union 
    select *
    from february_jobs
    where salary_year_avg > 70000
    union 
    select *
    from march_jobs
    where salary_year_avg > 70000
)

select skills_dim.skills, skills_dim.type,q1_jobs.job_id
from q1_jobs
inner join skills_job_dim on skills_job_dim.job_id = q1_jobs.job_id
inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
where q1_jobs.job_id is not null;


select *
from(
    select * 
    from january_jobs
    UNION ALL
    select * 
    from february_jobs
    UNION ALL
    select * 
    from march_jobs
) as quarter1_job_postings
where salary_year_avg > 70000 and 
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg desc;

with example as(
    select * 
    from january_jobs
    UNION ALL
    select * 
    from february_jobs
    UNION ALL
    select * 
    from march_jobs
)
select * from example
where salary_year_avg > 70000 and 
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg desc;


SELECT job_id,job_title, job_location,
    job_schedule_type,salary_year_avg,job_posted_date
from job_postings_fact
where salary_year_avg is not null and
    job_title = 'Data Analyst' and
    job_work_from_home = true
order by salary_year_avg desc
limit 10



