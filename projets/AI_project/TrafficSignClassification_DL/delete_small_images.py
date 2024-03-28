import os
from PIL import Image

# Define the directory containing the dataset folders
dataset_dir = "image_dataset"

# Function to delete images with height or width under 50 pixels
def delete_small_images(folder_path):
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        try:
            bool = False
            with Image.open(file_path) as img:
                width, height = img.size
                if width < 50 or height < 50:
                    bool = True
            if bool:
                os.remove(file_path)
                print(f"Deleted {file_path}")
        except PermissionError as e:
            print(f"Permission error while deleting {file_path}: {e}")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

# Iterate over dataset folders
for query in os.listdir(dataset_dir):
    query_dir = os.path.join(dataset_dir, query)
    if os.path.isdir(query_dir):
        delete_small_images(query_dir)
