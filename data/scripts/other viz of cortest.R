#GROUND
long_yg <- data %>%
  select(year_first_pub, ground) %>%
  group_by(ground, year_first_pub) %>%
  summarise(freq = n(), .groups = "keep") %>%
  drop_na() %>%
  ungroup()

years <- rep(min(long_yg$year_first_pub):max(long_yg$year_first_pub), long_yg$ground %>% unique %>% length())
grounds <- rep(long_yg$ground %>% unique, long_yg$year_first_pub %>% unique %>% length())

frame_yg <- tibble(year_first_pub = years %>% sort(),
                   ground = grounds)

long_yg <- left_join(frame_yg, long_yg, by = c("year_first_pub", "ground"))
long_yg$freq[is.na(long_yg$freq)] <- 0 #Plugging in zeros instead of NAs

line_yg <- long_yg %>%
  group_by(ground) %>%
  filter(sum(freq) >= 2) %>% #Retaining grounds with at least 2 observations
  ungroup()

line_yg <- line_yg %>%
  mutate(ground2 = ground)
line_yg %>%
  filter(year_first_pub <= 2020) %>%
  ggplot(aes(x = year_first_pub, y = freq)) +
  geom_line(data = line_yg %>% select(-ground),
            aes(group = ground2), color = black, size = 0.6, alpha = 0.1) +
  geom_line(aes(color = ground), color = blue, size = 1.2, alpha = 0.8) +
  geom_point(color = blue, shape = "square", size = 1.5) +
  scale_y_continuous(limits = c(0, max(line_yg$freq)+2)) +
  scale_x_continuous(limits = c(2005, 2020)) +
  facet_wrap(~ground, ncol = 2,
             scales = "free") +
  theme_minimal() +
  theme(text = element_text(family = "UGent Panno Text"),
        panel.grid.minor = element_blank(),
        panel.spacing.y=unit(1.5, "lines"),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l =0))) +
  labs(title = "Trend in the number of correspondence tests by discrimination ground",
       subtitle = "For discrimination grounds which were tested at least twice",
       x = "Year", y = "Count")



#COUNTRY
long_yc <- data %>%
  mutate(country = case_when(str_detect(country_of_analysis, "cross-national") ~ "Cross-national",
                             !str_detect(country_of_analysis, "cross-national") ~ country_of_analysis)) %>%
  select(year_first_pub, country) %>%
  group_by(country, year_first_pub) %>%
  summarise(freq = n(), .groups = "keep") %>%
  drop_na() %>%
  ungroup()

years <- rep(min(long_yc$year_first_pub):max(long_yc$year_first_pub), long_yc$country %>% unique %>% length())
countries <- rep(long_yc$country %>% unique, long_yc$year_first_pub %>% unique %>% length())

frame_yc <- tibble(year_first_pub = years %>% sort(),
                   country = countries)

long_yc <- left_join(frame_yc, long_yc, by = c("year_first_pub", "country"))
long_yc$freq[is.na(long_yc$freq)] <- 0

line_yc <- long_yc %>%
  group_by(country) %>%
  filter(sum(freq) >= 5) %>% #Retaining grounds with at least 5 observations
  ungroup()

line_yc <- line_yc %>%
  mutate(country2 = country)
line_yc %>%
  filter(year_first_pub <= 2020) %>%
  ggplot(aes(x = year_first_pub, y = freq)) +
  geom_line(data = line_yc %>% select(-country),
            aes(group = country2), color = black, size = 0.6, alpha = 0.1) +
  geom_line(aes(color = country), color = blue, size = 1.2, alpha = 0.8) +
  geom_point(color = blue, shape = "square", size = 1.5) +
  scale_y_continuous(limits = c(0, max(line_yc$freq)+2),
                     breaks = seq(0, max(line_yc$freq)+2, 4)) +
  scale_x_continuous(limits = c(2005, 2020)) +
  facet_wrap(~country, ncol = 2,
             scales = "free") +
  theme_minimal() +
  theme(text = element_text(family = "UGent Panno Text"),
        panel.grid.minor = element_blank(),
        panel.spacing.y = unit(1.5, "lines"),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l =0))) +
  labs(title = "Trend in the number of correspondence tests by country",
       subtitle = "For countries where at least five tests were performed",
       x = "Year", y = "Count",
       caption = "Cross-national studies are studies in which a correspondence test was executed across at least two countries simultaneously")





```{r analysis effect 2, echo = FALSE, warning = FALSE, fig.height = 15}
effect_reg <- data %>%
  select(ground, region, effect_category) %>%
  filter(effect_category != "N/A") %>%
  group_by(ground, region, effect_category) %>%
  summarise(freq = n(), .groups = "keep") %>%
  drop_na() %>%
  ungroup()

ground_reg <- effect_reg %>% select(ground, region) %>% unique()

grounds <- rep(effect_reg$ground %>% unique,
               effect_reg$effect_category %>% unique %>% length()*effect_reg$region %>% unique %>% length())
effects <- rep(effect_reg$effect_category %>% unique,
               effect_reg$ground %>% unique %>% length()*effect_reg$region %>% unique %>% length())
regions <- rep(effect_reg$region %>% unique,
               effect_reg$ground %>% unique %>% length()*effect_reg$effect_category %>% unique %>% length())

frame_effect_reg <- tibble(ground = grounds %>% sort(),
                           effect_category = effects,
                           region = regions)

long_effect_reg <- left_join(frame_effect_reg, effect_reg,
                             by = c("ground", "effect_category","region"))
long_effect_reg$freq[is.na(long_effect_reg$freq)] <- 0

bar_effect_reg <- long_effect_reg

bar_effect_reg$effect_category <- factor(bar_effect_reg$effect_category,
                                         levels = c("None", "Mixed", "Positive", "Negative"))

bar_effect_reg <- bar_effect_reg %>%
  group_by(ground) %>%
  #filter(sum(freq) >= 2) %>% #Retaining grounds with at least 2 observations
  ungroup()

ground_order_reg <- bar_effect_reg %>%
  group_by(region) %>%
  summarise(sumfreq = sum(freq)) %>%
  arrange(desc(sumfreq)) %>%
  ungroup()

ground_order <- bar_effect_reg %>%
  group_by(ground) %>%
  summarise(sumfreq = sum(freq)) %>%
  arrange(desc(sumfreq)) %>%
  ungroup()

bar_effect_reg$region <- factor(bar_effect_reg$region, levels = ground_order_reg$region)
bar_effect_reg$ground <- factor(bar_effect_reg$ground, levels = ground_order$ground)

bar_effect_reg <- bar_effect_reg %>%
  group_by(region) %>%
  mutate(sumfreq = sum(freq)) %>%
  filter(sumfreq >= 5) %>% #Retaining regions with at least 5 observations
  select(-sumfreq) %>%
  ungroup()

bar_effect_reg <- bar_effect_reg %>%
  mutate(region2 = region)

bar_effect_reg %>%
  ggplot(aes(x = ground, y = freq, fill = effect_category)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10)) +
  scale_fill_manual(values = c("#e6e6e6", "#cccccc", green, blue),
                    name = "Effect:") +
  coord_flip() +
  facet_wrap(~region, ncol = 1,
             scales = "free") +
  theme_minimal() +
  theme(text = element_text(family = "UGent Panno Text"),
        panel.grid.minor = element_blank(),
        legend.position = "bottom",
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l =0)),
        plot.title.position = "plot") +
  labs(title = "Effect of the treatment on the call-back outomes by region and discrimination ground",
       subtitle = "Considering subregions where at least five tests were performed",
       x = "Discrimination ground", y = "Count")
```