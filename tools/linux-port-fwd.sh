#!/bin/bash

sudo ssh -p 2222 -gNfL 80:localhost:80 vagrant@localhost -i ~/.vagrant.d/insecure_private_key
sudo ssh -p 2222 -gNfL 8080:localhost:2222 vagrant@localhost -i ~/.vagrant.d/insecure_private_key

