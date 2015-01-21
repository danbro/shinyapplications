library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Daily electricity consumption of your house"),
        sidebarPanel(
                h3("Basic Information"),
                h5("Fill in the form to predict your daily electricity profile"),
                numericInput("occupancy", "How many people live in your house?",1,min=1,max=5,step=1),
                radioButtons("size","How big is your house?",
                             c("Less than 50 m2" = "A",
                               "Between 50-100 m2"="B",
                               "Greater than 100 m2" = "C")),
                radioButtons("daytype","What type of day is it?",
                             c("Weekday",
                               "Weekend"))
        ),
        mainPanel(
                h3("Your daily load profile"),
                sliderInput("pos","Display hourly values",value=1,min=1,max=24,step=1),
                plotOutput("plot"),
                h4("Peak Consumption [kW]"),
                verbatimTextOutput("peakcons"),
                h4("Min Consumption [kW]"),
                verbatimTextOutput("mincons")
        )
))



