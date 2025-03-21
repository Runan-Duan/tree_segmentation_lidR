import json
import subprocess
import argparse
from pathlib import Path
import laspy
import os

# Set up argument parser
parser = argparse.ArgumentParser(description='Automatic detection of trees in a 3D point cloud')
parser.add_argument('--config', type=str, required=True, help='Path to config file (JSON)')
args = parser.parse_args()

# Load configuration file
config_path = Path(args.config)
with open(config_path, "r") as f:
    config = json.load(f)

# Extract input file name (without extension) for output naming
input_file_path = Path(config["input_file"])
input_file_name = input_file_path.stem

# Update output paths to include input file name
config["output_path"] = str(Path(config["output_dir"]) / input_file_name)

# Create output directory if it doesn't exist
Path(config["output_path"]).mkdir(parents=True, exist_ok=True)

# Load the pipeline template
with open("tiles_splitting.json", "r") as f:
    pipeline_template = f.read()

# Substitute placeholders with values from the configuration file
for key, value in config.items():
    placeholder = f"{{{key}}}"  # Placeholders are enclosed in curly braces
    pipeline_template = pipeline_template.replace(placeholder, str(value))

# Parse the updated pipeline template into a JSON object
pipeline = json.loads(pipeline_template)

# Save the updated pipeline
updated_pipeline_path = Path(config["output_path"]) / f"pipeline_{input_file_name}.json"
with open(updated_pipeline_path, "w") as f:
    json.dump(pipeline, f, indent=2)

# Run the pipeline using PDAL to split the tiles
subprocess.run(["pdal", "pipeline", str(updated_pipeline_path)])