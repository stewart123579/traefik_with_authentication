# A slightly modified version of the R-Shiny demo '09_upload'


library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(

  tabsetPanel(
    id = "wizard",
    type = "hidden",
    tabPanel("welcome",
      "Welcome!  You're not allowed to see customer data.  Imagine an amazing demo..."
    ),
    tabPanel("group1_sales",

  # App title ----
  titlePanel("Uploading Files"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",

                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),

      # Horizontal line ----
      tags$hr(),

      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),

      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),

      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),

      # Horizontal line ----
      tags$hr(),

      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head")

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Data file ----
      tableOutput("contents")

    )

  )
  ),    tabPanel("group1_lead",
      "You're in a leadership role.  Here are all the customer summaries.  Imagine some amaing graphs!"
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output, session) {

  output$contents <- renderTable({

    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.

    req(input$file1)

    df <- read.csv(input$file1$datapath,
             header = input$header,
             sep = input$sep,
             quote = input$quote)

    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }

  })

  groups <- session$request$HTTP_REMOTE_GROUPS
  print("Groups >")
  print(groups)
  print("<")

  if (is.null(groups)) {
    show_page <- "welcome"
  } else if ("group1_sales" %in% strsplit(groups, ",")[[1]]) {
    show_page <- "group1_sales"
  } else if ("group1_lead" %in% strsplit(groups, ",")[[1]]) {
    show_page <- "group1_lead"
  } else {
    show_page <- "welcome"
  }

  updateTabsetPanel(inputId = "wizard", selected = show_page)
}

# Create Shiny app ----
shinyApp(ui, server)
