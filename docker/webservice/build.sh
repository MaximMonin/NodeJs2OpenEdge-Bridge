#!/bin/bash
tar -cvf wsa.tar wsa
tar -cvf dlc.tar dlc

sudo docker build --rm -t openedge_webservice:latest .
