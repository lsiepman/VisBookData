vis_page <- div(
   navbarPage("VisBookData",
              tabPanel("View data",
                      fluidRow(
                        column(style = "background-color:white;", width = 12,
                          titlePanel("Visualisations"),
                          DTOutput('data', width = "100%")
                        )),
                          br(),
                         
                       absolutePanel("Created by Laura Siepman", 
                                     style = "background-color:white;", 
                                     bottom = 0, left = 0, fixed = TRUE)
              ),
              
              tabPanel("Statistics",
                       mainPanel(
                         h1("Stats page")
                       )
              ),
              
              tabPanel("Graphs",
                       mainPanel(
                         h1("graphs page")
                       )
              )
  )
)