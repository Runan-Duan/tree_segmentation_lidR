#!/bin/bash

# Step 1: Import the point cloud data and convert to .odm
echo "Importing point cloud data..."

# Loop through all .laz files in the specified directory
for l in "../tiles_data/bretten01_leafon/"*.laz; do
    # Extract the base name of the file (without extension)
    base_name=$(basename "$l" .laz)
    
    # Define the output .odm file path
    odm_file="${base_name}.odm"
    
    # Convert .laz to .odm using opalsImport
    echo "Converting $l to $odm_file..."
    opalsImport -inf "$l" -outf "$odm_file"
    
    # Apply terrain filtering to the .odm file
    echo "Applying terrain filter to $odm_file..."
    opalsTerrainFilter -inf "$odm_file" -method robustInterpolation -filter Echo[Last] -pyramidLevels 3 -gridSize 0.1 -filterThresholds 0.05 0.1 0.2
done

echo "Processing complete!"