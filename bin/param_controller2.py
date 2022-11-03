import yaml
import os

"""
we need to figure out in what manner we want the resource allocation to adapt 
when using a subset of the reads. 

we could do a straight linear rule. that probably will work.
We could also do manual values and test it out. 
I sort of like manual because then we don't waste too many resources even if its
more time for me


Here's a better idea. I make a separate test code environment where I test the subassemblies
for 1, 5, 10, 20, and 50 on a single sample. I guess and check the time constraints until they are done

TODO: 
make separate framework to test time limits (done)
make functions in param_controller2 to have different time limits (IP)
test subassemblies one by one (e.g. --sub 1) on hpc
adjust number accordingly



"""
def get_yaml_fields():
    config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config_generated2.yaml')
    with open(config_file, 'r') as file:
        config = yaml.safe_load(file)

    return config

def calculate_sickle_trim_full_time(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['time']

def calculate_sickle_trim_full_mem(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['mem']

def calculate_sickle_trim_full_partition(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['sickle_trim_full']['partition']

#
def calculate_m_assembly_time(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['metaspades_assembly']['time'][str("{0}_per".format(wildcards.subset[:-7]))]

def calculate_m_assembly_mem(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['metaspades_assembly']['mem']

def calculate_m_assembly_partition(wildcards):
    config = get_yaml_fields()
    return config['slurm_resources']['metaspades_assembly']['partition']