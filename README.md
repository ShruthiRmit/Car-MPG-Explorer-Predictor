# Car MPG Explorer & Predictor

This repository contains a Shiny application created for the Coursera Developing Data Products course project.

## What the app does

The app predicts a car's miles per gallon (MPG) using:

- transmission type,
- number of cylinders,
- vehicle weight, and
- horsepower.

The prediction is generated from a multiple linear regression model trained on R's built-in `mtcars` dataset.

## Files

- `ui.R` — user interface, widgets, layout, and on-site documentation
- `server.R` — regression model, reactive calculations, prediction interval, and plot

## How to run locally

1. Install R and RStudio.
2. Install Shiny:

```r
install.packages("shiny")
```

3. Open the project folder in RStudio.
4. Run:

```r
shiny::runApp()
```

## How to use

1. Select Automatic or Manual transmission.
2. Select 4, 6, or 8 cylinders.
3. Choose vehicle weight.
4. Choose horsepower.
5. Read the predicted MPG and 95% prediction interval.
6. Compare the prediction with the vehicles shown in the plot.

The deployed app also contains a **How to Use** tab so all user documentation is available directly on the Shiny website.

## Model

The app fits:

```r
lm(mpg ~ wt + hp + am + cyl, data = cars)
```

The project is intended as an educational demonstration and not as an engineering or purchasing tool.
