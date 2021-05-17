# EPL-Standings-2017-2020
The English Premier League (EPL) is a major soccer league in Great Britain consisting of 20 teams. The season begins in August and concludes in May with each team playing each other team exactly twice (home and away). This R script contains a function with the inputs of date and season that returns the league standings for the date and season specified (ie: who is ranked #1 in the league on a certain date). Data from the English Premier League's 2017/2018, 2018/2019, and 2019/2020 seasons are captured in the script.  

The resulting dataframe prints the standings in descending order according to the number of points per match earned up to and including the date parameter value.  When two teams have the same number of points per match, the teams appear in descending order according to the number of points per match, then wins, then goals scored per match and finally ascending according to goals allowed per match.

Initial dataset terms:

o	FTHG – the number of goals scored by the home team
o	FTAG – the number of goals scored by the away team
o	FTR – the result of the match (H indicates home team won, A indicates the away team won, D indicates a draw or tie)

Results dataframe terms:

o	Record as wins-loses-ties (Record) 
o	Home record (HomeRec)
o	Away record (AwayRec)
o	Total matches played (MathchesPlayed)
o	Total points scored (Points), 
o	Points scored per match (PPM), 
o	Point percentage = points / 3 * the number of games played, (PtPct)
o	Goals scored (GS),
o	Goals scored per match (GSM)
o	Goals allowed (GA)
o	Goals allowed per match (GAM) 
