-- create database PortfolioCovid;

-- use PortfolioCovid;

select * from coviddeaths
group by date
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population from coviddeaths
order by 1,2;

-- Looking at total cases VS total deaths in percentage
select location, date, (total_deaths/total_cases)*100 as death_percentage from coviddeaths
where location like 'Afgh%'
order by 3;

-- Looking at total cases VS population
-- Shows how much percentage of people got covid
select location, date, (total_cases/population)*100 as covid_percentage from coviddeaths
-- where location like 'Afgh%'
order by 3;

-- Looking at countries with highest infection rated compared to population 
select location, max(total_cases) as high_infection, population, max(total_cases/population)*100 as highinfection_perc
from coviddeaths
group by location 
order by 4;

-- Countries with highest death count per population
select location , max(cast(total_deaths as INT)) as high_death from coviddeaths
where continent is not null
group by location
order by 2;

-- Highest death per continent
select continent,max(cast(total_deaths as int)) as high_death from coviddeaths
where continent is not null
group by continent
order by 2 desc;

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 
from coviddeaths
order by 1,2;




-- Looking at total population vs vaccination
select a.date, a.continent, a.location, a.population, b.new_vaccinations,
sum(convert(int,b.new_vaccinations)) over(partition by location order by a.location,a.date) as rollingpeoplevaccinated
from coviddeaths as a
join covidvaccinations as b
on a.location = b.location and a.date = b.date
order by 1,3

-- Using CTE inside query should same no of column as outside query)
with popVSvacci( date, continent,location, population, new_vaccination, rollingpeoplevaccinated)
as
(select a.date, a.continent, a.location, a.population, b.new_vaccinations,
sum(convert(int,b.new_vaccinations)) over(partition by location order by a.location,a.date) as rollingpeoplevaccinated
from coviddeaths as a
join covidvaccinations as b
on a.location = b.location and a.date = b.date
where a.continent is not null)
select *, (rollingpeoplevaccinated/population)*100 from popVSvacci


-- TEMP table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
date datetime,
continent nvarchar(255),
location nvarchar(255),
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into #percentpopulationvaccinated
select a.date, a.continent, a.location, a.population, b.new_vaccinations,
sum(convert(int,b.new_vaccinations)) over(partition by location order by a.location,a.date) as rollingpeoplevaccinated
from coviddeaths as a
join covidvaccinations as b
on a.location = b.location and a.date = b.date
where a.continent is not null

select *, (rollingpeoplevaccinated/population)*100 from #percentpopulationvaccinated


-- Creating VIEW to store data for later visualizations
create view percentpopulationvaccinated as
select a.date, a.continent, a.location, a.population, b.new_vaccinations,
sum(convert(int,b.new_vaccinations)) over(partition by location order by a.location,a.date) as rollingpeoplevaccinated
from coviddeaths as a
join covidvaccinations as b
on a.location = b.location and a.date = b.date
where a.continent is not null

select * from percentpopulationvaccinated










