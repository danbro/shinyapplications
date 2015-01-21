library(shiny)

#https://www.google.se/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRw&url=http%3A%2F%2Fwww.intechopen.com%2Fbooks%2Fenergy-storage-technologies-and-applications%2Festimation-of-energy-storage-and-its-feasibility-analysis&ei=WCy-VLmzE4nnywPz_4DICg&psig=AFQjCNFmLaQDlTDU_ImNIjGzQmrfp2yA-g&ust=1421835704185611
load <- c(0.6, 0.58, 0.5, 0.42, 0.4, 0.42, 0.62, 1.1, 1.3, 0.62, 0.4, 0.39, 0.37, 0.36, 0.35, 0.4, 0.42, 0.82, 1.42, 1.98, 2, 1.3, 0.9, 0.5)
weekendload <- c(0.6, 0.58, 0.5, 0.42, 0.4, 0.42, 0.62, 1.1, 1.3, 1.2, 1.1, 0.9, 0.87, 0.86, 0.88, 0.89, 0.92, 0.97, 1.42, 1.98, 2, 1.3, 0.9, 0.5)
k1 <- 0.25 # rate of change occupant increase [kW]
k2 <- 1 # rate of change size increase [kW]
time <- seq(1,24)

# Compute peak load based on inputs
peakload <- function(occupancy, size, daytype){
        sizevalue<-switch(size, A=0, B=1, C=2)
        if (daytype == "Weekend") {
                max(weekendload+occupancy*k1+sizevalue*k2)
        } else if (daytype == "Weekday") {
                max(load+occupancy*k1+sizevalue*k2)        
        } 
}

# Compute minimum load based on inputs
minload <- function(occupancy, size, daytype){
        sizevalue<-switch(size, A=0, B=1, C=2)
        if (daytype == "Weekend") {
                min(weekendload+occupancy*k1+sizevalue*k2)
        } else if (daytype == "Weekday") {
                min(load+occupancy*k1+sizevalue*k2)        
        }        
}

# Compute load vector based on inputs
newload <- function(occupancy, size, daytype){
        sizevalue<-switch(size, A=0, B=1, C=2)
        if (daytype == "Weekend") {
                weekendload+occupancy*k1+sizevalue*k2
        } else if (daytype == "Weekday") {
                load+occupancy*k1+sizevalue*k2
        }
}
  
shinyServer(
        function(input, output) {
                output$peakcons <- renderPrint({peakload(input$occupancy,input$size,input$daytype)})
                output$mincons <- renderPrint({minload(input$occupancy,input$size,input$daytype)})
                output$plot <- renderPlot({
                        finalload<-newload(input$occupancy,input$size,input$daytype)
                        plot(time,finalload,type="l",
                             xlab="Hours",ylab="kW")
                        pos <- input$pos
                        points(pos, finalload[pos],pch=1,cex=1.5)
                        text(3,2.2,paste("value = ",finalload[pos]," kW"))
                        grid()
                })
        }
        
)