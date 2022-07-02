select * from CovidProject..Sheet1$

--select data that we will use

select location, date, total_cases, new_cases, total_deaths, population
from CovidProject..Sheet1$
order by 1, 2

--Looking at Death Percentage of those who contaracted Covid in Each Country
--Total Cases Vs Total Deaths

select location,  sum(total_cases) as TotalCases,  sum(cast(total_deaths as bigint)) as TotalDeaths , (sum(cast(total_deaths as bigint))/sum(total_cases))*100 as DeathPercentage
from CovidProject..Sheet1$
where continent is not NULL
group by location 
order by 1, 2

---Looking at total cases vs total deaths (Death Percentage) in Kenya
--- Percentage of people that have died of Covid in Kenya

select location, date, new_cases, total_cases, new_deaths, total_deaths, ((total_deaths)/(total_cases))*100 as DeathPercentage
from CovidProject..Sheet1$
where location like '%ken%'
order by 1, 2 DESC

--Daily Infection Rates in each country

select location, date, population, max(total_cases) as TotalCases, (max(total_cases)/population)*100 as PercentagePopulationInfected
from CovidProject..Sheet1$
where continent is not NULL
group by location, population, date
order by PercentagePopulationInfected DESC



--Looking at Countries with Highest Infection Rate compared to Population

select location as Country, sum( new_cases) as InfectionCases, population, round((sum( new_cases)/(population))*100,2) as PercentagePopulationInfected
from CovidProject..Sheet1$
where continent is not NULL
group by location, population
order by PercentagePopulationInfected DESC



-- Showing Countries with Highest Death Count Compared to  Population

select location, sum( cast(new_deaths as bigint)) as TotalDeathCases, population, round((sum( cast(new_deaths as bigint))/(population))*100,2) as DeathPercentagePopulation
from CovidProject..Sheet1$
where continent is not NULL
group by location, population
order by DeathPercentagePopulation DESC

-- Showing Countries with Highest Death Count

select location, sum(cast( new_deaths as bigint)) as TotalDeathCases 
from CovidProject..Sheet1$
--where continent is not NULL
where location not in ('Oceania','South America','Lower middle income','North America','Asia', 'World', 'Low income', 'Africa', 'European Union', 'International', 'Upper middle income', 'Europe', 'High income'  )
group by location
order by TotalDeathCases DESC

select location, sum(cast( new_deaths as bigint)) as TotalDeathCases 
from CovidProject..Sheet1$
where continent is not NULL
group by location
order by TotalDeathCases DESC

select * from CovidProject..Sheet1$

--Death Count Per Continent

select continent, sum(cast( new_deaths as bigint)) as TotalDeathCases 
from CovidProject..Sheet1$
where continent is not  NULL
group by continent
order by TotalDeathCases desc

select location, sum(cast( new_deaths as bigint)) as TotalDeathCases 
from CovidProject..Sheet1$
where continent is  NULL and
location not in ('Lower middle income', 'World', 'Low income',  'European Union', 'International', 'Upper middle income', 'High income'  )
group by location
order by TotalDeathCases desc



---GLOBAL NUMBERS

--World deaths

select  sum( new_cases) as TotalGlobalCases, sum(cast(new_deaths as bigint)) as TotalGlobalDeaths, round((sum( cast(new_deaths as bigint))/sum(new_cases))*100,2) as DeathPercentage
from CovidProject..Sheet1$
where continent is not NULL and
 location not in ('South America','Lower middle income','North America','Asia', 'World', 'Low income', 'Africa', 'European Union', 'International', 'Upper middle income', 'Europe', 'High income' )
 
 select * from CovidProject..Sheet1$
 order by location 
 

--- Daily Death Rates Globally

select date, sum( new_cases) as TotalGlobalCases, sum(cast(new_deaths as bigint)) as TotalGlobalDeaths, round((sum( cast(new_deaths as bigint))/sum(new_cases))*100,2) as DailyDeathPercentage
from CovidProject..Sheet1$
where continent is not NULL
group by date
order by 1 


---VACCINATIONS



--- Looking at Percentage of  Population Vaccinated in each Country

select location, population, MAX(cast(people_vaccinated as bigint)) as PopulationVaccinated,( MAX(cast(people_vaccinated as bigint))/population)*100 as PercentageVaccinated
from CovidProject..Sheet1$
where location not in ('South America','Lower middle income','North America','Asia', 'World', 'Low income', 'Africa', 'European Union', 'International', 'Upper middle income', 'Europe', 'High income' )
 group by location, population
order by PopulationVaccinated desc

--Looking at Percentage of  Population Vaccinated in Kenya

select population, MAX(cast(people_vaccinated as bigint)) as PopulationVaccinated,( MAX(cast(people_vaccinated as bigint))/population)*100 as PercentageVaccinated
from CovidProject..Sheet1$
where location like '%keny%'
group by location, population
--order by PopulationVaccinated desc

--- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Location nvarchar(255),
Population numeric,
TotalPopulationVaccinated numeric,
TotalPercentageVaccinated float
)

insert into #PercentPopulationVaccinated
select location, population, MAX(cast(people_vaccinated as bigint)) as PopulationVaccinated,( MAX(cast(people_vaccinated as bigint))/population)*100 as PercentageVaccinated
from CovidProject..Sheet1$
where location not in ('South America','Lower middle income','North America','Asia', 'World', 'Low income', 'Africa', 'European Union', 'International', 'Upper middle income', 'Europe', 'High income' )
 group by location, population
order by PopulationVaccinated desc


select * from #PercentPopulationVaccinated


--creating view to store data for later visualizations

CREATE VIEW 

PercentPopulationVaccinated 
as
select location, population, MAX(cast(people_vaccinated as bigint)) as PopulationVaccinated,( MAX(cast(people_vaccinated as bigint))/population)*100 as PercentageVaccinated
from CovidProject..Sheet1$
where location not in ('South America','Lower middle income','North America','Asia', 'World', 'Low income', 'Africa', 'European Union', 'International', 'Upper middle income', 'Europe', 'High income' )
 group by location, population

