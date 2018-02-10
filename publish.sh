#!/bin/bash

#
# Generate a new report
#
cd Source
Rscript -e "rmarkdown::render('./Dashboard.Rmd')"
cd ..

#
# Publish Learning Progress to Reporting Repository
#
cp -f Source/Dashboard.html ../Overview/docs/Learning-Dashboard.html
now=$(date +"%Y-%m-%d")
cp -f Source/Dashboard.html ../Overview/docs/Learning-Dashboard-$now.html
cd ../Overview
git add .
git commit -m "Update for Learning Dashboard"
git push
cd ../LearningProgress-R