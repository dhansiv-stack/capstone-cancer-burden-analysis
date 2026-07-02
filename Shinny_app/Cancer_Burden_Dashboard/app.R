library(shiny)
library(tidyverse)
library(scales)
library(ggrepel)

# Load data
cancer_survival_data <- read.csv(
  "C:/Users/dhans/Documents/DataScience/Program/NSS_projects/Capstones_Project/data/cancer_survival_trends.csv"
)

mortality_progress <- read.csv(
  "C:/Users/dhans/Documents/DataScience/Program/NSS_projects/Capstones_Project/data/mortality_incidence_progress.csv"
)


cancer_data <- read.csv(
  "C:/Users/dhans/Documents/DataScience/Program/NSS_projects/Capstones_Project/data/cancer_research_insights_v2.csv"
)

ui <- fluidPage(
  
  titlePanel("Cancer Burden & Research Insights Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(
        inputId = "cancer",
        label = "Select Cancer Type:",
        choices = cancer_data$cancer_type
      )
    ),
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel(
          "Overview",
          
          h3("Selected Cancer"),
          textOutput("selected_cancer"),
          
          br(),
          h4("Mortality-to-Incidence Ratio"),
          plotOutput("mortality_plot"),
          
          br(),
          h4("Research Insights"),
          uiOutput("research_insights")
        ),
        
        
        tabPanel(
          "ML Validation",
          
          h4("Machine Learning Cancer Burden Clusters"),
          
          tableOutput("ml_cluster_table"),
          
          br(),
          
          h4("Hierarchical Clustering Dendrogram"),
          
          img(
            src = "dendrogram.png",
            width = "100%"
          ),
          
          br(),
          
          h4("Interpretation"),
          uiOutput("ml_interpretation")
        ),
        
        
        tabPanel(
          "Economic Burden",
          
          h4("Cancer Care Costs by Cancer Type"),
          
          plotOutput(
            "cost_plot",
            height = "700px"
          ),
          
          br(),
          
          fluidRow(
            
            column(
              8,
              
              plotOutput(
                "cost_vs_mortality",
                height = "550px"
              )
              
            ),
            
            column(
              4,
              
              h4("RAG-Based Economic Interpretation"),
              
              uiOutput("economic_rag_insight")
              
            )
            
          )
        
        ),
        
        
        tabPanel(
          "Progress & Future Opportunities",
          
          tags$h3(
            style = "font-weight: bold;",
            "Panel A: Five-Year Survival Trends, 1999–2018"
          ),
          
          plotOutput(
            "survival_trend_plot",
            height = "650px"
          ),
          
          br(),
          
          tags$h3(
            style = "font-weight: bold;",
            "Panel B: Change in Mortality-to-Incidence Ratio, 1999–2023"
          ),
          
          plotOutput(
            "mortality_progress_plot",
            height = "500px"
          )
        )
      )
    )
  )
)

server <- function(input, output) {
  
  output$selected_cancer <- renderText({
    paste("You selected:", input$cancer)
  })
  
  output$research_insights <- renderUI({
    
    selected <- cancer_data |>
      filter(cancer_type == input$cancer)
    
    tagList(
      h4(selected$cancer_type),
      
      p(paste("Diagnosis Challenge:", selected$diagnosis_challenge)),
      p(paste("ML Cluster:", selected$ml_cluster)),
      
      p(paste("5-Year Survival:", selected$survival)),
      p(paste("Mortality Ratio:", selected$mortality_ratio)),
      
      tags$ul(
        tags$li(selected$insight_1),
        tags$li(selected$insight_2),
        tags$li(selected$insight_3),
        tags$li(selected$insight_4)
      )
    )
  })
  
  output$ml_cluster_table <- renderTable({
    cancer_data |>
      select(
        cancer_type,
        diagnosis_challenge,
        ml_cluster
      )
  })
  
  output$ml_interpretation <- renderUI({
    tagList(
      p("Hierarchical clustering grouped cancers based on incidence, mortality, survival, mortality ratio, and healthcare cost measures."),
      p("The model identified Pancreas, Liver, and Lung as a high-burden cluster, supporting the descriptive analysis findings."),
      p("Prostate and Female Breast formed a lower-burden cluster, reflecting higher survival and lower mortality burden.")
    )
  })
  
  
  output$cost_plot <- renderPlot({
    
    total_costs <- cancer_data |>
      mutate(
        total_cost = initial_care + continuing_care + last_year_of_life
      )
    
    cost_data <- total_costs |>
      pivot_longer(
        cols = c(initial_care, continuing_care, last_year_of_life),
        names_to = "cost_phase",
        values_to = "cost"
      )
    
    ggplot(
      cost_data,
      aes(
        x = reorder(cancer_type, total_cost),
        y = cost,
        fill = cost_phase
      )
    ) +
      geom_col(width = 0.75) +
      
      geom_text(
        aes(
          label = ifelse(cost > 20000, dollar(cost), "")
        ),
        position = position_stack(vjust = 0.5),
        color = "white",
        size = 5,
        fontface = "bold"
      ) +
      
      geom_text(
        data = total_costs,
        aes(
          x = reorder(cancer_type, total_cost),
          y = total_cost,
          label = dollar(total_cost)
        ),
        inherit.aes = FALSE,
        hjust = -0.3,
        size = 4.5,
        fontface = "bold"
      ) +
      
      coord_flip() +
      
      scale_y_continuous(
        limits = c(0, 300000),
        breaks = seq(0, 250000, by = 50000),
        labels = dollar_format(),
        expand = expansion(mult = c(0, 0))
      ) +
      
      scale_fill_manual(
        values = c(
          "continuing_care" = "#ff7f0e",
          "initial_care" = "#2ca02c",
          "last_year_of_life" = "#4472C4"
        ),
        breaks = c(
          "continuing_care",
          "initial_care",
          "last_year_of_life"
        ),
        labels = c(
          "Continuing Care",
          "Initial Care",
          "Last Year of Life"
        )
      ) +
      
      labs(
        title = "Cancer Care Costs by Cancer Type",
        subtitle = "Estimated cost across initial, continuing, and last-year-of-life care",
        x = NULL,
        y = "Estimated Cost (USD)",
        fill = "Care Phase"
      ) +
      theme_minimal(base_size = 15) +
      theme(
        plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
        plot.subtitle = element_text(size = 15, hjust = 0.5),
        axis.title.x = element_text(face = "bold", size = 15),
        axis.text.x = element_text(face = "bold", size = 13, color = "black"),
        axis.text.y = element_text(face = "bold", size = 13, color = "black"),
        legend.title = element_text(face = "bold", size = 15),
        legend.text = element_text(face = "bold", size = 12),
        legend.position = "right",
        panel.grid.minor = element_blank(),
        axis.line.x = element_line(
          linewidth = 1.2,
          color = "black"
        ),
        
        axis.line.y = element_line(
          linewidth = 1.2,
          color = "black"
        ),
        
        axis.ticks = element_line(
          linewidth = 1,
          color = "black"
        )
      ) 
      
  }, height = 650)
  
  
  output$cost_vs_mortality <- renderPlot({
    
    scatter_data <- cancer_data |>
      mutate(
        total_cost = initial_care + continuing_care + last_year_of_life,
        highlight = ifelse(
          cancer_type %in% c("Pancreas", "Non-Hodgkin Lymphoma"),
          "Key Insight",
          "Other Cancer Types"
        )
      )
    
    ggplot(
      scatter_data,
      aes(
        x = mortality_ratio,
        y = total_cost,
        label = cancer_type,
        color = highlight
      )
    ) +
      geom_point(size = 5, alpha = 0.9) +
      
      geom_text_repel(
        size = 6,
        fontface = "bold",
        show.legend = FALSE,
        max.overlaps = Inf,
        box.padding = 0.5,
        point.padding = 0.3,
        segment.color = "gray60"
      ) +
      
      scale_color_manual(
        values = c(
          "Key Insight" = "#D55E00",
          "Other Cancer Types" = "#4472C4"
        )
      ) +
      
      scale_x_continuous(
        labels = percent_format(accuracy = 1),
        limits = c(0.1, 0.9)
      ) +
      
      scale_y_continuous(
        labels = dollar_format(),
        limits = c(80000, 270000)
      ) +
      
      labs(
        title = "Economic Burden vs Mortality Burden",
        subtitle = "Comparing mortality-to-incidence ratio with total cancer care costs",
        x = "Mortality-to-Incidence Ratio",
        y = "Total Cost (USD)",
        color = NULL
      ) +
      
      theme_minimal(base_size = 15) +
      theme(
        plot.title = element_text(
          face = "bold",
          size = 19,
          hjust = 0.5
        ),
        plot.subtitle = element_text(
          size = 15,
          hjust = 0.5
        ),
        axis.title.x = element_text(
          face = "bold",
          size = 15
        ),
        axis.title.y = element_text(
          face = "bold",
          size = 15
        ),
        axis.text.x = element_text(
          size = 13,
          face = "bold",
          color = "black"
        ),
        axis.text.y = element_text(
          size = 13,
          face = "bold",
          color = "black"
        ),
        axis.line = element_line(
          linewidth = 1,
          color = "black"
        ),
        axis.ticks = element_line(
          linewidth = 0.8,
          color = "black"
        ),
        
        legend.title = element_text(
          size = 15,
          face = "bold"
        ),
        
        legend.text = element_text(
          size = 15,
          face = "bold"
        ),
        
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    
  }, height = 600)
  
  
  output$economic_rag_insight <- renderUI({
    tags$ul(
      tags$li(
        strong("Non-Hodgkin Lymphoma: "),
        "High treatment costs despite a lower mortality burden."
      ),
      tags$li(
        "Long-term monitoring and survivorship care contribute to sustained healthcare costs."
      ),
      tags$li(
        "Relapse and recurrence can require multiple lines of therapy."
      ),
      tags$li(
        "Advanced biologic, immunotherapy, and targeted treatments increase economic burden."
      ),
      tags$li(
        "This shows that cancer burden includes both clinical outcomes and long-term healthcare utilization."
      )
    )
  })
  
  output$mortality_plot <- renderPlot({
    
    plot_data <- cancer_data |>
      mutate(
        selected_flag = ifelse(
          cancer_type == input$cancer,
          "Selected Cancer",
          "Other Cancer Types"
        )
      )
    
    ggplot(
      plot_data,
      aes(
        x = reorder(cancer_type, mortality_ratio),
        y = mortality_ratio,
        fill = selected_flag
      )
    ) +
      geom_col(width = 0.7) +
      coord_flip() +
      scale_fill_manual(
        values = c(
          "Selected Cancer" = "#D55E00",
          "Other Cancer Types" = "#4472C4"
        )
      ) +
      scale_y_continuous(labels = percent_format(accuracy = 1)) +
      labs(
        title = "Mortality-to-Incidence Ratio by Cancer Type",
        subtitle = paste("Highlighted cancer type:", input$cancer),
        x = NULL,
        y = "Mortality-to-Incidence Ratio",
        fill = NULL
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 11, face = "bold", color = "black"),
        axis.text.x = element_text(size = 11, color = "black"),
        axis.line = element_line(linewidth = 1.1, color = "black"),
        axis.ticks = element_line(linewidth = 0.8, color = "black"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "bottom"
      )
  })
  
  output$survival_trend_plot <- renderPlot({
    cancer_survival_plot <- cancer_survival_data |>
    filter(Year <= 2018) |>
    mutate(
      cancer_label = case_when(
        Cancer_Type == "Lung and Bronchus" ~ "Lung",
        Cancer_Type == "Liver and Intrahepatic Bile Duct" ~ "Liver",
        Cancer_Type == "Female Breast" ~ "Breast",
        Cancer_Type == "Non-Hodgkin Lymphoma" ~ "NHL",
        Cancer_Type == "Melanomas of the Skin" ~ "Melanoma",
        TRUE ~ Cancer_Type
      )
    )
    
    label_data <- cancer_survival_plot |>
      group_by(cancer_label) |>
      slice_max(Year, n = 1) |>
      ungroup() |>
      mutate(
        label_y = case_when(
          cancer_label == "Prostate" ~ survival_5yr + 0.025,
          cancer_label == "Melanoma" ~ survival_5yr - 0.008,
          TRUE ~ survival_5yr
        )
      )

    ggplot(
      cancer_survival_plot,
      aes(
        x = Year,
        y = survival_5yr,
        color = cancer_label
      )
    ) +
      
      geom_line(
        linewidth = 1.5
      ) +
      
      geom_text(
        data = label_data,
        aes(
          x = Year,
          y = label_y,
          label = cancer_label
        ),
        hjust = -0.2,
        size = 6,
        fontface = "bold",
        show.legend = FALSE
      ) +
      
      scale_y_continuous(
        labels = scales::percent_format(accuracy = 1)
      ) +
      
      scale_x_continuous(
        breaks = seq(2000, 2020, by = 5),
        limits = c(1999, 2021)
      ) +
      
      coord_cartesian(
        clip = "off"
      ) +
      
      labs(
        title = "Progress in Cancer Survival Outcomes (1999–2018)",
        subtitle = "Five-year survival trends using mature follow-up period",
        x = "Year",
        y = "Five-Year Survival Rate",
        color = "Cancer Type"
      ) +
      
      guides(
        color = guide_legend(
          nrow = 2,
          byrow = TRUE
        )
      ) +
      
      theme_minimal(base_size = 15) +
      
      theme(
        
        plot.margin = margin(
          t = 10,
          r = 80,
          b = 35,
          l = 10
        ),
        
        legend.position = "none",
        
    
        plot.title = element_text(
          face = "bold",
          size = 22,
          hjust = 0.5
        ),
        
        plot.subtitle = element_text(
          size = 15,
          hjust = 0.5
        ),
        
        axis.title.x = element_text(
          face = "bold",
          size = 16
        ),
        
        axis.title.y = element_text(
          face = "bold",
          size = 16
        ),
        
        axis.text.x = element_text(
          size = 15,
          face = "bold",
          color = "black"
        ),
        
        axis.text.y = element_text(
          size = 15,
          face = "bold",
          color = "black"
        ),
        
        axis.line = element_line(
          color = "black",
          linewidth = 0.8
        ),
        
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        
        
        axis.ticks = element_line(
          color = "black",
          linewidth = 0.8,
          
        )
      )
    
  }, height = 700)
  
  output$mortality_progress_plot <- renderPlot({
    
    mortality_progress <- mortality_progress |>
      mutate(
        cancer_label = case_when(
          Cancer_Type == "Lung and Bronchus" ~ "Lung",
          Cancer_Type == "Liver and Intrahepatic Bile Duct" ~ "Liver",
          Cancer_Type == "Female Breast" ~ "Breast",
          Cancer_Type == "Non-Hodgkin Lymphoma" ~ "NHL",
          Cancer_Type == "Melanomas of the Skin" ~ "Melanoma",
          TRUE ~ Cancer_Type
        )
      )
    
    ggplot(
      mortality_progress,
      aes(
        x = reorder(cancer_label, change),
        y = change
      )
    ) +
      
      geom_col(
        aes(fill = change > 0)
      ) +
      
      scale_fill_manual(
        values = c(
          "TRUE" = "firebrick",
          "FALSE" = "steelblue"
        ),
        guide = "none"
      ) +
      
      geom_text(
        aes(
          label = round(change, 3)
        ),
        hjust = ifelse(mortality_progress$change < 0, 1.2, -0.2),
        color = "black",
        face = "bold",
        size = 6
      ) +
      
      geom_vline(
        xintercept = 0,
        linewidth = 0.8,
        color = "black"
      ) +
      
      geom_hline(
        yintercept = 0,
        linewidth = 0.8,
        color = "black"
      ) +
      
      coord_flip() +
      
      labs(
        title = "Progress in Mortality Burden (1999–2023)",
        subtitle = "More negative values indicate greater reductions in mortality burden relative to diagnosed cases",
        x = "",
        y = "Change in Mortality-to-Incidence Ratio"
      ) +
      
      theme_minimal(base_size = 15) +
      
      theme(
        
        legend.position = "bottom",
        
        legend.margin = margin(
          t = 12
        ),
        
        plot.margin = margin(
          t = 10,
          r = 10,
          b = 35,
          l = 10
        ),
        
        plot.title = element_text(
          face = "bold",
          size = 18,
          hjust = 0.5
        ),
        
        plot.subtitle = element_text(
          size = 14,
          hjust = 0.5
        ),
        
        axis.title = element_text(
          face = "bold",
          size = 15
        ),
        
        axis.text = element_text(
          face = "bold",
          size = 15,
          color = "black"
        ),
        
        axis.line = element_line(
          color = "black",
          linewidth = 0.8
        ),
        
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      )
  })
}

shinyApp(ui = ui, server = server)