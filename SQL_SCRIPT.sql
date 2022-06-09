
create database Portfolio;
use portfolio;
select * from covid_vaccination;


select * from covid_deaths;

select * from covid_deaths
order by 3,4;


select * from covid_vaccination
order by 3,4;

select Location, date, total_cases,new_cases,total_deaths, population
from covid_deaths
order by 1,2;

-- Looking at Total Cases Vs Total Deaths

select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths
where location like '%india%'
order by 1,2 ;
-- Looking at Countries with Highest Infection rate compared to population

Select Location, Population, Max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from covid_deaths
group by Location, Population
order by PercentPopulationInfected desc;




-- Showing Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as float)) as TotalDeathCount
from covid_deaths
where continent is not null
group by Location
order by TotalDeathCount desc;

-- Showing Countries With Highest Death Count per Population
Select Location,continent, MAX(cast(Total_deaths as float)) as TotalDeathCount
from covid_deaths
where continent is not NULL
group by location
order by TotalDeathCount desc;

--  Breaking Things by Continent
Select Continent, MAX(cast(Total_deaths as float)) as TotalDeathCount
from covid_deaths
where continent is not NULL
group by continent
order by TotalDeathCount desc;


create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
select * from PercentPopulationVaccinated;

Insert into PercentPopulationVaccinated 
Select covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccination.new_vaccinations
, SUM(covid_vaccination.new_vaccinations) OVER (Partition by covid_deaths.Location Order by covid_deaths.location, covid_deaths.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From covid_deaths
Join covid_vaccination
	On covid_deaths.location = covid_vaccination.location
	and covid_deaths.date = covid_vaccination.date
where covid_deaths.continent is not null 
order by 2,3;


-- Creating View to store data for later visualizations
Create view PercentPopulationVaccinated as 
Select covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccination.new_vaccinations
,sum(covid_vaccination.new_vaccinations) over (Partition by covid_deaths.location order by covid_deaths.location,
covid_deaths.date) as rolling_people_vaccinated
from covid_vaccination
Join covid_deaths
     On covid_deaths.location=covid_vaccination.location
     and covid_deaths.date=covid_vaccination.date
where covid_deaths.continent is not null
order by 2,3;
select * from PercentPopulationVaccinated;

