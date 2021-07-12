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