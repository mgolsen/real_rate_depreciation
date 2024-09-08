import os
import pandas as pd
import matplotlib.pyplot as plt

def create_figure2(base_dir, data_dir, processed_data_dir, figures_dir):
    # Construct paths to the stock and depreciation data files from BEA
    nom_stock_path = os.path.join(data_dir, 'BEA_Table2_1.xlsx')
    nom_dep_path = os.path.join(data_dir, 'BEA_Table_2_4.xlsx')

    # Load stock and depreciation data from Excel files
    stock_data = pd.read_excel(nom_stock_path, sheet_name='Sheet0', skiprows=5)

    # Load the depreciation data
    depreciation_data = pd.read_excel(nom_dep_path, sheet_name='Sheet0', skiprows=5)

    # Extract data for "Private fixed assets"
    stock_private_fixed_assets = stock_data.loc[stock_data['Line'] == '1'].iloc[:, 2:].astype(float)
    depreciation_private_fixed_assets = depreciation_data.loc[depreciation_data['Line'] == '1'].iloc[:, 2:].astype(float)

    # Calculate the depreciation rate as depreciation over stock
    depreciation_rate = depreciation_private_fixed_assets / stock_private_fixed_assets

    # Extract years and depreciation rate values for plotting
    years = depreciation_rate.columns.astype(int)

    # Extract the depreciation rate values
    depreciation_values = depreciation_rate.iloc[0].values*100

    # Plotting the depreciation rates over years
    plt.figure(figsize=(7, 5))
    plt.plot(years, depreciation_values, marker='o', linestyle='-', color='b', linewidth=1.5)
    plt.xlabel('Year', fontsize=10)
    plt.ylabel('Depreciation Rate (%)', fontsize=10)
    plt.xticks(fontsize=8)
    plt.yticks(fontsize=8)
    plt.grid(True)
    plt.tight_layout()

    # Save the plot as a PDF file
    output_file_path = os.path.join(figures_dir, 'Fig2.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)


