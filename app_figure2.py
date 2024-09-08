import pickle
import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def load_sorted_data(processed_data_dir):
    # Path to the pickle file where the sorted_data is stored
    pickle_path = os.path.join(processed_data_dir, 'sorted_data.pkl')
    
    # Load the DataFrame from the pickle file
    with open(pickle_path, 'rb') as file:
        sorted_data = pickle.load(file)
    
    # Convert 'Year' to integer to ensure correct filtering
    sorted_data['Year'] = sorted_data['Year'].astype(int)

    return sorted_data

def create_scatter_plot(sorted_data, processed_data_dir, figures_dir):
    # Filter data for 1970
    data_1970 = sorted_data[sorted_data['Year'] == 1970].copy()

    # Filter data for 1970
    data_1970['Normalized_Price_Index'] = (data_1970['Price_ind'] ** (-1 / 47)-1)
    
    # Compute the average Delta for each Equipment Type across all years
    average_delta = sorted_data.groupby('Equipment Type')['Delta'].mean().reset_index()

    # Merge average Delta data with data from 1970 on 'Equipment Type'
    merged_data = data_1970[['Equipment Type', 'Price_ind','Normalized_Price_Index']].merge(
        average_delta, on='Equipment Type', suffixes=('', '_avg'))
    
    # Scale by 100
    merged_data['Delta'] = merged_data['Delta'] * 100
    merged_data['Normalized_Price_Index'] = merged_data['Normalized_Price_Index'] * 100

    # Create the scatter plot
    plt.figure(figsize=(10, 6))
    sns.regplot(x='Delta', y='Normalized_Price_Index', data=merged_data, scatter_kws={'s': 50}, line_kws={'color': 'red'}, ci=None)
    plt.xlabel('Average depreciationn (%)')
    plt.ylabel('Average price increase (%)')
    plt.grid(True)

    # Save the figure as a PDF file in the specified directory
    output_file_path = os.path.join(figures_dir, 'App_fig2.pdf')
    plt.savefig(output_file_path, format='pdf', dpi=600)
    plt.close()  # Close the plot to free up memory

def create_app_figure2(base_dir, data_dir, processed_data_dir, figures_dir):
    # Load the processed data
    sorted_data = load_sorted_data(processed_data_dir)
    
    # Call the function to create and save the scatter plot
    create_scatter_plot(sorted_data, processed_data_dir, figures_dir)