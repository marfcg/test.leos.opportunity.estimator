
source('colsplit.cadmun.R')

# Read data and remove extinct and transfered Municipalities
df <- read.csv('data/cadmun/cadmun-utf8.csv', stringsAsFactors=F, encoding = 'UTF-8')
df <- droplevels(df[!(df$SITUACAO=='EXTIN' | df$SITUACAO=='TRANS'), ])

# Convert columns of interest for colsplit.cadmun into type character
target.cols <- c('MUNCODDV', 'MUNCOD', 'MUNSINON')
for (c in target.cols){
  df[, c] <- as.character(df[, c])
}

# Entries without comma in MUNSINON column have single correspondence, with ID_MUNICIP corresponding to MUNCOD
full.list <- df[!grepl(',', df$MUNSINON), c('MUNCODDV', 'MUNCOD')]

# Change column names to our liking:
names(full.list) <- c('municipio_geocode', 'ID_MUNICIP')

# Slice data frame keeping rows with multiple values in MUNSINON:
df.multiple <- df[grepl(',', df$MUNSINON), ]

# Apply colsplit.cadmun
res <- mapply(colsplit.cadmun, df.multiple$MUNCOD, df.multiple$MUNCODDV, df.multiple$MUNSINON)

# Generate list correspondence from output
i <- 1
municipio_geocode <- unlist(res[[1,i]])
ID_MUNICIP <- res[[2,i]]
for (i in 2:dim(res)[[2]]){
  municipio_geocode <- c(municipio_geocode, unlist(res[[1,i]]))
  ID_MUNICIP <- c(ID_MUNICIP, res[[2,i]])
}

# Append to output data frame
full.list <- rbind(full.list, data.frame(municipio_geocode, ID_MUNICIP, stringsAsFactors=F))

# Add informative columns from original data frame
full.list <- merge(full.list, df[, -which(names(df) %in% c('MUNCOD', 'MUNSINON', 'MUNSINONDV'))],
                   by.x='municipio_geocode', by.y='MUNCODDV', all.x=TRUE)

# Check for duplicates in ID_MUNICIP column, which must have unique values only:
if (nrow(full.list[duplicated(full.list$ID_MUNICIP), ]) == 0){
  print(paste0('Number of duplicated ID_MUNICIP: ', nrow(full.list[duplicated(full.list$ID_MUNICIP), ])))  
  saveRDS(full.list, 'data/cadmun/ID_MUNICIP2municipio_geocode.rds')
  write.csv(full.list, 'data/cadmun/ID_MUNICIP2municipio_geocode.csv', row.names=F)
} else {
  stop(paste0('Number of duplicated ID_MUNICIP: ', nrow(full.list[duplicated(full.list$ID_MUNICIP), ])))
}