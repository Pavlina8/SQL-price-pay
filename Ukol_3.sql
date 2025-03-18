--3.Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
--tady je jak mezirocne klesaji a rostou ceny potravin o procenta z roku na rok. tedy zachyceni  opravdu mezirocniho rustu a poklesu behem let
--scitaji se procenta, mezirocne, rekla bych, ze nejvice tento postup ukazuje, jak se ceny hybou z roku na rok.
with prumerne_rocni_ceny as
(select 	avg (avg_price_food) prumer_hodnot,
		lag (avg(avg_price_food)) over (order by name_food, year_price) as minula_cena,
		lag (name_food) over (order by name_food,year_price) as minula_potravina,
		year_price,
		name_food
from t_pavlina_kuncova_project_sql_primary_final tpt 
group by name_food, year_price
order by name_food, year_price)
select sum((prumer_hodnot - minula_cena)/prumer_hodnot) as procento, --soucet procent za vsechny roky
    	  name_food
from prumerne_rocni_ceny
where year_price != 2006 and name_food not like '%Jakostn%'  --je treba vynechat jakostni vino jelikoz nema vsechny roky sledovani
group by name_food
order by procento ;

select distinct name_food,year_price from t_pavlina_kuncova_project_sql_primary_final tpt 
order by name_food, year_price ;
--druha moznost je porovnani prvniho a posledniho roku a odmocnit na roky mezi nimi, to udava prumerny mezirocni rust.
with prvni_rok as
(select 	avg (avg_price_food) as rok2006,  --prumer za rok 2006
		year_price as prni_rok,
		name_food as jidlop
from t_pavlina_kuncova_project_sql_primary_final tpt 
where year_price = 2006 
group by name_food, year_price
order by name_food, year_price),
posledni_rok as 						--prumer za rok 2018
(select 	avg (avg_price_food) as rok2018,
		year_price,
		name_food as jidlopos
from t_pavlina_kuncova_project_sql_primary_final tpt 
where year_price = 2018
group by name_food, year_price
order by name_food, year_price)

select rok2006, rok2018, jidlop, jidlopos, power(rok2018/rok2006,0.0909) as procentualni_rust 
from prvni_rok
join posledni_rok on jidlop = jidlopos
order by procentualni_rust;
--v tabulce je pote videt, ktere potraviny prumerne rostly behem let nejpomaleji, jelikoz nejde udelat 11 odmocnina,
-- tak jsem pouzila 0,0909 coz je 1/11
