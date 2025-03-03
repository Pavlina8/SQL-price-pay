--vytvoreni prumernych cen za rok
CREATE table t_prumerne_ceny AS 
select 	avg(value) as prumerna_cena_potravin, 
		category_code,
		date_part('year',date_from) as year_price
from czechia_price cp
group by category_code,date_part('year',date_from)
order by category_code, year_price;

select * from czechia_price cp ;

--mezivypocet pro me, abych vedela co kde mam a jak se to chova 
select count(1) from t_prumerne_ceny;
select * from t_prumerne_ceny
order by date_part, category_code;
select min(year_price) from t_prumerne_ceny;
select max(year_price) from t_prumerne_ceny;
select count(1) from czechia_price;

--vytvoreni tabulky prumernych platu za rok a odvetvi

select distinct unit_code from czechia_payroll
where calculation_code = 100
and value_type_code = 5958;

CREATE table t_prumerne_mzdy AS 
select  	avg(value) as prumerna_mzda,
		industry_branch_code,
		payroll_year
from czechia_payroll cp 
where VALUE_type_code = 5958 and 
industry_branch_code is not null and 
calculation_code  = 100
group by industry_branch_code, payroll_year
order by industry_branch_code, payroll_year;

select * from t_prumerne_mzdy tpc  order by payroll_year, industry_branch_code ;


--VYTVORENI NEJDULEZITEJSI TABULKY t_{jmeno}_{prijmeni}_project_SQL_primary_final.
create table t_pavlina_kuncova_project_SQL_primary_final as
select tpm.*,
	  cpib.name as name_industry,
       tpc.prumerna_cena_potravin as AVG_price_food,
       tpc.year_price,
       tpc.category_code,
       cpc.name as name_food
from t_prumerne_mzdy tpm 
left join t_prumerne_ceny tpc on tpm.payroll_year = tpc.year_price
left join czechia_payroll_industry_branch cpib on cpib.code = tpm.industry_branch_code
left join czechia_price_category cpc on cpc.code = tpc.category_code;
select * from t_pavlina_kuncova_project_SQL_primary_final order by payroll_year, industry_branch_code;