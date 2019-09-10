import yaml

import functools
print = functools.partial(print, flush=True)

def load_cfg():
    global cfg
    with open("//helix/divisions/IERG/Data/config.yml","r") as ymlfile:
        cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)