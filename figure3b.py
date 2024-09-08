import matplotlib
matplotlib.use('Agg')  # Configure matplotlib to use a non-interactive backend
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns  # Improved visualization
import os

def clean_and_reshape(filepath, value_name):
    # Load and clean data from Excel, adjusting columns for analysis
    data = pd.read_excel(filepath, header=5)
    data.rename(columns={data.columns[1]: "Industry"}, inplace=True)
    data.rename(columns={data.columns[0]: "Line"}, inplace=True)

    data['Line'] = pd.to_numeric(data['Line'], errors='coerce')
    data = data.dropna(subset=['Line'])
    data = data[data['Line'] != 1]  # Exclude aggregate 
    data.reset_index(drop=True, inplace=True)

    # Reshape the data to a long format for easier analysis
    year_columns = [col for col in data.columns if col.startswith('y')]
    data_melted = data.melt(id_vars=['Line', 'Industry'], value_vars=year_columns, var_name='Year', value_name=value_name)
    data_melted['Year'] = data_melted['Year'].str.strip('y').astype(int)
    years_to_keep = [1970, 1980, 1990, 2000, 2010, 2020]
    data_filtered = data_melted[data_melted['Year'].isin(years_to_keep)]
    return data_filtered

def create_figure3b(base_dir, data_dir, processed_data_dir, figures_dir):
    # Paths to the Excel files containing the data from BEA on industry split
    capital_filepath = os.path.join(data_dir, 'BEA_Table_3_1ESI.xlsx')
    depreciation_filepath = os.path.join(data_dir, 'BEA_Table_3_4ESI.xlsx')

    # Prepare and reshape the data
    capital_data = clean_and_reshape(capital_filepath, 'Capital')
    depreciation_data = clean_and_reshape(depreciation_filepath, 'Depreciation')

    # Merge capital and depreciation data and calculate the depreciation rate
    merged_data = pd.merge(capital_data, depreciation_data, on=['Industry', 'Year'], how='inner')
    merged_data['Delta'] = merged_data['Depreciation'] / merged_data['Capital']
    sorted_data = merged_data.sort_values(by=['Industry', 'Year'])

    # Calculate reallocation and change in depreciation rate
    sorted_data['cap_tot'] = sorted_data.groupby('Year')['Capital'].transform('sum')
    sorted_data['cap_share'] = sorted_data['Capital'] / sorted_data['cap_tot']
    sorted_data['delta_past'] = sorted_data.groupby('Industry')['Delta'].shift(1)
    sorted_data['cap_share_past'] = sorted_data.groupby('Industry')['cap_share'].shift(1)

    sorted_data['reallocation_temp'] = sorted_data['delta_past'] * (sorted_data['cap_share'] - sorted_data['cap_share_past'])
    sorted_data['change_temp'] = sorted_data['cap_share'] * (sorted_data['Delta'] - sorted_data['delta_past'])

    # Aggregate and plot changes
    summary_data = sorted_data.groupby('Year').agg({
        'reallocation_temp': 'sum',
        'change_temp': 'sum'
    }).reset_index()
    summary_data.rename(columns={'reallocation_temp': 'Reallocation', 'change_temp': 'Change in delta within industry'}, inplace=True)

    # Calculate 1970 to 2020 totals without removing the year 1970 data from the data frame
    data_1970 = sorted_data[sorted_data['Year'] == 1970].groupby('Industry').sum()
    data_2020 = sorted_data[sorted_data['Year'] == 2020].groupby('Industry').sum()
    reallocation_1970_2020 = (data_1970['Delta'] * (data_2020['cap_share'] - data_1970['cap_share'])).sum()
    change_1970_2020 = (data_2020['cap_share'] * (data_2020['Delta'] - data_1970['Delta'])).sum()

    # Add this data to the summary data
    summary_1970_2020 = pd.DataFrame({
        'Year': ['All'],
        'Reallocation': [reallocation_1970_2020],
        'Change in delta within industry': [change_1970_2020]
    })
    summary_data = pd.concat([summary_data, summary_1970_2020], ignore_index=True)

    # Exclude 1970 from the plot
    summary_data = summary_data[summary_data['Year'] != 1970]

    year_labels = {
        1980: '1970-1980',
        1990: '1980-1990',
        2000: '1990-2000',
        2010: '2000-2010',
        2020: '2010-2020',
        'All': 'All'
    }
    summary_data['Year'] = summary_data['Year'].replace(year_labels)

    sns.set(style="whitegrid")
    fig, ax = plt.subplots(figsize=(12, 6))
    cols = ['Change in delta within industry', 'Reallocation']

    summary_data.plot(kind='bar', x='Year', y=cols, ax=ax, color=['navy', 'darkred'], width=0.8)
    ax.set_xlabel('Year', fontsize=12)
    ax.set_ylabel('')
    ax.set_xticklabels(summary_data['Year'], rotation=0)
    ax.grid(True, linestyle='--', linewidth=0.5)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    plt.tight_layout()

    # Save the figure as a PDF file in the specified directory
    output_file_path = os.path.join(figures_dir, 'Fig3b.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)
    plt.close(fig)
