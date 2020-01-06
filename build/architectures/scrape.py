#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import re
import datetime
import sys
import html2text
import pprint
from pathlib import Path, PurePath
from os import path
import os
import tempfile
import json


use_cache=False
single_url=False

#url="https://azure.microsoft.com/en-us/solutions/architecture/dev-test-microservice/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/modern-data-warehouse/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/advanced-analytics-on-big-data/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/cicd-for-containers/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters/"
#url="https://azure.microsoft.com/solutions/architecture/ai-at-the-edge/"
#url="https://azure.microsoft.com/solutions/architecture/population-health-management-for-healthcare/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/disaster-recovery-smb-azure-site-recovery/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/telemetry-analytics/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/azure-iot-subsystems/"
url="https://azure.microsoft.com/en-us/solutions/architecture/modern-customer-support-portal-powered-by-an-agile-business-process"

root = path.dirname(path.abspath(__file__))

mod_file = open(path.join(root, "mods.json.txt"), "r")
file_mods=json.load(mod_file)['mods']

def get_mods(filename): 
    for mod in file_mods: 
         if mod['file'] == str(filename.as_posix()): 
             return mod
  
def scrape_page(url):
    doc_directory = path.normpath(path.join(root, "..", ".." , "docs"))
    acom_dir=path.join(doc_directory, "solution-ideas")
    html_dir=path.join(root, "acom_html")

    # Generate file names
    basename=re.sub('/$', '', url).split('/')[-1]
    filename="/" + basename +".md"
    svgname="/media/" + basename + ".svg"
    local_file = path.join(html_dir, basename + ".html")

    if path.exists(local_file) and use_cache:
        html_file=open(local_file, "r", encoding="utf8")
        data=html_file.read()
    else:
        r=requests.get(url, headers = {"Connection":"keep-alive", "User-Agent":"Mozilla/5.0"})
        data=r.text
        html_file=open(local_file, "w", encoding="utf8")
        html_file.write(str(data))

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
    articletext = articletext + "\ntitleSuffix: Azure Solution Ideas"
    articletext = articletext + "\nauthor: adamboeglin"
    articletext = articletext + "\nms.date: " + datetime.datetime.today().strftime('%m/%d/%Y')
    if description:
        articletext = articletext + "\ndescription: " + str(description.get('content'))
    articletext = articletext + "\nms.custom: " + keywords + ", '" + url + "'"

    articletext = articletext + "\n---"

    # articletext += the title
    articletext = articletext + "\n# " + title + "\n\n"

    articletext += '[!INCLUDE [header_file](../header.md)]\n\n'

    # Pull all the text
    content=soup.find("div",{"class": "row-size2"}).find_all('p')

    h = html2text.HTML2Text()
    h.body_width=0

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

            if item.get('href'):
                item['href'] = item['href'].strip()
            
            articletext += h.handle(str(item))

    # Pull the SVG Image
    image=soup.find_all("div", {"class": "row"})
    import subprocess
    for i in image:
        if i.svg:
            temp=open('tmpsvg.svg', "w", encoding="utf8")
            try:
                temp.write(re.sub('<svg ', '<svg class="architecture-diagram" ', str(i.svg)))
                temp.close()
                stream = subprocess.run(['svgo', '--pretty', '--disable=removeViewBox,removeUnknownsAndDefaults', '-i', temp.name], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, shell=True)
                temp=open(temp.name, "r", encoding="utf8")
                svgtext=temp.read()
            finally:
                temp.close()
                os.unlink(temp.name)

            arch_info = "\n## Architecture"
            arch_info += "\n\n" + svgtext

            if re.findall('^(##.*)', articletext, flags=re.MULTILINE):
                articletext = re.sub('^##', arch_info + '\n\n##', articletext, count=1, flags=re.MULTILINE)
            else:
                articletext += arch_info

            # Strip links for creating the image
            svgtext = re.sub('<[/]?a.*?>', '', svgtext)
            break

    for div in interactive:
        articletext += "\n" + str(div)

    #List the data flow
    flow=soup.find("div", {"id": "flowSteps"})
    if flow:
        articletext += "\n\n## Data Flow\n\n"
        steps=flow.find_all('li')

        steps_regex=re.compile('.*</span>\s*(.*).*\n', re.DOTALL)
        for step in steps:
            #articletext += step.contents
            #articletext += str(step)
            match = steps_regex.match(str(step))
            if match:
                articletext += "1. " + match.group(1)
            


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
                        description = "["+name+"]"+'('+link['href']+')' + ": " + description
                    else:
                        description=description.replace(name,"["+name+"]"+'('+link['href']+')')
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
                articletext += "\n* "+ "["+link_text+"]"+'('+action['href']+')'

    if pricing_link:
        articletext += "\n\n## Pricing Calculator"
        articletext += "\n* ["+pricing_link.text.strip()+"]("+pricing_link['href']+")"

    if deploy_link:
        articletext += "\n\n## Deploy to Azure"
        articletext += "\n* ["+deploy_link.text.strip()+"]("+deploy_link['href']+")"


    # Link to JS file for dynamic content
    articletext += "\n\n[!INCLUDE [js_include_file](../../_js/index.md)]\n"

    # URL Cleanup
    articletext = re.sub('\(/en-us', '(https://azure.microsoft.com', articletext, flags=re.MULTILINE)
    articletext = re.sub('http(:?s)://docs.microsoft.com', '', articletext, flags=re.MULTILINE)
    articletext = re.sub('en-us\/', '', articletext, flags=re.MULTILINE)

    # Modify the articles as needed to meet docs standards
    mods = get_mods(Path(str(acom_dir) + "/articles/" + filename).relative_to(doc_directory))
    if mods:
        if mods.get("tags"):
            articletext = re.sub('ms.custom: ', 'ms.custom: ' + ','.join(mods['tags']) + ", ", articletext, flags=re.MULTILINE)

        if mods.get("updates"):
            for update in mods['updates']:
                articletext = re.sub(update['old'], str(update['new']), articletext, flags=re.MULTILINE)

    # Remove any extra blank lines
    articletext = re.sub('\n\n\n*', '\n\n', articletext, flags=re.MULTILINE)

    file=open(path.abspath(str(acom_dir) + "/articles/" + filename),"w", encoding='utf8')
    file.write(articletext)
    file.close
    print("Wrote", path.abspath(str(acom_dir) + "/articles/" + filename))

    if svgtext:
        image=open(path.abspath(str(acom_dir) + svgname), "w", encoding='utf8')
        image.write(svgtext)
        image.close

    return path.abspath(str(acom_dir) + "/articles/" + filename)

def get_docs_url(file_path):
    file_path = Path(file_path)
    root = path.dirname(path.abspath(__file__))
    doc_directory = path.normpath(path.join(root, "..", ".." , "docs"))
    http_url="https://docs.microsoft.com/en-us/azure/architecture/" + str(file_path.relative_to(doc_directory).as_posix()).replace(file_path.suffix, "")
    return http_url

if __name__ == '__main__':
    redirects = ""

    if single_url:
        file_path = scrape_page(url)
        redirects += '<add key="%s" value="%s" />\n' % (url.rstrip('\n'), get_docs_url(file_path))
    else:
        filepath = path.join(path.dirname(path.abspath(__file__)) + '/url_list.txt')
        with open(filepath) as fp:
            urls = fp.readlines()
        
        for url in urls:
            file_path = scrape_page(url.rstrip('\n'))
            redirects += '<add key="%s" value="%s" />\n' % (url.rstrip('\n'), get_docs_url(file_path))

    redirects = re.sub('http(:?s)://azure.microsoft.com', '', redirects, flags=re.MULTILINE)
    redirects += '<add key="%s" value="%s" />\n' % ("/en-us/solutions/architecture/", "https://docs.microsoft.com/en-us/azure/architecture/architectures/")
    redirects += '<add key="%s" value="%s" />\n' % ("/architecture/", "https://docs.microsoft.com/azure/architecture/")
    redirect_list=open(path.join(path.dirname(path.abspath(__file__)) + '/redirect_list.txt'), "w", encoding='utf8')
    redirect_list.write(redirects)
    redirect_list.close