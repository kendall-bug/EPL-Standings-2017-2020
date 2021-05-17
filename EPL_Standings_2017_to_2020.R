# read and import files
library(tidyverse)
library(lubridate)

# function 
EPL_Standings <- function(date, Season) {
  
  #  if statement is used so the function knows which CSV file to read depending on the season that the user inputs 
  if(Season == "2019/20") {
    Season <- read_csv(url("http://www.football-data.co.uk/mmz4281/1920/E0.csv"))
  } else if(Season == "2018/19") {
    Season <- read.csv(url("http://www.football-data.co.uk/mmz4281/1819/E0.csv"))
  } else if (Season == "2017/18") {
    Season <- read.csv(url("http://www.football-data.co.uk/mmz4281/1718/E0.csv")) 
  } 
  
  #filter(Date < "Date") %>% NEED TO SWITCH FORMAT TO BE DAY MONTH YEAR, NOT EUROPEAN DATE!!
  
  # temporary placeholder to test date variable 
  # date <- "10-01-2019" # (remove this when you build the final function)
  
  date = mdy(date)  # use mdy here based on input format for the fucntion argument in the placeholder on line 18
  
  Season <- Season %>% 
    mutate(Date = dmy(Date)) %>%  
    filter(Date <= date) 
  
  # create dummy variables for each type of win and loss      
  HomeTeamDF <- Season %>%
    rename(GS = FTHG) %>% 
    rename(GA = FTAG) %>% 
    mutate(HomeWins = ifelse(FTR == "H",1,0)) %>% 
    mutate(HomeLoss = ifelse(FTR == "A",1,0)) %>%
    mutate(HomeDraw = ifelse(FTR == "D",1,0)) %>%
    mutate(TeamName = HomeTeam) 
  
  
  AwayTeamDF <- Season %>%
    rename(GS = FTAG) %>% 
    rename(GA = FTHG) %>% 
    mutate(AwayLoss = ifelse(FTR == "H",1,0)) %>% 
    mutate(AwayWins= ifelse(FTR == "A",1,0)) %>% 
    mutate(AwayDraw = ifelse(FTR == "D",1,0)) %>%
    mutate(TeamName = AwayTeam) 
  
  # join the home and away DFs together
  join <- full_join(HomeTeamDF, AwayTeamDF)  
  
  epl_output <- join %>%  # use the joined data for summary calculations and return to df called epl_output
    group_by(TeamName) %>%
    summarize(
      
      # calculating for the record variable for the whole season, tallying up dummy variables to use as inputs for record
      # home record + away record = total season record
      HomeWinsSum = sum(HomeWins, na.rm = T), # add the na.rm = T argument to all sum functions to omit NAs from calculation
      HomeLossSum = sum(HomeLoss, na.rm = T),
      HomeDrawSum = sum(HomeDraw, na.rm = T),
      AwayLossSum = sum(AwayLoss, na.rm = T),
      AwayWinSum = sum(AwayWins, na.rm = T),
      AwayDrawSum = sum(AwayDraw, na.rm = T),
      HomeRec = paste(HomeWinsSum, HomeLossSum, HomeDrawSum, sep = "-"), #paste the results fromt the sums
      AwayRec = paste(AwayWinSum, AwayLossSum, AwayDrawSum, sep = "-"),
      TotalWins = sum(HomeWinsSum,AwayWinSum, na.rm = T), 
      TotalLoss = sum(HomeLossSum,AwayLossSum, na.rm = T),
      TotalDraw = sum(HomeDrawSum,AwayDrawSum, na.rm = T),
      Record = paste(TotalWins,TotalLoss,TotalDraw, sep="-"), #combine home and away record
      GS = sum(GS, na.rm = T), #goals scored
      GA = sum(GA, na.rm = T), #goals allowed
      
      # matches played        
      MatchesPlayed = sum(TotalWins,TotalLoss,TotalDraw, na.rm = T)) %>%
    
    # now that all summarized variables are calculated, the remaining calculations should be done using mutate
    mutate(
      
      # points, points per match, and point percentage. 3 for win, 1 for draw, 0 for loss.
      Points = ((TotalWins*3) + TotalDraw),
      PPM = (Points/MatchesPlayed),
      PtPct = (Points / (3*MatchesPlayed)),
      
      # goals scored and allowed per match variables
      GSM = (GS/MatchesPlayed),
      GAM = (GA/MatchesPlayed)
    ) %>% 
    
    
    # Display the standings in descending order according to the number of points per match. 
    # IF two teams have the same number of points per match, the teams should appear in DESCENDING
    # order according to the number of points per match, then total wins, 
    # then goals scored per match and finally ASCENDING according to goals allowed per match.
    arrange(desc(PPM), desc(TotalWins), desc(GSM), GAM) %>% 
    
    # SELECT ONLY THE VARIABLES OF INTEREST!!!!!
    select(TeamName, Record, HomeRec, AwayRec, MatchesPlayed, Points, PPM, PtPct, GS, GSM, GA, GAM)# Last10, Streak)
  
}


# call the function. Enter the date and season you are wanting to observe.
Results <- EPL_Standings("12/8/2019","2019/20")

# print results in new DF
View(Results)
  