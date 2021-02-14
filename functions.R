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
           ISBN13 = ifelse(ISBN13 == '=""', NA, str_extract(ISBN13, "\\d+"))) %>% 
    select(ISBN13, Title, `Author l-f`, 
           `My Rating`, `Average Rating`, 
           `Number of Pages`, `Original Publication Year`,
           `Date Read`, `Read Count`, 
           Bookshelves, `Exclusive Shelf`,
            `Additional Authors`) %>% 
    rename(title = Title,
           author = `Author l-f`,
           additional_authors = `Additional Authors`,
           community_rating = `Average Rating`,
           my_rating = `My Rating`,
           num_pages = `Number of Pages`,
           publication_year = `Original Publication Year`,
           date_read = `Date Read`,
           bookshelves = Bookshelves,
           exclusive_shelf = `Exclusive Shelf`,
           read_count = `Read Count`)
}