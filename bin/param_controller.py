import yaml
import os

def get_yaml_fields():
    config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config_generated.yaml')
    with open(yaml_file, 'r') as file:
        config = yaml.safe_load(file)

    return config

def calculate_params_sickle_trim_full(wildcards):
    params = {}
    config = get_yaml_fields()
    params['time'] = config['slurm resources']['sickle_trim_full']['time']
    params['mem_mb'] = config['slurm resources']['sickle_trim_full']['mem']
    params['partition'] = config['slurm resources']['sickle_trim_full']['partition']

    return params

    
