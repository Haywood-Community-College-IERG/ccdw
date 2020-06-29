# %% Import statements
import os
import sys
import pathlib
import argparse
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, Template

# Import other local packages
from module.config import load_cfg

__source__ = 'setup.py'
__version__ = "1.0.0"
current_directory = Path.cwd()

parser = argparse.ArgumentParser(description="Setup CCDW")
parser.add_argument('--path', dest='config_path', default=".",
                        help='Specify the path to the config.yml file')   
args = parser.parse_args()
config_path = Path(args.config_path.replace('"','').strip()) / "config.yml"

cfg = load_cfg(config_path)

if config_path.parent != current_directory:
    local_cfg_location = str(current_directory)
    local_cfg = f"""
config:
  location: {current_directory}
"""
    if (Path(current_directory) / "config.yml").is_file():
        print("ERROR: Cannot create local config.yml - File already exisits.")
    else:
        with open(Path(current_directory) / "config.yml", "w") as ymlfile:
            ymlfile.write(local_cfg) 
            
else:
    local_cfg_location = "self"

local_cfg_python_path = sys.executable

__local_cfg = { 'location'         : local_cfg_location,
                'script_path'      : str(current_directory),
                'python_path'      : local_cfg_python_path
              }

cfg.update( {'__local' : __local_cfg} )

# %% Define global variables

install_templates_root = Path(current_directory) / "install_templates"

print("Creating files from templates...")
for dirName, subdirs, files in os.walk(install_templates_root):

    ENV = Environment(loader=FileSystemLoader(Path(current_directory) / "install_templates" / dirName))

    relative_path = Path(dirName).relative_to(install_templates_root)
    print(f"\tProcessing directory: {relative_path}")

    for file in files:
        template_fn = relative_path / file
        dest_fn = Path( str(current_directory / template_fn).replace("_Template.txt","") )
        print(f"\t\tProcessing template file {template_fn}")

        template = ENV.get_template(f"{file}")
        rendered = template.render(config=cfg)

        if dest_fn.is_file():
            print(f"ERROR: Cannot create {dest_fn}  - File already exisits.")
        else:
            print(rendered)
            with open(dest_fn, "w") as destfile:
                destfile.write(rendered) 

print("Done")