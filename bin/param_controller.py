import yaml
import os

def get_yaml_fields():
    config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config_generated.yaml')
    with open(config_file, 'r') as file:
        config = yaml.safe_load(file)

    return config

def calculate_sickle_trim_full_time(wildcards):
    params = {}
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['time']


def calculate_sickle_trim_full_mem(wildcards):
    params = {}
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['mem']

def calculate_sickle_trim_full_partition(wildcards):
    params = {}
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['partition']

    
