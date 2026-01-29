library(ggplot2)

p <- ggplot() +
  geom_hline(yintercept = seq(0, 7, by = 0.5), color = "gray85", linewidth = 0.5) +
  geom_vline(xintercept = seq(-3, 3, by = 0.5), color = "gray85", linewidth = 0.5) +
  geom_rect(
    xmin = -0.83, xmax = 0.83,
    ymin = 1.5, ymax = 3.5,
    fill = NA,
    color = "black",
    inherit.aes = FALSE,
    size = 1.3,
    linewidth = 1.3
  ) +
  coord_fixed() +
  xlim(-3, 3) +
  ylim(0, 7) +
  labs(title = "Strike Zone Test", x = "Horizontal (ft)", y = "Vertical (ft)") +
  theme_minimal() +
  theme(panel.grid = element_blank())

ggsave(filename = "c:/Users/nbrow/OneDrive/Desktop/PAWS/tmp_rect_test.png", plot = p, width = 6, height = 4, dpi = 150)
