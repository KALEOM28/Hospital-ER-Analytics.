# Hospital Emergency Room (ER) Analytics & Performance Tuning

## 📌 Project Overview
This project focuses on analyzing real-world Emergency Room (ER) operational data to uncover critical insights regarding patient demographics, hospital operations, and efficiency constraints. By executing a series of 30 structured SQL queries (ranging from basic data exploration to advanced multi-level analytical CTEs and Window Functions), this repository provides actionable recommendations to optimize ER resources, reduce patient wait times, and enhance overall operational throughput.

---

## 📊 Key Insights & Business Findings
Based on the advanced data analysis of **9,216 patient records**, here are the major operational findings:

1. **Peak Demand Hours (Resource Allocation):** The absolute peak hour for ER admissions is **11:00 PM** (recording 436 visits). This points toward a critical need for strengthening overnight medical staffing.
2. **High-Bottleneck Departments (Operational Delays):** Patients referred to **Neurology** and **Physiotherapy** experience the highest average wait times (~36.8 and ~36.5 minutes respectively). These departments require process tuning or added diagnostic support.
3. **High Conversion & Admission Rates:** Out of all ER triages, **50.04%** result in successful hospital admissions, indicating that half of the incoming ER pipeline comprises high-acuity cases requiring inpatient care.
4. **Patient Flow Profiling:** The ER treats a perfectly diverse group across all ages (Average age: ~40 years, ranging from infants to seniors up to 79 years old).

---

## 🛠️ Repository Structure
```bash
├── Hospital_ER_Data.csv          # Raw ER Operational Dataset (9,216 rows)
├── Hospital_ER_Analytics.sql     # Full SQL Script containing all 30 Queries
└── README.md                     # Project Documentation & Insights
