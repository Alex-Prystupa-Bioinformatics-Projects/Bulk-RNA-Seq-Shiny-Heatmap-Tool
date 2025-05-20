library(shiny)
options(shiny.maxRequestSize=30*1024^2)

library(pheatmap)
library(dplyr)
library(tibble)
library(ggplot2)
library(stringr)
library(glue)

source("custom-heatmap-function.R")

shinyApp(
  ui <- fluidPage(
    navbarPage(title = "Bulk RNA-Seq Heatmap Tool",
       tabPanel("Custom Heatmaps",
            sidebarLayout(
              
              # Sidebar panel for inputs ----
              sidebarPanel(
                
                fileInput("rds_file", label = h4("Upload RDS File")),
                textInput("text", label = h4("Input Genes List"), value = "Enter genes..."),
                uiOutput(outputId = "groups_checkbox"),
                uiOutput(outputId = "clusters_checkbox"),
                selectInput("image_height", "Image Height", choices = c(rep(1:20))),
                selectInput("image_width", "Image Width", choices = c(rep(1:20))),
                textInput("image_name", "Image Name", value = "Heatmap"),
                downloadButton("download_plot_pdf", "Save Plot PDF"),
                downloadButton("download_plot_png", "Save Plot PNG")
              ),
              
              
              mainPanel(
                plotOutput(outputId = "heatmap", height = 800)
              )
            )     
         ),
       tabPanel("DGE Spreadsheet Parser",
          sidebarPanel(
            fileInput(inputId = "dge_csv", label = "Load DGE CSV"),
            uiOutput(outputId = "top_genes_dropdown"),
            uiOutput(outputId = "manual_top_genes_input")
          ),  
          
          mainPanel(
            DT::dataTableOutput(outputId = "dge_table")
          )
        )
      )
    ),
  
  server <- function(input, output) {
    
    ### 1. Custom Genes Heatmap Code
    # Return Heatmap ggplot object
    heatmap.plot <- reactive({
      inFile <- input$rds_file
      if (is.null(inFile)) {
        return(NULL)
      }
        
      genes <- input$text %>%
        str_replace_all(fixed(" "), "") %>%
        strsplit(",") %>%
        unlist()
      
      deseq.obj <- readRDS(inFile$datapath)
      
      # Heatmap
      cluster_values <- input$checkbox_cluster
      
      if ("Cluster Rows" %in% cluster_values) {
        cluster_rows <- TRUE
      } else {
        cluster_rows <- FALSE
      }
      
      if ("Cluster Columns" %in% cluster_values) {
        cluster_columns <- TRUE
      } else {
        cluster_columns <- FALSE
      }
      
      heatmap.obj <- plot.heatmap(vst_deseq_obj = deseq.obj, subset_genes = genes, subset_groups = input$checkbox,
                                  cluster_rows = cluster_rows, cluster_cols = cluster_columns)
      
      return(heatmap.obj)
    })
    
    # Render plot 
    output$heatmap <- renderPlot({
      if (!(input$text) == "Enter genes...") {
        heatmap.obj <- heatmap.plot()
        heatmap.obj 
      }
    })    
    
    # Download plot as pdf
    output$download_plot_pdf <- downloadHandler(
      filename = function() {glue("{input$image_name}.pdf")},
      content = function(file) {
        pdf(file, height = as.numeric(input$image_height), width = as.numeric(input$image_width))
        print(heatmap.plot())
        dev.off()
      }
    )
    
    # Download plot as png
    output$download_plot_png <- downloadHandler(
      filename = function() {glue("{input$image_name}.png")},
      content = function(file) {
        png(file, height = as.numeric(input$image_height), width = as.numeric(input$image_width), units = "in", res = 100)
        print(heatmap.plot())
        dev.off()
      }
    )
    
    # Check box
    samples.groups <- reactive({
      deseq.obj <- readRDS(input$rds_file$datapath)
      return(get.samples.groups(deseq.obj))
    })
    
    output$groups_checkbox <- renderUI({
      if (!is.null(input$rds_file)) {
        samples <- samples.groups()
        checkboxGroupInput(inputId = "checkbox", label = h4("Groups Checkbox"), choices = samples, selected = samples)
      }
    })
    
    output$clusters_checkbox <- renderUI({
      if (!is.null(input$rds_file)) {
        cluster.options <- c("Cluster Rows", "Cluster Columns")
        checkboxGroupInput(inputId = "checkbox_cluster", label = h4("Clusters Checkbox"), choices = cluster.options, selected = cluster.options)
      }
    })
    
    ### 2. DGE CSV Code
    # Render Uploaded CSV File
    get_csv <- reactive({
      data <- input$dge_csv
      if (is.null(data)) {
        return(NULL)
      }
      
      dge_csv <- read.csv(data$datapath)
    })
    
    output$dge_table <- DT::renderDataTable({
      if (!is.null(input$dge_csv)) {
        dge_csv <- get_csv()
        
        # Potentially add use case for if manual_genes_input is > nrow() of data frame
        if (input$manual_genes_input == "" | is.na(as.numeric(input$manual_genes_input))) {
          return(dge_csv[1:input$subset_dropdown,])
        }
        
        return(dge_csv[1:as.numeric(input$manual_genes_input),])
      }
    })
    
    # Render UI Subset Drop-down Menu
    output$top_genes_dropdown <- renderUI({
      if (!is.null(input$dge_csv)) {
        data <- read.csv(input$dge_csv$datapath)
        selectInput(inputId = "subset_dropdown", label = "Dropdown Select # of Genes to Subset", choices = c(25, 50, 100, 1000, nrow(data)), selected = nrow(data)) 
      }
    })
    
    # Render UI Manual Subset Input
    output$manual_top_genes_input <- renderUI({
      if (!is.null(input$dge_csv)) {
        textInput(inputId = "manual_genes_input", label = "Manually Select # of Genes to Subset") 
      }
    })
  }
)
