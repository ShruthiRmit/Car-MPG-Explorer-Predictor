library(shiny)

navbarPage(
  title = "Car MPG Explorer & Predictor",

  tabPanel(
    "MPG Predictor",
    fluidPage(
      br(),
      titlePanel("Estimate a Car's Fuel Economy"),
      p(
        "Choose a few vehicle characteristics below. ",
        "The app uses a regression model trained on the built-in mtcars dataset ",
        "to estimate miles per gallon (MPG)."
      ),

      sidebarLayout(
        sidebarPanel(
          radioButtons(
            inputId = "am",
            label = "Transmission",
            choices = c("Automatic", "Manual"),
            selected = "Automatic"
          ),

          selectInput(
            inputId = "cyl",
            label = "Number of cylinders",
            choices = c("4", "6", "8"),
            selected = "6"
          ),

          sliderInput(
            inputId = "wt",
            label = "Vehicle weight (1000 lb)",
            min = 1.5,
            max = 5.5,
            value = 3.0,
            step = 0.1
          ),

          sliderInput(
            inputId = "hp",
            label = "Horsepower",
            min = 50,
            max = 350,
            value = 150,
            step = 5
          ),

          helpText(
            "Tip: Move the sliders or change the transmission/cylinder options. ",
            "The results update automatically."
          )
        ),

        mainPanel(
          wellPanel(
            h3("Predicted fuel economy"),
            h2(textOutput("predictedMPG", inline = TRUE)),
            p(strong("95% prediction interval: "), textOutput("predictionInterval", inline = TRUE)),
            p(strong("Compared with the mtcars average: "), textOutput("comparison", inline = TRUE))
          ),

          plotOutput("predictionPlot", height = "420px"),

          h4("What does this mean?"),
          textOutput("interpretation")
        )
      )
    )
  ),

  tabPanel(
    "How to Use",
    fluidPage(
      br(),
      h2("How to Use This App"),
      p("This application is designed for a beginner. No statistical knowledge is required."),

      tags$ol(
        tags$li("Choose whether the car has an automatic or manual transmission."),
        tags$li("Choose the number of cylinders."),
        tags$li("Use the weight slider to enter the approximate vehicle weight in thousands of pounds."),
        tags$li("Use the horsepower slider to enter the approximate engine horsepower."),
        tags$li("Read the predicted MPG and its 95% prediction interval."),
        tags$li("Use the plot to compare your selected car with the cars in the mtcars dataset.")
      ),

      h3("How to read the output"),
      tags$ul(
        tags$li(
          strong("Predicted MPG: "),
          "the model's best estimate of fuel economy for the selected characteristics."
        ),
        tags$li(
          strong("95% prediction interval: "),
          "a range showing the uncertainty for the MPG of an individual car."
        ),
        tags$li(
          strong("Comparison: "),
          "shows whether the prediction is above or below the average MPG in the dataset."
        )
      ),

      h3("Important limitation"),
      p(
        "The app is an educational demonstration based on only 32 cars from the mtcars dataset. ",
        "It should not be used as an engineering specification or a purchasing guarantee."
      )
    )
  ),

  tabPanel(
    "About the Model",
    fluidPage(
      br(),
      h2("Model Information"),
      p(
        "The prediction model is a multiple linear regression fitted to the built-in R dataset ",
        code("mtcars"), "."
      ),
      p(strong("Model formula:")),
      code("mpg ~ wt + hp + am + cyl"),
      br(), br(),

      p(strong("Model R-squared: "), textOutput("modelR2", inline = TRUE)),
      p(strong("Dataset average MPG: "), textOutput("averageMPG", inline = TRUE)),

      h3("Variables"),
      tags$ul(
        tags$li(code("mpg"), " — miles per gallon (outcome)"),
        tags$li(code("wt"), " — vehicle weight in thousands of pounds"),
        tags$li(code("hp"), " — gross horsepower"),
        tags$li(code("am"), " — transmission type"),
        tags$li(code("cyl"), " — number of cylinders")
      ),

      p(
        "All calculations are performed reactively on the server whenever an input changes."
      )
    )
  )
)
