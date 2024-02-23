#!/bin/bash

TOOLBX="orora-cli"
if "${TOOLBX}" ~= "wolfi"; then
  TOOLBX="wolfi-toolbox"
fi

echo "./toolboxes/${TOOLBX}/Containerfile"
