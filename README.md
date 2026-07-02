# Cancer Burden Analysis and Cancer Intelligence Assistant

## Project Overview

This capstone project investigates the burden of major cancers in the United States by integrating national cancer surveillance, survival outcomes, healthcare costs, machine learning, and Retrieval-Augmented Generation (RAG).

The project combines Python, SQL, R Shiny, machine learning, and generative AI to identify high-burden cancers, visualize population-level trends, and develop an AI-powered Cancer Intelligence Assistant capable of answering cancer-related questions using trusted medical literature.

---

## Research Objectives

- Analyze cancer incidence, mortality, survival, and healthcare costs.
- Identify high-burden cancer groups using machine learning.
- Develop an interactive R Shiny dashboard for cancer burden visualization.
- Build a Retrieval-Augmented Generation (RAG) system for evidence-based cancer question answering.

---

## Data Sources

- CDC United States Cancer Statistics (USCS)
- SEER (Surveillance, Epidemiology, and End Results)
- National Cancer Institute (NCI) PDQ Cancer Information Summaries
- American Cancer Society – Cancer Facts & Figures 2025
- National Cancer Institute Cancer Economic Burden Reports

---

## Technologies

- Python
- SQL (PostgreSQL)
- R / R Shiny
- Pandas
- NumPy
- Scikit-learn
- SciPy
- Matplotlib
- LangChain
- FAISS
- Hugging Face Sentence Transformers
- Jupyter Notebook

---

## Machine Learning Workflow

The machine learning component applies hierarchical clustering (Ward linkage) to identify groups of cancers with similar burden characteristics based on:

- Incidence
- Mortality
- Five-year survival
- Mortality-to-incidence ratio
- Initial care cost
- Continuing care cost
- Last-year-of-life care cost

---

## Interactive R Shiny Dashboard

The dashboard provides interactive visualizations including:

- Cancer incidence and mortality
- Survival trends
- Machine learning clustering results
- Research insights
- Cancer-specific exploration

---

## Cancer Intelligence Assistant (RAG)

The project includes a Retrieval-Augmented Generation (RAG) pipeline that combines cancer-specific knowledge documents with authoritative literature.

### Knowledge Sources

- Nine NCI PDQ cancer knowledge documents
- American Cancer Society – Cancer Facts & Figures 2025
- Cancer Patient Economic Burden Report

### RAG Workflow

- Document loading
- Document chunking
- Sentence embeddings
- FAISS vector database
- Semantic retrieval
- Large Language Model (LLM) question answering

---

## Current Status

- ✅ Data integration completed
- ✅ Machine learning clustering completed
- ✅ Interactive R Shiny dashboard completed
- ✅ Cancer knowledge corpus completed
- ✅ RAG pipeline implementation completed
- 🔄 LLM-powered question answering in progress

---

## Repository Structure

```
capstone-cancer-burden-analysis/
│
├── notebooks/
├── data/
│   └── RAG_files/
├── Shinny_app/
│   └── Cancer_Burden_Dashboard/
└── README.md
```

---

## Future Work

- Integrate RetrievalQA chain
- Deploy the Cancer Intelligence Assistant
- Expand the cancer knowledge corpus
- Add source citations to generated answers
- Deploy the complete application

---

## Author

**Sivaraja Vaithiyalingam**

Data Scientist Apprentice  
Nashville Software School

- GitHub: https://github.com/dhansiv-stack
- LinkedIn: https://www.linkedin.com/in/sivaraja-vaithiyalingam
