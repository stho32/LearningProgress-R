#!/bin/bash

#
# Get the latest changes to this repository
#
cd /home/shoff/Projekte/LearningProgress-R
git pull

#
# Generate a new report
#
cd Source
Rscript -e "rmarkdown::render('./Dashboard.Rmd', output_file='/home/shoff/Projekte/LearningProgress-R/Source/Dashboard.html')"
cd ..

#
# Publish Learning Progress to Reporting Repository
#
cp -f Source/Dashboard.html ../Overview/docs/Learning-Dashboard.html
now=$(date +"%Y-%m-%d")
cp -f Source/Dashboard.html ../Overview/docs/Learning-Dashboard-$now.html
cd ../Overview
git pull
git add .
git commit -m "Update for Learning Dashboard"
git push
cd ../LearningProgress-R
