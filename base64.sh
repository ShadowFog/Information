#! /bin/sh

base64 ss-manager.json.raw | tr -d  '\n' > ss-manager.json
