--VYTVORENI DOCASNE TABULKY KDE ODENDAM DUPLICITY
CREATE temporary table bez_duplicit as
select distinct prumerna_mzda,
			payroll_year,
			industry_branch_code
from t_pavlina_kuncova_project_sql_primary_final tpt ;

select * from bez_duplicit
order by industry_branch_code, payroll_year;

with platy_oddeleni as				--KDYZ BEZ POMOCNE TABULKY do with distinct, TAK to FUNGUJE BLBE protoze se napoji minule a ty josu jine
(select 	*,
		lag (industry_branch_code) over (order by industry_branch_code,payroll_year) as minule_odvetvi,
		lag (prumerna_mzda) over (order by industry_branch_code,payroll_year) as minuly_plat,  --lag nam vrati hodnoty z minuleho roku
		case 
			when prumerna_mzda > lag (prumerna_mzda) over (order by industry_branch_code,payroll_year)  then 1 
			when industry_branch_code != lag (industry_branch_code) over (order by industry_branch_code,payroll_year)  then null 
			else 0
		end as trend_platu
from bez_duplicit
where industry_branch_code is not null
order by industry_branch_code, payroll_year)
--select * from platy_oddeleni po
--join czechia_payroll_industry_branch cpib on cpib.code = po.industry_branch_code
--order by industry_branch_code, payroll_year
select sum(trend_platu) as pocet_rostoucich_roku, cpib.name as odvetvi,
case 
	when sum(trend_platu) > 20  then 'rostou' 
	when sum(trend_platu) > 18  then 'klesaji 1 az 2 roky'
	when sum(trend_platu) > 16  then 'klesaji 3 az 4 roky'
	else 'klesaji vic jak 4 roky'
end as rust_platu	
from platy_oddeleni po
join czechia_payroll_industry_branch cpib on cpib.code = po.industry_branch_code
group by cpib.name
order by sum(trend_platu) desc;
