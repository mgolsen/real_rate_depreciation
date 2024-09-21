import os

# Function to create all figures
def run_figures(base_dir):
    # Import figure modules
    from figure1 import create_figure1
    from figure2 import create_figure2
    from figure3a import create_figure3a
    from figure3b import create_figure3b
    from app_figure1 import create_app_figure1                      # Cannot run without output from figure3a
    from app_figure2 import create_app_figure2

    # Set up directories
    data_dir = os.path.join(base_dir, 'raw_data')
    processed_data_dir = os.path.join(base_dir, 'processed_data')  # For processed data. In particular for appendix figures 
    figures_dir = os.path.join(base_dir, 'figures')
    
    # Ensure directories exist
    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(processed_data_dir, exist_ok=True)
    os.makedirs(figures_dir, exist_ok=True)

    # Execute figure creation functions
    create_figure1(base_dir, data_dir, processed_data_dir, figures_dir)
    create_figure2(base_dir, data_dir, processed_data_dir, figures_dir)
    create_figure3a(base_dir, data_dir, processed_data_dir, figures_dir)
    create_figure3b(base_dir, data_dir, processed_data_dir, figures_dir)
    create_app_figure1(base_dir, data_dir, processed_data_dir, figures_dir)
    create_app_figure2(base_dir, data_dir, processed_data_dir, figures_dir)
# Base directory for all data and outputs
base_dir = r'C:\\Users\\graug\\Documents\\GitHub\\real_rate_depreciation'

# Run the figure creation scripts
run_figures(base_dir)
print("All figures have been created and saved.")
