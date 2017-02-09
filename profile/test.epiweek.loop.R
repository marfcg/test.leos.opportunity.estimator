source('~/codes/opportunity_estimator/leos.opportunity.estimator/R/episem.R')
source('~/codes/opportunity_estimator/leos.opportunity.estimator/R/generate.columns.from.date.R')

# df <- readRDS('~/codes/test.leos.method.dengue/data/dengue.munRJ.2012.2016.rds')[1:100000, ]
# names(df)
# names(df) <- c('ID_MUNICIP', 'DT_NOTIFIC', 'DT_DIGITA')
# target.cols <- c('DT_NOTIFIC_epiyearweek', 'DT_NOTIFIC_epiweek', 'DT_NOTIFIC_epiyear')
# if (!all(target.cols %in% names(df))){
# df <- generate.columns.from.date(df, 'DT_NOTIFIC')
# names(df) <- sub("^epi", "DT_NOTIFIC_epi", names(df))
# }
# target.cols <- c('DT_DIGITA_epiyearweek', 'DT_DIGITA_epiweek', 'DT_DIGITA_epiyear')
# if (!all(target.cols %in% names(df))){
#   df <- generate.columns.from.date(df, 'DT_DIGITA')
#   names(df) <- sub("^epi", "DT_DIGITA_epi", names(df))
# }
# 
# seq_epiweek <- sort(unique(df$DT_NOTIFIC_epiyearweek))
f <- function(df, seq_epiweek){
  t1(df, seq_epiweek)
  t2(df, seq_epiweek)
}

t1 <- function(df, seq_epiweek){
  for (current.epiyearweek in seq_epiweek){
    d <- df[df$DT_DIGITA_epiyearweek <= current.epiyearweek, ]
  }
}

t2 <- function(df, seq_epiweek){
  current.epiyearweek <- seq_epiweek[1]
  d <- df[df$DT_DIGITA_epiyearweek <= current.epiyearweek, ]
  previous.epiyearweek <- current.epiyearweek
  for (current.epiyearweek in seq_epiweek[2:length(seq_epiweek)]){
    d <- rbind(d, df[df$DT_DIGITA_epiyearweek > previous.epiyearweek &
                       df$DT_DIGITA_epiyearweek <= current.epiyearweek, ])
    previous.epiyearweek <- current.epiyearweek
  }
}