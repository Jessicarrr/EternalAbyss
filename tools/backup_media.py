import os
import shutil
from datetime import datetime

# Define the project directory and backup directory
project_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
backup_dir = os.path.join(os.path.dirname(__file__), "media-backups")

# Define the media folders to search for
media_folders = ["textures", "sounds", "models", "blender"]

# Create the backup folder if it doesn't exist
if not os.path.exists(backup_dir):
    os.makedirs(backup_dir)
    print(f"Created backup directory: {backup_dir}")
else:
    print(f"Backup directory already exists: {backup_dir}")

# Create a new folder for this backup with the current date and time
current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
current_backup_dir = os.path.join(backup_dir, current_time)
os.makedirs(current_backup_dir)
print(f"Created current backup directory: {current_backup_dir}")

# Function to back up media files
def backup_media_files():
    print(f"Starting backup process in project directory: {project_dir}")
    for root, dirs, files in os.walk(project_dir):
        # Skip the backup directory
        if backup_dir in root:
            print(f"Skipping backup directory: {root}")
            continue
        
        print(f"Checking directory: {root}")
        for dir_name in media_folders:
            if dir_name in dirs:
                print(f"Found media folder: {dir_name} in {root}")
                
                # Construct the full path to the media folder
                media_folder_path = os.path.join(root, dir_name)
                print(f"Media folder path: {media_folder_path}")
                
                # Determine the relative path of the media folder to the project directory
                relative_path = os.path.relpath(media_folder_path, project_dir)
                print(f"Relative path for backup: {relative_path}")
                
                # Create the corresponding folder in the backup directory
                backup_folder_path = os.path.join(current_backup_dir, relative_path)
                if not os.path.exists(backup_folder_path):
                    os.makedirs(backup_folder_path)
                    print(f"Created backup folder path: {backup_folder_path}")
                
                # Recursively copy all files and folders from the media folder to the backup folder
                for root_dir, sub_dirs, sub_files in os.walk(media_folder_path):
                    # Create the corresponding sub-directory structure in the backup folder
                    sub_folder_relative_path = os.path.relpath(root_dir, project_dir)
                    backup_sub_folder_path = os.path.join(current_backup_dir, sub_folder_relative_path)
                    if not os.path.exists(backup_sub_folder_path):
                        os.makedirs(backup_sub_folder_path)
                        print(f"Created sub-folder path in backup: {backup_sub_folder_path}")
                    
                    for file_name in sub_files:
                        full_file_path = os.path.join(root_dir, file_name)
                        if os.path.isfile(full_file_path):
                            shutil.copy2(full_file_path, backup_sub_folder_path)
                            print(f"Backed up: {full_file_path} to {backup_sub_folder_path}")
                        else:
                            print(f"Skipped non-file item: {full_file_path}")

# Run the backup process
backup_media_files()
