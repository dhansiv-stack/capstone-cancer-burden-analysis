
from pathlib import Path
from dotenv import load_dotenv
import os
import pandas as pd
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage


load_dotenv()

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

PROJECT_DATA_PATH = (
    "C:/Users/dhans/Documents/DataScience/Program/"
    "NSS_projects/capstone-cancer-burden-analysis/"
    "data/master_cancer_summary.csv"
)

cancer_data = pd.read_csv(PROJECT_DATA_PATH)

llm = ChatOpenAI(
    model="openrouter/free",
    base_url="https://openrouter.ai/api/v1",
    api_key=OPENROUTER_API_KEY
)

embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
)

vector_store = FAISS.load_local(
    "C:/Users/dhans/Documents/DataScience/Program/NSS_projects/capstone-cancer-burden-analysis/notebooks/faiss_cancer_index",
    embeddings,
    allow_dangerous_deserialization=True
)


retriever = vector_store.as_retriever(
    search_kwargs={"k": 4}
)
    
def get_cancer_data(cancer_name):

    result = cancer_data[
        cancer_data["cancer_type"]
        .str.contains(cancer_name, case=False, na=False)
    ]

    if result.empty:
        return None

    return result.iloc[0]



def get_project_context(question):

    question_lower = question.lower()
    cancer_keywords = {
        "colon": "Colon",
        "rectum": "Colon",
        "lung": "Lung",
        "pancreas": "Pancreas",
        "pancreatic": "Pancreas",
        "liver": "Liver",
        "breast": "Breast",
        "prostate": "Prostate",
        "melanoma": "Melanoma",
        "bladder": "Bladder",
        "lymphoma": "Lymphoma",
        "non-hodgkin": "Lymphoma"
    }

    cancer = None

    for keyword, cancer_name in cancer_keywords.items():
        if keyword in question_lower:
             cancer = get_cancer_data(cancer_name)
             break

    if cancer is None:
        return ""

    return f"""   
Project Dataset Context:
Cancer Type: {cancer['cancer_type']}
Diagnosis Challenge: {cancer['diagnosis_challenge']}
Incidence Rate: {cancer['incidence']} per 100,000
Mortality Rate: {cancer['mortality']} per 100,000
Five-Year Survival: {cancer['survival']}
Mortality Ratio: {cancer['mortality_ratio']}
Initial Care Cost: ${cancer['initial_care']}
Continuing Care Cost: ${cancer['continuing_care']}
Last Year of Life Cost: ${cancer['last_year_of_life']}
"""


def ask_cancer_question(question):

    """
    This function receives a question from R Shiny,
    sends it through the Python RAG pipeline,
    and returns the final answer back to Shiny.
    """

    retrieved_docs = retriever.invoke(question)

    context = "\n\n".join(
        doc.page_content for doc in retrieved_docs
    )

    project_context = get_project_context(question)

    messages = [
        SystemMessage(
            content="""
You are an AI Cancer Burden Analyst.

Respond using EXACTLY this structure:

Summary:
Write 2 clear sentences.

Key Findings:
• Write one bullet about mortality or survival.
• Write one bullet about treatment or continuing-care costs.
• Write one bullet about healthcare or economic burden.


Significance:
Write one clear sentence.


Rules:
- Answer the specific question directly.
- If the question asks "why," explain only the reasons.
- Do not include survival, treatment costs, or economic burden unless they directly answer the question.
- Use both the Project Data and the Retrieved Context.
- Prefer the Project Data for structured values such as incidence, mortality, survival, diagnosis challenge, and healthcare costs.
- Use the Retrieved Context for explanations, clinical background, and supporting evidence.
- If both sources contain relevant information, combine them into one coherent answer.
- Do not invent facts.
- Keep the answer concise and easy for dashboard users to read.
- Stop after the Significance sentence.
"""
        ),
        HumanMessage(
            content=f"""
Project Data:
{project_context}

Retrieved Context:
{context}

Question:
{question}
"""
        )
    ]

    response = llm.invoke(messages)

    return response.content
