#!/bin/bash

repos_dir=$HOME/data/repos
cd $repos_dir

for repo in `ls -d */`; do
    cd $repos_dir/$repo
    # find . -type f -exec rg --color=always '# TODO:' {} ';' 2>/dev/null
    rg --color=always '# TODO:' 2>/dev/null
done
