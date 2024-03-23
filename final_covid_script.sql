use Covid_Project;


UPDATE final_data_complete 
set continent = 'World'
where location ='World';

UPDATE final_data_complete 
set continent = 'Asia'
where location ='Asia';

UPDATE final_data_complete 
set continent = 'Africa'
where location ='Africa';

UPDATE final_data_complete 
set continent = 'North America'
where location ='North America';

UPDATE final_data_complete 
set continent = 'South America'
where location ='South America';

UPDATE final_data_complete 
set continent = 'Oceania'
where location ='Oceania';

UPDATE final_data_complete 
set continent = 'Europe'
where location ='Europe';

UPDATE final_data_complete 
set continent = 'European Union'
where location ='European Union';


DELETE from final_data_complete 
where location = 'High income';

delete from final_data_complete 
where location = 'Low income';

delete from final_data_complete 
WHERE location = 'Lower middle income';

delete from final_data_complete 
where location = 'Upper middle income';




-- 1. Highest Deaths by Country using a CTE

with Covid_Countries as
	(select location, date , total_deaths as Deaths, 
	sum(total_deaths) over
		(PARTITION by location
		order by location, date) as RollingDeathCount
	from final_data_complete fdc 
	where location != 'World'
		AND location != 'North America'
		AND location != 'South America'
		AND location != 'Oceania'
		AND location != 'Africa'
		AND location != 'Asia'
		AND location != 'Europe'
		AND location != 'European Union')
select *
from Covid_Countries;


with Covid_Countries as
	(select location, date , total_deaths as Deaths, 
	sum(total_deaths) over
		(PARTITION by location
		order by location, date) as RollingDeathCount
	from final_data_complete fdc 
	where location != 'World'
		AND location != 'North America'
		AND location != 'South America'
		AND location != 'Oceania'
		AND location != 'Africa'
		AND location != 'Asia'
		AND location != 'Europe'
		AND location != 'European Union')
select location, max(Deaths) as Total_Deaths 
from Covid_Countries
group by location ;




-- 2. Highest Deaths by Continent using a CTE
with Covid_Continents as
	(select *
	from final_data_complete fdc
	where location = 'World'
		OR location = 'North America'
		OR location = 'South America'
		OR location = 'Oceania'
		OR location = 'Africa'
		OR location = 'Asia'
		OR location = 'Europe'
		OR location = 'European Union')
select continent, max(total_deaths) as Total_Deaths 
from Covid_Continents 
group by continent
order by Total_Deaths desc;


-- 3. Percent of Deaths from Total Cases Worldwide
select sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths,round(sum(new_deaths)/sum(new_cases), 4) * 100 as Death_Percentage
from final_data_complete fdc
where location = 'World';



-- 4. Countries with highest infection rate
select date, location, population, max(total_cases) as Infected_Count,
		round(max(total_cases/population*100), 2) as InfectionPercentage
from final_data_complete fdc
where location != 'World'
	AND location != 'North America'
	AND location != 'South America'
	AND location != 'Oceania'
	AND location != 'Africa'
	AND location != 'Asia'
	AND location != 'Europe'
	AND location != 'European Union'
group by date, population , location
order by 2, 5 desc;



with Covid_Countries as
	(select location, date, population, people_vaccinated
	from final_data_complete fdc 
	where location != 'World'
		AND location != 'North America'
		AND location != 'South America'
		AND location != 'Oceania'
		AND location != 'Africa'
		AND location != 'Asia'
		AND location != 'Europe'
		AND location != 'European Union')
select location, date, population ,(people_vaccinated /population)* 100 as percent_vaccinated
from final_data_complete
group by location, date, population, people_vaccinated 
having percent_vaccinated  > 0
order by location, percent_vaccinated ;





select location, date, population, new_cases 
from final_data_complete
where location != 'World'
		AND location != 'North America'
		AND location != 'South America'
		AND location != 'Oceania'
		AND location != 'Africa'
		AND location != 'Asia'
		AND location != 'Europe'
		AND location != 'European Union';
