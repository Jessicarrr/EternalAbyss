import os

def print_dir_structure(path, indent=0):
    # Get all entries in the directory
    entries = os.listdir(path)
    
    # Sort the entries to ensure directories come first
    entries.sort(key=lambda x: (os.path.isfile(os.path.join(path, x)), x.lower()))
    
    for entry in entries:
        # Skip hidden files/folders (those starting with a dot)
        if entry.startswith("."):
            continue

        entry_path = os.path.join(path, entry)
        
        # Skip unwanted files
        if "-folding-" in entry or "-editstate-" in entry:
            continue
        
        # Print the entry with the appropriate indentation
        print(('- ' * indent) + entry)
        
        # If the entry is a directory, recurse into it
        if os.path.isdir(entry_path):
            print_dir_structure(entry_path, indent + 1)

# Get the directory where the script is located
script_directory = os.path.dirname(os.path.abspath(__file__))
parent_directory = os.path.dirname(script_directory)


# Starting point
print("root")
print_dir_structure(parent_directory)

# Wait for user input before closing
input("\nPress any key to continue...")
