# Load necessary packages
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(Bolstad, tidyverse, svDialogs, ggplot2, shiny, DT, rio)

# Set working directory to the directory of the current script
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Function to create the window for manual input
manual_data <- function(obj) {
  #Set up the main window
  dimensions <- fluidPage(
    titlePanel("Manual Data Input - Table Dimensions"),
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          "row_num",
          "Number of Rows:",
          min = 2,
          max = 20,
          value = 2
        ),
        sliderInput(
          "column_num",
          "Number of Columns:",
          min = 2,
          max = 2,
          value = 2
        ),
        actionButton("go_to_input", "Go to Input Data")
      ),
      mainPanel(textOutput("selected_dimensions"))
    )
  )
  
  #Set up the inner window
  editor <- fluidPage(
    titlePanel("Manual Data Input - Data Editor"),
    sidebarLayout(
      sidebarPanel(),
      mainPanel(
        DTOutput("data"),
        actionButton("done", "Done"),
        actionButton("go_back", "Go Back")
      )
    )
  )
  
  #Set up the server to make the code active
  srvr <- function(input, output, session) {
    row_num <- reactive({
      input$row_num
    })
    column_num <- reactive({
      input$column_num
    })
    
    output$dimensions <- renderText({
      paste("Dimensions:",
            input$row_num,
            "rows,",
            input$column_num,
            "columns")
    })
    
    data <- reactiveVal()
    
    observe({
      data1 <- data.frame(matrix(nrow = row_num(), ncol = column_num()))
      data(data1)
    })
    
    observeEvent(input$go_to_input, {
      showModal(modalDialog(title = "Data Editor", size = "l", editor))
      data_done <- data()
      data(data_done)
    })
    
    output$data <- renderDT({
      data()
    }, editable = TRUE)
    
    observeEvent(input$done, {
      data_done <- as.data.frame(data())
      data(data_done)
      data_done <- data()
      write.csv(data_done, "manualdata.csv", row.names = FALSE)
      showModal(
        modalDialog(
          title = "Data Submitted",
          "Your data has been submitted!",
          Sys.sleep(3),
          session$close(),
          stopApp()
        )
      )
    })
    
    observeEvent(input$go_back, {
      removeModal()
    })
    
  }
  
  # Runs the manual data input window
  # Note: Sometimes you may need to change which line below runs.
  # I'm not sure why that is the case, but occasionally it can't find
  # "srvr". Ususally, running the alternative line will cover the error,
  # but sometimes you need to completely restart the program or application
  # you are running it from.
  print(shinyApp(ui = dimensions, server = srvr))
  #print(obj)
}

# Function to generate the magic sequence. Can you find the pattern?
magic_number <- function(number) {
  #Initialize the needed variables
  old_num <- number
  old_word <- "NaN"
  new_num <- -1
  new_word <- "NaN"
  done <- FALSE
  turns <- 1
  
  #Create the basic list of numbers to access
  basic_nums <- list("zero",
                     "one",
                     "two",
                     "three",
                     "four",
                     "five",
                     "six",
                     "seven",
                     "eight",
                     "nine",
                     "ten")
  
  #Possible Expansion of Number Game could be here
  
  #Function that generates the complete sequence to the magic number
  num_to_words <- function(number) {
    old_num <- number
    while (!done) {
      if (old_num == 4 && turns > 1) {
        dlg_message("And four is the magic number!")
        dlg_message(
          paste(
            "It took you",
            turns,
            " steps to get from your number,",
            number,
            ", to the magic number!"
          )
        )
        done = TRUE
      } else if (number == 4 && turns == 1) {
        dlg_message("Four is the magic number!")
        done = TRUE
      } else {
        while (old_num != 4) {
          old_word <- basic_nums[old_num + 1]
          new_num <- nchar(old_word)
          new_word <- basic_nums[new_num + 1]
          
          dlg_message(paste(toupper(old_word), "is", new_word, "."), type = "ok")
          turns <- turns + 1
          old_num <- new_num
        }
      }
    }
  }
  
  #Runs the magic sequencing code
  num_to_words(number)
}

# Initialize data variable
data1 <- NULL
all_done <- FALSE

#Runs the program until exit command is initiated from the main menu
while (!all_done) {
  #Opens and runs the main menu
  my_choice <- dlg_list(
    c(
      "Choose an Option",
      "Linear Regression",
      "Complex Numbers",
      "Magic Number",
      "Exit"
    ),
    title = "Main Menu"
  )$res
  
  #If main menu is cancelled, exits the program
  if (is_empty(my_choice)) {
    my_choice <- "Exit"
  }
  
  #Runs code based off of user's choice
  if (my_choice == "Linear Regression") {
    # Ask user if they want to import data
    resp1 <- dlg_message(
      "Would you like to import CSV data or use automatically provided test data?",
      type = "yesno",
      gui = .GUI
    )
    userres <- resp1$res
    
    #Runs menu to import a CSV file. Currently the test file is guaranteed to work. Errors appear if the file is not set up correctly.
    if (userres == "yes") {
      opt <- dlg_list(c("Online (BETA)", "On Computer (BETA)", "Test Data"),
                      title = "Import from...")$res
      
      if (is_empty(opt)) {
        opt <- "menu"
      }
      
      #Imports data from an online file
      if (opt == "Online") {
        dlgMessage(
          "Warning: BETA testing only. Errors may propogate and crash the program if the file isn't set up properly."
        )
        url <- dlg_input(message = "Please enter the url to the data table: ")$res
        data1 <- rio::import(url)
        
        #Imports data from a file on the computer
      } else if (opt == "On Computer") {
        dlgMessage(
          "Warning: BETA testing only. Errors may propogate and crash the program if the file isn't set up properly."
        )
        resp <- dlg_open(title = "Import CSV data for Linear Regression")$res
        
        # Check if resp is character
        if (is.character(resp)) {
          resp <- as.character(resp)
          
          #Reads in an Excel file if possible
          if (endsWith(resp, ".xlsx") | endsWith(resp, ".xls")) {
            data1 <- readxl::read_excel(resp)
            data1 <- as.data.frame(data1)
            
            #Reads in a CSV file if possible
          } else if (endsWith(resp, ".csv")) {
            data1 <- read.csv(resp, row.names = 1)
            data1 <- as.data.frame(data1)
          }
          
          #A little fun bit I wanted to add in because I learned how to do it.
          load <- winProgressBar(title = "Loading file...", label = "0% done")
          for (i in 1:100) {
            Sys.sleep(0.02)
            info <- sprintf("%d%% done", round((i / 100) * 100))
            setWinProgressBar(load, i / 100, label = info)
          }
          Sys.sleep(0.2)
          close(load)
          dlg_message("Upload Complete")
          
        } else {
          #Catches any non-Excel or non-CSV files
          dlg_message(
            "Invalid file selection. Please select a file.",
            type = "ok",
            gui = .GUI
          )
        }
        
        #Imports the default test data
      } else if (opt == "Test Data") {
        data1 <- as.data.frame(read.csv("defaultTestData.csv"))
        
        #Creates a loading bar (Only works on Windows, unfortunately)
        load <- winProgressBar(title = "Loading test data file...", label = "0% done")
        for (i in 1:100) {
          Sys.sleep(0.02)
          info <- sprintf("%d%% done", round((i / 100) * 100))
          setWinProgressBar(load, i / 100, label = info)
        }
        Sys.sleep(0.2)
        close(load)
        dlg_message("Upload Complete.")
      }
      
      #Starts the manual data input process.
    } else if (userres == "no") {
      dlg_message("You will need to input your data manually.",
                  type = "ok",
                  gui = .GUI)
      
      manual_data(shinyApp(ui = dimensions, server = srvr))
    }
    
    # Check if data is available
    if (!is.null(data1)) {
      col1 <- colnames(data1)[1]
      col2 <- colnames(data1)[2]
      colnames(data1)[1] <- "X1"
      colnames(data1)[2] <- "X2"
      
      # Plots data
      plot <- ggplot(data1, aes(X1, X2)) +
        geom_point(color = "blue1") +
        geom_smooth(method = lm,
                    color = "aquamarine",
                    se = FALSE) +
        labs(x = col1, y = col2, title = "Linear Regression Plot")
      
      print(plot)
      
      # Perform linear regression
      datalinreg <- lm(X2 ~ X1, data = data1)
      
      # Display regression line equation
      msgBox(
        message = paste(
          "The equation of the regression line is y = ",
          datalinreg$coefficients[2],
          "x + ",
          datalinreg$coefficients[1],
          "."
        )
      )
    }
    
    #Starts the complex numbers program
  } else if (my_choice == "Complex Numbers") {
    num <- as.integer(dlg_input("Please enter an integer (1-1000): ", default = 64)$res)
    
    # Makes sure the value is not empty before proceeding
    if (!is_empty(num)) {
      dlg_message(
        paste(
          "We will now take your number (",
          num,
          ") and convert it into a complex number."
        ),
        type = "ok"
      )
      
      #Creates a loading bar (Only works on Windows, unfortunately)
      load <- winProgressBar(title = "Preparing Your Number...", label = "0% done")
      for (i in 1:20) {
        Sys.sleep(0.05)
        info <- sprintf("%d%% done", round((i / 100) * 100))
        setWinProgressBar(load, i / 100, label = info)
      }
      
      #Begins calculations using absolute value and turns one value into a complex
      pos_num <- abs(num)
      abs_num <- -abs(num)
      cpnum <- as.complex(abs_num)
      
      chg_t <- "Taking the Sqare Root..."
      setWinProgressBar(load, 20, title = chg_t)
      for (i in 21:40) {
        Sys.sleep(0.05)
        info <- sprintf("%d%% done", round((i / 100) * 100))
        setWinProgressBar(load, i / 100, label = info)
      }
      
      #Takes the square root, rounds, and combines the two values into one complex.
      sqrt_num <- sqrt(pos_num + 64)
      cpnum <- as.complex(round(sqrt(cpnum), digits = 2) + round(sqrt_num, digits = 2))
      
      chg_t <- "Dividing By Zero..."
      setWinProgressBar(load, 40, title = chg_t)
      for (i in 41:60) {
        Sys.sleep(0.05)
        info <- sprintf("%d%% done", round((i / 100) * 100))
        setWinProgressBar(load, i / 100, label = info)
      }
      
      #Takes the modulus of the complex and rounds
      mnum <- round(Mod(cpnum), digits = 2)
      
      chg_t <- "Applying Mathemagic..."
      setWinProgressBar(load, 60, title = chg_t)
      for (i in 61:80) {
        Sys.sleep(0.05)
        info <- sprintf("%d%% done", round((i / 100) * 100))
        setWinProgressBar(load, i / 100, label = info)
      }
      
      #Takes the complex argument of the complex
      anum <- round(Arg(cpnum), digits = 2)
      
      chg_t <- "Finishing with Fairy Dust..."
      setWinProgressBar(load, 80, title = chg_t)
      for (i in 81:100) {
        Sys.sleep(0.05)
        info <- sprintf("%d%% done", round((i / 100) * 100))
        setWinProgressBar(load, i / 100, label = info)
      }
      
      #Finds the conjugate of the complex
      cnum <- round(Conj(cpnum), digits = 2)

      Sys.sleep(0.25)
      close(load)
      dlg_message("Complex Transformation Complete.")
      
      #Prints out the information calculated for the user.
      dlg_message(
        paste(
          "The converted version of your number (",
          num,
          ") in complex form is ",
          cpnum,
          "."
        ),
        type = "ok"
      )
      dlg_message(
        paste(
          "The polar representation of the converted version of your number (",
          num,
          ") is (",
          mnum,
          ",",
          anum,
          ")."
        ),
        type = "ok"
      )
      dlg_message(
        paste(
          "The conjugate of the converted version of your number (",
          num,
          ") is ",
          cnum,
          "."
        ),
        type = "ok"
      )
    }
    
    #Runs the Magic Number Game
  } else if (my_choice == "Magic Number") {
    dlg_message(
      "Welcome to the Magic Number Game! (WARNING: Current functionality only works for numbers 0-10.)"
    )
    mynum <- -1
    
    #Double checks to make sure the value is in the correct bounds.
    while (mynum > 10 || mynum < 0) {
      mynum <- as.integer(dlg_input("Please enter a number (0-10): ")$res)
      if (is_empty(mynum)) {
        break
      }
      if (mynum > 10 || mynum < 0) {
        dlg_message("Invalid number. Please enter a new number.", type = "ok")
      }
    }
    if (!is_empty(mynum)) {
      magic_number(mynum)
    }
    
    #Lets the user exit the program
  } else if (my_choice == "Exit") {
    all_done <- TRUE
  }
}
