import argparse
import os
from pathlib import Path
import subprocess
import time

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
		start = time.time()
		rc = subprocess.call([str(yosys), "-p", "read_firrtl {}".format(src)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
		stop = time.time()
		ms = (stop - start) * 1000
		print(src.relative_to(test_dir), "{:.03f}ms".format(ms), "OK" if rc == 0 else "FAIL")
