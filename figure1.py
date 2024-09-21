import os
import pandas as pd
import matplotlib.pyplot as plt

def create_figure1(base_dir, data_dir, processed_data_dir, figures_dir):
    # Load the data from the Penn World Table data
    file_path = os.path.join(data_dir, 'pwt91.xlsx')
    data_sheet = pd.read_excel(file_path, sheet_name='Data')

    # List of IMF Advanced Economies
    imf_advanced_economies = [
        'United States', 'Canada', 'Austria', 'Belgium', 'Cyprus', 'Denmark', 'Estonia', 'Finland',
        'France', 'Germany', 'Greece', 'Iceland', 'Ireland', 'Italy', 'Latvia', 'Lithuania',
        'Luxembourg', 'Malta', 'Netherlands', 'Norway', 'Portugal', 'Slovakia', 
        'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'United Kingdom', 'Australia', 
        'Israel', 'Japan', 'New Zealand', 'Singapore', 'Czech Republic'
    ]

    # Create an indicator for IMF Advanced Economies in the dataset
    data_sheet['AE'] = data_sheet['country'].apply(lambda x: 1 if x in imf_advanced_economies else 0)

    # Filter the data for Advanced Economies and ensure the data is complete
    ae_data = data_sheet[(data_sheet['AE'] == 1) & (data_sheet['year'] >= 1970)]

    # Identify countries with complete delta data for all years
    complete_countries = ae_data.groupby('country').filter(lambda x: x['delta'].notna().all())['country'].unique()

    # Filter AE data to include only countries with complete delta data
    complete_ae_data = ae_data[ae_data['country'].isin(complete_countries)]

    # Calculate average, median, and GDP-weighted depreciation rates by year for AE countries
    ae_avg_delta = complete_ae_data.groupby('year')['delta'].mean().dropna()
    ae_median_delta = complete_ae_data.groupby('year')['delta'].median().dropna()
    ae_weighted_avg_delta = complete_ae_data.groupby('year').apply(
        lambda x: (x['delta'] * x['cgdpe']).sum() / x['cgdpe'].sum()
    ).dropna()

    # Prepare data for the United States for plotting
    us_data = data_sheet[(data_sheet['country'] == 'United States') & (data_sheet['year'] >= 1970)]
    if 'delta' in us_data.columns:
        us_delta_data = us_data[['year', 'delta']].dropna()
    else:
        us_delta_data = pd.DataFrame()

    # Plotting and saving figures for AE countries
    plt.figure(figsize=(7, 5))
    plt.plot(ae_avg_delta.index, ae_avg_delta.values*100, linestyle='-', color='r', linewidth=1.5, label='Unweighted', marker='o')
    plt.plot(ae_median_delta.index, ae_median_delta.values*100, linestyle='--', color='b', linewidth=1.5, label='Median', marker='s')
    plt.plot(ae_weighted_avg_delta.index, ae_weighted_avg_delta.values*100, linestyle='-', color='g', linewidth=1.5, label='GDP weighted', marker='^')
    plt.xlabel('Year', fontsize=12)
    plt.ylabel('Depreciation rate (%)', fontsize=12)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.grid(True)
    plt.legend(fontsize=12)

    plt.tight_layout()

    # Save as Fig1A.pdf (for all Advanced Economies)
    output_file_path = os.path.join(figures_dir, 'Fig1a.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)

    # Plotting and saving figure for the United States
    plt.figure(figsize=(7, 5))
    plt.plot(us_delta_data['year'], us_delta_data['delta']*100, linestyle='-', color='b', linewidth=1.5)
    plt.xlabel('Year', fontsize=12)
    plt.ylabel('Depreciation rate (%)', fontsize=12)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.grid(True)

    plt.tight_layout()

    # Save as Fig1B.pdf
    output_file_path = os.path.join(figures_dir, 'Fig1b.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)
