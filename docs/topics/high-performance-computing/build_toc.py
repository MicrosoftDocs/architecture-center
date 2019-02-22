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
breadcrumb_toc = ""
toc_list = []
url = ""

# Iterate through every line of the index file to generate a list used for the TOC
for line in input_file:
    # Look for an inline link
    inline_match = re.compile('.*\[(.*)\]\((.*)\).*')
    inline_link = inline_match.match(line)

    # Look for an html link
    href_match = re.compile('.*href=\"(.*)\".*')
    href_link = href_match.match(line)

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

        if re.match('^(.(?<!docs.microsoft.com))*?$', inline_link.group(2)):
            if not re.match('^\/.*', inline_link.group(2)):
                continue

        toc_list.append({'level': level + 1, 'name': inline_link.group(1), 'href': inline_link.group(2)})
        
    # Find links with <a href.., but the link title is probably in an <p>, see below
    elif href_link:
        url = href_link.group(1)
        continue
    # Grab titles from h3, we're assuming we already have the URL at this point
    elif url:

        # Look for an h3 title
        h3_match = re.compile('.*<h3.*>\n*(.*)\n*</h3>.*', re.DOTALL)
        h3_title = h3_match.match(line)

        if ".com" in url:
            if re.match('^(.(?<!docs.microsoft.com))*?$', url):
                continue

        #print(title)
        if h3_title:
            if h3_title.group(1):
                toc_list.append({'level': level + 1, 'name': h3_title.group(1), 'href': url})
                url = ""
    # Anything else is not a line we know how to deal with, skip
    else:
        continue

# Build the TOC
for i in range(0,len(toc_list)):
    item_level = toc_list[i].get('level')
    item_name = toc_list[i]['name']

    # Automatically indent based on the heading level
    if item_level <= 1:
        indent = ""
        bc_indent = ""
    else:
        indent = "  " * (item_level - 2)
        bc_indent = "  " * (item_level - 2) + "  "

    # If there are multiple items below a heading, provide an overview link
    if i+1 != len(toc_list):
        if toc_list[i+1].get('level') > item_level:
            toc += indent + "- name: " + item_name + '\n'
            breadcrumb_toc += bc_indent + "- name: " + item_name + '\n'
            # Don't create an overview link for the top level item
            if item_level == 1:
                toc += indent + "  href: index.md\n"
                breadcrumb_toc += bc_indent + "  topicHref: /azure/architecture/topics/high-performance-computing#" + overviewlink(item_name) + "\n"
                breadcrumb_toc += bc_indent + "  items:" + "\n"
            else:
                breadcrumb_toc += bc_indent + "  topicHref: /azure/architecture/topics/high-performance-computing#" + overviewlink(item_name) + "\n"
                breadcrumb_toc += bc_indent + "  items:" + "\n"
                toc += indent + "  items:" + "\n"
        # Add an arror indicating external links
        elif toc_list[i].get('href'):
            toc += indent + "- name: " + item_name.strip() + '\n'
            toc += indent + "  href: " + toc_list[i].get('href') + "\n"
            breadcrumb_toc += bc_indent + "- name: " + item_name.strip() + '\n'
            breadcrumb_toc += bc_indent + "  topicHref: /azure/architecture/topics/high-performance-computing/\n"
            breadcrumb_toc += bc_indent + "  tocHref: " + re.match('^([\/\w\-]*)\?*',toc_list[i].get('href')).group(1) + "\n"

# Write the TOC file
output_file_path = join(current_dir, 'TOC.yml')
output_file = codecs.open(output_file_path, 'w', "utf-8")
output_file.write(toc)
output_file.close()

bc_output_file_path = join(current_dir,"breadcrumb", 'TOC.yml')
bc_output_file = codecs.open(bc_output_file_path, 'w', "utf-8")
bc_output_file.write(breadcrumb_toc)
bc_output_file.close()