-- top 10 teams by number of wins 
SELECT
  winner AS team,
  COUNT(*) AS total_wins
FROM international_football_matches.default.clean_results
WHERE winner <> 'Draw'
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 10;

-- Average goals per match by year
SELECT
  year,
  AVG(total_goals) AS avg_goals
FROM international_football_matches.default.clean_results
GROUP BY year
ORDER BY year;

-- Home vs away vs draw
SELECT
  result,
  COUNT(*) AS total_matches 
FROM international_football_matches.default.clean_results
GROUP BY result;
