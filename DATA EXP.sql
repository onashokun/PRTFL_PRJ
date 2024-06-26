--SELECT *
--FROM CovidDeaths$
--ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations$
--ORDER BY 3,

--FILTERING TABLE
--SELECT location, date, total_cases,new_cases,total_deaths, population
--FROM CovidDeaths$
--ORDER BY 1,2

----TOTAL CASES VS TOTAL DEATHS - RATIO
--SELECT location, date, total_cases,total_deaths,(total_deaths/total_cases) * 100 AS DEATH_RATIO
--FROM CovidDeaths$
--WHERE location LIKE 'NIGERIA'
--ORDER BY 1,2

---- PERCENT OF POPULATION INFECTED
--SELECT location, date,population,total_cases,(total_cases/population) * 100 AS PERCENT_INFECTED
--FROM CovidDeaths$
--WHERE location LIKE 'NIGERIA'
--ORDER BY 1,2

----COUNTRIES WITH THE HIGHEST INFECTION RATE W.R.T POPULATION
--SELECT location,population,MAX(total_cases)  highest_infection_count, MAX((total_cases/population) * 100) AS MAX_PERCENT_INFECTED
--FROM CovidDeaths$
----WHERE location LIKE 'NIGERIA'
--GROUP BY location, population
--ORDER BY MAX_PERCENT_INFECTED DESC

----COUNTRIES WITH THE HIGHEST DEATH COUNT PER INFECTION RATE W.R.T POPULATION
--SELECT location,population,MAX(CAST(total_deaths as int))  highest_death_count, MAX((total_deaths/population) * 100) AS MAX_PERCENT_KILLED
--FROM CovidDeaths$
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY highest_death_count DESC

----PARTITION BY CONTINENT
--SELECT continent, MAX(population), MAX(CAST(total_deaths as int))  highest_death_count, MAX((total_deaths/population) * 100) AS MAX_PERCENT_KILLED
--FROM CovidDeaths$
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY highest_death_count DESC

----GLOBAL DATA
--SELECT date, SUM(new_cases) as SUM_NEW_CASES, SUM(CAST(new_deaths as int)) as SUM_NEW_DEATHS, SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100 AS DEATH_PERCENTAGE
--FROM CovidDeaths$
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2

----POPULATION VS AMOUNT VACCINATED PER COUNTRY PER DAY
--SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, SUM(CAST(CV.new_vaccinations as int)) OVER (Partition by CD.location ORDER BY CD.location, CD.date) as SUM_VACCINATED_PER_DAY--, 
----(SUM_VACCINATED_PER_DAY/population) *100
--FROM CovidDeaths$ CD
--JOIN CovidVaccinations$ CV
--	ON CD.location = CV.location
--	AND	CD.date =CV.date
--WHERE CD.continent IS NOT NULL
--ORDER BY 2,3;

----USE CTE
--WITH POPvsVAC(continent, Date, location, population, new_vaccinations,SUM_VACCINATED_PER_DAY)
--as
--(
--SELECT CD.continent,CD.date, CD.location, CD.population, CV.new_vaccinations, SUM(CAST(CV.new_vaccinations as int)) OVER (Partition by CD.location ORDER BY CD.location, CD.date) as SUM_VACCINATED_PER_DAY
--FROM CovidDeaths$ CD
--JOIN CovidVaccinations$ CV
--	ON CD.location = CV.location
--	AND	CD.date =CV.date
--WHERE CD.continent IS NOT NULL
--)
--SELECT *, (SUM_VACCINATED_PER_DAY/population)*100 AS PERCENTAGE_SUM_VACCINATED
--FROM POPvsVAC
--ORDER BY continent, location;

------SUM OF POPULATION VS AMOUNT VACCINATED PER COUNTRY
------USE CTE
--WITH POPvsVAC1(continent, location, SUM_POPULATION1, SUM_VACCINATED1)
--as
--(
--SELECT CD.continent, CD.location, CD.population, SUM(CAST(CV.new_vaccinations as numeric))
--FROM CovidDeaths$ CD
--JOIN CovidVaccinations$ CV
--	ON CD.location = CV.location
--	AND	CD.date =CV.date
--WHERE CD.continent IS NOT NULL
--GROUP BY CD.location, CD.continent, CD.population
--)
--SELECT *, (SUM_VACCINATED1/SUM_POPULATION1)*100 AS PERCENTAGE_SUM_VACCINATED
--FROM POPvsVAC1
--ORDER BY continent,location

--CREATING A VIEW TO STORE DATA FOR LATER
--CREATE VIEW PERCENT_POPULATION_VACCINATION AS
--SELECT CD.continent,CD.date, CD.location, CD.population, CV.new_vaccinations, SUM(CAST(CV.new_vaccinations as int)) OVER (Partition by CD.location ORDER BY CD.location, CD.date) as SUM_VACCINATED_PER_DAY
--FROM CovidDeaths$ CD
--JOIN CovidVaccinations$ CV
--	ON CD.location = CV.location
--	AND	CD.date =CV.date
--WHERE CD.continent IS NOT NULL
--ORDER BY 2,3
