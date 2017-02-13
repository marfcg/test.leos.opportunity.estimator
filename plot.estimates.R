# Read data:
df.estimates <- readRDS('./data/leosmethod.estimates.2017-02-11.rds')

# Generate numerical row:
df.estimates$num <- row.names(df.estimates)

# Plot:
svg('./data/leos.method.estimates.2017-02-11.svg', width=16, height =9)
p + geom_ribbon(aes(x=num, ymin=`2.5%`, ymax=`97.5%`, fill='95% CI')) +
  geom_line(aes(num, CASOS_NOTIFIC, color='Notified cases')) +
  geom_line(aes(num, `50%`, color='Estimate'), linetype=2) +
  geom_vline(xintercept=22, color='green', linetype=2) +
  labs(title='Case estimation using Leo\'s Method', 
       x='Epidemiological week (starting 2012W01)',
       y='Number of cases') +
  theme(legend.position='right') +
  scale_fill_manual(name='', values=c('95% CI'='#7b7b7b')) +
  scale_colour_manual(name='', values=c('Notified cases'='black', 'Estimate'='red'))
dev.off()
