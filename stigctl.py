#!/usr/bin/env python3
# ScoutStig control CLI (minimal version)

import argparse, subprocess, json, xml.etree.ElementTree as ET, os, re

def run_sql(db, sql):
    subprocess.run(["mariadb", db], input=sql.encode(), check=True)

def main():
    print("ScoutStig control tool placeholder. Full logic can be extended.")

if __name__ == "__main__":
    main()
