# Step 1: Import the point cloud data and convert to .odm
Write-Host "Importing point cloud data..."

# Define the directory containing .laz files
$inputDir = "..\tiles_data\bretten01_leafon"

# Define the output directory for .odm files (under the current directory)
$outputDir = ".\odm_output"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory | Out-Null
    Write-Host "Created output directory: $outputDir"
}

# Loop through all .laz files in the specified directory
foreach ($lazFile in Get-ChildItem -Path $inputDir -Filter *.laz) {
    # Extract the base name of the file (without extension)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($lazFile.Name)
    
    # Define the output .odm file path in the new output directory
    $odmFile = Join-Path -Path $outputDir -ChildPath "$baseName.odm"
    
    # Convert .laz to .odm using opalsImport
    Write-Host "Converting $($lazFile.FullName) to $odmFile..."
    opalsImport -inf $lazFile.FullName -outf $odmFile
    
    # Apply terrain filtering to the .odm file
    Write-Host "Applying terrain filter to $odmFile..."
    opalsTerrainFilter -inf $odmFile -method robustInterpolation -filter Echo[Last] -pyramidLevels 3 -gridSize 0.1 -filterThresholds 0.05 0.1 0.2
}

Write-Host "Processing complete!"