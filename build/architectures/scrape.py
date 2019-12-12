#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import re
import datetime
import sys
import html2text
import pprint
from os import path
import os
import tempfile

h = html2text.HTML2Text()
h.body_width=0

root = path.dirname(path.abspath(__file__))
doc_directory = path.normpath(path.join(root, "..", ".." , "docs"))
acom_dir=path.join(doc_directory, "solution-ideas")
html_dir=path.join(root, "acom_html")

#TODO, CLI option to use cache or not
use_cache=True

if len(sys.argv) == 2:
    url = sys.argv[1]
else:
    #url="https://azure.microsoft.com/en-us/solutions/architecture/dev-test-microservice/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/modern-data-warehouse/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/advanced-analytics-on-big-data/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/cicd-for-containers/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters/"
    #url="https://azure.microsoft.com/solutions/architecture/ai-at-the-edge-disconnected/"
    #url="https://azure.microsoft.com/solutions/architecture/population-health-management-for-healthcare/"
    url="https://azure.microsoft.com/en-us/solutions/architecture/disaster-recovery-smb-azure-site-recovery/"

# Generate file names
basename=re.sub('/$', '', url).split('/')[-1]
filename="/" + basename +".md"
svgname="/media/" + basename + ".svg"
local_file = path.join(html_dir, basename + ".html")

if path.exists(local_file) and use_cache:
    html_file=open(local_file, "r", encoding="utf8")
    data=html_file.read()
else:
    r=requests.get(url)
    data=r.text.encode('ascii', 'ignore')
    html_file=open(local_file, "w")
    html_file.write(r.text)

html_file.close
soup=BeautifulSoup(data, "lxml")

title=re.sub(r" \| .*", "", soup.title.string, flags=re.S)
title=re.sub(r"\n.*", "", title, flags=re.S)
description=soup.find(attrs={"name": re.compile(r"description", re.I)})
keywords=soup.find(attrs={"name": re.compile(r"keywords", re.I)})

pricing_link=soup.find(attrs={"data-event": "area-solutions-architecture-clicked-pricingcalculator"}, href=True)
deploy_link=soup.find(attrs={"data-event": "area-solutions-architecture-clicked-deploy"}, href=True)
interactive=soup.find_all("div", {"class": "architecture-tooltip-content"})

if keywords:
    keywords = "acom-architecture, " + str(keywords.get('content'))
else:
    keywords = "acom-architecture"

if interactive:
    keywords = keywords + ", interactive-diagram"

if pricing_link:
    keywords = keywords + ", pricing-calculator"

if deploy_link:
    keywords = keywords + ", is-deployable"

articletext = "---"
articletext = articletext + "\ntitle: " + title
articletext = articletext + "\nauthor: adamboeglin"
articletext = articletext + "\nms.date: " + datetime.datetime.today().strftime('%m/%d/%Y')
if description:
    articletext = articletext + "\ndescription: " + str(description.get('content'))
articletext = articletext + "\nms.custom: " + keywords
articletext = articletext + "\n---"

# articletext += the title
articletext = articletext + "\n# " + title + "\n\n"

# Pull all the text
content=soup.find("div",{"class": "row-size2"}).find_all('p')

for item in soup.find_all("div",{"class": "row-size2"}):
    if item.find(['p','h2']):
        if str(item.text) == "Disclaimer":
            continue
        if "All rights reserved." in item.text:
            continue
        if item.get('class'):
            if "footer" in item['class']:
                continue
            if "text-heading6" in item['class']:
                continue

        if u'\xa9' in item.text:
            continue
        # TODO: Fix this bit
        if item.get('href'):
            print("Found en-us")
            item['href'] = item['href'].replace('href="/en-us', 'href="https://azure.microsoft.com')\
                            .replace('/en-us/', '/')\
                            .strip()
        
        articletext += h.handle(str(item))



# Pull the SVG Image
image=soup.find_all("div", {"class": "row"})
import subprocess
for i in image:
    if i.svg:
        temp=open('tmpsvg.svg', "w")

        try:
            temp.write(re.sub('<svg ', '<svg class="architecture-diagram" ', str(i.svg)))
            temp.close()
            stream = subprocess.run(['/usr/local/bin/svgo', '--pretty', '--disable=removeViewBox,removeUnknownsAndDefaults', '-i', temp.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            temp=open(temp.name, "r")
            svgtext=temp.read()
        finally:
            temp.close()
            os.unlink(temp.name)


        articletext += "\n\n## Architecture"
        articletext += "\n\n" + svgtext

        # Strip links for creating the image
        svgtext = re.sub('<[/]?a.*?>', '', svgtext)
        break

for div in interactive:
    articletext += "\n" + str(div)

#List the data flow
flow=soup.find("div", {"id": "flowSteps"})
if flow:
    articletext += "\n\n## Data Flow"
    steps=flow.find_all('li')

    steps_regex=re.compile('.*</span>\s*(.*).*\n', re.DOTALL)
    for step in steps:
        #articletext += step.contents
        #articletext += str(step)
        match = steps_regex.match(str(step))
        if match:
            articletext += "\n1. " + match.group(1)
        


actions=[]

table_body = soup.find('tbody')

if table_body:
    rows = table_body.find_all('tr')

    articletext += "\n\n## Components"
    #Parse the services table
    for row in rows:
            cols = row.find_all('td')
            link=cols[0].find('a', href=True)
            description=''

            # Skip lines without a name
            if cols[0].find('p').string:
                name=cols[0].find('p').string.strip()
            else:
                continue

            if cols[1].string:
                description=cols[1].string.strip()
            elif cols[1].find('span'):
                if cols[1].find('span').string:
                    description=cols[1].find('span').string.strip()

            if link:
                if name not in description:
                    description = "["+name+"]"+'('+link['href'].replace('/en-us', 'http://azure.microsoft.com')+')' + ": " + description
                else:
                    description=description.replace(name,"["+name+"]"+'('+link['href'].replace('/en-us', 'http://azure.microsoft.com')+')')
            elif description:
                description=name+": "+description
            else:
                description=name

            # If there's anything in the 3rd column, add it as an action
            if cols[2].find('a', href=True):
                actions.append([name,cols[2].find('a', href=True)])
            
            articletext += "\n* " + description
                
    if len(actions) >0:
        articletext += "\n\n## Next Steps"
        for item in actions:
            name=item[0]
            action=item[1]
            if action.string.strip().lower() == "learn more":
                link_text=name+ " documentation"
            else:
                link_text=action.string.strip()
            articletext += "\n* "+ "["+link_text+"]"+'('+re.sub('^/en-us', 'http://azure.microsoft.com', action['href']).replace("/en-us/","/")+')'

if pricing_link:
    articletext += "\n\n## Pricing Calculator"
    articletext += "\n* ["+pricing_link.text.strip()+"]("+pricing_link['href']+")"

if deploy_link:
    articletext += "\n\n## Deploy to Azure"
    articletext += "\n* ["+deploy_link.text.strip()+"]("+deploy_link['href']+")"


# Link to original article on ACOM
# articletext += "\n\n## Original Article"
# articletext += "\n* ["+title.strip()+"]("+url+")"

articletext += "\n\n[!INCLUDE [js_include_file](../../_js/index.md)]\n"

file=open(path.abspath(str(acom_dir) + "/articles/" + filename),"w")
file.write(articletext)
file.close
print("Wrote", path.abspath(str(acom_dir) + "/articles/" + filename))

if svgtext:
    image=open(path.abspath(str(acom_dir) + svgname), "w")
    image.write(svgtext)
    image.close