library(dplyr)
library(ggplot2)
library(klaR)
library(readxl)

df <- read_excel("premier_league_team_sponsors_2025_2026.xlsx")

#Filter to only team sponsors (remove Premier League-wide sponsors)
teams_df <- df[df$Team != "Premier League", ]

#Get unique teams
team_list <- unique(teams_df$Team)

# Create empty data frame for results
Team <- character()
Gambling <- character()
SponsorType <- character()
TechPresence <- character()
Financial <- character()
Sports <- character()
Tourism <- character()
Airlines <- character()

#Loop through each team and extract features
for (team in team_list) {
  # Get data for this team
  team_data <- teams_df[teams_df$Team == team, ]
  
  # Count gambling sponsors
  gambling_count <- sum(grepl("Gambling", team_data$Industry, ignore.case = TRUE))
  
  # Check if has public sponsors
  has_public <- sum(team_data$`Stock Ticker` != "Private") > 0
  
  # Check for different industries
  has_tech <- any(grepl("Tech|Software|IT|Information Technology", team_data$Industry, ignore.case = TRUE))
  has_financial <- any(grepl("Financial|Banking|Insurance", team_data$Industry, ignore.case = TRUE))
  has_sports <- any(grepl("Sport|Sporting Goods | Clothing | Sportswear", team_data$Industry, ignore.case = TRUE))
  has_tourism <- any(grepl("Tourism|Travel", team_data$Industry, ignore.case = TRUE))
  has_airlines <- any(grepl("Airline", team_data$Industry, ignore.case = TRUE))
  
  # Categorize
  gambling_level <- if(gambling_count == 0) {
    "None"
  } else if(gambling_count == 1) {
    "One"
  } else {
    "Multiple"
  }
  
  sponsor_type <- if(has_public) "Public" else "Private"
  tech_status <- if(has_tech) "Tech" else "NoTech"
  financial_status <- if(has_financial) "Financial" else "NoFinancial"
  sports_status <- if(has_sports) "Sports" else "NoSports"
  tourism_status <- if(has_tourism) "Tourism" else "NoTourism"
  airlines_status <- if(has_airlines) "Airlines" else "NoAirlines"
  
  # Add to vectors
  Team <- c(Team, team)
  Gambling <- c(Gambling, gambling_level)
  SponsorType <- c(SponsorType, sponsor_type)
  TechPresence <- c(TechPresence, tech_status)
  Financial <- c(Financial, financial_status)
  Sports <- c(Sports, sports_status)
  Tourism <- c(Tourism, tourism_status)
  Airlines <- c(Airlines, airlines_status)
}

#Create results data frame
results <- data.frame(
  Team = Team,
  Gambling = Gambling,
  SponsorType = SponsorType,
  TechPresence = TechPresence,
  Financial = Financial,
  Sports = Sports,
  Tourism = Tourism,
  Airlines = Airlines,
  stringsAsFactors = FALSE
)

print("=== YOUR DATA FOR CLUSTERING ===")
print(results)

#Prepare clustering data (select features and convert to factors)
cluster_data <- data.frame(
  Gambling = as.factor(results$Gambling),
  SponsorType = as.factor(results$SponsorType),
  TechPresence = as.factor(results$TechPresence),
  Financial = as.factor(results$Financial),
  Sports = as.factor(results$Sports)
)

#Run K-modes with 3 clusters
set.seed(42)
km <- kmodes(cluster_data, modes = 3, iter.max = 10)

results$Cluster <- km$cluster

print(table(results$Cluster))



# Convert cluster to factor for better plotting
results$Cluster <- as.factor(results$Cluster)


cluster_colors <- c("#FF6B6B", "#4ECDC4", "#95E1D3")




# Prepare data for industry breakdown
industry_summary <- data.frame()

for (i in 1:3) {
  cluster_subset <- results[results$Cluster == i, ]
  
  industry_summary <- rbind(industry_summary,
                            data.frame(
                              Cluster = paste0("Cluster ", i),
                              Industry = c("Gambling", "Tech", "Financial", "Sports", "Tourism", "Airlines"),
                              Count = c(
                                sum(cluster_subset$Gambling != "None"),
                                sum(cluster_subset$TechPresence == "Tech"),
                                sum(cluster_subset$Financial == "Financial"),
                                sum(cluster_subset$Sports == "Sports"),
                                sum(cluster_subset$Tourism == "Tourism"),
                                sum(cluster_subset$Airlines == "Airlines")
                              )
                            ))
}


league_positions <- data.frame(
  Team = c(
    "Arsenal",
    "Manchester City", 
    "Aston Villa",
    "Chelsea",
    "Crystal Palace",
    "Manchester United",
    "Liverpool",
    "Sunderland",
    "Everton",
    "Brighton & Hove Albion",
    "Tottenham Hotspur",
    "Newcastle United",
    "Bournemouth",
    "Fulham",
    "Brentford",
    "Nottingham Forest",
    "Leeds United",
    "West Ham United",
    "Burnley",
    "Wolverhampton Wanderers"
  ),
  Position = c(
    1,   # Arsenal - 36 pts
    2,   # Manchester City - 34 pts
    3,   # Aston Villa - 33 pts
    4,   # Chelsea - 28 pts
    5,   # Crystal Palace - 26 pts
    6,   # Manchester United - 26 pts
    7,   # Liverpool - 26 pts
    8,   # Sunderland - 26 pts
    9,   # Everton - 24 pts
    10,  # Brighton - 23 pts
    11,  # Tottenham - 22 pts
    12,  # Newcastle - 22 pts
    13,  # Bournemouth - 21 pts
    14,  # Fulham - 20 pts
    15,  # Brentford - 20 pts
    16,  # Nottingham Forest - 18 pts
    17,  # Leeds United - 16 pts
    18,  # West Ham - 13 pts
    19,  # Burnley - 10 pts
    20   # Wolves - 2 pts
  )
)

# Merge with your clustering results
results_with_position <- merge(results, league_positions, by = "Team", all.x = TRUE)

# Calculate a "premium sponsor score" based on industries
results_with_position <- results_with_position %>%
  mutate(
    PremiumScore = 
      (SponsorType == "Public") * 3 +           # Public sponsors = +3
      (TechPresence == "Tech") * 2 +            # Tech presence = +2
      (Financial == "Financial") * 2 +          # Financial = +2
      (Gambling == "One") * 1 +                 # One gambling = +1
      (Gambling == "Multiple") * -1 +           # Multiple gambling = -1
      (Sports == "Sports") * 3 +
      (Airlines == "Airlines") * 3 +            #Airlines = +3
      (Tourism == "Tourism") * 3,               #Tourism = +3
    
    # Gambling Dependency Score (alternative X-axis)
    GamblingScore = 
      (Gambling == "None") * 0 +
      (Gambling == "One") * 1 +
      (Gambling == "Multiple") * 2
  )


# Define cluster colors
cluster_colors <- c("#FF6B6B", "#4ECDC4", "#95E123")

# Create the plot
p <- ggplot(results_with_position, 
            aes(x = PremiumScore, y = Position, color = Cluster)) +
  
  # Add points
  geom_point(size = 5, alpha = 0.7) +
  
  # Reverse Y-axis (1st place at top)
  scale_y_reverse(breaks = 1:20) +
  
  #team labels
  geom_text(aes(label = Team), hjust = -0.1, vjust = 0, size = 3, show.legend = FALSE) +
  

  scale_color_manual(values = cluster_colors,
                     labels = c("Cluster 1", "Cluster 2", "Cluster 3")) +
  

  labs(
    title = "Premier League Position vs Sponsor Quality",
    subtitle = "Do premium sponsors correlate with better league positions?",
    x = "Premium Sponsor Score",
    y = "League Position",
    color = "Cluster"
  ) +
  
  # Theme
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray30"),
    legend.position = "right",
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  ) 



print(p)
