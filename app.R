#library(RMySQL)

# create MySql connection - this is being hosted locally for now (hence the user/password)
con <- dbConnect(MySQL(),
                 user = 'remote',
                 password = 'password',
                 host = 'localhost',
                 dbname = 'skate')

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
  #
  # COMPLETED:
  #   - CREATED A LOGGING SYSTEM FOR TRACKING DATA
  #     -CREATED A DATABASE (MYSQL)
  #     - CONNECTED SERVER.R SCRIPT TO THE DB 
  #     - CREATED REACTIVE FUNCTIONS THAT DYNAMICALLY UPDATE THE DB 
  #
  ##############################################################  
  #
  #  NEXT STEPS:
  #   - ADD A selectInput() BOX TO ALLOW USER TO CHOOSE DIFFERENT TRICKS AND UPDATE DB ACCORDINGLY  
  #   - NEED TO RESEARCH IF DISCONNECTING FROM THE DB IS NECESSARY AND IMPLEMENT IF NEED BE
  #   - HOST THE APP ON A WEB SERVER
  #
  ##############################################################  
  #
  # MySql DB DETAILS: 
  #       - NAME: skate
  #       - TABLES: skate
  #       - COLUMNS:
  #           - attempt_id (auto-increment)
  #           - date
  #           - time
  #           - trick
  #           - attempt_nbr
  #           - make
  #           - miss
  #
  ##############################################################  
  
  # track the number of makes, misses, total attempts
  output$make <- renderText( { input$make })
  output$miss <- renderText( { input$miss })
  output$total <- renderText( { input$make + input$miss })
  
  # INSERTING DATA INTO THE DATABASE
  
  # make 
  observeEvent(input$make, {
    # upon clicking the make button, send an insert query with the made attempt
    sql = paste0('INSERT INTO skate.skate ( date, time, trick, attempt_nbr, make, miss) VALUES (curdate(), curtime(), \'kickflip\', ',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    query <- dbSendQuery(con, sql)
  })
  
  # miss
  observeEvent(input$miss, {
    # upon clicking the make button, send an insert query with the missed attempt
    sql = paste0('INSERT INTO skate.skate ( date, time, trick, attempt_nbr, make, miss) VALUES (curdate(), curtime(), \'kickflip\', ',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    query <- dbSendQuery(con, sql)
  })
}

# run the app
shinyApp(ui = ui, server = server)
