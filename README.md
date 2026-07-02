# Cancer Burden Analysis and Cancer Intelligence Assistant

## Project Overview

This capstone project investigates the burden of major cancers in the United States by integrating national cancer surveillance, survival outcomes, healthcare costs, machine learning, and Retrieval-Augmented Generation (RAG).

The project combines Python, SQL, R Shiny, machine learning, and generative AI to identify high-burden cancers, visualize population-level trends, and develop an AI-powered Cancer Intelligence Assistant capable of answering cancer-related questions using trusted medical literature.

---

## Project Highlights

- Integrated multiple national cancer datasets from the CDC, SEER, ACS, and NCI.
- Applied hierarchical clustering (Ward linkage) to identify high-burden cancer groups.
- Developed an interactive R Shiny dashboard for cancer burden exploration.
- Built a Retrieval-Augmented Generation (RAG) pipeline using LangChain and FAISS.
- Combined healthcare analytics, machine learning, and generative AI into a unified cancer intelligence framework.

---

## Research Objectives

- Analyze cancer incidence, mortality, survival, and healthcare costs.
- Identify high-burden cancer groups using machine learning.
- Develop an interactive R Shiny dashboard for cancer burden visualization.
- Build a Retrieval-Augmented Generation (RAG) system for evidence-based cancer question answering.

---

## Data Sources

This project integrates multiple publicly available healthcare datasets:

- **CDC United States Cancer Statistics (USCS)**
- **SEER (Surveillance, Epidemiology, and End Results)**
- **National Cancer Institute (NCI) PDQ Cancer Information Summaries**
- **American Cancer Society – Cancer Facts & Figures 2025**
- **National Cancer Institute Cancer Economic Burden Reports**

---

## Technologies

- Python
- SQL (PostgreSQL)
- R
- R Shiny
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

The machine learning component applies **Hierarchical Clustering (Ward linkage)** to identify groups of cancers with similar burden characteristics based on:

- Incidence
- Mortality
- Five-year survival
- Mortality-to-incidence ratio
- Initial care cost
- Continuing care cost
- Last-year-of-life care cost

---

## Interactive R Shiny Dashboard

The dashboard provides multiple interactive visualizations, including:

- Cancer incidence and mortality
- Survival trends
- Machine learning clustering
- Research insights
- Cancer-specific exploration

---

## Cancer Intelligence Assistant (RAG)

The project includes a Retrieval-Augmented Generation (RAG) pipeline that combines cancer-specific knowledge documents with authoritative medical literature to improve the accuracy and reliability of AI-generated responses.

### Knowledge Sources

The knowledge corpus currently includes:

**Nine cancer-specific NCI PDQ knowledge documents:**

- Breast Cancer
- Colon Cancer
- Liver Cancer
- Lung Cancer
- Melanoma
- Non-Hodgkin Lymphoma
- Pancreatic Cancer
- Prostate Cancer
- Urinary Bladder Cancer

**Supporting Literature**

- American Cancer Society – *Cancer Facts & Figures 2025*
- National Cancer Institute – *Cancer Patient Economic Burden Report*

### RAG Workflow

- Document loading
- Document chunking
- Sentence embedding generation
- FAISS vector database creation
- Semantic similarity retrieval
- Large Language Model (LLM) question answering

---

## Current Status

- ✅ Data integration completed
- ✅ Machine learning clustering completed
- ✅ Interactive R Shiny dashboard completed
- ✅ Cancer knowledge corpus completed
- ✅ Document chunking completed
- ✅ Embedding generation completed
- ✅ FAISS vector database completed
- ✅ Semantic retrieval completed
- 🔄 LLM-powered question answering in progress

---

## Repository Structure

```text
capstone-cancer-burden-analysis/
│
├── notebooks/
│   ├── Capstone_Project_Sivaraja.ipynb
│   ├── cancer_burden_ml.ipynb
│   └── cancer_cdc_ml.ipynb
│
├── data/
│   ├── CDC datasets
│   ├── SEER datasets
│   ├── Cancer cost datasets
│   └── RAG_files/
│
├── Shinny_app/
│   └── Cancer_Burden_Dashboard/
│
└── README.md
```

---

## Future Work

- Integrate RetrievalQA with a Large Language Model
- Display retrieved source citations with generated responses
- Connect the RAG assistant to the R Shiny dashboard
- Deploy the Cancer Intelligence Assistant as an interactive application
- Expand the knowledge corpus using additional NCI publications
- Enhance explainability with citation-aware responses

---

## Author

**Sivaraja Vaithiyalingam**

Data Scientist Apprentice  
Nashville Software School

- GitHub: https://github.com/dhansiv-stack
- LinkedIn: https://www.linkedin.com/in/sivaraja-vaithiyalingam

---

## Acknowledgments

This project was developed as part of the **Nashville Software School Data Science Apprenticeship Program**. It combines healthcare analytics, machine learning, dashboard development, and Retrieval-Augmented Generation (RAG) to explore cancer burden and demonstrate the application of modern AI techniques to public health data.
