#!/usr/bin/env python3

import argparse


def parse_args():
    parser = argparse.ArgumentParser(description="A Factorio Server")
    whitelist = parser.add_mutually_exclusive_group(required=True)
    whitelist.add_argument("-w", "--whitelist", dest="whitelist", action="store_true", help="Enable the server whitelist.")
    whitelist.add_argument("-nw", "--no-whitelist", dest="whitelist", action="store_false", help="Disable the server whitelist.")
    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    if args.whitelist:
        print("Starting server with whitelist...")
    else:
        print("Starting server without whitelist...")


if __name__ == "__main__":
    main()
