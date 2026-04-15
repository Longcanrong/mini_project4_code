library(ggplot2)
library(gridExtra)

setwd("/home/cmml3_xxxx/Results/320K_50ns")
OUTPUT_DIR <- "Figures"
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR)
}


read_xvg <- function(file, skip_lines) {
  df <- read.table(
    file,
    sep = "",
    header = FALSE,
    skip = skip_lines,
    na.strings = "",
    stringsAsFactors = FALSE
  )
  return(df)
}

running_mean <- function(x, k = 10) {
  out <- rep(NA, length(x))
  if (length(x) >= k) {
    out[k:length(x)] <- sapply(k:length(x), function(i) mean(x[(i-k+1):i]))
  }
  return(out)
}

report_theme <- theme_bw(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.title = element_blank(),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

save_report_plot <- function(plot_obj, filename, width = 8, height = 6) {
  ggsave(filename, plot_obj, width = width, height = height, dpi = 300, path = OUTPUT_DIR)
  ggsave(sub("\\.png$", ".pdf", filename), plot_obj, width = width, height = height, path = OUTPUT_DIR)
}

# 1. Energy minimization
potential <- read_xvg("potential.xvg", skip_lines = 24)

p1 <- ggplot(potential, aes(x = V1, y = V2)) +
  geom_line(linewidth = 0.7) +
  labs(
    x = "Energy minimization step",
    y = expression("Potential energy (kJ " * mol^{-1} * ")"),
    title = "Energy minimization"
  ) +
  report_theme

save_report_plot(p1, "figure1_potential_energy.png")

# 2. Temperature equilibration
temperature <- read_xvg("temperature_320K.xvg", skip_lines = 24)
temperature$avg10 <- running_mean(temperature$V2, k = 10)

p2 <- ggplot(temperature, aes(x = V1, y = V2)) +
  geom_line(linewidth = 0.5, alpha = 0.8) +
  geom_line(aes(y = avg10), linewidth = 1) +
  geom_hline(yintercept = 320, linetype = "dashed") +
  labs(
    x = "Time (ps)",
    y = "Temperature (K)",
    title = "NVT temperature equilibration"
  ) +
  report_theme

save_report_plot(p2, "figure2_temperature_equilibration.png")

# 3. Pressure equilibration
pressure <- read_xvg("pressure_320K.xvg", skip_lines = 24)
pressure$avg10 <- running_mean(pressure$V2, k = 10)

p3 <- ggplot(pressure, aes(x = V1, y = V2)) +
  geom_line(linewidth = 0.5, alpha = 0.8) +
  geom_line(aes(y = avg10), linewidth = 1) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  labs(
    x = "Time (ps)",
    y = "Pressure (bar)",
    title = "NPT pressure equilibration"
  ) +
  report_theme

save_report_plot(p3, "figure3_pressure_equilibration.png")

# 4. Density equilibration
density <- read_xvg("density_320K.xvg", skip_lines = 24)
density$avg10 <- running_mean(density$V2, k = 10)

p4 <- ggplot(density, aes(x = V1, y = V2)) +
  geom_line(linewidth = 0.5, alpha = 0.8) +
  geom_line(aes(y = avg10), linewidth = 1) +
  geom_hline(yintercept = 1000, linetype = "dashed") +
  labs(
    x = "Time (ps)",
    y = expression("Density (kg " * m^{-3} * ")"),
    title = "NPT density equilibration"
  ) +
  report_theme

save_report_plot(p4, "figure4_density_equilibration.png")

# 5. RMSD
rmsd_equilibrated <- read_xvg("rmsd_320K.xvg", skip_lines = 18)
rmsd_xtal <- read_xvg("rmsd_xtal_320K.xvg", skip_lines = 18)

rmsd <- data.frame(
  time_ns = rmsd_equilibrated$V1,
  ref_equilibrated = rmsd_equilibrated$V2,
  ref_original = rmsd_xtal$V2
)

p5 <- ggplot(data = rmsd, aes(x = time_ns)) +
  geom_line(aes(y = ref_equilibrated, color = "Equilibrated reference"), linewidth = 0.9) +
  geom_line(aes(y = ref_original, color = "Original reference"), linewidth = 0.9, linetype = "dashed") +
  labs(
    x = "Time (ns)",
    y = "Backbone RMSD (nm)",
    title = "Backbone RMSD during 20 ns MD"
  ) +
  scale_color_manual(values = c("Equilibrated reference" = "black",
                                "Original reference" = "grey40")) +
  report_theme

save_report_plot(p5, "figure5_rmsd.png")

# 6. Radius of gyration
gyration <- read_xvg("gyrate_320K.xvg", skip_lines = 27)
gyration$time_ns <- gyration$V1 / 1000

rg_mean <- mean(gyration$V2, na.rm = TRUE)

p6 <- ggplot(gyration, aes(x = time_ns, y = V2)) +
  geom_line(linewidth = 0.8) +
  geom_hline(yintercept = rg_mean, linetype = "dashed") +
  labs(
    x = "Time (ns)",
    y = expression(R[g] * " (nm)"),
    title = "Radius of gyration during 20 ns MD"
  ) +
  report_theme

save_report_plot(p6, "figure6_radius_of_gyration.png")

# 7. Report-ready combined panels
panel_eq <- grid.arrange(
  p2, p3, p4,
  ncol = 1
)
ggsave("report_equilibration_panel.png", panel_eq, width = 8, height = 14, dpi = 300, path = OUTPUT_DIR)
ggsave("report_equilibration_panel.pdf", panel_eq, width = 8, height = 14, path = OUTPUT_DIR)

panel_md <- grid.arrange(
  p5, p6,
  ncol = 1
)
ggsave("report_md_panel.png", panel_md, width = 8, height = 10, dpi = 300, path = OUTPUT_DIR)
ggsave("report_md_panel.pdf", panel_md, width = 8, height = 10, path = OUTPUT_DIR)

# 8. Optional: summary statistics for Results section
sink("report_summary_320K.txt")

cat("320 K simulation summary\n")
cat(sprintf("Average temperature: %.3f K\n", mean(temperature$V2, na.rm = TRUE)))
cat(sprintf("Average pressure: %.3f bar\n", mean(pressure$V2, na.rm = TRUE)))
cat(sprintf("Average density: %.3f kg/m^3\n", mean(density$V2, na.rm = TRUE)))
cat(sprintf("Final RMSD vs equilibrated reference: %.4f nm\n", tail(rmsd$ref_equilibrated, 1)))
cat(sprintf("Mean RMSD vs equilibrated reference: %.4f nm\n", mean(rmsd$ref_equilibrated, na.rm = TRUE)))
cat(sprintf("Final Rg: %.4f nm\n", tail(gyration$V2, 1)))
cat(sprintf("Mean Rg: %.4f nm\n", mean(gyration$V2, na.rm = TRUE)))