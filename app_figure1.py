import os
import pickle
import pandas as pd
import matplotlib.pyplot as plt

def load_sorted_data(processed_data_dir):
    """Load sorted data from a specified directory."""
    pickle_path = os.path.join(processed_data_dir, 'sorted_data.pkl')
    with open(pickle_path, 'rb') as file:
        sorted_data = pickle.load(file)
    return sorted_data

def create_app_figure1(base_dir, data_dir, processed_data_dir, figures_dir):
    """Function to be called from main_file.py to create figure 2."""
    sorted_data = load_sorted_data(processed_data_dir)
    
    # Filter the data for the year 2017 to find the Capital for each Equipment Type
    capital_2017 = sorted_data[sorted_data['Year'] == 2017][['Equipment Type', 'Capital']].set_index('Equipment Type')
    delta_2017 = sorted_data[sorted_data['Year'] == 2017][['Equipment Type', 'Delta']].set_index('Equipment Type')
    
    # Map the capital and depreciation values from 2017 back to the original DataFrame
    sorted_data['capital_2017'] = sorted_data['Equipment Type'].map(capital_2017['Capital'])
    sorted_data['Delta_in_2017'] = sorted_data['Equipment Type'].map(delta_2017['Delta'])

    # Calculate Real_capital_corr by dividing capital_2017 by the price index. THis will measure the 
    # real stock of capital if the nominal values had been the same as in 2017 thorughout. 
    sorted_data['Real_capital_corr'] = sorted_data['capital_2017'] / sorted_data['Price_ind']
    
    # Calculate total Real_capital_corr and total capital_1997 for each year across all equipment types
    sorted_data['tot_Real_capital_corr'] = sorted_data.groupby('Year')['Real_capital_corr'].transform('sum')
    sorted_data['tot_capital_2017'] = sorted_data.groupby('Year')['capital_2017'].transform('sum')
    
    # Calculate real_share_corr and cap_2017_share
    sorted_data['real_share_corr'] = sorted_data['Real_capital_corr'] / sorted_data['tot_Real_capital_corr']
    sorted_data['cap_2017_share'] = sorted_data['capital_2017'] / sorted_data['tot_capital_2017']
    
    # Calculate total Real_capital for each year across all equipment types and its share
    sorted_data['tot_Real_capital'] = sorted_data.groupby('Year')['Real_capital'].transform('sum')
    sorted_data['real_capital_share'] = sorted_data['Real_capital'] / sorted_data['tot_Real_capital']
    
    # Calculate delta_corr, delta_1997, and delta_real as weighted averages
    sorted_data['weighted_delta'] = sorted_data['Delta'] * sorted_data['real_share_corr'] * 100       # Delta in year with real stock as if nominal stock was constant
    sorted_data['weighted_delta_2017'] = sorted_data['Delta'] * sorted_data['cap_2017_share'] * 100   # Delta in year with constant nominal stock from 2017
    sorted_data['weighted_delta_real'] = sorted_data['Delta'] * sorted_data['real_capital_share'] * 100 # Delta measured with real stock
    sorted_data['weighted_delta_only_price'] = sorted_data['Delta_in_2017'] * sorted_data['real_share_corr'] * 100  # average delta measured with constant delta and real stock as if nominal stock was constant


    delta_corr = sorted_data.groupby('Year')['weighted_delta'].sum().reset_index(name='delta_corr')
    delta_2017 = sorted_data.groupby('Year')['weighted_delta_2017'].sum().reset_index(name='delta_2017')
    delta_real = sorted_data.groupby('Year')['weighted_delta_real'].sum().reset_index(name='delta_real')
    delta_only_price = sorted_data.groupby('Year')['weighted_delta_only_price'].sum().reset_index(name='delta_only_price')
 

    # Merge back to sorted_data if necessary or just plot directly
    plt.figure(figsize=(10, 6))
    plt.plot(delta_real['Year'], delta_real['delta_real'], marker='o', linestyle='--', label='Actual series')
    plt.plot(delta_corr['Year'], delta_corr['delta_corr'], marker='o', linestyle='-', label='Holding nominal capital shares constant')
    plt.plot(delta_only_price['Year'], delta_only_price['delta_only_price'], marker='o', linestyle='-', label='Constant asset-spec. depr. rates and nominal cap. shares')
  # Set font sizes
    plt.xlabel('Year', fontsize=16)
    plt.ylabel('Depreciation (%)', fontsize=16)
    plt.legend(fontsize=16)
    plt.xticks(fontsize=16)
    plt.yticks(fontsize=16)
    plt.grid(True)
    plt.tight_layout()

    # Save the figure as a PDF file
    output_file_path = os.path.join(figures_dir, 'App_fig1.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)
    plt.close()

