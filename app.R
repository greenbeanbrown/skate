ui <- fluidPage(
  # make button
  actionButton(inputId = 'make',
               label = 'Make',
  ),
  
  # miss button
  actionButton(inputId = 'miss',
               label = 'Miss',
  ),
  
  # print outputs
  textOutput('make'),
  textOutput('miss'),
  textOutput('total')
)

server <- function(input, output){
  
  ##############################################################
  # NEXT STEPS: 
  #
  # CREATE A LOGGING SYSTEM FOR TRACKING DATA
  #  -CREATE A DATABASE(POSTGRESQL OR MYSQL)
  #  - CONNECT R SERVER SCRIPT TO THE DB 
  #  - CREATE A REACTIVE FUNCTION THAT DYNAMICALLY UPDATES THE DB 
  #
  ##############################################################  
  
  # track the number of makes, misses, total attempts
  output$make <- renderText( { input$make })
  output$miss <- renderText( { input$miss })
  output$total <- renderText({input$make + input$miss})
  
  
  
}

# run the app
shinyApp(ui = ui, server = server)