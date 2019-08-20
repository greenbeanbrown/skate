library(RMySQL)

# create MySql connection - this is being hosted locally for now (hence the user/password)
con <- dbConnect(MySQL(),
                 user = 'remote',
                 password = 'password',
                 host = 'localhost',
                 dbname = 'skate')

# sending a quick query to determine the current session ID
session_id <- dbGetQuery(con, 'SELECT (CASE WHEN MAX(session_id) IS NULL THEN 0 ELSE MAX(session_id) END) FROM skate')[1,1] + 1

ui <- fluidPage(
  
  # trick dropdown menu
  selectInput(inputId = 'trick',
              label = 'Select your trick',
              c('Ollie', 'Kickflip','Heelflip','FS 180','BS 180','Boardslide','50-50')
  ),
  
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
  #   - ADDED A selectInput() BOX TO ALLOW USER TO CHOOSE DIFFERENT TRICKS AND UPDATE DB ACCORDINGLY  
  #   - ADDED FUNCTION TO DISCONNECT FROM THE DATABASE UPON CLOSING THE APP (BRIEFLY TESTED, I THINK IT'S WORKING PROPERLY)
  #   - ADDED session_id TRACKING AND UPDATED DB ACCORDINGLY
  #
  ##############################################################  
  #
  #  NEXT STEPS:
  #   - NEED TO RESET attempt_nbr AND make/miss UPON CHANGING THE TRICK
  #      - could set to autoincrement and reset the number each session with ALTER
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
  output$trick <- renderText( { input$trick })
  output$make <- renderText( { input$make })
  output$miss <- renderText( { input$miss })
  output$total <- renderText( { input$make + input$miss})
  
  # make 
  observeEvent(input$make, {
    # upon clicking the make button, send an insert query with the made attempt
    #sql = paste0('INSERT INTO skate.skate ( date, time, trick, attempt_nbr, make, miss) VALUES (curdate(), curtime(), \'',input$trick, '\',',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    #sql = paste0('INSERT INTO skate.skate ( date, time, trick, attempt_nbr, make, miss) VALUES (curdate(), curtime(), \'',input$trick, '\',',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    sql = paste0('INSERT INTO skate.skate ( session_id, date, time, trick, attempt_nbr, make, miss) VALUES (',session_id,', curdate(), curtime(), \'',input$trick, '\',',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    print(sql)
    query <- dbSendQuery(con, sql)
  })
  
  # miss
  observeEvent(input$miss, {
    # upon clicking the make button, send an insert query with the missed attempt
    sql = paste0('INSERT INTO skate.skate ( session_id, date, time, trick, attempt_nbr, make, miss) VALUES (',session_id,', curdate(), curtime(), \'',input$trick, '\',',(input$make + input$miss),', ',input$make,', ',input$miss,')')
    query <- dbSendQuery(con, sql)
  })
}

# disconnect from the DB upon closing
onStop(function(){
  dbDisconnect(con)
  })

# run the app
shinyApp(ui = ui, server = server)
