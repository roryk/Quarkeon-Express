#!/usr/bin/env python

import json
import sys

def usage ():
    print >>sys.stderr, "usage: %s <sought_key>" % (sys.argv[0])
    print >>sys.stderr, "  (json structure expected on stdin)"

if __name__ == '__main__':

    if len(sys.argv) < 2:
        usage()
        exit(1)
                                              
    sought_key = sys.argv[1]

    json_string = sys.stdin.read()
    json_data = json.loads(json_string)
    if json_data.has_key(sought_key):
        print json.dumps(json_data[sought_key])
        exit(0)
    else:
        exit(1)
