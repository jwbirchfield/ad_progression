d <- read_csv('../project_files/data.csv')

### PROFILES BY DIAGNOSIS

# which id's have 4 or more observations?
four_visits <- d %>% 
  group_by(id) %>% 
  summarize(visit = max(visit_number)) %>% 
  filter(visit >= 4) %>% 
  pull(id)

d_four_visits %>% 
  filter(id %in% four_visits)

set.seed(1)
cn_ids <- d_four_visits %>% 
  filter(diagnosis == 'CN' & id != 18 & id != 19) %>% 
  pull(id) %>% 
  unique() %>% 
  sample(size = 10)

set.seed(2)
mci_ids <- d_four_visits %>% 
  filter(diagnosis == 'MCI') %>% 
  pull(id) %>% 
  unique() %>% 
  sample(size = 10)

set.seed(3)
ad_ids <- d_four_visits %>% 
  filter(diagnosis == 'AD') %>% 
  pull(id) %>% 
  unique() %>% 
  sample(size = 10)

d_selected_cn <- d %>% 
  filter(id %in% cn_ids)

d_selected_mci <- d %>% 
  filter(id %in% mci_ids)

d_selected_ad <- d %>% 
  filter(id %in% ad_ids)
  
cn_profiles <- ggplot(d_selected_cn, aes(x = years, y = FSLong)) + 
  theme_bw() +
  labs(title = 'CN', y = 'ERC thickness (FSLong)') + 
  ylim(c(3.2, 7.7)) +
  geom_point(size = .75) + 
  geom_line(aes(group = id))

mci_profiles <- ggplot(d_selected_mci, aes(x = years, y = FSLong)) + 
  theme_bw() +
  labs(title = 'MCI', y = NULL) + 
  ylim(c(3.2, 7.7)) +
  geom_point(size = .75) + 
  geom_line(aes(group = id))

ad_profiles <- ggplot(d_selected_ad, aes(x = years, y = FSLong)) + 
  theme_bw() +
  labs(title = 'AD', y = NULL) + 
  ylim(c(3.2, 7.7)) +
  geom_point(size = .75) + 
  geom_line(aes(group = id))

profiles_by_diagnosis <- cn_profiles + mci_profiles + ad_profiles
profiles_by_diagnosis
ggsave(filename = 'figures/profiles_by_diagnosis.pdf', width = 8, height = 4)

### PROFILES BY PIPELINE

cn_pipeline_comp <- 
  d_selected_cn %>% 
  filter(id == 1) %>%
  ggplot(aes(x = years)) + 
  theme_bw() +
  ylim(c(5.7, 7.7)) +
  labs(title = 'CN', y = 'ERC thickness') +
  geom_point(aes(y = ANTsSST), color = 'royalblue', size = .75) + 
  geom_line(aes(y = ANTsSST), color = 'royalblue') + 
  geom_point(aes(y = FSLong), color = 'orange3', size = .75) +
  geom_line(aes(y = FSLong), color = 'orange3')

mci_pipeline_comp <- 
  d_selected_mci %>% 
  filter(id == 203) %>%
  ggplot(aes(x = years)) + 
  theme_bw() +
  ylim(c(5.7, 7.7)) +
  labs(title = 'MCI', y = NULL) +
  geom_point(aes(y = ANTsSST), color = 'royalblue', size = .75) + 
  geom_line(aes(y = ANTsSST), color = 'royalblue') + 
  geom_point(aes(y = FSLong), color = 'orange3', size = .75) +
  geom_line(aes(y = FSLong), color = 'orange3')

ad_pipeline_comp <- 
  d_selected_ad %>% 
  filter(id == 533) %>%
  ggplot(aes(x = years)) + 
  theme_bw() +
  ylim(c(5.7, 7.7)) +
  labs(title = 'AD', y = NULL) +
  geom_point(aes(y = ANTsSST), color = 'royalblue', size = .75) + 
  geom_line(aes(y = ANTsSST), color = 'royalblue') + 
  geom_point(aes(y = FSLong), color = 'orange3', size = .75) +
  geom_line(aes(y = FSLong), color = 'orange3')

profiles_by_pipeline <- cn_pipeline_comp + mci_pipeline_comp + ad_pipeline_comp
profiles_by_pipeline
ggsave(filename = 'figures/profiles_by_pipeline.pdf', width = 8, height = 4)

### ERC BY MMSE SCATTERPLOT

fslong_scatterplot <- ggplot(d, aes(y = FSLong, x = MMSE)) + 
  theme_bw() +
  ylim(c(2.0, 13.4)) + 
  labs(title = 'FSLong', y = 'ERC thickness') +
  geom_point(alpha = .25) + 
  geom_smooth()

antssst_scatterplot <- ggplot(d, aes(y = ANTsSST, x = MMSE)) + 
  theme_bw() +
  ylim(c(2.0, 13.4)) + 
  labs(title = 'ANTsSST', y = NULL) +
  geom_point(alpha = .25) + 
  geom_smooth()

erc_mmse_scatterplot <- fslong_scatterplot + antssst_scatterplot
erc_mmse_scatterplot

ggsave(filename = 'figures/erc_mmse_scatterplot.pdf', width=8, height=4)
