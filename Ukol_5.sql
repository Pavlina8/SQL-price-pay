--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--pomocne
select * from countries c 
--order by country;
where country like'%Cze%';
select * from economies e 
where country like'%Cze%';

--prikaz
with vystup as
(select 	tst.year,
		tst.country,
		tst.hdp, 
		tpt.prumerna_mzda, 
		tpt.name_food,
		tpt.avg_price_food 
		from t_secondary_table tst
join t_primarni_tabulka tpt on tpt.year_price =tst.year
where country like'%Cze%')
select avg(prumerna_mzda) as mzda,
	  avg(avg_price_food) as cena_potravin,
	  avg(hdp) as HDP,
	  year
from vystup
group by year
order by year;


