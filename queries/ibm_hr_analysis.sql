use ibm_hr_sales;

-- Customer demographics 
-- which age group dominates the company ?
select case when age between 18 and 25 then '18-25'
when age between 26 and 35 then '26-35'
when age between 36 and 45 then '36-45'
else'46+'
end as age_group,
count(*) as employee_count
from hr_attrition
group by age_group
order by employee_count desc;

-- Workforce gender balance

select gender , count(*) as total 
from hr_attrition
group by gender;

-- Income distribution by education 
select education , avg(monthlyincome) as avg_salary
from hr_attrition
group by education
order by avg_salary desc;


-- What is overall attrition rate ?
select count(*) as total_employees,
round(sum(case when attrition = 'Yes' then 1 else 0 end) * 100.0 / count(*) ,2) as attrition_percentage 
from hr_attrition;


-- Which department contributes most to overall attrition ?
select department , 
sum(case when attrition ='yes' then 1 else 0 end) as emp_left
from hr_attrition
group by department
order by emp_left DESC;



-- What is average tenure of employess who leave vs stay ?

select attrition , 
avg(YearsAtCompany) as avg_tenure ,
avg(TotalWorkingYears) as avg_total_experience
from hr_attrition
group by attrition;


-- Which salary band has highest attrition risk ?

select 
case when MonthlyIncome < 3000 then 'Low'
when MonthlyIncome between 3000 and 7000 then 'Medium'
else 'High'
end as salary_band ,
count(*) as total , sum(case when attrition ='yes' then 1 else 0 end) as attrition_total
from hr_attrition
group by salary_band 
order by attrition_total desc;


-- role of promotion in increase attrition 

SELECT 
CASE WHEN YearsSinceLastPromotion >= 3 THEN 'No Promotion 3+ Years'
ELSE 'Recently Promoted'
END AS Promotion_Status,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS emp_left
FROM hr_attrition
GROUP BY Promotion_Status;

-- which satisfaction metric differs most between employees who left vs stayed 

SELECT 
    'JobSatisfaction' AS Factor,
    ROUND(AVG(CASE WHEN Attrition='Yes' THEN JobSatisfaction END),2) AS Left_Avg,
    ROUND(AVG(CASE WHEN Attrition='No' THEN JobSatisfaction END),2) AS Stay_Avg
FROM hr_attrition

UNION ALL

SELECT 
    'WorkLifeBalance',
    ROUND(AVG(CASE WHEN Attrition='Yes' THEN WorkLifeBalance END),2),
    ROUND(AVG(CASE WHEN Attrition='No' THEN WorkLifeBalance END),2)
FROM hr_attrition;
