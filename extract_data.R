library("RPostgreSQL", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")
dbname <- "dengue"
user <- "dengueadmin"
password <- "aldengue"
host <- "localhost"
con <- dbConnect(dbDriver("PostgreSQL"), user=user,
password=password, dbname=dbname)

# Notification data from geocod Municipality:
geocod <- 3304557
query.txt <- paste0("SELECT * from 
                    \"Municipio\".\"Notificacao\"
                    WHERE municipio_geocodigo = ", geocod)
df.munRJ <- dbGetQuery(con, query.txt)

# Filter duplicate data and missing values:
target.cols <- c('nu_notific','bairro_nome', 'dt_digita', 'municipio_geocodigo')
df.munRJ.clean <- df.munRJ[!duplicated(df.munRJ[, target.cols]) & !is.na(df.munRJ$dt_digita),
                           c('municipio_geocodigo', 'dt_notific', 'dt_digita')]

# Filter by years:
df.munRJ.clean <- df.munRJ.clean[df.munRJ.clean$dt_notific >= '2012-01-01' & 
                                   df.munRJ.clean$dt_notific <= '2016-12-31', ]

# Save object:
saveRDS(df.munRJ.clean, 'dengue.munRJ.2012.2016.rds')
