library(tidyverse)
library(fitzRoy)
library(readr)

# create a list of integers for past 5 years
years <- seq(2017, 2024, 1)

game_list = list()
player_list = list()

# loop through each year and get the data using fetch_results
for (i in 1:length(years)) {
  game_list[[i]] <- fetch_results(season = years[i])
  player_list[[i]] <- fetch_player_stats(season = years[i])
}

# combine the list into a single data frame
games_df <- bind_rows(game_list)
players_df <- bind_rows(player_list)

# save data to csv
write_csv(games_df, "game_results.csv")
write_csv(players_df, "player_stats.csv")

fixtures <- fetch_fixture(season = 2025)

# Convert list-columns to character
fixtures <- data.frame(lapply(fixtures, function(col) {
  if (is.list(col)) {
    return(sapply(col, toString))  # Convert lists to comma-separated strings
  }
  return(col)
}), stringsAsFactors = FALSE)

# Write to CSV
write.csv(fixtures, "2025_fixtures.csv", row.names = FALSE)


ladder_status <- list()

unique <- games_df %>% distinct(games_df['round.year'], games_df['round.roundNumber'])

for (i in 1:nrow(unique)){
  year <- as.integer(unique[i,'round.year'])
  roundnum <- as.integer(unique[i,'round.roundNumber'])
  tryCatch(
    {
    ladder_status[[i]] <- fetch_ladder(season=year, round=roundnum, source='afltables')
    cat(sprintf("fetching: Season %d Round %d\n", year, roundnum))
    },
    error = function(e){
      ladder_status[[i]] <- "finals"
    }
  )
  }

ladder_df <- bind_rows(ladder_status)
write.csv(ladder_df, "ladder_stats.csv")
