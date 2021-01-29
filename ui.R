router <- make_router(
  route("/", landing_page)
)

ui <- fluidPage(
  tags$ul(
    tags$li(a(href = route_link("/"), "Home"))
  ),
  router$ui
)
# https://www.r-bloggers.com/2020/11/basic-multipage-routing-tutorial-for-shiny-apps-shiny-router/