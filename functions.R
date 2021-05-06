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

date_pub_vs_read <- function(data) {

  plot_dates <- ggplot(data, aes(x = as.Date(date_read), y = publication_year, color = `read count`)) +
    geom_point(colour = "#d23451") + 
    labs(title = "Year of publication vs date read") +
    xlab("Date read") +
    ylab("Year published") + 
    theme_bw() + 
    scale_x_date()
  
  return(plot_dates)
}