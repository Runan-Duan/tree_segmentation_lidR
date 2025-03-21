import os
from pathlib import Path
import laspy
import sys


# Path to the folder containing the tiles
tiles_folder = Path(sys.argv[1])

# Iterate over all files in the folder
for file_path in tiles_folder.glob("tile_*.laz"):
    # Read the LAS/LAZ file
    las = laspy.read(file_path)
    
    # Get the bounding box coordinates
    xmin = las.header.x_min
    ymin = las.header.y_min
    
    # Extract the tile ID from the filename (e.g., "tile_1.laz" -> 1)
    tile_id = file_path.stem.split("_")[1]
    
    # Create the new filename
    new_filename = f"{xmin}_{ymin}_{tile_id}.laz"
    new_file_path = tiles_folder / new_filename
    
    # Rename the file
    os.rename(file_path, new_file_path)
    print(f"Renamed {file_path.name} -> {new_filename}")

# Iterate over all files in the folder
for file_path in tiles_folder.glob("*.odm"):
    
    # Extract the tile ID from the filename (e.g., "tile_1.laz" -> 1)
    tile_id = file_path.stem.split("_")[1]
    
    # Create the new filename
    new_filename = f"{tile_id}.odm"
    new_file_path = tiles_folder / new_filename
    
    # Rename the file
    os.rename(file_path, new_file_path)
    print(f"Renamed {file_path.name} -> {new_filename}")