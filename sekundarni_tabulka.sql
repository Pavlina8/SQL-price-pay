CREATE table t_pavlina_kuncova_project_SQL_secondary_final AS     --a t_{jmeno}_{prijmeni}_project_SQL_secondary_final 
select  	e.country,
				e.year,
	 			c.continent,
	 			e.gdp as HDP,
	 			e.gini as GINI,
	 			e.population 
from economies e 
join countries c on c.country = e.country
where c.continent like 'Europe'
and year > 1999 and e.year < 2022
order by country ;
--tato tabulka se vytvaret vicemene nemusi, ale v zadani je ze mame tabulku vytvorit, tak ji vytvarim
select 	tst.year,
		tst.country,
		tst.hdp, 
		tpt.prumerna_mzda, 
		tpt.name_food,
		tpt.avg_price_food 
from t_secondary_table tst
join t_primarni_tabulka tpt on tpt.year_price =tst.year
where country like '%Cze%';
