select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%state%'
order by 1,2


--looking at total cases vs population
select location, date, total_cases, population, (total_cases/population)*100 as PercentageOfHavingCovid
from CovidDeaths
where location like '%state%'
order by 1,2

--looking at countries that has the highest infection rate compared to population

select location, population, max(total_cases), max((total_cases/population)*100) as PercentageOfHavingCovid
from CovidDeaths

group by location,population
order by PercentageOfHavingCovid desc

-- looking at countries with highest death count
select location, max(cast(total_deaths as int)) as totalDeath
from CovidDeaths
where continent is not Null
group by location
order by  totalDeath desc

-- looking at continent with highest death count
select continent, max(cast(total_deaths as int)) as totalDeath
from CovidDeaths
where continent is not Null
group by continent
order by  totalDeath desc



--Global numbers

select date, sum(new_cases) NewCases, SUM(cast( new_deaths as int)) NewDeaths,SUM(cast( new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1


-- looking at total population vs vaccintaions
select dea.continent, dea.location,dea.date, population, new_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations va
	on va.location = dea.location
	and va.date = dea.date
where dea.continent is not null
order by 2,3


with popvsvac(continent, location, date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, population, new_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations va
	on va.location = dea.location
	and va.date = dea.date
where dea.continent is not null
)

select * , RollingPeopleVaccinated/population *100
from popvsvac
order by 2,3

