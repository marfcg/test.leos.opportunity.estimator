source('./episem.R')
source('./generate.columns.from.date.R')
source('./generate.columns.from.datev2.R')

f <- function(){
  df <- readRDS('../data/dengue.munRJ.2012.2016.rds')
  names(df)[2] <- 'DT_NOTIFIC'
  df.sample <- df[1:10000, ]
  t1(df.sample[, 1:3])
  t2(df.sample[, 1:3])
  t3(df.sample[, 1:3])
  t4(df.sample[, 1:3])
}

t1 <- function(df.sample){
  cbind(df.sample, t(sapply(df.sample$DT_NOTIFIC,generate.columns.from.date)))
}

t2 <- function(df.column){
  df <- t(sapply(df.column,generate.columns.from.datev2))
  for (c in names(df)){
    df[, c] <- unlist(df[, c])
  }
}

t3 <- function(df.sample){
  df.sample['DT_NOTIFIC_epiweek'] <- mapply(function(x) as.integer(episem(x, retorna = 'W')), df.sample$DT_NOTIFIC)
  df.sample['DT_NOTIFIC_epiyear'] <- mapply(function(x) as.integer(episem(x, retorna = 'Y')), df.sample$DT_NOTIFIC)
  df.sample['DT_NOTIFIC_epiyearweek'] <- mapply(function(x,y) paste0(x,'W',sprintf("%02d",y)),
                                                df.sample$DT_NOTIFIC_epiyear,df.sample$DT_NOTIFIC_epiweek)
}

t4 <- function(df.column){
  df['DT_NOTIFIC_epiyearweek'] <- mapply(function(x) episem(x), df.column)
  df[, 'DT_NOTIFIC_epiweek'] <- mapply(function (x) as.integer(strsplit(as.character(x[[1]]), 'W')[[1]][2]), 
                                                                      df[, 'DT_NOTIFIC_epiyearweek'])
  df[, 'DT_NOTIFIC_epiyear'] <- mapply(function (x) as.integer(strsplit(as.character(x[[1]]), 'W')[[1]][1]), 
                                                                      df[, 'DT_NOTIFIC_epiyearweek'])
}

t5 <- function(df.column){
  df <- t(mapply(function(x) generate.columns.from.datev2(x), df.column))
  for (c in names(df)){
    df[, c] <- unlist(df[, c])
  }
}

