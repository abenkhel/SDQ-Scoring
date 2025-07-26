###################################################
##### Strengths & Difficulties Questionnaire ######
###################################################

#Adapted form source: https://sdqinfo.org/c9.html
#a .csv file with individual responses in each row, and SDQ items in each column. Refer to READ.me for naming conventions.
### Run the following to begin analysis ###

#Set working directory to data file location
library("tidyverse")
library("dplyr")

#Load data
df <- read_csv("SDQ Data.csv") #Change file name
head(df)
names(df)

#Function to return NA if "at least 3 items per scale" is not met
score_scale <- function(items) {
  valid_items <- items[!is.na(items)]
  if (length(valid_items) >= 3) {
    return(floor(0.5 + mean(valid_items) * 5))
  } else {
    return(NA_real_)
  }
}

df_Score <- df %>%
  #Reverse-code the following 5 items
  mutate(
    qobeys   = recode(obeys, '0'=2, '1'=1, '2'=0),
    qreflect = recode(reflect, '0'=2, '1'=1, '2'=0),
    qattends = recode(attends, '0'=2, '1'=1, '2'=0),
    qfriend  = recode(friend, '0'=2, '1'=1, '2'=0),
    qpopular = recode(popular, '0'=2, '1'=1, '2'=0)
  ) %>%
  #Calculate scale scores
  rowwise() %>%
  mutate(
    emotion = score_scale(c(somatic, worries, unhappy, clingy, afraid)), #Emotional problems
    conduct = score_scale(c(tantrum, qobeys, fights, lies, steals)), #Conduct problems
    hyper   = score_scale(c(restles, fidgety, distrac, qreflect, qattends)), #Hyperactivity
    peer    = score_scale(c(loner, qfriend, qpopular, bullied, oldbest)), #Peer problem
    prosoc  = score_scale(c(consid, shares, caring, kind, helpout)), #Prosocial (not used)
    ebdtot  = emotion + conduct + hyper + peer #Total difficulties score
  ) %>%
  ungroup()

#Internalising and Externalising Scores:
df_Score <- df_Score %>%
  mutate(
    pexternal = conduct + hyper, #Externalising: Conduct + Hyperactivity
    pinternal = emotion + peer) #Internalising: Emotional + Peer Problems

#Summary statistics for total difficulties
df_Score %>% 
  summarise(
    Min = min(ebdtot, na.rm = TRUE),
    Max = max(ebdtot, na.rm = TRUE),
    Mean = mean(ebdtot, na.rm = TRUE),
    SD = sd(ebdtot, na.rm = TRUE),
    N = sum(!is.na(ebdtot))
    )

write.csv(df_Score, "SDQ R Scoring.csv") #Export output


#############################
## Checking Missing values ##
#############################

#To check rows of data with a missing value and count of how are missing in each domain (5 items in each category):
#Missing count per category for each row (last 5 columns of df_missing)
df_missing <- df %>%
  mutate(
    missing_emotion = rowSums(is.na(select(., somatic, worries, unhappy, clingy, afraid))),
    missing_conduct = rowSums(is.na(select(., tantrum, obeys, fights, lies, steals))),
    missing_hyper   = rowSums(is.na(select(., restles, fidgety, distrac, reflect, attends))),
    missing_peer    = rowSums(is.na(select(., loner, friend, popular, bullied, oldbest))),
    missing_prosoc  = rowSums(is.na(select(., consid, shares, caring, kind, helpout)))
  )
#Filter rows where more than 3 items are missing in any category
df_filter_missing <- df_missing %>%
  filter(
    missing_emotion > 3 |
      missing_conduct > 3 |
      missing_hyper > 3 |
      missing_peer > 3 |
      missing_prosoc > 3
  )
df_filter_missing #View

#############################
##   Categorical scoring   ##
#############################

#Categorical classification:
df_Cat <- df_Score %>%
  mutate(
    #Emotional problems
    emotion_cat = case_when(
      emotion <= 3 ~ "Close to average",
      emotion == 4 ~ "Slightly raised",
      emotion <= 6 ~ "High",
      emotion <= 10 ~ "Very high",
      TRUE ~ NA_character_),
    #Conduct problems
    conduct_cat = case_when(
      conduct <= 2 ~ "Close to average",
      conduct == 3 ~ "Slightly raised",
      conduct <= 5 ~ "High",
      conduct <= 10 ~ "Very high",
      TRUE ~ NA_character_),
    #Hyperactivity
    hyper_cat = case_when(
      hyper <= 5 ~ "Close to average",
      hyper <= 7 ~ "Slightly raised",
      hyper == 8 ~ "High",
      hyper <= 10 ~ "Very high",
      TRUE ~ NA_character_),
    #Peer problems
    peer_cat = case_when(
      peer <= 2 ~ "Close to average",
      peer == 3 ~ "Slightly raised",
      peer == 4 ~ "High",
      peer <= 10 ~ "Very high",
      TRUE ~ NA_character_),
    #Prosocial (note: reverse logic - lower = more concern)
    prosoc_cat = case_when(
      prosoc >= 8 ~ "Close to average",
      prosoc == 7 ~ "Slightly lowered",
      prosoc == 6 ~ "Low",
      prosoc <= 5 ~ "Very low",
      TRUE ~ NA_character_),
    #Total difficulties score
    ebdtot_cat = case_when(
      ebdtot <= 13 ~ "Close to average",
      ebdtot <= 16 ~ "Slightly raised",
      ebdtot <= 19 ~ "High",
      ebdtot <= 40 ~ "Very high",
      TRUE ~ NA_character_))
df_Cat %>% select(ebdtot, ebdtot_cat, emotion, emotion_cat) %>% head()

write.csv(df_Cat, "SDQ R Categories.csv") #Export output
