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
    # browser()
    data %>% 
      # browser()
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
      )
              
  })
    output$plot_pub_vs_read <- renderPlot({date_pub_vs_read(graph_data())})
}