#!/bin/bash

tee /etc/ld.so.conf.d/local.conf <<EOF
/usr/local/lib
/usr/local/lib64
EOF