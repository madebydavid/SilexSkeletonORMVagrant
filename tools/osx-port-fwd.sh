#!/bin/bash

echo 'rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080' | sudo pfctl -ef - > /dev/null 2>&1; echo '==> Fowarding Port 80 To 8080'
