#!/usr/bin/env python3

import argparse
import re
import subprocess
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--label')
    parser.add_argument('--minimum-rate', type=float)
    parser.add_argument('--maximum-rate', type=float)
    parser.add_argument('command', nargs='+')
    args = parser.parse_args()
    result = subprocess.run(
        args.command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    m = re.search(rb'D1  miss rate:\s+(?P<miss>[\d.]+)%', result.stderr)
    assert m is not None
    miss_rate = float(m.group('miss'))
    is_okay = True
    if args.minimum_rate and miss_rate < args.minimum_rate:
        is_okay = False
    if args.maximum_rate and miss_rate > args.maximum_rate:
        is_okay = False
    print("{}: miss rate {:.1f}% -- {}".format(
        args.label,
        miss_rate,
        'ok' if is_okay else 'FAIL',
    ))
    return is_okay

if __name__ == '__main__':
    if main():
        sys.exit(0)
    else:
        sys.exit(1)
