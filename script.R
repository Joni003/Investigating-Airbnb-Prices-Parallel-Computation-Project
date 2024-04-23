# Host is super host

# Has 10 or more total listings

# Average review above 4.5 stars

# Check if command line arguments are provided
if (length(commandArgs(trailingOnly = TRUE)) != 1) {
    cat("usage: Rscript script.R <city_listing.csv> \n")
    quit(status = 1)
}


df = read.csv(commandArgs(trailingOnly = TRUE)[1])

desired_columns <- c("id", 
                     "host_id", 
                     "host_name", 
                     "host_since", 
                     "host_is_superhost", 
                     "host_listings_count", 
                     "host_total_listings_count", 
                     "review_scores_rating", 
                     "review_scores_accuracy", 
                     "review_scores_cleanliness", 
                     "review_scores_checkin", 
                     "review_scores_communication", 
                     "review_scores_location", 
                     "review_scores_value")


#Filter by desired columns from above
filtered_df <- df[, desired_columns]

# Filter by host being a superhost
filtered_df <- subset(filtered_df, host_is_superhost == "t")

# Filter by total listings greater than 10 for a single host
filtered_df = subset(filtered_df, host_total_listings_count >= 10)

# Filter by host having average review score greater than 4.5
filtered_df$avg_review_score <- rowMeans(filtered_df[, c("review_scores_rating", 
                                                         "review_scores_accuracy", 
                                                         "review_scores_cleanliness", 
                                                         "review_scores_checkin", 
                                                         "review_scores_communication", 
                                                         "review_scores_location", 
                                                         "review_scores_value")], na.rm = TRUE)

filtered_df <- filtered_df[filtered_df$avg_review_score >= 4.5, ]

# Get unique hosts
filtered_df <- filtered_df[!duplicated(filtered_df$host_id), ]

# Filter by host being an Airbnb host since before 2018
filtered_df$host_since <- as.Date(filtered_df$host_since)

filtered_df <- filtered_df[filtered_df$host_since < as.Date("2018-01-01"), ]

# Omit NA values
filtered_df <- na.omit(filtered_df)

# Prepare output file name
file_name <- sub("\\.csv$", "", basename(commandArgs(trailingOnly = TRUE)[1]))
output_file <- paste0(file_name, "_filtered", ".csv")

write.csv(filtered_df, output_file, row.names = FALSE)