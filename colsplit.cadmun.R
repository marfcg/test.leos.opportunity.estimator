require(stringr)
require(foreign)

#' Split entries with multiple MUNSINON values in CADMUN.DBF
#'
#' @name colplit.cadmun
#' 
#' Function to generate list of all MUNSINON codes corresponding to the same MUNCODDV.
#' Returns list with
#' municipio_geocode List of MUNCODDV, corresponding to IBGE geocode to Municipalities.
#' ID_MUNICIP List of MUNSINON, corresponding to public health codes for localities, i.e., 
#'  Municipalities and administrative units inside those.
#' @param x Character corresponding to MUNCODDV value
#' @param y Character corresponding to MUNCOD value
#' @param z Character corresponding to MUNSINON value
#'
#' @return Named list with all ID_MUNICIP \(from MUNSINON\) corresponding to the same
#'   municipio_geocode \(from MUNCODDV\)
#'   \item{ID_MUNICIP} List of all MUNSINON values
#'   \item{municipio_geocode} List of MUNCODDV with same length as ID_MUNICIP
#' @export
#'
#' @examples
#' df <- read.dbf('data/cadmun/CADMUN.DBF')[1, ]
#' colsplit.cadmun(as.character(df$MUNCODDV), as.character(df$MUNCOD), as.character(df$MUNSION))
colsplit.cadmun <- function(x,y,z){
  
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
  return(data.frame(list(municipio_geocode=municipio_geocode, ID_MUNICIP=ID_MUNICIP), stringsAsFactors=F))
}
