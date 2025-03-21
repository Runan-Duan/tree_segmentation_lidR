# Step 1: Import the point cloud data and convert to .odm
Write-Host "Importing point cloud data..."

# Define the directory containing .laz files
#$inputDir = "odm_output"

# Define the output directory for .odm files (under the current directory)
$outputDir = "las_output"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory | Out-Null
    Write-Host "Created output directory: $outputDir"
}

# Loop through all .odm files in the specified directory
foreach ($odmFile in Get-ChildItem -Filter *.odm) {
    # Extract the base name of the file (without extension)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($domFile.Name)
    
    # Define the output .odm file path in the new output directory
    $lasFile = Join-Path -Path $outputDir -ChildPath "$baseName.laz"
    
    # Convert .laz to .odm using opalsImport
    Write-Host "Converting $($odmFile.FullName) to $lasFile..."
    opalsExport -inf $domFile.FullName -outf $lasFile -oFormat las
}

Write-Host "Processing complete!"