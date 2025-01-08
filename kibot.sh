#!/bin/env bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
    -v $(pwd):/home/$USER/workdir \
    --user $USER_ID:$GROUP_ID \
    --env NO_AT_BRIDGE=1 \
    --workdir="/home/$USER/workdir" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/home/$USER/.config/kicad:/home/$USER/.config/kicad:rw" \
    --volume="/home/$USER/.cache/kicad:/home/$USER/.cache/kicad:rw" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    ghcr.io/inti-cmnb/kicad8_auto:1.8.1 /bin/bash -c \
    "kibot -c kibot-quick.yaml -b kicad/mk2/srvant-mk2/srvant-mk2.kicad_pcb -v"
