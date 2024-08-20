suppressMessages({
  ggplot2::theme_set(cowplot::theme_half_open(12))
  extrafont::font_import(pattern = "Times New Roman", prompt = FALSE)
  extrafont::loadfonts(device = "pdf")
})

dt_maxprecip <- readr::read_csv(
  file = "data/dt_maxprecip.csv",
  show_col_types = FALSE
)

dt_precip_decade <- dt_maxprecip |>
  dplyr::mutate(decade = (year %/% 10) * 10) |>
  dplyr::group_by(decade) |>
  dplyr::summarize(
    n = dplyr::n(),
    mean_mprecip = mean(max_precip),
    sd_mprecip = sd(max_precip),
    ci_95 = paste0(
      "[",
      signif(
        mean_mprecip - qt(p = 0.975, df = n - 1) * sd_mprecip / sqrt(n),
        digits = 3
      ),
      ", ",
      signif(
        mean_mprecip + qt(p = 0.975, df = n - 1) * sd_mprecip / sqrt(n),
        digits = 3
      ),
      "]"
    )
  )

go_timeseries <- dt_maxprecip |>
  ggplot2::ggplot(ggplot2::aes(x = year, y = max_precip)) +
  ggplot2::geom_line(
    colour = "steelblue",
    linetype = "dotted"
  ) +
  ggplot2::geom_point() +
  ggplot2::labs(
    x = "Year",
    y = "Maximum precipitation [mm]",
    tag = "A"
  ) +
  ggplot2::theme(
    text = ggplot2::element_text(family = "serif"),
    plot.tag = ggplot2::element_text(size = 14)
  )

ggplot2::ggsave(
  go_timeseries,
  device = "pdf",
  width = 8,
  height = 2.35,
  file = "pdf/timeseries.pdf"
)

lin <- lm(mean_mprecip ~ decade, data = dt_precip_decade)

go_precip_decade <- dt_precip_decade |>
  ggplot2::ggplot(ggplot2::aes(x = decade, y = mean_mprecip)) +
  ggplot2::geom_smooth(
    method = "lm",
    colour = "royalblue",
    fill = "royalblue"
  ) +
  ggplot2::labs(
    x = "Decade",
    y = "Mean precipitation [mm]",
    tag = "B1"
  ) +
  ggplot2::geom_point() +
  ggplot2::theme(
    text = ggplot2::element_text(family = "serif"),
    plot.tag = ggplot2::element_text(size = 14)
  )

go_dist_decade <- dt_precip_decade |>
  dplyr::mutate(
    pred = predict(lin, data.frame(decade)),
    devn = abs(mean_mprecip - pred)
  ) |>
  ggplot2::ggplot(ggplot2::aes(x = decade, y = devn)) +
  ggplot2::labs(
    x = "Decade",
    y = "Residual [mm]",
    tag = "B2"
  ) +
  ggplot2::geom_smooth(
    method = "lm",
    colour = "royalblue",
    se = FALSE
  ) +
  ggplot2::geom_point() +
  ggplot2::scale_y_continuous(limits = c(-0.25, 9)) +
  ggplot2::theme(
    text = ggplot2::element_text(family = "serif"),
    plot.tag = ggplot2::element_text(size = 14)
  )

go_decade_arranged <- cowplot::plot_grid(
  go_timeseries,
  cowplot::plot_grid(
    go_precip_decade,
    go_dist_decade
  ),
  ncol = 1
)

ggplot2::ggsave(
  go_decade_arranged,
  width = 8,
  height = 6,
  device = "pdf",
  file = "pdf/decade.pdf",
)
