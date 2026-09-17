import pandas as pd
import os
import matplotlib.pyplot as plt

print("=" * 55)
print("HR EMPLOYEE ATTRITION & COST ANALYSIS")
print("=" * 55)

# Load dataset
file_path = os.path.join(
    os.path.dirname(__file__),
    "..",
    "Dataset",
    "Employee_Attrition_Data.csv"
)

df = pd.read_csv(file_path)

# Clean column names automatically
df.columns = (
    df.columns
    .str.strip()
    .str.replace(" ", "_", regex=False)
    .str.replace("-", "_", regex=False)
)
# Clean all text values
for col in df.select_dtypes(include="object").columns:
    df[col] = df[col].astype(str).str.strip()

# Convert numeric columns
for col in [
    "Age",
    "Monthly_Salary",
    "Months_Worked",
    "Training_Cost",
    "Job_Satisfaction",
    "Performance_Rating"
]:
    df[col] = (
        df[col]
        .astype(str)
        .str.replace("₹", "", regex=False)
        .str.replace("?", "", regex=False)
        .str.replace(",", "", regex=False)
        .str.replace(" ", "", regex=False)
    )

    df[col] = pd.to_numeric(df[col], errors="coerce")

# Total Loss
df["Total_Loss"] = (
    df["Monthly_Salary"] * df["Months_Worked"]
    + df["Training_Cost"]
)

# Main metrics
total_employees = len(df)

total_attrition = (
    df["Attrition"].str.lower().eq("yes").sum()
)

attrition_rate = (
    total_attrition / total_employees
) * 100

average_salary = df["Monthly_Salary"].mean()
total_training_cost = df["Training_Cost"].sum()
total_loss = df["Total_Loss"].sum()

# Final output
print("\nKEY HR METRICS")
print("-" * 55)

print("Total Employees:", total_employees)
print("Total Attrition:", total_attrition)
print("Attrition Rate:", attrition_rate, "%")
print("Average Monthly Salary:", average_salary)
print("Total Training Cost:", total_training_cost)
print("Total Loss:", total_loss)

# Department analysis
print("\nDEPARTMENT-WISE ATTRITION")
print("-" * 55)

department_analysis = df.groupby("Department").agg(
    Employees=("Employee_ID", "count"),
    Attrition=("Attrition", lambda x: x.str.lower().eq("yes").sum())
).reset_index()

department_analysis["Attrition_Rate"] = (
    department_analysis["Attrition"]
    / department_analysis["Employees"]
) * 100

print(department_analysis)

# Attrition reasons
print("\nATTRITION BY REASON")
print("-" * 55)

attrition_reasons = df[
    df["Attrition"].str.lower() == "yes"
]["Attrition_Reason"].value_counts()

print(attrition_reasons)

# Overtime analysis
print("\nOVERTIME VS ATTRITION")
print("-" * 55)

overtime_analysis = df.groupby("Overtime").agg(
    Employees=("Employee_ID", "count"),
    Attrition=("Attrition", lambda x: x.str.lower().eq("yes").sum())
).reset_index()

overtime_analysis["Attrition_Rate"] = (
    overtime_analysis["Attrition"]
    / overtime_analysis["Employees"]
) * 100

print(overtime_analysis)

print("\n" + "=" * 55)
print("ANALYSIS COMPLETED SUCCESSFULLY")
print("=" * 55)


# Attrition by Department Chart

plt.figure(figsize=(8, 5))

plt.bar(
    department_analysis["Department"],
    department_analysis["Attrition_Rate"]
)

plt.title("Department-wise Attrition Rate")
plt.xlabel("Department")
plt.ylabel("Attrition Rate (%)")
plt.xticks(rotation=45)
plt.tight_layout()

plt.show()

# Attrition by Reason Chart

reason_counts = df[
    df["Attrition"].str.lower() == "yes"
]["Attrition_Reason"].value_counts()

plt.figure(figsize=(8, 5))

plt.bar(
    reason_counts.index,
    reason_counts.values
)

plt.title("Attrition by Reason")
plt.xlabel("Attrition Reason")
plt.ylabel("Number of Employees")
plt.xticks(rotation=30)
plt.tight_layout()

plt.show()