require(stringr)
require(foreign)

fsplit <- function(x,y,z){
  municipio_geocode <- y
  ID_MUNICIP <- x
  if (is.na(z)){
    return(data.frame(municipio_geocode, ID_MUNICIP, stringsAsFactors=F))
  }
  
  vals <- strsplit(z, ',')
  for (v in vals[[1]][2:length(vals[[1]])]){
    if (v == str_pad('', 6, pad=' ')){
      next
    }
    
    if (grepl('-', v)){
      v.list <- strsplit(v, '-')
      for (vi in v.list[[1]][1]:v.list[[1]][2]){
        municipio_geocode <- c(municipio_geocode, y)
        ID_MUNICIP <- c(ID_MUNICIP, sprintf("%06d", vi))
      }
    } else {
      municipio_geocode <- c(municipio_geocode, y)
      ID_MUNICIP <- c(ID_MUNICIP, sprintf("%06s", v))
    }
  }
  return(list(municipio_geocode=municipio_geocode, ID_MUNICIP=ID_MUNICIP))
}

df <- read.dbf('data/cadmun/CADMUN.DBF')[, c('MUNCODDV', 'MUNCOD', 'MUNSINON')]
for (c in col(df)){
  df[, c] <- as.character(df[, c])
}

full.list <- df[!grepl(',', df$MUNSINON), c('MUNCODDV', 'MUNCOD')]
names(full.list)
names(full.list) <- c('municipio_geocode', 'ID_MUNICIP')

df.multiple <- df[grepl(',', df$MUNSINON), ]

res <- mapply(fsplit, df.multiple$MUNCOD, df.multiple$MUNCODDV, df.multiple$MUNSINON)

i <- 1
municipio_geocode <- unlist(res[[1,i]])
ID_MUNICIP <- res[[2,i]]
for (i in 2:dim(res)[[2]]){
  municipio_geocode <- c(municipio_geocode, unlist(res[[1,i]]))
  ID_MUNICIP <- c(ID_MUNICIP, res[[2,i]])
}

full.list <- rbind(full.list, data.frame(municipio_geocode, ID_MUNICIP, stringsAsFactors=F))
saveRDS(full.list, 'data/cadmun/ID_MUNICIP2municipio_geocode.rds')
write.csv(full.list, 'data/cadmun/ID_MUNICIP2municipio_geocode.csv', row.names=F)
tmp <- full.list[duplicated(full.list$ID_MUNICIP), ]
head(tmp)
full.list[full.list$ID_MUNICIP==431453, ]
df[df$MUNCOD==431453, ]
df[df$MUNCODDV==4314530, ]
df[df$MUNCODDV==4314548, ]
