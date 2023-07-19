//*In this Project I clean and prepare data, I then go into an exploratory analysis examining multiple trends
the main component of this project was joining tables*/

 --Cleaning and prepping the data, the platform is null for the 2600 we will fix it up with a quick update command
UPDATE dbo.vgsalesTitles
		SET Platform = 2600 where Platform is NULL;
--Under year there are null values however I got an error trying to update in "Null" as the columns is a integer not Varhar 
 /* UPDATE dbo.vgsalesTitles
		SET year = 'N/A' where year is NULL; */
SELECT *
FROM dbo.vgsalesTitles 
join dbo.vgsales$
on dbo.vgsales$.Rank = dbo.vgsalesTitles.rank
ORDER BY platform;

--Lets check how many games each platform has using a Count function
SELECT Platform, COUNT(Platform) as 'titles on platform'
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
GROUP BY Platform
ORDER BY 'Titles on Platform' DESC
--Now lets check the global sales per platform
SELECT Platform, sum(Global_Sales) AS "GLOBAL SALES"
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
GROUP BY Platform
ORDER BY "GLOBAL SALES" DESC;

--This allows us to see the Name, Platform, Year and global sales ordered by sales for the top 100 games
SELECT Name, platform, Year, Global_Sales
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
WHERE dbo.vgsalesTitles.Rank <= 100
ORDER by Global_Sales desc

--Number of games in each genre
SELECT Genre, COUNT(Name) as 'Games per Genre'
FROM dbo.vgsalesTitles
GROUP BY Genre
Order by 'Games per Genre' desc;

--Sales per Genre
SELECT Genre, COUNT(Global_Sales) as 'Global Sales'
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
GROUP BY Genre
ORDER BY 'Global Sales' DESC

--Popularity by Genre see how it differs from NA, EU and JP
SELECT Genre, SUM(NA_Sales) as 'North America Popularity', SUM(EU_Sales) 'Europe Popularity', SUM(JP_Sales) 'Japan Popularity', SUM(Global_Sales) as 'Global Popularity'
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
WHERE dbo.vgsalesTitles.Rank <= 100
GROUP BY Genre
ORDER BY 'Global Popularity' desc

--sales split by year
SELECT Year, sum(Global_Sales) AS "GLOBAL SALES"
FROM dbo.vgsalesTitles
join dbo.vgsales$
ON dbo.vgsales$.Rank = dbo.vgsalesTitles.Rank
GROUP BY Year
ORDER BY Year