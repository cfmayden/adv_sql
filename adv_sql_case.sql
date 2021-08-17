'''Case statements are SQLs version of an IF this THEN that statement. Case statements have three parts -- a WHEN clause, a THEN clause, and an ELSE clause. The first part -- the WHEN clause -- tests a given condition, say, x = 1. If this condition is TRUE, it returns the item you specify after your THEN clause. You can create multiple conditions by listing WHEN and THEN statements within the same CASE statement.''' 
CASE 
WHEN
WHEN 
THEN
ELSE
END

'''If you want to test multiple logical conditions in a CASE statement, you can use AND inside your WHEN clause. EXAMPLE BELOW'''

SELECT date, hometeam_id, awayteam_id, 
    CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
        THEN 'Chelsea home win'
    WHEN awayteam_id = 8455 AND home_goal < awayteam_id
        THEN 'Chelsea away win'
    ELSE 'Loss or tie' END AS outcome
FROM match 
WHERE hometeam_id = 8455 OR awayteam_id = 8455;

'''When testing logical conditions, its important to carefully consider which rows of your data are part of your ELSE clause, and if theyre categorized correctly. Heres the same CASE statement from the previous slide, but the WHERE filter has been removed. Without this filter, your ELSE clause will categorize ALL matches played by anyone, who dont meet these first two conditions, as Loss or tie :(. Here are the results of this query. A quick look at it shows that the first few matches are all categorized as Loss or tie, but neither the hometeam_id or awayteam_id belong to Chelsea.'''
'''The easiest way to correct for this is to ensure you add specific filters in the WHERE clause that exclude all teams where Chelsea did not play. Here, we specify this by using an OR statement in WHERE,'''
'''
7. What are your NULL values doing?
Lets say were only interested in viewing the results of games where Chelsea won, and we dont care if they lose or tie. Just like in the previous example, simply removing the ELSE clause will still retrieve those results -- and a lot of NULL values.

8. Where to place your CASE?
To correct for this, you can treat the entire CASE statement as a column to filter by in your WHERE clause, just like any other column. In order to filter a query by a CASE statement'''

SELECT date, hometeam_id, awayteam_id, 
    CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
        THEN 'Chelsea home win'
    WHEN awayteam_id = 8455 AND home_goal < awayteam_id
        THEN 'Chelsea away win'
    ELSE 'Loss or tie' END AS outcome
FROM match 
WHERE CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
        THEN 'Chelsea home win'
    WHEN awayteam_id = 8455 AND home_goal < awayteam_id
        THEN 'Chelsea away win' END IS NOT NULL;

'''CASE statements with aggregate functions. CASE statements can be used to create columns for categorizing data, and to filter your data in the WHERE clause. You can also use CASE statements to aggregate data based on the result of a logical test.'''

'''Lets say you wanted to prepare a summary table'''

SELECT 
    season,
    COUNT(CASE WHEN hometeam_id = 8650
        AND home_goal > away_goal
        THEN id END) AS home_wins
    FROM match
    GROUP BY season;

'''The difference begins in your THEN clause. Instead of returning a string of text, you return the column identifying the unique match id. When this CASE statement is inside the COUNT function, it COUNTS every id returned by this CASE statement.'''

'''you can use the SUM function to calculate a total of any value. Let's say we're interested in the number of home and away goals that Liverpool scored in each season. '''

SELECT 
    season,
    SUM( CASE WHEN hometeam_id = 8650
    THEN home_goal END) AS home_goals,
    SUM(CASE WHEN awayteam_id - 8650
    THEN away_goal END) AS away_goals
FROM match
GROUP BY season;

'''The second key application of CASE with AVG is in the calculation of percentages. This requires a specific structure in order for your calculation to be accurate.'''
'''What percentage of Liverpools games did they win in each season? '''

SELECT 
    season,
    AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
    WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
    END) AS pct_homewins,
    AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
    WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0 END) AS pct_awaywins
FROM match
GROUP BY season;

SELECT 
    season,
    ROUND(AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
    WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
    END),2) AS pct_homewins,
    ROUND(AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
    WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0 END), 2) AS pct_awaywins
FROM match
GROUP BY season;