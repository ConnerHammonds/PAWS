#Pitcher extension visualization file
pitcher_extension<-function(df){
    #init base plot with grid
    base<-ggplot()+
    geom_hline(yintercept = seq(0, 100, by = 10), color = "gray80", size = 0.5) +
    geom_vline(xintercept = seq(0, 120, by = 10), color = "gray80", size = 0.5) 
    #visualization for pitcher extension
    base +
    geom_point(data = df,
                aes(x=as.numeric(Extension)*12,
                y=as.numeric(Release_Height)*12,
                color=Pitch_Type),
                size=3)+
        labs(
            title="Pitch Extension",
            x="Extension",
            y="Release Height"
        )+
        theme_minimal() +
        theme(panel.grid = element_blank())
}