#Pitcher release visualization file
release_point<-function(df){
    #init base plot with grid
    base<-ggplot()+
    geom_hline(yintercept = seq(0, 100, by = 10), color = "gray80", size = 1) +
    geom_vline(xintercept = seq(-60, 60, by = 10), color = "gray80", size = 1) 
    #visualization for release point
    base +
    geom_point(data = df,
                aes(x = as.numeric(Release_Side) ,
                    y = as.numeric(Release_Height)*12,
                    color = Pitch_Type),
                    size = 3) +
    labs(
      title="Release Point",
      x = "Release Side (in inches from center of rubber)",
      y = "Release Height"
    ) +
    theme_minimal() +
    theme(panel.grid = element_blank())
}