#' process data
#'
process_data <- function(data) {
  processed <- data %>% 
    mutate(`Original Publication Year` = ifelse(is.na(`Original Publication Year`) &
                                                  !is.na(`Year Published`), 
                                                `Year Published`, 
                                                `Original Publication Year`)) %>% 
    select(`Book Id`, Title, `Author l-f`, 
           `Additional Authors`, ISBN, ISBN13,
           `My Rating`, `Average Rating`, Publisher,
           `Number of Pages`, `Original Publication Year`,
           `Date Read`, Bookshelves, `Exclusive Shelf`,
           `Read Count`) %>% 
    rename(book_ID = `Book Id`,
           title = Title,
           author = `Author l-f`,
           additional_authors = `Additional Authors`,
           community_rating = `Average Rating`,
           my_rating = `My Rating`,
           publisher = Publisher,
           num_pages = `Number of Pages`,
           publication_year = `Original Publication Year`,
           date_read = `Date Read`,
           bookshelves = Bookshelves,
           exclusive_shelf = `Exclusive Shelf`,
           read_count = `Read Count`) %>% 
    mutate(ISBN = ifelse(ISBN == '=""', NA, str_extract(ISBN, "\\d+")),
           ISBN13 = ifelse(ISBN13 == '=""', NA, str_extract(ISBN13, "\\d+")))
}