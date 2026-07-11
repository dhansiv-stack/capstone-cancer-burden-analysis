library(shiny)
library(tidyverse)
library(scales)
library(ggrepel)
library(reticulate)
library(shinycssloaders)

use_python(
  "C:/ProgramData/anaconda3/python.exe",
  required = TRUE
)

source_python("rag_pipeline.py")

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
  
  titlePanel(
    div(
      "Cancer Burden & Research Insights Dashboard",
      style = "font-weight: bold; font-size: 32px;"
    )
  ),
  
  tabsetPanel(
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>Overview</span>"),
      
      wellPanel(
        h3(
          "Project Overview & Features",
          style = "font-weight: bold; font-size: 24px;"
        ),
        
        p(
          "This interactive dashboard integrates CDC incidence and mortality data, SEER survival statistics, healthcare expenditure analysis, machine learning clustering, and a Retrieval-Augmented Generation (RAG) AI assistant to support evidence-based exploration of cancer burden in the United States.",
          style = "font-size: 20px;"
        )
      ),
      
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "cancer",
            label = tags$span(
              "Select Cancer Type:",
              style = "font-size:18px; font-weight:bold;"
            ),
            choices = unique(cancer_data$cancer_type)
          )
        ),
        
        mainPanel(
          h3(
            "Mortality-to-Incidence Ratio",
            style = "font-weight: bold; font-size: 24px;"
          ),
          plotOutput("mortality_plot", height = "600px"),
          
          br(),
          h4(
            "Research Insights",
            style = "font-weight: bold; font-size: 24px;"
          ),
          uiOutput("research_insights")
        )
      )
    ),
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>ML Validation</span>"),
      
      fluidRow(
        column(
          5,
          h4(
            "Machine Learning Cancer Burden Clusters",
            style = "font-weight: bold; font-size: 22px;"
          ),
          div(
            style = "font-size:20px;",
            tableOutput("ml_cluster_table")
          )
        ),
        
        column(
          7,
          wellPanel(
            h4(
              "Machine Learning Interpretation",
              style = "text-align:center;
                 color:#1F4E79;
                 font-weight:bold;
                 font-size:22px;"
            ),
            uiOutput("ml_interpretation")
          )
        )
      ),
      
      br(),
      
      h4(
        "Hierarchical Clustering Dendrogram",
        style = "font-weight:bold; font-size:22px;"
      ),
      
      div(
        style = "text-align:center;",
        img(
          src = "dendrogram.png",
          width = "50%"
        ),
        p(
          style = "text-align:center;
             font-style:italic;
             font-size:18px;",
          "Figure: Hierarchical clustering of cancer types based on incidence, mortality, survival, and healthcare expenditure."
        )
      )
    ),
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>Economic Burden</span>"),
      
      h4(
        "Cancer Care Costs by Cancer Type",
        style = "font-weight:bold; font-size:22px;"
      ),
      
      plotOutput("cost_plot", height = "500px"),
      
      div(
        style = "margin-top:40px;",
        
        fluidRow(
          column(
            8,
            plotOutput("cost_vs_mortality", height = "600px")
          ),
          
          column(
            4,
            h4(
              "RAG-Based Economic Interpretation",
              style = "font-weight:bold; font-size:22px;"
            ),
            uiOutput("economic_rag_insight")
          )
        ),
        
        tags$div(
          style = "
        text-align: right;
        font-size: 18px;
        color: gray;
        font-style: italic;
        margin-top: 30px;
        margin-right: 10px;
        margin-bottom: 15px;
      ",
          "Source: Centers for Medicare & Medicaid Services (CMS). Visualization and analysis by the author."
        )
      )
    ),
   
   
    
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>Future Opportunities</span>"),
      
      tags$h3(
        style = "font-weight:bold; font-size:25px;",
        "Panel A: Five-Year Survival Trends, 1999–2018"
      ),
      
      plotOutput("survival_trend_plot", height = "550px"),
      
      br(),
      
      tags$h3(
        style = "font-weight:bold; font-size:25px;",
        "Panel B: Change in Mortality-to-Incidence Ratio, 1999–2023"
      ),
      
      plotOutput("mortality_progress_plot", height = "550px"),
      
      tags$div(
        style = "
      text-align: right;
      font-size: 18px;
      color: gray;
      font-style: italic;
      margin-top: 30px;
      margin-right: 10px;
      margin-bottom: 15px;
    ",
        "Source: Centers for Disease Control and Prevention (CDC). Visualization and analysis by the author."
      )
    ),
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>Cancer AI Assistant</span>"),
      
      h3(
        "🤖 Cancer AI Assistant",
        style = "font-weight:bold; font-size:26px;"
      ),
      
      p(
        "Ask questions about cancer incidence, survival, diagnosis, treatment, healthcare costs, or probability analysis. Answers are generated by combining the project's structured data with a curated Retrieval-Augmented Generation (RAG) knowledge base.",
        style = "font-size:22px;"
      ),
      
      textAreaInput(
        inputId = "rag_question",
        label = NULL,
        rows = 6,
        width = "100%",
        placeholder = "Example: Why does pancreatic cancer have only a 9% five-year survival probability? Compare it with breast cancer."
      ),
      
      tags$style(HTML("
      #rag_question {
      font-size: 18px;
    }

      #rag_question::placeholder {
      font-size: 18px;
      color: #777777;
      
    }
    
    ")),
      
      actionButton(
        "ask_rag",
        "Ask AI",
        style = "background-color:#28a745; color:white; font-weight:bold; font-size:18px;"
      ),
      
      br(),
      br(),
      
      withSpinner(
        uiOutput("rag_answer"),
        type = 6,
        color = "#2C3E50",
        size = 1.5
      )
    ),
    
    tabPanel(
      HTML("<span style='font-size:18px; font-weight:bold;'>Final Project Conclusion</span>"),
      
      h2(
        "Final Project Conclusion",
        style = "font-weight: bold; font-size: 25px;"
      ),
      
      br(),
      
      uiOutput("final_conclusion")
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
      h4(
        selected$cancer_type,
        style = "font-size:24px; font-weight:bold;"
      ),
      
      p(
        tags$b("Diagnosis Challenge: "),
        selected$diagnosis_challenge,
        style = "font-size:22px;"
      ),
      
      p(
        tags$b("ML Cluster: "),
        selected$ml_cluster,
        style = "font-size:20px;"
      ),
      
      p(
        tags$b("5-Year Survival: "),
        selected$survival,
        style = "font-size:20px;"
      ),
      
      p(
        tags$b("Mortality Ratio: "),
        selected$mortality_ratio,
        style = "font-size:20px;"
      ),
      
      tags$ul(
        style = "font-size:20px;",
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
      
      p(
        tags$b("Clustering Method: "),
        "Hierarchical clustering using Ward's linkage grouped cancers based on incidence, mortality, five-year survival, mortality-to-incidence ratio, and healthcare expenditure after feature standardization.",
        style = "font-size:20px;"
      ),
      
      p(
        tags$b("High-Burden Cluster: "),
        "The model identified Pancreas, Liver, and Lung as a high-burden cluster, supporting the descriptive analysis findings.",
        style = "font-size:20px;"
      ),
      
      p(
        tags$b("Moderate-Burden Cluster: "),
        "Colon and Rectum, Non-Hodgkin Lymphoma, Urinary Bladder, and Melanoma formed a moderate-burden cluster, reflecting intermediate survival, mortality, and healthcare burden patterns.",
        style = "font-size:20px;"
      ),
      
      p(
        tags$b("Lower-Burden Cluster: "),
        "Prostate and Female Breast formed a lower-burden cluster, reflecting higher survival and lower mortality burden.",
        style = "font-size:20px;"
      )
      
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
          label = dollar(cost)
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
        size = 6,
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
        plot.title = element_text(face = "bold", size = 22, hjust = 0.5),
        plot.subtitle = element_text(size = 18, hjust = 0.5),
        axis.title.x = element_text(face = "bold", size = 18),
        axis.text.x = element_text(face = "bold", size = 18, color = "black"),
        axis.text.y = element_text(face = "bold", size = 18, color = "black"),
        legend.title = element_text(face = "bold", size = 18),
        legend.text = element_text(face = "bold", size = 16),
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
      
  }, height = 500)
  
  
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
        size = 7,
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
          size = 25,
          hjust = 0.5
        ),
        
        plot.subtitle = element_text(
          size = 20,
          hjust = 0.5
        ),
        
        plot.margin = margin(t = 30, r = 10, b = 10, l = 10),
        
        
        axis.title.x = element_text(
          face = "bold",
          size = 18
        ),
        axis.title.y = element_text(
          face = "bold",
          size = 18
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
          linewidth = 1,
          color = "black"
        ),
        axis.ticks = element_line(
          linewidth = 0.8,
          color = "black"
        ),
        
        legend.title = element_text(
          size = 20,
          face = "bold"
        ),
        
        legend.text = element_text(
          size = 20,
          face = "bold"
        ),
        
        legend.key.size = grid::unit(1.2, "cm"),
        legend.spacing.x = grid::unit(0.5, "cm"),
        
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    
  }, height = 600)
  
  
  output$economic_rag_insight <- renderUI({
    
    tags$ul(
      style = "font-size:20px;",
      
      tags$li(
        strong("Key Finding – Non-Hodgkin Lymphoma: "),
        "Despite relatively favorable survival and a lower mortality burden, long-term treatment and survivorship care contribute to substantial healthcare costs."
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
        plot.title = element_text(face = "bold", size = 24, hjust = 0.5),
        plot.subtitle = element_text(size = 18, hjust = 0.5),
        
        axis.title.x = element_text(size = 20, face = "bold"),
        axis.text.y = element_text(size = 18, face = "bold", color = "black"),
        axis.text.x = element_text(size = 18, face = "bold", color = "black"),
        
        legend.text = element_text(size = 18, face = "bold"),
        legend.position = "bottom",
        
        axis.line = element_line(linewidth = 1.1, color = "black"),
        axis.ticks = element_line(linewidth = 0.8, color = "black"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
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
          cancer_label == "Breast" ~ survival_5yr - 0.015,
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
        size = 7,
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
          size = 24,
          hjust = 0.5
        ),
        
        plot.subtitle = element_text(
          size = 20,
          hjust = 0.5
        ),
        
        axis.title.x = element_text(
          face = "bold",
          size = 20
        ),
        
        axis.title.y = element_text(
          face = "bold",
          size = 20
        ),
        
        axis.text.x = element_text(
          size = 20,
          face = "bold",
          color = "black"
        ),
        
        axis.text.y = element_text(
          size = 20,
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
    
  }, height = 550)
  
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
        size = 8
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
        legend.margin = margin(t = 12),
        plot.margin = margin(t = 10, r = 10, b = 35, l = 10),
        plot.title = element_text(face = "bold", size = 24, hjust = 0.5),
        plot.subtitle = element_text(size = 20, hjust = 0.5),
        axis.title = element_text(face = "bold", size = 20),
        axis.text = element_text(face = "bold", size = 20, color = "black"),
        axis.line = element_line(color = "black", linewidth = 0.8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      )
    
  }, height = 550)
  
  output$final_conclusion <- renderUI({
    HTML("
    <h4 style='font-size:22px; font-weight:bold;'>Overall Conclusion</h4>
    <p style='font-size:18px;'>
    This project demonstrates that cancer burden cannot be explained by incidence alone.
    By integrating cancer incidence, mortality, survival, healthcare costs, statistical analysis,
    probability analysis, machine learning, and Retrieval-Augmented Generation (RAG),
    the project provides a comprehensive framework for understanding the burden of major cancers
    in the United States.
    </p>

  <h4 style='font-size:22px; font-weight:bold;'>Key Findings</h4>
  <ul style='font-size:18px;'>
  
    <li><b>Pancreatic, liver, and lung cancers</b> emerged as the highest-burden cancers because of poor survival, high mortality-to-incidence ratios, and substantial healthcare costs.</li>

    <li><b>Breast and prostate cancers</b> exhibited high incidence but favorable survival outcomes, reflecting the benefits of early detection and effective treatment.</li>

    <li><b>Non-Hodgkin Lymphoma</b> demonstrated that relatively favorable survival does not necessarily correspond to a lower healthcare burden because of substantial continuing-care and long-term treatment costs.</li>

    <li><b>Hierarchical clustering</b> independently validated the cancer burden patterns by grouping cancers with similar clinical and economic characteristics.</li>

    <li><b>The Cancer AI Assistant</b> integrates structured project data with retrieved medical evidence through a Retrieval-Augmented Generation (RAG) pipeline, enabling users to ask natural-language questions and receive evidence-based explanations.</li>
  </ul>

  <h4 style='font-size:22px; font-weight:bold;'>Project Impact</h4>
  <p style='font-size:18px;'>
  This project illustrates how data science, machine learning, and generative AI can be integrated into an interactive healthcare analytics platform. By combining statistical findings with curated medical knowledge, the Cancer Intelligence Assistant enhances data interpretation, supports evidence-based communication, and demonstrates the potential of AI-assisted decision support in healthcare analytics.
  </p>
")
  })
  
  rag_result <- reactiveVal(NULL)
  
  observeEvent(input$ask_rag, {
    
    question <- input$rag_question
    
    if (is.null(question) || question == "") {
      rag_result("<b>Please enter a question.</b>")
      return()
    }
    
    print(paste("RAG question:", question))
    
    rag_result("<b>⏳ AI assistant is thinking...</b>")
    
    answer <- tryCatch(
      {
        ask_cancer_question(question)
      },
      error = function(e) {
        paste("ERROR:", e$message)
      }
    )
    
    print(answer)
    
    rag_result(answer)
  })
  
  output$rag_answer <- renderUI({
    
    req(rag_result())
    
    formatted_text <- gsub("\n- ", "\n• ", rag_result())
    
    formatted_text <- gsub("Summary:", "<b>Summary:</b>", formatted_text)
    formatted_text <- gsub("Key Findings:", "<b>Key Findings:</b>", formatted_text)
    formatted_text <- gsub("Significance:", "<b>Significance:</b>", formatted_text)
    
    div(
      style = "
      background:#f8f9fa;
      border-left:5px solid #2E86C1;
      padding:18px;
      border-radius:8px;
      font-size:20px;
      line-height:1.8;
      color:#333333;
      white-space: pre-wrap;
    ",
      HTML(formatted_text)
    )
  })
}
shinyApp(ui = ui, server = server)