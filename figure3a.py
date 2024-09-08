import os
import pickle
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def clean_and_reshape(filepath, value_name):
    # Load data from Excel, skipping initial rows and cleaning up the dataset
    data = pd.read_excel(filepath, skiprows=5)
    data.rename(columns={data.columns[1]: "Equipment Type"}, inplace=True)
    # Rows to drop due to find the highest level of disaggreation for each type
    rows_to_drop = [
        0, 1, 2, 3, 4, 11, 18, 19, 26, 35, 36, 37, 39, 40, 49, 50, 54, 57, 62,
        67, 68, 69, 76, 77, 78, 82, 83, 84, 92, 95, 98
    ]

    data.drop(rows_to_drop, inplace=True, errors='ignore')
   # Convert 'Line' column to numeric, forcing non-numeric values to NaN
    data['Line'] = pd.to_numeric(data['Line'], errors='coerce')
    # Drop rows where 'Line' column has NaN values
    data.dropna(subset=['Line'], inplace=True)

    data.reset_index(drop=True, inplace=True)
    data_melted = data.melt(id_vars=['Line', 'Equipment Type'], var_name='Year', value_name=value_name)
    
    return data_melted

def create_figure3a(base_dir, data_dir, processed_data_dir, figures_dir):
    # Paths to data files
    capital_filepath = os.path.join(data_dir, 'BEA_Table2_1.xlsx')
    depreciation_filepath = os.path.join(data_dir, 'BEA_Table_2_4.xlsx')
    real_capital_filepath = os.path.join(data_dir, 'BEA_Table_2_2.xlsx')

    # Prepare and reshape the data
    capital_data = clean_and_reshape(capital_filepath, 'Capital')
    depreciation_data = clean_and_reshape(depreciation_filepath, 'Depreciation')
    real_capital_data = clean_and_reshape(real_capital_filepath, 'Real_capital')

    # Merge and calculate the depreciation rate
    merged_data = pd.merge(capital_data, depreciation_data, on=['Equipment Type', 'Year'], how='inner')
    merged_data = pd.merge(merged_data, real_capital_data, on=['Equipment Type', 'Year'], how='inner')

    # Scale Real_capital to match Capital in 2017
    merged_data['Year'] = merged_data['Year'].astype(int)
    capital_2017 = merged_data[merged_data['Year'] == 2017][['Equipment Type', 'Capital']]
    capital_2017 = capital_2017.rename(columns={'Capital': 'Capital_2017'})
    # Real_capital is in quantities indexed to 100 in 2017. We renormalize to have it equal nominal capital in 2017
    merged_data = pd.merge(merged_data, capital_2017, on='Equipment Type', how='left')
    merged_data['Scaling_Factor'] = merged_data['Capital_2017'] / 100
    merged_data['Real_capital'] = merged_data['Real_capital'] * merged_data['Scaling_Factor']

    # Drop the temporary columns used for scaling
    merged_data.drop(columns=['Capital_2017', 'Scaling_Factor'], inplace=True)
    merged_data['Delta'] = merged_data['Depreciation'] / merged_data['Capital']
    merged_data['Price_ind'] = merged_data['Capital'] / merged_data['Real_capital']
    sorted_data = merged_data.sort_values(by=['Equipment Type', 'Year'])
    # save sorted data for use for appendix figure
    pickle_path = os.path.join(processed_data_dir, 'sorted_data.pkl')
    with open(pickle_path, 'wb') as file:
        pickle.dump(sorted_data, file)

    # Only keep decades for Figure3a
    years_to_keep = [1970, 1980, 1990, 2000, 2010, 2020]
    sorted_data = sorted_data[sorted_data['Year'].isin(years_to_keep)]

    # Calculate reallocation and change in depreciation rate
    sorted_data['cap_tot'] = sorted_data.groupby('Year')['Capital'].transform('sum')
    sorted_data['cap_share'] = sorted_data['Capital'] / sorted_data['cap_tot']
    sorted_data['delta_past'] = sorted_data.groupby('Equipment Type')['Delta'].shift(1)
    sorted_data['cap_share_past'] = sorted_data.groupby('Equipment Type')['cap_share'].shift(1)
    
    sorted_data['reallocation_temp'] = sorted_data['delta_past'] * (sorted_data['cap_share'] - sorted_data['cap_share_past'])
    sorted_data['change_temp'] = sorted_data['cap_share'] * (sorted_data['Delta'] - sorted_data['delta_past'])



    # Aggregate and plot changes
    summary_data = sorted_data.groupby('Year').agg({
        'reallocation_temp': 'sum',
        'change_temp': 'sum'
    }).reset_index()
    
    summary_data.rename(columns={'reallocation_temp': 'Reallocation', 'change_temp': 'Change in delta within asset type'}, inplace=True)
    
    plot_data = summary_data[summary_data['Year'] != 1970]

    # Ensure calculations are correct
    initial = sorted_data[sorted_data['Year'] == 1970].groupby('Equipment Type').agg({'Delta': 'sum', 'cap_share': 'sum'})
    final = sorted_data[sorted_data['Year'] == 2020].groupby('Equipment Type').agg({'Delta': 'sum', 'cap_share': 'sum'})
    total_reallocation = ((initial['Delta'] * (final['cap_share'] - initial['cap_share'])).sum())
    total_change_within = ((final['cap_share'] * (final['Delta'] - initial['Delta'])).sum())

    total_changes = pd.DataFrame({
        'Year': ['All'],
        'Reallocation': [total_reallocation],
        'Change in delta within asset type': [total_change_within]
    })
    plot_data = pd.concat([plot_data, total_changes], ignore_index=True)
    
    year_map = {1980: '1970-1980', 1990: '1980-1990', 2000: '1990-2000', 2010: '2000-2010', 2020: '2010-2020'}
    plot_data['Year'] = plot_data['Year'].replace(year_map)
    
    sns.set(style="whitegrid")
    fig, ax = plt.subplots(figsize=(12, 6))
    cols = ['Change in delta within asset type', 'Reallocation']
    plot_data.plot(kind='bar', x='Year', y=cols, ax=ax, color=['navy', 'darkred'], width=0.8)
    
    ax.set_xlabel('Year', fontsize=12)
    ax.set_ylabel('')
    ax.set_xticklabels(plot_data['Year'], rotation=0)
    ax.grid(True, linestyle='--', linewidth=0.5)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    plt.tight_layout()

    # Save the figure as a PDF file in the specified directory
    output_file_path = os.path.join(figures_dir, 'Fig3a.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)

