#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import codecs
from os.path import dirname, join

current_dir = dirname(__file__)
file_path = join(current_dir, "./index.md")
input_file = open(file_path, 'r')

# Use regex to pull a title from a header
def getname(line):
    pattern = re.compile('.*# (.*)')
    name = pattern.match(line)
    return name.group(1)

# Generate the links used in anchors
def overviewlink(name):
    shortname = name.lower()
    return str(shortname).replace(" ", "-").replace("&", "")

toc = ""
toc_list = []

# Iterate through every line of the index file to generate a list used for the TOC
for line in input_file:
    # Look for an inline link
    inline_match = re.compile('.*\[(.*)\]\((.*)\).*')
    inline_link = inline_match.match(line)

    # Look for an html link
    href_match = re.compile('.*href=\"(.*)\" .*')
    href_link = href_match.match(line)

    # Look for an h3 title
    h3_match = re.compile('.*<h3>(.*)</h3>.*')
    h3_title = h3_match.match(line)

    # Find all the sections
    if line.startswith("#"):
        name = getname(line)
        level = line.count("#")
        toc_list.append({'level': level, 'name': name})
    # Look for markdown links
    elif inline_link:
        # Skip internal anchors
        if re.match('^#.*', inline_link.group(2)):
            continue
        toc_list.append({'level': level + 1, 'name': inline_link.group(1), 'href': inline_link.group(2)})
    # Find links with <a href.., but the link title is probably in an h3, see below
    elif href_link:
        url = href_link.group(1)
        continue
    # Grab titles from h3, we're assuming we already have the URL at this point
    elif h3_title:
        toc_list.append({'level': level + 1, 'name': h3_title.group(1), 'href': url})
    # Anything else is not a line we know how to deal with, skip
    else:
        continue

# Build the TOC
for i in range(0,len(toc_list)):
    item_level = toc_list[i].get('level')
    item_name = toc_list[i]['name']

    # Automatically indent based on the heading level
    if item_level <= 2:
        indent = ""
    else:
        indent = "  " * (item_level - 2)

    # If there are multiple items below a heading, provide an overview link
    if i+1 != len(toc_list):
        if toc_list[i+1].get('level') > item_level:
            toc += indent + "- name: " + item_name + '\n'
            # Don't create an overview link for the top level item
            if item_level == 1:
                toc += indent + "  href: index.md\n"
            else:
                toc += indent + "  items:" + "\n"
                toc += indent + "  - name: Overview\n"
                toc += indent + "    href: index.md#" + overviewlink(item_name) + "\n"
        # Add an arror indicating external links
        elif toc_list[i].get('href'):
            # TODO: Also add marker to links with domains ending in other than .com
            if ".com" in toc_list[i].get('href'):
                # Skip docs links
                if re.match('^(.(?<!docs.microsoft.com))*?$', toc_list[i].get('href')):
                    item_name = item_name + u" ↗"
            toc += indent + "- name: " + item_name + '\n'
            toc += indent + "  href: " + toc_list[i].get('href') + "\n"
        # Set anchors for sections within the article
        else:
            toc += indent + "- name: " + item_name + '\n'
            toc += indent + "  href: index.md#" + overviewlink(item_name) + "\n"

# Write the TOC file
output_file_path = join(current_dir, 'TOC.yml')
output_file = codecs.open(output_file_path, 'w', "utf-8")
output_file.write(toc)
output_file.close()