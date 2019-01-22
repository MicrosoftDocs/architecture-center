#!/usr/bin/env python3
from pathlib import Path
from os.path import dirname
import re

www_path = "/azure/architecture/example-scenario/"
path = "./"

pathlist = Path(path).glob('**/*.md')
for path in pathlist:
    # because path is object not string
    path_in_str = str(path)

    if "index.md" not in path_in_str:
        f = open(path_in_str, "r")
        contents = f.readlines()
        f.close()

        line_num = 0
        section_end = ""
        image_path = ""
        for line in contents:
            if line_num != 0 and section_end == "" and "---" in line:
                section_end = line_num

            r = re.compile('.*(media.*(?:png|jpg|svg)).*')
            image_match = re.search(r, line)
            if image_match and image_path == "":
                image_path=image_match.group(1)

            line_num = line_num + 1
        
        if image_path != "" and "social_image_url" not in contents:
            print("Adding social URL to "+ str(path))
            contents.insert(section_end, "social_image_url: " + www_path + dirname(path) + "/" + image_path + "\n")

            f = open(path, "w")
            contents = "".join(contents)
            f.write(contents)
            f.close()