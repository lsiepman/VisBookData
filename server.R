server <- function(input, output) {
  router$server(input, output)
  
  # data <- reactive({read.csv(input$filedata$datapath, check.names = F)})

  # data <- process_data(data)
  output$table <- renderDT(data, 
                           filter = "top", 
                           options = list(pageLength = 10))
  # )
  
  observeEvent(input$data, {
    change_page("visualisations")
  })

  graph_data <- reactive({ 
    # original data
    data %>% 

      # exclusiveShelf selection
      filter(`exclusive shelf` %in% input$ExclusiveShelves) %>% 
      
      # dateRead filtering
      filter(., if(input$dateReadFilter) {
         between(as.Date(date_read), 
                 as.Date(input$DateReadSlider[1]), 
                 as.Date(input$DateReadSlider[2]))
        } else {
          TRUE
        }
      ) %>% 
      
      # datePublished filtering
      filter(., if(input$datePubFilter) {
        between(as.integer(publication_year),
                as.integer(input$DatePubSlider[1]),
                as.integer(input$DatePubSlider[2]))
      } else {
          TRUE
      }
      ) %>% 
      
      # readCount filtering
      
      filter(., between(as.integer(`read count`), 
                        as.integer(input$ReadCountSlider[1]),
                        as.integer(input$ReadCountSlider[2])
                        )
             )

  })
    output$plot_pub_vs_read <- renderPlot({date_pub_vs_read(graph_data())})
    output$plot_pages_over_time <- renderPlot({num_pages_over_time(graph_data())})
    output$plot_books_over_time <- renderPlot({num_books_over_time(graph_data())})
    output$plot_pages_per_genre <- renderPlot({pages_per_genre(graph_data())})
    
    output$global_total_stats <- renderTable({ calc_stats(data)})
}