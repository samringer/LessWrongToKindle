#!/bin/bash -eu
source ./config.sh

if [[ $# -ne 3 ]]; then
    echo $#
    echo "Usage <url> <title> <author>"
    exit 1
fi

url=$1
title=$2
author=$3

# Prepare the yml definition
cat template.yml | sed "s|URL|${url}|g" | sed "s|TITLE|${title}|g" | sed "s|AUTHOR|${author}|g" > ${webpages_to_epub_dir}/output.yml

pushd ${webpages_to_epub_dir}


node index.js output.yml # html -> epub
${epub_to_mobi_converter_dir}/ebook-convert output/epub/"${title}.epub" "${title}.mobi" # epub -> mobi

popd
mv ${webpages_to_epub_dir}/"${title}.mobi" ./done_kindle_files/"${title}.mobi"

# Cleanup
rm ${webpages_to_epub_dir}/output/epub/"${title}.epub"
rm ${webpages_to_epub_dir}/output.yml
