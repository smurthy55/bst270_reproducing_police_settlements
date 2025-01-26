#comparison of allegation summaries in Cincinnati and Charleston
figure2 <- function(cincinnati, charleston){
  
  #Take charleston and cincinnati columns used for generating figure
  charleston_short <- charleston[,c("city", "amount_awarded", "summary_allegations")]
  
  
  cincinnati_short <- cincinnati[,c("city", "amount_awarded", "summary_allegations")]
  
  #Combine in one dataframe
  short.df <- rbind(cincinnati_short, charleston_short)
  
  #change sentence case to match for the alegations
  short.df$summary_allegations <-  str_to_upper(short.df$summary_allegations)
  
  #match between two cities data by removing law enforcement text added (so both cities have similar naming of categories)
  short.df$summary_allegations <- str_replace(short.df$summary_allegations, "LAW ENFORCEMENT - ", "")
  
  #fix naming of some allegation categories to match figure, particularly improper auto procedure and fail to render care
  short.df$summary_allegations <- str_replace(short.df$summary_allegations, "IMPROPR PROCEDURE/AUTO", "IMPROPER AUTO PROCEDURE")
  short.df$summary_allegations <- str_replace(short.df$summary_allegations, "FAIL TO RENDER MEDCARE", "FAIL TO RENDER CARE")
  
  # Color palette generated manually by matching pixel hexadecimal color using color patch
  color_palette <- c(
    "CIVIL RIGHTS" = "#63A755", "DECLARATORY JUDGMENT" = "#DB6562",
    "LITIGATION" = "#D54741", "PERSONAL INJURY" = "#A82B23",
    "NEGLIGENCE" = "#C9342C", "PRESUIT" = "#751D18",
    "BRUTALITY" = "#E1EDF6", "CRUEL & UNUSUAL" = "#C2DBEE",
    "DUE PROCESS" = "#A5CAE5", "ERRORS & OMISSIONS" = "#88B7DD",
    "FAIL TO RENDER CARE" = "#6DA6D5", "FAILURE TO ENFORCE" = "#5395CD",
    "FALSE ARREST" = "#447FB2", "IMPROPER AUTO PROCEDURE" = "#2A5171",
    "MISCELLANEOUS" = "#1D3851", "NEGLIGENT SUPERVISION" = "#1D3851",
    "SEARCH & SEIZURE" = "#132231"
  )
  
  # Factor columns for correct ordering of city, summary allegations
  short.df <- short.df %>% mutate(legend_labels = case_when(summary_allegations == "CIVIL RIGHTS" ~ "BOTH", summary_allegations =="DECLARATORY JUDGMENT"  ~ "CINCINNATI", summary_allegations =="LITIGATION" ~ "CINCINNATI", summary_allegations =="PERSONAL INJURY"~ "CINCINNATI", summary_allegations =="NEGLIGENCE" ~ "CINCINNATI", summary_allegations =="PRESUIT"~ "CINCINNATI", summary_allegations =="BRUTALITY" ~ "CHARLESTON", summary_allegations =="CRUEL & UNUSUAL"  ~ "CHARLESTON",
                                                            summary_allegations =="DUE PROCESS"  ~ "CHARLESTON", summary_allegations =="ERRORS & OMISSIONS"  ~ "CHARLESTON", summary_allegations =="FAIL TO RENDER CARE" ~ "CHARLESTON",
                                                            summary_allegations =="FAILURE TO ENFORCE"  ~ "CHARLESTON", summary_allegations =="FALSE ARREST"  ~ "CHARLESTON", summary_allegations =="IMPROPER AUTO PROCEDURE"  ~ "CHARLESTON", summary_allegations =="MISCELLANEOUS"  ~ "CHARLESTON", summary_allegations =="NEGLIGENT SUPERVISION"  ~ "CHARLESTON", summary_allegations =="SEARCH & SEIZURE"  ~ "CHARLESTON"))
  
  short.df$summary_allegations <- factor(short.df$summary_allegations, levels = c("CIVIL RIGHTS", "DECLARATORY JUDGMENT", "LITIGATION", "PERSONAL INJURY", "NEGLIGENCE", "PRESUIT", "BRUTALITY", "CRUEL & UNUSUAL",
                                                                                  "DUE PROCESS", "ERRORS & OMISSIONS", "FAIL TO RENDER CARE",
                                                                                  "FAILURE TO ENFORCE", "FALSE ARREST", "IMPROPER AUTO PROCEDURE", "MISCELLANEOUS", "NEGLIGENT SUPERVISION", "SEARCH & SEIZURE"))
  
  
  
  short.df$city <- factor(short.df$city, levels = c("Cincinnati", "Charleston")) 
  
  
  
  # Create the stacked bar chart with adjusted features
  plot_figure2 <- ggplot(short.df, aes(x = city, fill = summary_allegations)) +
    geom_bar(stat = "count", position = "fill", width = 0.8, size = 0.5, color = "white") + scale_fill_manual(
      values = color_palette  ) +
    scale_y_continuous(
      labels = c("0%", "25%", "50%", "75%", "100%"),
      breaks = seq(0, 1, by = 0.25),
      expand = c(0, 0)
    ) + 
    labs(
      title = "Data categorization can be misleading",
      subtitle = "Share of settlements based on city's categorization of police misconduct",
      caption = "Source: Charleston Police Department, Cincinnati Police Department\nFiveThirtyEight / The Marshall Project",
      x = NULL, y = "Share of settlements"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, , hjust = 0.5),
      plot.caption = element_text(size = 10, hjust = 0),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(face = "bold"),
      panel.grid.major = element_line(color = "lightgray", size = 0.5),  # Light gray grid lines
      panel.grid.minor = element_blank(),
      legend.position = "bottom",
      legend.title = element_blank(),
      panel.border = element_rect(color = "black", fill = NA, size = 1.2)  # Dark border
    ) + scale_y_reverse() + #have green be on the left
    guides(fill = guide_legend(ncol = 3, byrow = FALSE)) +
    coord_flip() + annotate("text", x =1, y = rev(c(0, 0.25, 0.50, 0.75, 1.00)), label = (c("0%", "25", "50", "75", "100")), 
                            hjust = -0.15, vjust = 10, size = 4, fontface = "bold", color = "grey30")
  return(plot_figure2)
}