import os

def extract_gd_details(file_path):
    """Extract details from a .gd file."""
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    class_name = os.path.basename(file_path).replace('.gd', '')
    extends = ""
    vars = []
    funcs = []
    encountered_func = False

    for line in lines:
        line = line.strip()
        
        # If we encounter a function, set the flag to True
        if line.startswith("func"):
            encountered_func = True
            funcs.append(line.split()[1].split('(')[0])
        # If we haven't encountered a function yet, check for variables
        elif not encountered_func and line.startswith("var"):
            vars.append(line.split()[1].split('=')[0])
        elif line.startswith("extends"):
            extends = line.split()[1]

    return {
        "class_name": class_name,
        "extends": extends,
        "vars": vars,
        "funcs": funcs
    }

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.dirname(script_dir)
    output = []

    for root, _, files in os.walk(parent_dir):
        for file in files:
            if file.endswith(".gd") and not file.startswith("."):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(file_path, parent_dir).replace("\\", "/")
                details = extract_gd_details(file_path)
                
                class_line = f"Class {details['class_name']}"
                if details['extends']:
                    class_line += f" extends {details['extends']}"
                class_line += f" ({relative_path})"
                output.append(class_line)
                
                if details['vars']:
                    vars_lines = ", ".join(details['vars'])
                    output.append(f"vars: {vars_lines}")
                
                if details['funcs']:
                    output.append("func:")
                    output.extend([f"- {func}" for func in details['funcs']])
                output.append("")

    with open(os.path.join(script_dir, "class_diagram.txt"), 'w', encoding='utf-8') as f:
        f.write("\n".join(output))

if __name__ == "__main__":
    main()
