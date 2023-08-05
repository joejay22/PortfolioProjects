Select *
from dbo.Richest_atheletes
---------------------------------------------------------------------------------------------------------------------------

--lets see how many athletes per sport within the richest 300
SELECT DISTINCT(sport) AS sport, COUNT(sport) AS 'athletes per sport'
FROM dbo.Richest_atheletes
GROUP BY sport
ORDER BY 'athletes per sport'

---------------------------------------------------------------------------------------------------------------------------
--now lets check what the average earning is for each sport
SELECT DISTINCT(sport) AS sports, AVG(earnings_$million) AS 'average earning per sport'
FROM dbo.Richest_Atheletes
GROUP BY Sport
ORDER BY 'average earning per sport' desc

--have the earnings gone up per year? inflation contracts
SELECT DISTINCT(Year) AS Year, AVG(earnings_$million) AS 'average earning per year' 
FROM dbo.Richest_Atheletes
GROUP BY Year
ORDER BY 'average earning per year' DESC

--ammount of individuals for each nationality and average Earnings based on Nationality
Select distinct(Nationality), count(Nationality) AS 'Indiduals of each nationality' , AVG(earnings_$million) as 'Average Earnings for each nationality in Millions$'
from dbo.Richest_atheletes
group by Nationality
ORDER BY 'Average Earnings for each nationality in Millions$' DESC