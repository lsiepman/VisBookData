server <- function(input, output) {
  router$server(input, output)

  output$contents <- renderTable({
    file <- input$data
    ext <- tools::file_ext(file$datapath)

    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))

    browser()
    data <- read.csv(file$datapath, check.names = F)
    process_data(data)
    
  })
}