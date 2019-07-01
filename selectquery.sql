SELECT population FROM world WHERE name = 'France'
SELECT name, population FROM world WHERE name IN ('Brazil', 'Russia', 'India', 'China');
SELECT name, area FROM world WHERE area BETWEEN 250000 AND 300000
SELECT name, continent, population FROM world
SELECT name FROM world WHERE population = 64105700
SELECT name, LENGTH(name), continent, LENGTH(continent), capital, LENGTH(capital) FROM world WHERE name LIKE 'G%'