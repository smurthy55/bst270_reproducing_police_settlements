## Code for Figure 1 of Cleveland case following Tamir's

figure1 <- function(cleveland){ #
#Columns are updated as follows. This has been adapted from the script provided within the cleveland_oh folder from the original GitHub

cleveland <- cleveland %>%
  rename(calendar_year = Year,
         amount_awarded = Amount,
         matter_name = `Case Name`,
         plaintiff_name = Payee,
         docket_number = `Case #`) %>%
  mutate(city= "Cleveland",
         state = "OH",
         incident_date = NA,
         incident_year = NA,
         other_expenses = NA,
         collection = NA,
         total_incurred = NA,
         claim_number = NA,
         court = NA,
         plaintiff_attorney = NA,
         location = NA,
         summary_allegations = NA,
         closed_date = NA,
         filed_date = NA,
         filed_year = NA,
         case_outcome = ...6) # Extraneous info about the case has been removed.

#Figure 1 highlights the Tamir Rice case. From the raw files, the author made the following adjustments to clean up the amount awarded
# The authors described within their cleveland_oh.R processing code the following: 
# Tamir Rice case - in the original dataset:
# - There are 5 payees in 2016 and 5 in 2017 that are all assigned amount of $6m. 
# - The authors stated that they approached processing it as follows, quoted directly from their script: "However we know that $6m was the total amount, split as $3m and $3m in each year. They gave us
# 1st installment payments in 2016 - we're going to replace the $6m in 2016 with the first installment figures.
# in 2017, we're going to collapse all the payees into 1 row for $3m - we don't want to impute 2nd installment 
# numbers for the second year"

#Reformatting the data for consistent numeric values in amount awarded column.

cleveland <- cleveland %>% 
  mutate(amount_awarded = case_when(
    ...6 == "1st installment 125000" & calendar_year == 2016 ~ 125000,
    ...6 == "1st installment 43673.18" & calendar_year == 2016 ~ 43673.18,
    ...6 == "1st installment 81326.82" & calendar_year == 2016 ~ 81326.82,
    ...6 == "1st installment 2481326.82" & calendar_year == 2016 ~ 2481326.82,
    ...6 == "1st installment 268673.18" & calendar_year == 2016 ~ 268673.18,
    TRUE ~ amount_awarded
  )) %>% 
  mutate(case_outcome = ...6) 

# The authors filtered out 2017 Tamir Rice payments for later collapsing them into the full dataset, with the exact commands as follows
tamir <- cleveland %>% filter(docket_number=="1:14-CV-319" & calendar_year == 2017)
cleveland_no_tamir <- cleveland %>% filter(docket_number!="1:14-CV-319" | calendar_year !=2017)

#Removed extra columns and collapsed Tamir Rice data. The cleaning steps provided were from the original preprocessing script 
tamir <- tamir %>% 
  mutate(case_outcome = ...6) %>% 
  select(-...6,-...7,-...8) %>% 
  mutate(amount_awarded = 3000000) 

#Unique values for tamir case
plaintiff_concat = paste(tamir$plaintiff_name, collapse = ",")

tamir <- tamir %>% mutate(plaintiff_name = plaintiff_concat) %>% distinct()

cleveland <- bind_rows(cleveland_no_tamir,tamir) 

# One other case where payment info was written as "87500.00/82090.61"
# unclear if they should be added together, so we're gonna save the second
# number as "other expenses" to be conservative
cleveland <- cleveland %>% 
  mutate(other_expenses = 
           ifelse(...6 == 82090.61, 82090.61, other_expenses),
         case_outcome = ifelse(...6==82090.61,"Amount paid listed as 87500.00/82090.61 originally",case_outcome)) %>% 
  select(-...6,-...7,-...8)  

cleveland <- cleveland %>% select(calendar_year,
                                  city,
                                  state,
                                  incident_date,
                                  incident_year,
                                  filed_date,
                                  filed_year,
                                  closed_date,
                                  amount_awarded,
                                  other_expenses,
                                  collection,
                                  total_incurred,
                                  case_outcome,
                                  docket_number,
                                  claim_number,
                                  court,
                                  plaintiff_name,
                                  plaintiff_attorney,
                                  matter_name,
                                  location,
                                  summary_allegations)

# CHECKS - these were consistent with provided values in the original script
# Time period of closed date? NA
# time period of calendar year or incident year or filed year if closed date missing
summary(cleveland$calendar_year) # Min 2010, max 2020

# Perfect duplicates? 0 duplicates
nrow(cleveland %>% group_by_all() %>% filter(n()>1))

# 6 duplicates on year, docket number, payee and matter name - 0 dups if we account for amount awarded so it doesnt seem like 
# a data entry issue, but multiple payments
dups <- cleveland %>% group_by(docket_number,plaintiff_name,matter_name,calendar_year) %>% filter(n()>1)

dups <- cleveland %>% group_by(docket_number,plaintiff_name,matter_name,calendar_year,amount_awarded) %>% filter(n()>1)

# Missing ness of variables
print(paste("There are",nrow(cleveland %>% filter(is.na(closed_date))),"rows missing closed date"))
print(paste("There are",nrow(cleveland %>% filter(is.na(calendar_year))),"rows missing calendar year"))
print(paste("There are",nrow(cleveland %>% filter(is.na(amount_awarded))),"rows missing amount awarded"))
print(paste("There are",nrow(cleveland %>% filter(amount_awarded==0)),"rows with amount awarded = 0"))
print(paste("There are",nrow(cleveland %>% filter(is.na(docket_number))),"rows missing docket number"))

# count cases
print("Total number of cases")
print(nrow(cleveland))

print("Total amount awarded")
sum(cleveland$amount_awarded)

##Edited script to visualize Figure 1 as follows. Winston v City, corresponding to matter_name variable, was colored in the plot.

# Assign colors based on whether the matter is "Winston v City"
cleveland <- cleveland %>%
  mutate(fill_color = ifelse(matter_name == "Winston v City", "highlight", "regular"))

##Used ggplot to visualize amount awarded from the Cleveland dataset from 2010-2019.
  plot_figure1 <- ggplot(cleveland, aes(x = factor(calendar_year), y = as.numeric(amount_awarded), fill = fill_color)) +
  geom_bar(stat = "identity", width = 0.6) +  # Adjusting bar width
  scale_fill_manual(values = c("highlight" = "#49C5B6", "regular" = "#6B3378")) +
  scale_x_discrete(
    breaks = unique(cleveland$calendar_year),
    labels = function(x) ifelse(x == 2010, "2010", paste0("'", substr(x, 3, 4))) 
  ) +
  scale_y_continuous(
    limits = c(0, 8000000),  # Set upper limit to 8 million
    breaks = seq(0, 8000000, by = 1000000),  # Set breaks every million
    labels = c("0", "1", "2", "3", "4", "5", "6", "7", "$8 million")  # Custom labels
  ) +
  labs(title = "Cleveland’s settlement amounts rose after Rice’s death",
       subtitle = "Annual cash payouts for court cases settled against the Cleveland police department, 2010-19",
       x = NULL,
       y = "Total amount paid in settlements") +
  annotate("text", x = 1, y = 5500000, label = "                            the case brought\nby Tamir Rice’s family after police\nkilled the 12-year-old in 2014,\nwas settled for $6 million paid out\nover 2016 and 2017.",
           hjust = 0, size = 4, color = "black", fontface = "bold") +
  annotate("text", x = 1, y = 6225000, label = "Winston v. City,",
           hjust = 0, size = 4, color = "#49C5B6", fontface = "bold") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.text.x = element_text(size = 12, color = "gray20"),
    axis.text.y = element_text(size = 12, color = "gray20"),
    axis.title.y = element_text(size = 12, face = "bold"),
    panel.grid.major.y = element_line(color = "gray80"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(size = 10, color = "gray50"),
    legend.position = "none", panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white")
  ) +
  annotate("text", x = 5, y = -500000, label = "FiveThirtyEight/The Marshall Project", size = 3, color = "gray60") +
  annotate("text", x = 9.5, y = -500000, label = "SOURCE: CLEVELAND POLICE DEPARTMENT", size = 3, color = "gray60")
  return(plot_figure1)
}
