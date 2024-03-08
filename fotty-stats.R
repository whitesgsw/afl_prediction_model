library(tidyverse)
library(fitzRoy)
library(readr)

# create a list of integers for past 5 years
years <- seq(2019, 2023, 1)

game_list = list()
player_list = list()

# loop through each year and get the data using fetch_results
for (i in 1:length(years)) {
  game_list[[i]] <- fetch_results(season = years[i])
  player_list[[i]] <- fetch_player_stats(season = years[i])
}

# combine the list into a single data frame
games_df <- bind_rows(list)
players_df <- bind_rows(player_list)

# save data to csv
write_csv(games_df, "game_results.csv")
write_csv(players_df, "player_stats.csv")

# build an ml to predict next seasons results
fixtures <- fetch_fixtures(season = 2024)

# train the model based on the home team, away team, home ground and result
model <- lm(result ~ home_team + away_team + home_ground, data = games_df)
