import yaml
import os

def printhello():
    print("helloooooooo")
    
def get_yaml_fields():
    config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config_generated.yaml')
    with open(yaml_file, 'r') as file:
        config = yaml.safe_load(file)

    return config

def calculate_params_sickle_trim_full(wildcards):
    config = get_yaml_fields()
    config['slurm resources']['sickle_trim_full']

    
