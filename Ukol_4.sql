--nejdrive si udelam prumer mezd, a prumer cen a k nim priradim hodnoty za minuly rok
--pote vypoctu procento minuly versus aktualni rok.
-- s pote mohu udelat rozdil procent mezim mzdou a cenou cenou potravin
with rocni_ceny as
(select 	avg(avg_price_food) as rocni_prumer_cen,
		lag (avg(avg_price_food)) over (order by year_price) as minuly_rok_cen,
          avg(prumerna_mzda) as rocni_mzdy, 
          lag (avg(prumerna_mzda)) over (order by year_price) as minuly_rok_mezd,
		year_price
from t_pavlina_kuncova_project_sql_primary_final tpt
group by year_price 
order by year_price)
select 	rocni_prumer_cen,
		minuly_rok_cen,
		rocni_mzdy,
		minuly_rok_mezd,
		(rocni_mzdy /(minuly_rok_mezd/100)-100) as procento_mzda,  -- o kolik se procentuelne zvedly mzdy
		(rocni_prumer_cen /(minuly_rok_cen/100)-100) as procento_ceny,
		(rocni_prumer_cen /(minuly_rok_cen/100)-100)-(rocni_mzdy /(minuly_rok_mezd/100)-100) as rozdil_cena_mzda
from rocni_ceny;
  

--POMOCNE PRIKAZY
select avg(avg_price_food) from t_pavlina_kuncova_project_sql_primary_final tpkpspf; --prumer vsech cen potravin za cele obdobi54.06

select avg(prumerna_mzda) from t_pavlina_kuncova_project_sql_primary_final tpkpspf ; --25688.75
where ((100 - (minuly_rok_cen / (rocni_prumer_cen / 100))) - (100 - (minuly_rok_mezd / (rocni_mzdy / 100)))) > 10
or((100 - (minuly_rok_cen / (rocni_prumer_cen / 100))) - (100 - (minuly_rok_mezd / (rocni_mzdy / 100))))<-10;
--neexistuje rok, kdy by narust  prumernych cen potravin byl vyrazne vyssi nez narust prumeru mezd za vsechna odvetvi
--ale v roce 2009 byl narust mezd o 10 procent vetsi nez narust cen potravin.
--PODIVAT SE NA ROK KTERY JE VYPLNENY NULL
select * from t_pavlina_kuncova_project_sql_primary_final;

-- tady si jeste delam odchylku od cen potravin pres prumer











