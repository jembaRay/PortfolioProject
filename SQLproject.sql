use PortfolioProject;

select * from CovidDeaths  ;

--select Data that we are going to be using

select Location,date ,total_cases,new_cases,total_deaths,population
From CovidDeaths ;

--loooking at cases vs total death
--shows likehood of dying if you contract covid in your country
select Location,date ,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent
From CovidDeaths where location like '%states%';

--looking at total cases vs population
select Location,date ,total_cases ,population,(total_cases/population)*100 as cases_percent
From CovidDeaths where location like '%states%';

---looking at countries with highest infection rate
select Location ,Max(total_cases) as HighestInfectionCount,population,MAX((total_cases/population))*100 as cases_percent
From CovidDeaths 
group by location,population
order by cases_percent desc;

---looking at countries with highest Death rate
select Location ,Max(cast(total_deaths as int)) as HighestDeathCount
From CovidDeaths 
where continent is not null
group by location
order by HighestDeathCount desc;

--looking at continents with highest Death rate but we will will use location with no continent depending on our data set but for our BI drill down we will use the next
--select location ,Max(cast(total_deaths as int)) as HighestDeathCount
--From CovidDeaths 
--where continent is null
--group by location
--order by HighestDeathCount desc;


--looking at continents with highest Death rate
select continent ,Max(cast(total_deaths as int)) as HighestDeathCount
From CovidDeaths 
where continent is not null
group by continent
order by HighestDeathCount desc;


--showing continents with highest death count per population
select continent,population ,Max(cast(total_deaths as int)) as HighestDeathCount
From CovidDeaths 
where continent is not null
group by continent,population
order by HighestDeathCount desc;

--Global numbers(total cases and total deaths per day around the word)
select date ,sum(new_cases) as sum_of_cases,sum(cast(new_deaths as int)) as sum_of_deaths,--otal_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent
sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percent
From CovidDeaths 
--where location like '%states%';
where continent is not null
group by date
order by sum_of_cases

--looking at total population vs vaccination

select cov.continent,cov.location,cov.date,cov.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by cov.location Order by cov.location,cov.Date) 
as Rollingpoeplevaccinated,sum(convert(int,vac.new_vaccinations)) over (partition by cov.location Order by cov.location,cov.Date)
/population*100 as percetage_vaccination 
from 
CovidDeaths cov join CovidVaccination vac 
on cov.location=vac.location and cov.date=vac.date where cov.continent is not null 
order by 2,3


--creating view to store data for later visualisation

create view PercentPopulation as
select cov.continent,cov.location,cov.date,cov.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by cov.location Order by cov.location,cov.Date) 
as Rollingpoeplevaccinated,sum(convert(int,vac.new_vaccinations)) over (partition by cov.location Order by cov.location,cov.Date)
/population*100 as percentage_vaccination 
from 
CovidDeaths cov join CovidVaccination vac 
on cov.location=vac.location and cov.date=vac.date where cov.continent is not null 
order by 2,3

select * from PercentPopulation

