landing_page <- div(
    fluidPage(
         fluidRow(
                br(),
                br(),
                br(),
                column(width = 4, offset = 4, style = "background-color:white;",
                br(),
                h3("Please upload your Goodreads export"),
                br(),
                fileInput("data", "Choose CSV File", accept = ".csv")
            ),
        )
    ),
    setBackgroundImage("books_image.jpg"),
    absolutePanel("Created by Laura Siepman", 
                  style = "background-color:white;", 
                  bottom = 0, left = 0, fixed = TRUE)
)

