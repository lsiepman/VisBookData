server <- function(input, output) {
  router$server(input, output)

  output$data <- renderDataTable({
    file <- input$data
    ext <- tools::file_ext(file$datapath)

    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))

    data <- read.csv(file$datapath, check.names = F)
    data <- process_data(data)
  })
  
  observeEvent(input$data, {
    change_page("visualisations")
  })
}