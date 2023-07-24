use hr_analytics;    # Create Schemas

select * from hr_1;   # Import Data
select * from hr_2;

# Merge hr_1 & hr_2 dataset using join and stored it into 'hr' table 
create table hr as 
select * from hr_1
join hr_2
on hr_1.EmployeeNumber = hr_2.`Employee ID`;

select * from hr;

alter table hr add column AttritionRate INT;

# set global sql_mode ="";


# Add column named as AttritionRate
Update hr set hr.AttritionRate = 
case when Attrition = 'Yes' then 1
else 0
end;
                                
select * from hr;

-- 1.Average Attrition Rate for all department
select Department,concat(round(avg(AttritionRate*100),2),"%") as Average_AttritionRate 
from hr group by Department order by Average_AttritionRate desc;

-- 2.Average Hourly rate of Male Research Scientist
select jobrole from hr;
select JobRole,Gender,avg(HourlyRate) as Avg_HourlyRate 
from hr where Gender = "Male" AND JobRole = "Research Scientist";

-- 3.Attrition rate Vs Monthly income stats
select Department, round(avg(case when AttritionRate = "Yes" Then MonthlyIncome End),2) as Avg_MonthlyIncome,
concat(round(avg(AttritionRate*100),2),"%") as Attrition_Rate
from hr group by Department;

-- 4.Average working years for each Department
select Department, avg(TotalWorkingYears) as Avg_WorkingYears 
from hr group by Department;

-- 5.Job Role Vs Work life balance
SELECT
  IFNULL(JobRole, 'Total') AS JobRole,
  COUNT(CASE WHEN WorkLifeBalance = 1 THEN 1 END) AS Poor,
  COUNT(CASE WHEN WorkLifeBalance = 2 THEN 2 END) AS Fair,
  COUNT(CASE WHEN WorkLifeBalance = 3 THEN 3 END) AS Good,
  COUNT(CASE WHEN WorkLifeBalance = 4 THEN 4 END) AS Excellent,
  COUNT(*) AS Total_Count
FROM hr GROUP BY JobRole;

-- 6.Attrition rate Vs Year since last promotion relation
select 
Department,
concat(
	format(
			count(case when YearsSinceLastPromotion between 0 and 5 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 0 and 5 then 1 end)*100,2),'%'
	) as '0-5 Years',
concat(
	format(
			count(case when YearsSinceLastPromotion between 6 and 10 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 6 and 10 then 1 end)*100,2),'%'
	) as '06-10 Years',
 concat(
	format(
			count(case when YearsSinceLastPromotion between 11 and 15 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 11 and 15 then 1 end)*100,2),'%'
	) as '11-15 Years',
concat(
	format(
			count(case when YearsSinceLastPromotion between 16 and 20 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 16 and 20 then 1 end)*100,2),'%'
	) as '16-20 Years',
concat(
	format(
			count(case when YearsSinceLastPromotion between 21 and 25 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 21 and 25 then 1 end)*100,2),'%'
	) as '21-25 Years',
concat(
	format(
			count(case when YearsSinceLastPromotion between 26 and 30 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion between 26 and 30 then 1 end)*100,2),'%'
	) as '26-30 Years',
concat(
	format(
			count(case when YearsSinceLastPromotion > 30 and AttritionRate = 1 then 1 end ) /
            count(case when YearsSinceLastPromotion > 30 then 1 end)*100,2),'%'
	) as 'Above 30'
from hr
group by Department;

-- 7.Count of employee Based on Educational Fields
select EducationField,count(EmployeeNumber) as No_Employee 
from hr group by EducationField 
order by No_Employee desc ; 

-- 8.Gender Based Percentage of Employee
SELECT
  gender,
  COUNT(*) AS total_count,
 concat(round((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM hr),2),"%") AS percentage
FROM hr GROUP BY gender;

-- 9.Department wise No. of Employees
select Department, count(EmployeeNumber) as No_of_Employees 
from hr group by Department order by No_of_Employees desc;

-- 10.Total Employees
select count(EmployeeNumber) as Total_Employees from hr;



                                





