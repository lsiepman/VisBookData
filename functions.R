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
  data <- data %>% filter(`exclusive shelf` == "read")
  plot_dates <- ggplot(data, aes(y = as.integer(publication_year))) +
    labs(title = "Year of publication vs date read") +
    xlab("Date read") +
    ylab("Year published") + 
    theme_bw() + 
    scale_x_date(date_labels = "%Y-%m-%d") 

  if (nrow(data) == 0 || all (nchar(data$date_read) == 0)){
    plot_dates <- plot_dates + geom_blank(aes(x = Sys.Date()))
    } else {
    plot_dates <- plot_dates + geom_point(aes(x = as.Date(date_read)), colour = "#d23451")
  }
  
  
  return(plot_dates)
}

num_pages_over_time <- function(data) {
  data <- data %>% 
    arrange(date_read) %>% 
    mutate(read_pages = cumsum(`number of pages`))
  
  plot_pages <- ggplot(data, aes(x = as.Date(date_read), y = read_pages)) + 
    geom_step(colour = "#35cee6") + 
    labs(title = "Number of read pages over time") + 
    xlab("Time") + 
    ylab("Number of pages") +
    theme_bw() +
    scale_x_date(date_labels = "%Y-%m-%d")

  return(plot_pages)
  
}

num_books_over_time <- function(data) {
  data <- data %>% 
    arrange(date_read) %>% 
    mutate(num_books = row_number())
  
  plot_books <- ggplot(data, aes(x = as.Date(date_read), y = num_books)) +
    geom_step(colour = "#39f0b6") + 
    labs(title = "Number of books read over time") + 
    xlab("Time") + 
    ylab("Number of books") +
    theme_bw() +
    scale_x_date(date_labels = "%Y-%m-%d")
  
  return(plot_books)
}