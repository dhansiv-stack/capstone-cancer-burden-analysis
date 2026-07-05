# Cancer Burden Analysis & Cancer Intelligence Assistant

## Project Overview

This capstone project presents an end-to-end cancer analytics platform that integrates national cancer surveillance data, survival outcomes, healthcare expenditures, machine learning, and Retrieval-Augmented Generation (RAG) to investigate the burden of major cancers in the United States.

The project combines Python, PostgreSQL, SQL, R Shiny, machine learning, and generative AI to identify high-burden cancers, visualize epidemiological trends, and develop an evidence-based Cancer Intelligence Assistant capable of answering cancer-related questions using curated medical literature.

---

## Project Highlights

- Integrated multiple national cancer datasets from the CDC, SEER, ACS, and NCI.
- Performed end-to-end data integration using PostgreSQL and SQL.
- Applied hierarchical clustering (Ward linkage) to identify high-burden cancer groups.
- Developed an interactive R Shiny dashboard for cancer burden exploration.
- Built a Retrieval-Augmented Generation (RAG) pipeline using LangChain, Sentence Transformers, and FAISS.
- Integrated an AI-powered Cancer Intelligence Assistant into the R Shiny dashboard.
- Combined healthcare analytics, machine learning, interactive visualization, and generative AI into a unified cancer intelligence platform.

---

## Research Objectives

- Analyze cancer incidence, mortality, survival, and healthcare expenditures.
- Identify high-burden cancer groups using machine learning.
- Develop an interactive R Shiny dashboard for cancer burden visualization.
- Build a Retrieval-Augmented Generation (RAG) system for evidence-based cancer question answering.
- Demonstrate the integration of data science, machine learning, and generative AI within a healthcare analytics workflow.

---

## Data Sources

This project integrates multiple publicly available healthcare datasets:

- **CDC United States Cancer Statistics (USCS)**
- **SEER (Surveillance, Epidemiology, and End Results Program)**
- **National Cancer Institute (NCI) PDQ Cancer Information Summaries**
- **American Cancer Society – Cancer Facts & Figures 2025**
- **National Cancer Institute – Cancer Economic Burden Reports**

---

## Technologies

### Programming Languages

- Python
- SQL
- PostgreSQL
- R

### Data Science & Machine Learning

- Pandas
- NumPy
- Scikit-learn
- SciPy
- Matplotlib

### Dashboard Development

- R Shiny
- ggplot2
- dplyr

### Retrieval-Augmented Generation (RAG)

- LangChain
- FAISS
- Hugging Face Sentence Transformers
- OpenRouter LLM

### Development Tools

- Jupyter Notebook
- Git
- GitHub

---

## Machine Learning Workflow

The machine learning component applies hierarchical clustering to identify cancers with similar burden characteristics.

### Workflow

- Feature selection
- Feature preprocessing using **StandardScaler**
- Hierarchical clustering using **Ward linkage**
- Dendrogram visualization
- Cluster interpretation and validation

### Features Used

- Incidence
- Mortality
- Five-year Survival
- Mortality-to-Incidence Ratio
- Initial Care Cost
- Continuing Care Cost
- Last-Year-of-Life Cost

---

## Interactive R Shiny Dashboard

The dashboard provides an interactive environment for exploring multiple aspects of cancer burden.

### Dashboard Features

- **Overview**
  - Mortality-to-incidence visualization
  - Cancer-specific research insights

- **Machine Learning Validation**
  - Cancer burden clusters
  - Hierarchical clustering dendrogram
  - Cluster interpretation

- **Economic Burden**
  - Healthcare expenditure comparison
  - Cost versus mortality visualization
  - AI-generated economic interpretation

- **Progress & Future Opportunities**
  - Survival trends
  - Mortality trend analysis

- **Final Conclusion**
  - Summary of key findings

- **Cancer AI Assistant**
  - Retrieval-Augmented Generation (RAG)
  - Evidence-based cancer question answering

---

## Cancer Intelligence Assistant (RAG)

The project includes a Retrieval-Augmented Generation (RAG) pipeline that retrieves evidence from curated cancer literature before generating responses with a Large Language Model.

### Knowledge Sources

#### Cancer-Specific Knowledge Base

- Breast Cancer
- Colon Cancer
- Liver Cancer
- Lung Cancer
- Melanoma
- Non-Hodgkin Lymphoma
- Pancreatic Cancer
- Prostate Cancer
- Urinary Bladder Cancer

#### Supporting Literature

- American Cancer Society – Cancer Facts & Figures 2025
- National Cancer Institute – Cancer Economic Burden Report

### RAG Workflow

- Document loading
- Document chunking
- Sentence embedding generation
- FAISS vector database
- Semantic similarity retrieval
- Large Language Model (LLM) response generation

---

## Key Results

- Identified pancreatic, liver, and lung cancers as the highest-burden cluster using hierarchical clustering.
- Demonstrated an inverse relationship between five-year survival and mortality-to-incidence ratio.
- Integrated epidemiological, survival, and healthcare expenditure data into a unified analytics platform.
- Developed a Retrieval-Augmented Generation (RAG) pipeline capable of producing evidence-based responses from trusted medical literature.
- Delivered an interactive R Shiny dashboard integrating descriptive analytics, machine learning, and generative AI.

---

## Current Status

- ✅ Data integration completed
- ✅ PostgreSQL database integration completed
- ✅ Machine learning clustering completed
- ✅ Hierarchical clustering validation completed
- ✅ Interactive R Shiny dashboard completed
- ✅ Cancer knowledge corpus completed
- ✅ RAG pipeline completed
- ✅ FAISS vector database completed
- ✅ Semantic retrieval completed
- ✅ LLM-powered Cancer Intelligence Assistant completed
- ✅ RAG integrated into the R Shiny dashboard

---

## Repository Structure

```text
capstone-cancer-burden-analysis/
│
├── notebooks/
│   ├── Capstone_Project_Sivaraja.ipynb
│   ├── cancer_burden_ml.ipynb
│   ├── cancer_cdc_ml.ipynb
│   └── RAG_Exercise.ipynb
│
├── data/
│   ├── CDC datasets
│   ├── SEER datasets
│   ├── Healthcare expenditure datasets
│   └── RAG_files/
│
├── Shinny_app/
│   └── Cancer_Burden_Dashboard/
│       ├── app.R
│       ├── data/
│       └── www/
│
├── README.md
└── requirements.txt
```

---

## Future Work

- Deploy the R Shiny dashboard to a cloud hosting platform.
- Expand the cancer knowledge corpus using additional NCI publications.
- Incorporate real-time cancer surveillance updates.
- Add citation-aware responses for improved explainability.
- Extend the platform with predictive risk modeling and personalized cancer analytics.

---

## Author

**Sivaraja Vaithiyalingam**

Data Scientist Apprentice  
Nashville Software School

**GitHub:** https://github.com/dhansiv-stack

**LinkedIn:** https://www.linkedin.com/in/sivaraja-vaithiyalingam

---

## Acknowledgments

This project was completed as part of the Nashville Software School Data Science Apprenticeship Program.

It demonstrates an end-to-end healthcare analytics workflow by integrating epidemiological data, machine learning, interactive visualization, and Retrieval-Augmented Generation (RAG) into a unified Cancer Intelligence platform designed to support evidence-based cancer exploration.
