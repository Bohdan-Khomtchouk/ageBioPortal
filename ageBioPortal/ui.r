#-----------------------------------------------------------------------------#
#--------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>-------#
#--------------------------------ageBioPortal---------------------------------#
#--------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>-------#
#-----------------------------------------------------------------------------#


## load libraries
require(shiny)
require(shinyWidgets)

## start UI
ui <- fluidPage(
  tags$head(
    ## -- Add Tracking JS File 
    includeScript("google-analytics.js"),
    ## -- Add Webpage Customizations
    tags$style(
      HTML(".shiny-notification {
                height: 100px;
                width: 800px;
                position:fixed;
                top: calc(50% - 50px);;
                left: calc(50% - 400px);;
           }", 
           "body {background-color: lightgrey; }"
           ),
      type = "text/css", 
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }", 
      "#finwell {margin: auto;}", 
      ".my_style1{background-color:black;} .my_style1{color: white;} .my_style1{font-family: Courier New}",
      ".my_style2{background-color:black;} .my_style2{color: white;} .my_style2{font-family: Courier New}"
              )
            ),
  
  #-----------------------------------------------------------------------------#
  #--------------------------------- Main body ---------------------------------#
  #-----------------------------------------------------------------------------#
  absolutePanel(top = 0, bottom = 125, left = 0, width = '100%',
                fluidRow(
                  titlePanel(h2("")), 
                  align = "center",
                  img(src = "ageBioPortal_logo_oval.png", width = "75%", height = "75%", style = "display: block; margin-left: auto; margin-right: auto;")
                )),
  
  tabPanel("Thank you for using ageBioPortal!",
    sidebarLayout(
          absolutePanel(top = "80%", width = "100%", align = "center",
                        searchInput(
                        inputId = "search_id", 
                        label = "", 
                        placeholder = "E.g., LRRK2 and Parkinson's disease", 
                        btnSearch = icon("search"), 
                        btnReset = icon("remove"),
                        width = '400px'
                      ),
                    fixed=TRUE
                      #br(),
                      #br()
                  ),
      
        mainPanel(NULL)
      
                )
            )
        )