# AI-Powered Cancer Burden Analytics Platform

## Project Demonstrates

-   Healthcare Data Analytics
-   PostgreSQL Data Integration
-   Machine Learning (Hierarchical Clustering)
-   Retrieval-Augmented Generation (RAG)
-   Large Language Model (LLM) Integration
-   Interactive R Shiny Dashboard
-   End-to-End AI Application Development

## Project Overview

This capstone project is an end-to-end AI-powered healthcare analytics
application that integrates national cancer surveillance data,
healthcare expenditures, machine learning, and Retrieval-Augmented
Generation (RAG) to analyze the burden of major cancers in the United
States.

Rather than functioning as a collection of notebooks, the project
combines data engineering, analytics, machine learning, and generative
AI into a unified platform. Users can explore cancer burden through an
interactive R Shiny dashboard while an AI-powered Cancer Intelligence
Assistant answers evidence-based questions using both structured project
data and curated medical literature.

## System Architecture

    Healthcare Data Sources
            │
            ▼
    PostgreSQL + SQL
            │
            ▼
    Master Cancer Summary
            │
      ┌─────┴─────┐
      ▼           ▼
    Machine      RAG
    Learning   Knowledge Base
      └─────┬─────┘
            ▼
     AI Cancer Assistant
            │
            ▼
      R Shiny Dashboard

## Project Objectives

-   Integrate CDC, SEER, healthcare cost, and literature datasets.
-   Analyze incidence, mortality, survival, and healthcare costs.
-   Identify cancer burden groups using hierarchical clustering.
-   Build an AI-powered Cancer Intelligence Assistant.
-   Deliver an interactive R Shiny dashboard.

## Technology Stack

- **Programming Languages:** Python, R
- **Database:** PostgreSQL
- **Python Libraries:** Pandas, NumPy, SciPy
- **Machine Learning:** Scikit-learn
- **Visualization:** Matplotlib, ggplot2
- **Dashboard:** R Shiny
- **Generative AI:** LangChain, FAISS, Sentence Transformers, OpenRouter LLM

## Repository Structure

    notebooks/
      Capstone_Project_Sivaraja.ipynb  - Main analysis
      cancer_burden_ml.ipynb           - ML workflow
      cancer_cdc_ml.ipynb              - CDC preprocessing
      RAG_Exercise.ipynb               - RAG prototype

    data/
      master_cancer_summary.csv        - Integrated dataset

    Shinny_app/Cancer_Burden_Dashboard/
      app.R                            - Dashboard
      rag_pipeline.py                  - AI Assistant

## Machine Learning

Hierarchical clustering grouped cancers into High, Moderate, and Lower
Burden clusters using incidence, mortality, survival,
mortality-to-incidence ratio, and healthcare costs.

## AI-Powered Cancer Intelligence Assistant

The assistant first retrieves project data (statistics, costs, and ML
clusters), then retrieves supporting literature using FAISS before
generating an evidence-based response with an LLM.

## Key Findings

-   Pancreatic, Liver, and Lung cancers formed the High Burden Cluster.
-   Survival decreases as mortality-to-incidence ratio increases.
-   Structured healthcare analytics and RAG were successfully integrated
    into one AI workflow.
-   The AI assistant answers questions using both project analytics and
    trusted medical evidence.

## Current Status

-   Complete: PostgreSQL integration, machine learning, RAG, AI
    Assistant.
-   In Progress: Final refinement of the R Shiny dashboard.

## Future Work

The remaining work focuses on polishing the R Shiny dashboard by
refining the user interface, enhancing visual presentation, and
integrating the remaining dashboard components.

## Author

Sivaraja Vaithiyalingam

GitHub: https://github.com/dhansiv-stack

LinkedIn: https://www.linkedin.com/in/sivaraja-vaithiyalingam

## Closing

This project demonstrates an end-to-end AI-powered healthcare analytics
application that integrates data engineering, machine learning,
Retrieval-Augmented Generation, and Large Language Models into a unified
decision-support platform.
