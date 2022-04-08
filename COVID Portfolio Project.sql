-- COVID-19 Data Exploration

-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

-- */
Select *
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 3,4

-- Select data to start with

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 1, 2

-- Total cases vs total deaths
-- Shows likelihood of dying if you contract COVID-19 in Canada

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%canada%'
Order by 1, 2


-- Looking at the total cases vs population
-- Shows what percentage of the Canadian population infected with COVID-19

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where location like '%canada%'
Order by 1, 2

-- Looking at countries with highest infection rate compared to population

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by location, population
Order by PercentPopulationInfected desc

-- Showing countries with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths$
where continent is not null
Group by location, population
Order by totaldeathcount desc

-- Breaking things down by continent

-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
Order by totaldeathcount desc

-- Global numbers

Select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 1, 2

-- Use CTE
-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as  rollingpeoplevaccinated
From PortfolioProject.. CovidDeaths$ dea
Join PortfolioProject.. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

-- Using CTE to perform calculations on Partition By in previous query

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as  rollingpeoplevaccinated
From PortfolioProject.. CovidDeaths$ dea
Join PortfolioProject.. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
select *, (rollingpeoplevaccinated/population)*100
From popvsvac

-- Using Temp Table to perform calculation on Partition By in previous query

Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as  rollingpeoplevaccinated
From PortfolioProject.. CovidDeaths$ dea
Join PortfolioProject.. CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

select *, (rollingpeoplevaccinated/population)*100
From #percentpopulationvaccinated

-- Creating a view to store data for later visualizations

create view percentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as  rollingpeoplevaccinated
From PortfolioProject.. CovidDeaths$ dea
Join PortfolioProject.. CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


-- For Tableau project, Table 1

Select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 1, 2

-- Table 2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is null
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
Order by TotalDeathCount desc

-- Table 3

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths$
Group by location, population
Order by PercentagePopulationInfected desc

-- Table 4

Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject.. CovidDeaths$
Group by location, population, date
Order by PercentPopulationInfected desc





