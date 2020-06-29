import yaml

def load_cfg(path):
    with open(f"{path}","r") as ymlfile:
        cfg_l = yaml.load(ymlfile, Loader=yaml.FullLoader)

        if cfg_l["config"]["location"] == "self":
            cfg = cfg_l.copy()
        else:
            with open(cfg_l["config"]["location"] + "config.yml","r") as ymlfile2:
                cfg = yaml.load(ymlfile2, Loader=yaml.FullLoader)

    return cfg