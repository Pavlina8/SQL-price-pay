--2.UKOL
--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--Za odvětví
select * from t_pavlina_kuncova_project_sql_primary_final tpkpspf ;
--mleko za platy v odvetvi
select 
	prumerna_mzda/avg_price_food as mnoztvi_potravin,
	name_food,
	year_price,
	name_industry
	from t_pavlina_kuncova_project_sql_primary_final tpt 
where name_food like '%Mléko%' and year_price = 2006
or name_food like '%Mléko%' and year_price = 2018;
--chleb za platy odvetvi
select 
	prumerna_mzda/avg_price_food as mnoztvi_potravin,
	name_food,
	year_price,
	name_industry
	from t_pavlina_kuncova_project_sql_primary_final tpt 
where name_food like '%Chléb%' and year_price = 2006
or name_food like '%Chléb%' and year_price = 2018;

--Za celou CR
with mzdy_CR as 
(select 
     avg (prumerna_mzda) as prumer_mezd,
     avg (avg_price_food) as prumer_potravin,
	--((avg(prumerna_mzda))/avg_price_food) as mnoztvi_potravin,
     (avg (prumerna_mzda)/avg(avg_price_food)) as pocet,
	name_food,
	year_price
	from t_pavlina_kuncova_project_sql_primary_final tpt 
--where name_food like '%Mléko%' and year_price = 2006
--or name_food like '%Mléko%' and year_price = 2018
group by year_price, name_food) 
select *  
from  mzdy_CR
where name_food like '%Mléko%'and year_price = 2006 or name_food like '%Chl%' and year_price = 2006 
or name_food like '%Chl%' and year_price = 2018 or name_food like '%Mléko%'and year_price = 2018;



select * from t_pavlina_kuncova_project_sql_primary_final tpkpspf 
order by year_price, name_food ;


