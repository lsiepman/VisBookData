vis_page <- div(
   navbarPage("VisBookData",
              tabPanel("View data",
                      fluidRow(
                        column(style = "background-color:white;", width = 12,
                          titlePanel("Visualisations"),
                          DTOutput('table', width = "100%")
                        )),
                          br(),
                         
                       absolutePanel("Created by Laura Siepman", 
                                     style = "background-color:white;", 
                                     bottom = 0, left = 0, fixed = TRUE)
              ),
              
              tabPanel("Statistics",
                       sidebarLayout(
                         sidebarPanel(
                           titlePanel("Filter values"),
                           checkboxInput("dateReadFilter", "Filter by date read"),
                           checkboxInput("datePubFilter", "Filter by date published"),
                           
                           sliderInput("DateReadSlider",
                                       "Dates read:",
                                       min = min(as.Date(data$date_read), na.rm = T),
                                       max = max(as.Date(data$date_read), na.rm = T),
                                       value = c(min(as.Date(data$date_read), na.rm = T),
                                                 max(as.Date(data$date_read), na.rm = T))
                                       
                           ),
                           sliderInput("DatePubSlider",
                                       "Dates published:",
                                       min = min(data$publication_year, na.rm = T),
                                       max = max(data$publication_year, na.rm = T),
                                       value = c(min(data$publication_year, na.rm = T),
                                                 max(data$publication_year, na.rm = T)),
                                       sep = "", step = 1
                                       
                           ),
                           sliderInput("ReadCountSlider", "Read count:",
                                       min = min(data$`read count`),
                                       max = max(data$`read count`),
                                       value = c(min(data$`read count`),
                                                 max(data$`read count`)), step = 1),
                           
                           selectInput("ExclusiveShelves", "Exclusive shelves",
                                       choices = unique(data$`exclusive shelf`),
                                       selected = unique(data$`exclusive shelf`),
                                       multiple = T),
                           
                           
                           p("Include the following shelves:"),
                           
                           
                           lapply(unique(unlist(strsplit(as.character(data$bookshelves), ", "))),
                                  function(shelf){
                                    checkboxInput(glue("{shelf}ShelfCheckbox"),
                                                  glue("{shelf}"), value = T)
                                  })
                         ),
                         mainPanel(
                           style = "background-color:white;",
                           h1("Stats page"),
                           
                           h3("Global stats"),
                           h4("Total stats"),
                           tableOutput('global_total_stats')
                           ,
                           
                           p("genre stats"),
                           
                           h3("Custom stats"),
                           p("total stats"),
                           
                           p("genre stats")
                           
                         )
                       )
              ),
              
              tabPanel("Graphs",
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Filter values"),
                           checkboxInput("dateReadFilter", "Filter by date read"),
                           checkboxInput("datePubFilter", "Filter by date published"),

                           sliderInput("DateReadSlider",
                                       "Dates read:",
                                       min = min(as.Date(data$date_read), na.rm = T),
                                       max = max(as.Date(data$date_read), na.rm = T),
                                       value = c(min(as.Date(data$date_read), na.rm = T),
                                                 max(as.Date(data$date_read), na.rm = T))

                         ),
                         sliderInput("DatePubSlider",
                                     "Dates published:",
                                     min = min(data$publication_year, na.rm = T),
                                     max = max(data$publication_year, na.rm = T),
                                     value = c(min(data$publication_year, na.rm = T),
                                               max(data$publication_year, na.rm = T)),
                                     sep = "", step = 1

                         ),
                         sliderInput("ReadCountSlider", "Read count:",
                                     min = min(data$`read count`),
                                     max = max(data$`read count`),
                                     value = c(min(data$`read count`),
                                           max(data$`read count`)), step = 1),

                         selectInput("ExclusiveShelves", "Exclusive shelves",
                                     choices = unique(data$`exclusive shelf`),
                                     selected = unique(data$`exclusive shelf`),
                                     multiple = T),


                           p("Include the following shelves:"),


                           lapply(unique(unlist(strsplit(as.character(data$bookshelves), ", "))),
                                  function(shelf){
                                    checkboxInput(glue("{shelf}ShelfCheckbox"),
                                                  glue("{shelf}"), value = T)
                                  })
                         
                          ),
                       mainPanel(style = "background-color:white;",
                         h1("Graphs"),
                         br(),
                         plotOutput("plot_pub_vs_read"),
                         plotOutput("plot_pages_over_time"),
                         plotOutput("plot_books_over_time"),
                         plotOutput("plot_pages_per_genre")
                       )),
                       br(),
                       
                       absolutePanel("Created by Laura Siepman", 
                                     style = "background-color:white;", 
                                     bottom = 0, left = 0, fixed = TRUE)
              )
  )
)