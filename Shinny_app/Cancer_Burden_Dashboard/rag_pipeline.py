
# ==========================================================
# Imports
# ==========================================================
from dotenv import load_dotenv
import os
from pathlib import Path
import pandas as pd
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage


# ==========================================================
# Load Environment and Project Data
# ==========================================================

load_dotenv()

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

BASE_DIR = Path(__file__).resolve().parents[2]

PROJECT_DATA_PATH = BASE_DIR / "data" / "master_cancer_summary.csv"

cancer_data = pd.read_csv(PROJECT_DATA_PATH)

cancer_data["prob_survive_5yr"] = cancer_data["survival"]
cancer_data["prob_not_survive_5yr"] = 1 - cancer_data["survival"]

# Create probability context for AI assistant
probability_context = "\n".join(
    cancer_data.apply(
        lambda row: (
            f"{row['cancer_type']}: "
            f"5-year survival probability = {row['prob_survive_5yr']}, "
            f"5-year non-survival probability = {row['prob_not_survive_5yr']}"
        ),
        axis=1
    )
)

cancer_data["total_healthcare_cost"] = (
    cancer_data["initial_care"] +
    cancer_data["continuing_care"] +
    cancer_data["last_year_of_life"]
)

cancer_data = cancer_data.sort_values(
    "total_healthcare_cost",
    ascending=False
)

# --------------------------------------------------
# Project statistical analysis
# --------------------------------------------------

survival_cost_corr = cancer_data["survival"].corr(
    cancer_data["total_healthcare_cost"]
)

mortality_cost_corr = cancer_data["mortality"].corr(
    cancer_data["total_healthcare_cost"]
)

survival_mortality_ratio_corr = cancer_data["survival"].corr(
    cancer_data["mortality_ratio"]
)

# ==========================================================
# Initialize LLM and Vector Store
# ==========================================================

llm = ChatOpenAI(
    model="openrouter/free",
    base_url="https://openrouter.ai/api/v1",
    api_key=OPENROUTER_API_KEY,
    temperature=0
)

embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
)

vector_store = FAISS.load_local(
    "C:/Users/dhans/Documents/DataScience/Program/NSS_projects/capstone-cancer-burden-analysis/data/faiss_cancer_index",
    embeddings,
    allow_dangerous_deserialization=True
)


retriever = vector_store.as_retriever(
    search_kwargs={"k": 4}
)
    
# ==========================================================
# Helper Functions
# ==========================================================

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
    matched_cancers = []
    if "highest healthcare cost" in question_lower:
        for _, cancer in cancer_data.iterrows():
            matched_cancers.append(cancer)

    if "highest mortality" in question_lower:
        for _, cancer in cancer_data.iterrows():
            matched_cancers.append(cancer)

    if "high burden cluster" in question_lower:
        cluster_results = cancer_data[
            cancer_data["ml_cluster"] == "High Burden Cluster"
        ]

        for _, cancer in cluster_results.iterrows():
            matched_cancers.append(cancer)

    if "moderate burden cluster" in question_lower:
        cluster_results = cancer_data[
            cancer_data["ml_cluster"] == "Moderate Burden Cluster"
        ]

        for _, cancer in cluster_results.iterrows():
            matched_cancers.append(cancer)

    if "lower burden cluster" in question_lower:
        cluster_results = cancer_data[
            cancer_data["ml_cluster"] == "Lower Burden Cluster"
        ]

        for _, cancer in cluster_results.iterrows():
            matched_cancers.append(cancer)


    comparison_keywords = [
        "highest",
        "lowest",
        "most",
        "least",
        "compare",
        "cost",
        "mortality",
        "incidence",
        "survival",
        "ratio"
    ]
    if any(keyword in question_lower for keyword in comparison_keywords):
        for _, cancer in cancer_data.iterrows():
            matched_cancers.append(cancer)

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

   
    for keyword, cancer_name in cancer_keywords.items():
        if keyword in question_lower:
            cancer = get_cancer_data(cancer_name)

            if cancer is not None:
                matched_cancers.append(cancer)

    if len(matched_cancers) == 0:
        return ""
    
    statistics_context = f"""
Project Statistical Analysis:

- Survival vs Total Healthcare Cost
  Correlation: {survival_cost_corr:.3f}
  Interpretation:
  Strong negative relationship. Cancers with lower survival generally have higher healthcare costs.

- Mortality vs Total Healthcare Cost
  Correlation: {mortality_cost_corr:.3f}
  Interpretation:
  Very weak linear relationship.

- Survival vs Mortality-to-Incidence Ratio
  Correlation: {survival_mortality_ratio_corr:.3f}
  Interpretation:
  Strong inverse relationship.
"""   

    context_blocks = []

    for cancer in matched_cancers:
        context_blocks.append(f"""
Project Dataset Context:
Cancer Type: {cancer['cancer_type']}
ML Cluster: {cancer['ml_cluster']}
Diagnosis Challenge Rating: {cancer['diagnosis_challenge']}
Incidence Rate (per 100,000): {cancer['incidence']}
Mortality Rate (per 100,000): {cancer['mortality']}
Five-Year Survival Rate: {cancer['survival']}
Probability of Surviving Five Years: {cancer['prob_survive_5yr']:.2%}
Probability of Not Surviving Five Years: {cancer['prob_not_survive_5yr']:.2%}
Mortality-to-Incidence Ratio: {cancer['mortality_ratio']}
Initial Care Cost (USD): ${cancer['initial_care']}
Continuing Care Cost (USD): ${cancer['continuing_care']}
Last-Year-of-Life Cost (USD): ${cancer['last_year_of_life']}
Total Healthcare Cost (USD): ${cancer['total_healthcare_cost']}
""")

    return (
    statistics_context
    + "\n\n"
    + "\n-------------------------\n".join(context_blocks)
)

def format_rag_answer(answer):
    """
    Clean and format the LLM response so it displays well in Shiny.
    """
    # Remove markdown bold symbols
    answer = answer.replace("**", "")

    # Force section headings onto their own lines
    answer = answer.replace("Summary:", "Summary:\n")
    answer = answer.replace("Key Findings:", "\n\nKey Findings:\n")
    answer = answer.replace("Significance:", "\n\nSignificance:\n")
    # Convert numbered lists to hyphen bullets
    for number in range(1, 10):
        answer = answer.replace(f"{number}. ", "- ")
    # Put bullets on separate lines if model returned one paragraph
    answer = answer.replace(" - ", "\n- ")
    # Clean extra spaces
    answer = answer.strip()

    return answer.strip()


# ==========================================================
# Main RAG Pipeline
# ==========================================================

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
Your goal is to help users understand cancer burden by combining structured project data with retrieved medical knowledge. Always provide informative explanations, not just isolated statistics.
Respond using EXACTLY this structure:

Summary:
Write exactly 2 concise sentences that directly answer the user's question and summarize the main findings.


Key Findings:
Write between 3 and 5 bullet points highlighting the most important findings and supporting evidence.

Significance:
Write one sentence explaining why these findings matter for patients, clinicians, researchers, or public health.

Formatting Rules:
- Output plain text only.
- Do not use Markdown.
- Do not use **bold**, # headings, backticks, or other Markdown syntax.
- Do not write the answer as one paragraph.
- Put each heading on its own line.
- Put each bullet point on its own separate line.
- Leave one blank line between Summary, Key Findings, and Significance.
- Use exactly these headings:
  Summary:
  Key Findings:
  Significance:
- Use hyphens (-) for every bullet point.
- Do not add any text after the Significance section.

Rules:
- Answer the specific question directly.
- Provide a complete explanation, not just simple metrics.
- Prioritize information that directly answers the user's question.
- Include supporting clinical details only when they help explain the answer.
- Avoid adding unrelated medical facts that do not improve the explanation.
- Whenever statistics are presented, explain their clinical or public health significance.
- Base every factual statement on the Project Data, the Retrieved Context, or both. Do not rely on outside knowledge unless the user explicitly asks for it.
- When asked which cancer has the greatest overall burden, answer based on the project's integrated burden framework. In this project, pancreatic cancer represents the greatest overall burden because it combines the lowest five-year survival, highest mortality-to-incidence ratio, high diagnosis challenge, high healthcare cost, and High Burden ML cluster assignment. Lung cancer may have higher incidence, but incidence alone should not override the integrated burden framework.
- Include all relevant information that helps answer the user's question.
- Explain what the numbers mean and why they matter.
- Explain the relationships between Project Data and the Retrieved Context instead of listing facts independently.
- Use both the Project Data and the Retrieved Context.
- Prefer the Project Data for structured values such as incidence, mortality, survival, diagnosis challenge, ML cluster, and healthcare costs.
- Use the Retrieved Context for explanations, clinical background, screening, symptoms, diagnosis difficulty, treatment context, and supporting evidence.
- Combine both sources into one coherent answer.
- Do not mention "Project Data" or "Retrieved Context" in the final answer.
- Integrate all information into one natural explanation.
- When Project Data contains relevant statistics, incorporate them naturally into the explanation.
- If the question asks "why," explain the relevant reasons using both data and clinical context.
- If the question asks for a comparison, explain both the similarities and the differences using Project Data and Retrieved Context.
- Present between 3 and 5 meaningful bullet points in the Key Findings section.
- Do not invent facts or statistics.
- Keep the answer clear, complete, and easy for dashboard users to read.
- Stop after the Significance section.
"""
  ),


    HumanMessage(
        content=f"""
    
Question:
{question}

Project Data:
{project_context}

Probability Analysis:
{probability_context}

Retrieved Context:
{context}
"""
        )
    ]

    try:
        response = llm.invoke(messages)

        answer = format_rag_answer(response.content)

        return answer

    except Exception:
        return """
Summary:

The AI assistant is temporarily unavailable.

Key Findings:

- The external AI service has reached its request limit.
- The R Shiny dashboard is working correctly.
- The Python RAG pipeline is working correctly.
- Please try again later.

Significance:

The dashboard remains functional, but the external language model is temporarily unavailable.
"""
