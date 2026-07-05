
from pathlib import Path
from dotenv import load_dotenv
import os

from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage


load_dotenv()

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

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
- Use only the retrieved context.
- Do not invent facts.
- Keep the answer concise and easy for dashboard users to read.
- Stop after the Significance sentence.
"""
        ),
        HumanMessage(
            content=f"""
Context:
{context}

Question:
{question}
"""
        )
    ]

    response = llm.invoke(messages)

    return response.content
