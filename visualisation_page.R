vis_page <- div(
   navbarPage("VisBookData",
              tabPanel("View data",
  
                        mainPanel(
                          titlePanel("Visualisations"),
                          dataTableOutput('data')
                        )
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