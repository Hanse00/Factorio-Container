#!/usr/bin/env python3

import argparse
import shutil
import subprocess


SERVER_ARGS = [
    "--mod-directory", "/opt/factorio/mods",
    "--map-gen-settings", "/opt/factorio/config/map-gen-settings.json",
    "--map-settings", "/opt/factorio/config/map-settings.json",
    "--server-settings", "/opt/factorio/config/server-settings.json",
    "--server-banlist", "/opt/factorio/config/server-banlist.json",
    "--server-adminlist", "/opt/factorio/config/server-adminlist.json",
]


CONFIG_FILES = [
    {
        "path": "/opt/factorio/config/map-gen-settings.json",
        "template": "/opt/factorio/data/map-gen-settings.example.json"
    },
    {
        "path": "/opt/factorio/config/map-settings.json",
        "template": "/opt/factorio/data/map-settings.example.json"
    },
    {
        "path": "/opt/factorio/config/server-settings.json",
        "template": "/opt/factorio/data/server-settings.example.json"
    },
    {
        "path": "/opt/factorio/config/server-whitelist.json",
        "template": "/opt/factorio/data/server-whitelist.example.json"
    },
]


def main():
    args = parse_args()
    populate_config_files()
    run_args = ["/opt/factorio/bin/x64/factorio", "--start-server"]

    save_path = f"/opt/factorio/saves/{args.save}"
    run_args.append(save_path)

    if args.whitelist:
        print("Starting server with whitelist...")
        run_args.extend(["--use-server-whitelist", "true", "--server-whitelist", "/opt/factorio/config/server-whitelist.json"])
    else:
        print("Starting server without whitelist...")
    
    run_args.extend(SERVER_ARGS)
    subprocess.call(run_args)


def populate_config_files():
    for config in CONFIG_FILES:
        if file_is_accessible(config["path"]):
            continue
        else:
            shutil.copy(config["template"], config["path"])


def parse_args():
    parser = argparse.ArgumentParser(description="A Factorio Server. The script is a lightweight utilitiy for handling the configuration and starting of the real Factorio server.")
    whitelist = parser.add_mutually_exclusive_group(required=True)
    whitelist.add_argument("--whitelist", dest="whitelist", action="store_true", help="Enable the server whitelist. (Note: Either this or --no-whitelist must be present)")
    whitelist.add_argument("--no-whitelist", dest="whitelist", action="store_false", help="Disable the server whitelist. (Note: Either this or --whitelist must be present)")
    parser.add_argument("-s", "--save-file", dest="save", required=True, help="The name of the save file to load out of the saves directory (Eg. default.zip).")
    args = parser.parse_args()
    return args


def file_is_accessible(path):
    try:
        f = open(path)
        f.close()
    except IOError:
        return False
    return True


if __name__ == "__main__":
    main()
