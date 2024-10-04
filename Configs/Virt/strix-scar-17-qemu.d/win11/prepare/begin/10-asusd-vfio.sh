#!/usr/bin/env bash

## Load VM variables
source "../../vm-vars.conf"

## Use supergfxctl to set graphics mode to vfio
echo "Setting graphics mode to VFIO..."
supergfxctl -m Vfio

echo "Graphics mode set!"
sleep 1
