# Replication package for "Has the Real Rate of Return Depreciated?"
# Two programs have been used for this project 
# i) Python for the empirical part,
# ii) MATLAB for the Simulation part. 

These are here in order: 


1. Project Overview
This python script creates the 3 figures (including subplots) for rates of deprecation. It is based on Penn World Table 9.1 and the Bureau of Economic Analysis. Run on 3.12.4

2. File Descriptions
main_file.py: This is the central script that orchestrates the running of all other scripts. It sets up the necessary directories, calls the figure creation scripts, and manages the flow of data between them. One has to set base directory. 
figure1.py:
Purpose: Generates figures analyzing depreciation rates for IMF Advanced Economies + the United States based on PWT data
Output: Creates Figures 1a and 1b
figure2.py:
Purpose: Generates figures for the depreciation rate for the United States. Based on BEA data.
Output: Produces Figure 2.
figure3a.py and figure3b.py:
Purpose: These scripts perform detailed analyses of capital reallocations and changes in depreciation rates across different asset types and industries.
Output: Creates figures 3a and 3b.
app_figure1.py and app_figure2.py
Purpose: These scripts calculate various measures of average depreciation weighted by the real stock of assets. They also relate price declines to average depreciation 
Output: Creates app_figure1.pdf and app_figure2.pdf, the two subplots in the appendix 

3. Dependencies
Required Libraries: pandas, numpy, matplotlib, seaborn, os, pickle
Version Information: Ensure that your Python environment is using versions compatible with the latest releases of these libraries as of 2024.

4. Setup Instructions
Dependency Installation: Install required libraries using pip:
pip install pandas matplotlib seaborn numpy os pickle

5. Execution
Running the Scripts: To run the scripts and generate the figures, execute the main_file.py from your command line:
python main_file.py. figureX.py can run independently, but appendix figures requires that figure3a.py runs first. 
Parameter Adjustments: Adjust the base_dir path in main_file.py to match their directory structure for data and output locations.

6. Output Description
Expected Files: Figures are saved in the PDF format in the 'figures' directory under the base directory specified in main_file.py. Processed files are stored in processed_data

7. Additional Resources
Data Sources: 
- pwt91: Penn World Table 9.1 downloaded in August 2021
- BEA_table2_1: Bureau of Economic Analysis - Table 2.1. Current-Cost Net Stock of Private Fixed Assets, Equipment, Structures, and Intellectual Property Products by Type.Downloaded August 2021
- BEA_table2_2: Bureau of Economic Analysis - Table 2.2. Chain-Type Quantity Indexes for Net Stock of Private Fixed Assets, Equipment, Structures, and Intellectual Property Products by Type. Downloaded Sep 2024 
- BEA_table_2_4: BEA - Table 2.4. Current-Cost Depreciation of Private Fixed Assets, Equipment, Structures, and Intellectual Property Products by Type. Downloaded August 2021
- BEA_table_3_1_ESI.xlsx (downloaded as an .xls file): BEA - Table 3.1. ESI. Table 3.1ESI. Current-Cost Net Stock of Private Fixed Assets by Industry. Downloaded August 2021
- BEA_table_3_4ESI.xlsx (downloaded as an .xls file): Table 3.4ESI. Current-Cost Depreciation of Private Fixed Assets by Industry. Downloaded August 2021

8. Contact Information
Maintainer Contact: Morten Olsen: mgo@econ.ku.dk
