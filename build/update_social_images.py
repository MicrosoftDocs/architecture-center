#!/usr/bin/env python3
"""Loops through a given directory and recursively adds
social_image_url to the metadata using the first image
found within the article inside a "media" folder.

Modify the www_path to match the path to the directory in
your browser when published.
"""

from pathlib import Path
from os.path import dirname
import re

# Set this as the base URL from docs
www_path = "/azure/architecture/example-scenario/"

# Directory you want to search for files in
path = "./"

# Loop recurisively through all subdirectories looking for files that end in .md
pathlist = Path(path).glob('**/*.md')
for path in pathlist:
    # because path is object not string
    path_in_str = str(path)

    # If it's not an index file, look for an image
    if "index.md" not in path_in_str:
        f = open(path_in_str, "r")
        contents = f.readlines()
        f.close()

        line_num = 0
        section_end = ""
        image_path = ""

        # Find the end of the
        for line in contents:
            if line_num != 0 and section_end == "" and "---" in line:
                section_end = line_num

            # Look for any line that contains the word "media" and common image formats
            r = re.compile('.*(media.*(?:png|jpg|svg)).*')
            image_match = re.search(r, line)
            if image_match and image_path == "":
                # Set the first found image as the image to use for social media
                image_path=image_match.group(1)

            line_num = line_num + 1
        
        # If the article doesn't already have a social media_url, add one
        if image_path != "" and "social_image_url" not in contents:
            print("Adding social URL to "+ str(path))
            contents.insert(section_end, "social_image_url: " + www_path + dirname(path) + "/" + image_path + "\n")

            f = open(path, "w")
            contents = "".join(contents)
            f.write(contents)
            f.close()
