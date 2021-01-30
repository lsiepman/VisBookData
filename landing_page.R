landing_page <- div(
    titlePanel("Home"),
    h2("Please upload your Goodreads export"),
    fluidPage(
        sidebarLayout(
            sidebarPanel(
            fileInput("data", "Choose CSV File", accept = ".csv"),
            ),
            mainPanel(
            tableOutput("contents")
    )
  )
)
)