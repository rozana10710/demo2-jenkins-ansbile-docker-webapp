import os

# Define the hierarchy
structure = {
    "terraform-jenkins-minimal": [
        "provider.tf",
        "main.tf",
        "variables.tf",
        "outputs.tf",
        "terraform.tfvars.example",
        {
            "modules": [
                {
                    "vpc": ["main.tf", "variables.tf", "outputs.tf"]
                },
                {
                    "security_group": ["main.tf", "variables.tf", "outputs.tf"]
                },
                {
                    "ec2-instance": ["main.tf", "variables.tf", "outputs.tf"]
                }
            ]
        }
    ]
}

def create_structure(base_path, items):
    for item in items:
        if isinstance(item, str):
            # Create file
            file_path = os.path.join(base_path, item)
            open(file_path, 'w').close()
        elif isinstance(item, dict):
            # Create subdirectories
            for folder, subitems in item.items():
                folder_path = os.path.join(base_path, folder)
                os.makedirs(folder_path, exist_ok=True)
                create_structure(folder_path, subitems)

# Create the root folder and structure
for root, content in structure.items():
    os.makedirs(root, exist_ok=True)
    create_structure(root, content)

print("Terraform Jenkins minimal structure created.")
