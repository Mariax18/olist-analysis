Olist E-commerce Analysis

SQL analysis of ~99K orders from Olist, a Brazilian e-commerce marketplace. The goal is to answer a client brief in plain language and give one concrete recommendation.

Status: in progress. Data checks and cleaning are done; trend, repeat-purchase, delivery and category analysis are being written up.

Business questions
Are orders growing over time, or is it seasonal?
What is the repeat-purchase rate, and how has it changed?
Does delivery delay affect review score?
Which product categories drive revenue, and where are the problems?
What is one action the business should take?
Data

Brazilian E-Commerce Public Dataset by Olist (Kaggle): 8 CSV tables (orders, customers, order items, payments, reviews, products, sellers, category translation). Orders span 2016-09-04 to 2018-10-17.

The raw data is not stored in this repo. Download the CSVs from Kaggle into a local data/ folder.

Tools

DuckDB (SQL), Git/GitHub. Dashboard (Tableau Public) and report are planned.

How to reproduce
bash
duckdb olist.duckdb
.read sql/00_load.sql
.read sql/01_cleaning.sql
Repo structure
sql/       load and analysis queries (numbered in run order)
reports/   report and dashboard (coming)
Data checks and cleaning
Check	Result
Orders	99,441 rows; order_id is unique; all date columns are TIMESTAMP
Unique customers	96,096 (customer_id changes per order, so people are counted with customer_unique_id)
Repeat customers	2,997 of 96,096 (about 3.1%) placed 2+ orders
Multiple reviews	547 orders have 2-3 reviews; reduced to one row per order with an average score (view average_score) to avoid duplicated rows in joins
No review	768 orders (about 0.77%)
Missing delivery date	8 delivered orders; excluded from delay analysis only
Incomplete months	2016 and Sep-Oct 2018 have very low volume; growth analysis uses Jan 2017 to Aug 2018 (hypothesis: incomplete data, not yet confirmed)
Findings so far

These are observations, not yet tested:

Orders grew strongly through 2017.
November 2017 spikes (hypothesis: Black Friday; only one November in the usable data, so it can't be separated from a one-off).
2018 is roughly flat at 6-7K orders per month.
The share of delivered orders rose over time (about 93% to about 99%).
Next

Monthly revenue and average order value, delivery delay vs review score, revenue by category, dashboard, 2-page report.
