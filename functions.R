#' process data
#' 
#' Read the goodreads export and extract interesting columns
#' @param data dataframe
#' @return dataframe  
process_data <- function(data) {
  processed <- data %>% 
    mutate(`Original Publication Year` = ifelse(is.na(`Original Publication Year`) &
                                                  !is.na(`Year Published`), 
                                                `Year Published`, 
                                                `Original Publication Year`),
           ISBN13 = ifelse(ISBN13 == '=""', NA, str_extract(ISBN13, "\\d+")),
           `Exclusive Shelf` = as.factor(`Exclusive Shelf`)) %>% 
    select(ISBN13, Title, `Author l-f`, 
           `My Rating`, `Average Rating`, 
           `Number of Pages`, `Original Publication Year`,
           `Date Read`, `Read Count`, 
           Bookshelves, `Exclusive Shelf`,
            `Additional Authors`) %>% 
    rename(title = Title,
           author = `Author l-f`,
           `additional authors` = `Additional Authors`,
           `community rating` = `Average Rating`,
           `my rating` = `My Rating`,
           `number of pages` = `Number of Pages`,
           publication_year = `Original Publication Year`,
           date_read = `Date Read`,
           bookshelves = Bookshelves,
           `exclusive shelf` = `Exclusive Shelf`,
           `read count` = `Read Count`)
}