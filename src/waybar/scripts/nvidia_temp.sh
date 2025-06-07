#!/bin/bash
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
echo "{\"text\": \"$temp°C GPU\", \"tooltip\": \"NVIDIA GPU Temp\"}"

