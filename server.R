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
  
  graph_data <- reactive({data %>% filter(`exclusive shelf` %in% input$ExclusiveShelves)})
              

    output$plot_pub_vs_read <- renderPlot({date_pub_vs_read(graph_data())})
}