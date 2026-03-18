alter table healthcare_data
add column Length_of_stay int;

update healthcare_data
set length_of_stay = datediff(Discharge_Date,Date_of_Admission);

alter table healthcare_data
ADD column Age_group varchar(50);

update healthcare_data
set Age_group= case when Age between 0 and 18 then 'Child' 
when age between 18 and 30 then 'Young Adult' 
when age between 30 and 50 then 'Adult' 
when age between 50 and 70 then 'Elderly' else 'Old' end;

set SQL_SAFE_UPDATES=1;
set SQL_SAFR_UPDATES=0;

#what age group visit the hospital the most?
select Age_group, count(distinct(name)) as Number_of_visits 
from healthcare_data
group by Age_group
order by Number_of_visits desc;

#what certain medical conditions are more common in certain age groups
select Medical_Condition, Age_group, count(distinct(name)) as total_patients,
case when Age_group = 'Elderly' then '50-70' 
when Age_group = 'Adult' then '30-50'
when Age_group = 'Young Adult' then '18-30'
when Age_group ='old' then '70~' 
else '0-18'end as Age_bracket 
from healthcare_data 
group by medical_condition, Age_group
order by total_patients desc;

# what certain medical conditions are more common by gender?
select gender, medical_condition, count(*) total_count
from healthcare_data
group by gender, Medical_Condition
order by total_count desc;

#which hospitals admit the most patients (Top 5 only)
select hospital, count(*) as 
Total_patients
from healthcare_data
group by hospital order by Total_patients desc
limit 5;

#which admission types are most common 
select admission_type, count(*) as Total_count
from healthcare_data
group by Admission_Type
order by total_count desc;

#which medical conditions cost the most treat
select Medical_Condition, avg(Billing_Amount) as avg_bills
from healthcare_data
group by Medical_Condition
order by avg_bills desc;

#which insurance provides pay the highest billing amount (top 5)
select Insurance_Provider, avg(Billing_Amount) as bills
from healthcare_data
group by Insurance_Provider
order by bills desc
limit 5;

#INDIVIDUALS IN DEBT
select*
from healthcare_data
where Billing_Amount < '1';

#which hospitals genarate the highest revenue (top 10)
select hospital, avg(Billing_Amount) as avg_bills
from healthcare_data
group by hospital
order by avg_bills desc
limit 10;

#which medications are most prescribed
select medication,count(*) as total_count
from healthcare_data
group by medication;

# Are certain more blood types linked to certain medical conditions?
select Blood_type, Medical_Condition, count(Medical_Condition) as total_cases
from healthcare_data
group by Blood_Type, Medical_Condition
order by total_cases desc;



create view healthcare_dashboards as
(select Name, age, gender, medical_condition, Date_of_Admission, hospital,Insurance_Provider,Billing_Amount,Admission_Type,
Medication,Test_Results,length_of_stay,Age_group
from healthcare_data);
