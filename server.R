server <- function(input, output) {
  router$server(input, output)

  output$data <- renderDT({
      file <- input$data
      ext <- tools::file_ext(file$datapath)
  
      req(file)
      validate(need(ext == "csv", "Please upload a csv file"))
  
      data <- read.csv(file$datapath, check.names = F)
      data <- process_data(data)
  },
  filter = "top", options = list(pageLength = 10)
  )
  
  observeEvent(input$data, {
    change_page("visualisations")
  })
}