This project analyzes the relationship between crypto prices (BTC, ETH, ADA) and the S&P 500, incorporating quantitative easing (QE) and tightening (QT) policies by examining the U.S. Federal Reserve's total assets.

Key methodologies include:
✅ SQL for data storage, cleaning, and analysis
✅ Power BI for visualization and insights
✅ Excel for data preprocessing and merging

📅 Project Timeline & Key Steps
📌 Step 1: Data Collection & Preparation
✅ Collected historical price data for BTC, ETH, ADA, and S&P 500
✅ Fetched Federal Reserve total assets data (from FRED)
✅ Merged multiple CSV files in Excel
✅ Ensured correct number formatting (avoiding E+11 notation issues)

📌 Step 2: Database Setup (SQL Server)
✅ Created two databases:

crypto_db (for BTC, ETH, ADA)
snp500_db (for S&P 500)
✅ Designed a relational schema, linking both databases using timestamp
✅ Imported cleaned CSV data into SQL tables
📌 Step 3: SQL Analysis & Insights
✅ Trend Analysis: Identified bull & bear markets using daily returns
✅ Volatility Analysis: Compared price fluctuations across assets
✅ Correlation Analysis: Measured BTC-S&P 500 correlation over time
✅ Impact of QE & QT: Analyzed crypto price changes relative to Fed policies

Key SQL Challenge Solved:
⚡ Window function nesting error → Resolved by restructuring queries
⚡ Null correlation values → Fixed by removing rows with missing data

📌 Step 4: Data Visualization in Power BI
✅ Imported SQL data into Power BI
✅ Fixed decimal issues & large number formatting (E+11)
✅ Created interactive line charts:

📈 Crypto prices over time
📊 BTC, ETH, and ADA scaled correctly
🔥 Fed assets vs. Crypto prices
✅ Added a secondary Y-axis to compare different scales
📌 Step 5: Insights & Findings
🔹 Did QE drive crypto rallies? → Strong correlation between Fed balance sheet expansion & BTC growth (2020-2021)
🔹 How did QT affect crypto? → Declines in BTC & ETH prices during Fed tightening periods (2018, 2022)
🔹 Crypto vs. S&P 500 → Weak correlation in bull markets, stronger correlation in downturns
