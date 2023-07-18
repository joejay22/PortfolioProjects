SELECT * FROM dbo.vgsales$
--wanted to break down categories and see dinstinct values

SELECT DISTINCT(Genre) as "every genre"
from dbo.vgsales$;

SELECT DISTINCT(Platform) "every platform"
from dbo.vgsales$;

SELECT DISTINCT(Publisher) "every publisher"
from dbo.vgsales$  
 
/* Breaking down total sales by Platform */
SELECT Platform, COUNT (Global_sales) AS "GLOBAL SALES"
from dbo.vgsales$
GROUP BY Platform ORDER BY [GLOBAL SALES] desc;


--gonna check sales split by year
SELECT YEAR, COUNT (Global_sales) AS "GLOBAL SALES"
from dbo.vgsales$
GROUP BY Year ORDER BY Year desc

--Sales split by genre, see which is most popular
SELECT Genre, COUNT (Global_sales) AS "GLOBAL SALES"
from dbo.vgsales$
GROUP BY Genre ORDER BY [GLOBAL SALES] desc;