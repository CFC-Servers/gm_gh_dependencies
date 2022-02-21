#!/bin/bash
while IFS=$'\t' read -r url branch _; do
  echo "Cloning $url@$branch"
  git clone --no-tags "$url" --single-branch --branch "$branch" working

  echo "Removing git dirs"
  rm -rfv ./working/.git*

  echo "Removing top-level files"
  find ./working -maxdepth 1 -type f -exec rm -rfv {} \;

  echo "Moving contents into root"
  cp -r ./working/* ./

  echo "Removing working dir"
  rm -rfv ./working
done < <(yq e '.dependencies[] | [.url, .branch] | @tsv' config.yaml)
