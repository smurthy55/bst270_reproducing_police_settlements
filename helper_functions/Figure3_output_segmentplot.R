#Generate figure 3 of average and median settlements per city police department

figure3 <- function(all_data) {
  # Calculate summary statistics
  summary_stats <- all_data %>%
    group_by(city_label) %>%
    summarize(
      median_settlement = median(amount_awarded, na.rm = TRUE),
      average_settlement = mean(amount_awarded, na.rm = TRUE)
    ) %>%
    mutate(city_label = factor(city_label, levels = rev(unique(all_data$city_label)))) 
  
  # Adjust data to ensure visualization of both values
  summary_stats <- summary_stats %>%
    rowwise() %>%
    mutate(
      adjusted_median = if_else(average_settlement <= median_settlement, median_settlement + 1e-5, median_settlement),
      adjusted_average = if_else(average_settlement <= median_settlement, average_settlement - 1e-5, average_settlement),
      segment_min = min(adjusted_median, adjusted_average),
      segment_max = max(adjusted_median, adjusted_average)) %>%
    ungroup()
  
  # Create the plot
  plot_figure3 <- ggplot(summary_stats, aes(y = city_label)) +
    geom_segment(aes(x = segment_min, xend = segment_max, yend = city_label), 
                 color = "gray80", linewidth = 1.5) +
    geom_point(aes(x = median_settlement, color = "MEDIAN SETTLEMENT AMOUNT"), 
               size = 3, show.legend = TRUE, position = position_nudge(x = -1e4)) +  # Slight left nudge
    geom_point(aes(x = average_settlement, color = "AVERAGE SETTLEMENT AMOUNT"), 
               size = 3, show.legend = TRUE, position = position_nudge(x = 1e4)) +  # Slight right nudge
    labs(
      title = "Large settlements can skew a city's average payment",
      subtitle = "Comparison of average settlement and median settlement amounts\nfor the cities that responded to records requests",
      x = "Settlement amount",
      y = "",
      caption = "Source: Police Departments | FiveThirtyEight/The Marshall Project",
      color = ""
    ) + 
    scale_x_continuous(labels = scales::label_dollar(scale = 1e-3, suffix = "k"), expand = c(0, 0)) +
    scale_color_manual(
      values = c("MEDIAN SETTLEMENT AMOUNT" = "#00C5CD", 
                 "AVERAGE SETTLEMENT AMOUNT" = "#FF6F61"),
      breaks = c("MEDIAN SETTLEMENT AMOUNT", "AVERAGE SETTLEMENT AMOUNT")
    ) +
    theme_classic(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      axis.text.y = element_text(face = "bold", color = "gray50"),
      axis.title.x = element_text(face = "bold"),
      axis.ticks.y = element_blank(),
      axis.line.x = element_blank(),
      panel.grid.major.x = element_line(color = "gray80"),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "top"
    ) 
  
  return(plot_figure3)
}
