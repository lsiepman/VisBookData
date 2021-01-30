router <- make_router(
  route("/", landing_page),
  route("visualisations", vis_page)
)

ui <- fluidPage(
  title = "Goodreads visualiser",
  router$ui
)
# https://www.r-bloggers.com/2020/11/basic-multipage-routing-tutorial-for-shiny-apps-shiny-router/