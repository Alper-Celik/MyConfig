#!/usr/bin/env bash

## Load VM variables
source "../../vm-vars.conf"

## Use supergfxctl to set graphics mode to vfio
echo "Resetting graphics mode back to integrated..."
supergfxctl -m Integrated

echo "Graphics mode reset!"
sleep 1

