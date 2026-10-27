library(shiny)

# Prepare the built-in data once when the app starts.
cars <- mtcars

cars$am <- factor(
  cars$am,
  levels = c(0, 1),
  labels = c("Automatic", "Manual")
)

cars$cyl <- factor(cars$cyl)

# Regression model used by the app.
mpg_model <- lm(mpg ~ wt + hp + am + cyl, data = cars)

function(input, output, session) {

  # Build a one-row data frame from the user's inputs.
  selected_car <- reactive({
    data.frame(
      wt = input$wt,
      hp = input$hp,
      am = factor(
        input$am,
        levels = levels(cars$am)
      ),
      cyl = factor(
        input$cyl,
        levels = levels(cars$cyl)
      )
    )
  })

  # Server-side calculation: predict MPG and a 95% prediction interval.
  prediction <- reactive({
    predict(
      mpg_model,
      newdata = selected_car(),
      interval = "prediction",
      level = 0.95
    )
  })

  output$predictedMPG <- renderText({
    sprintf("%.1f MPG", prediction()[1, "fit"])
  })

  output$predictionInterval <- renderText({
    sprintf(
      "%.1f to %.1f MPG",
      prediction()[1, "lwr"],
      prediction()[1, "upr"]
    )
  })

  output$comparison <- renderText({
    predicted <- prediction()[1, "fit"]
    average <- mean(cars$mpg)
    difference <- predicted - average

    if (difference >= 0) {
      sprintf("%.1f MPG above average", difference)
    } else {
      sprintf("%.1f MPG below average", abs(difference))
    }
  })

  output$interpretation <- renderText({
    sprintf(
      paste0(
        "For a %s car with %s cylinders, %.1f thousand lb of weight, ",
        "and %d horsepower, the model predicts approximately %.1f MPG."
      ),
      input$am,
      input$cyl,
      input$wt,
      input$hp,
      prediction()[1, "fit"]
    )
  })

  output$modelR2 <- renderText({
    sprintf("%.3f", summary(mpg_model)$r.squared)
  })

  output$averageMPG <- renderText({
    sprintf("%.1f MPG", mean(cars$mpg))
  })

  output$predictionPlot <- renderPlot({
    automatic <- cars$am == "Automatic"

    plot(
      cars$wt,
      cars$mpg,
      pch = ifelse(automatic, 1, 16),
      xlab = "Vehicle weight (1000 lb)",
      ylab = "Miles per gallon (MPG)",
      main = "Your Prediction Compared with mtcars",
      xlim = range(c(1.5, 5.5, cars$wt)),
      ylim = range(c(10, 35, cars$mpg))
    )

    points(
      input$wt,
      prediction()[1, "fit"],
      pch = 8,
      cex = 2,
      lwd = 2
    )

    legend(
      "topright",
      legend = c("Automatic cars", "Manual cars", "Your prediction"),
      pch = c(1, 16, 8),
      bty = "n"
    )

    abline(
      h = mean(cars$mpg),
      lty = 2
    )

    text(
      x = min(cars$wt),
      y = mean(cars$mpg),
      labels = " Dataset average",
      pos = 3,
      cex = 0.8
    )
  })
}
