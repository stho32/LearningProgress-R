#!/bin/bash

#
# Publish Learning Progress to Reporting Repository
#
cp -f Source/Dashboard.html ../Overview/docs/Learning-Dashboard.html
cd ../Overview
git add docs/Learning-Dashboard.html
git commit -m "Update for Learning Dashboard"
git push
cd ../LearningProgress-R