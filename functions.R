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

#' Date published vs date read
#' 
#' Show a scattesplot with date published vs date read
#' @param data dataframe
#' @return plot
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

#' Number of pages read over time
#' 
#' Create a plot with the number of pages read over time
#' @param data dataframe
#' @return plot
num_pages_over_time <- function(data) {
  data <- data %>% 
    filter(`exclusive shelf` == "read") %>% 
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

#' Number of books read over time
#' 
#' Create a plot with the number of books read over time
#' @param data dataframe
#' @return plot
num_books_over_time <- function(data) {
  data <- data %>% 
    filter(`exclusive shelf` == "read") %>% 
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
#' Pages per genre
#' 
#' Shows the number of read pages per genre
#' @param data dataframe
#' @return plot
pages_per_genre <- function(data) {

  excl_shelves <- unique(unlist(strsplit(as.character(data$bookshelves), ", ")))
  excl_shelves<- excl_shelves[!excl_shelves %in% c("currently-reading", "to-read")]
  
  page_count <- tibble(excl_shelves, pages = 0)
  
  data <- data %>% 
    filter(`exclusive shelf` == "read") 
  
  for (idx in 1:nrow(data)) {
    curr_shelves <- unlist(strsplit(as.character(data$bookshelves[[idx]]), ", "))
    for (shelf in excl_shelves){
      if (shelf %in% curr_shelves){
        old_val <- as.integer(page_count[page_count$excl_shelves == shelf, "pages"][1])
        page_count[page_count$excl_shelves == shelf, "pages"] <- old_val + data[idx, "number of pages"]
      }
    }
  }
  plot_genres <- ggplot(page_count, aes(x = excl_shelves, y = pages)) +
    geom_bar(stat = "identity", colour = "#35cee6", fill = "#35cee6") +
    coord_flip() + 
    theme_bw() + 
    labs(title = "Number of pages read per genre") + 
    ylab("Number of pages") +
    xlab("Genre")
  
  return(plot_genres)
}

#' calc_stats
#' 
#' Calculates number of books and number of pages read (per year) for the data inserted
#' @param data dataframe with the columns date_read ("%Y/%m/%d") and `number of pages`
#' @return shiny table
calc_stats <- function(data){
  
  necessary_info <- data %>% 
    select(date_read, `number of pages`)
  
  data_per_year <- necessary_info %>% filter(date_read != "") %>% 
    mutate(year_read = format(as.Date(date_read, format="%Y/%m/%d"),"%Y")) %>% 
    group_by(year_read) %>% 
    summarise(books_read = n(), pages_read = sum(`number of pages`)) %>% 
    arrange(year_read)
  
  
  total_data <- necessary_info %>% 
    summarise(books_read = n(), pages_read = sum(`number of pages`)) %>% 
    mutate(year_read = "Total") %>% relocate(year_read, .before = books_read)
  
  result <- rbind(total_data, data_per_year)
  
}