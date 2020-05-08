#!/usr/bin/env python3

import argparse
import subprocess


SERVER_ARGS = [
    "--mod-directory", "/opt/factorio/mods",
]


def parse_args():
    parser = argparse.ArgumentParser(description="A Factorio Server")
    whitelist = parser.add_mutually_exclusive_group(required=True)
    whitelist.add_argument("-w", "--whitelist", dest="whitelist", action="store_true", help="Enable the server whitelist.")
    whitelist.add_argument("-nw", "--no-whitelist", dest="whitelist", action="store_false", help="Disable the server whitelist.")
    parser.add_argument("-s", "--save-name", required=True, help="The name of the savefile to load (Eg. default.zip).")
    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    run_args = ["/opt/factorio/bin/x64/factorio", "--start-server"]

    save_path = f"/opt/factorio/saves/{args.save_name}"
    run_args.append(save_path)

    if args.whitelist:
        print("Starting server with whitelist...")
        run_args.extend(["--use-server-whitelist", "true", "--server-whitelist", "/opt/factorio/config/server-whitelist.json"])
    else:
        print("Starting server without whitelist...")
    
    run_args.extend(SERVER_ARGS)
    subprocess.call(run_args)


if __name__ == "__main__":
    main()
