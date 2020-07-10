import argparse
import os
from pathlib import Path
import subprocess

test_dir = Path(__file__).resolve().parent

parser = argparse.ArgumentParser()
parser.add_argument("yosys", help="path to yosys")
ns = parser.parse_args()

yosys = ns.yosys

for root, _, files in os.walk(test_dir):
	for file in sorted(files):
		if not file.endswith(".fir"):
			continue
		src = test_dir / root / file
		rc = subprocess.call([str(yosys), "-p", "read_firrtl {}".format(src)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
		print(src, "OK" if rc == 0 else "FAIL")
