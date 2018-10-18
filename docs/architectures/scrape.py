#!/usr/bin/python2

from bs4 import BeautifulSoup
import requests
import re
import datetime
import sys

#url="https://azure.microsoft.com/en-us/solutions/architecture/dev-test-microservice/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview/"
url="https://azure.microsoft.com/en-us/solutions/architecture/modern-data-warehouse/"
#url="https://azure.microsoft.com/en-us/solutions/architecture/advanced-analytics-on-big-data/"

if len(sys.argv) == 2:
    url = sys.argv[1]
else:
    #url="https://azure.microsoft.com/en-us/solutions/architecture/dev-test-microservice/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/modern-data-warehouse/"
    #url="https://azure.microsoft.com/en-us/solutions/architecture/advanced-analytics-on-big-data/"
    url="https://azure.microsoft.com/en-us/solutions/architecture/cicd-for-containers/"

# Generate file names
basename=re.sub('/$', '', url).split('/')[-1]
filename=basename +".md"
svgname="media/" + basename + ".svg"

r=requests.get(url)
data=r.text.encode('ascii', 'ignore')
soup=BeautifulSoup(data, features="html5lib")


title=soup.title.string.replace("| Microsoft Azure", '')
description=soup.find_all(attrs={"name": re.compile(r"description", re.I)})[0]['content']

articletext = "---"
articletext += "\ntitle: " + title
articletext += "\ndescription: " + description
articletext += "\nauthor: adamboeglin"
articletext += "\nms.date: " + datetime.datetime.today().strftime('%m/%d/%Y')
articletext += "\n---"

# articletext += the title
articletext += "\n# " + title

# Pull all the text
content=soup.find("div",{"class": "row-size2"}).find_all('p')

for line in content:
    if u'\xa9' in line.text:
        continue

    if 'href="/en-us' in str(line.text):
        articletext += "\n" + str(line.text).replace('href="/en-us', 'href="http://azure.microsoft.com').strip()
    else:
        articletext += "\n" + str(line.text).strip()

#TODO: Parse relative links

# Pull the SVG Image
image=soup.find_all("div", {"class": "row"})
for i in image:
    if i.svg:
        articletext += "\n\n## Architecture"
        articletext += "\n<img src=\"" + svgname + "\" alt='architecture diagram' />"
        svgtext = re.sub('<[/]?a.*?>', '', str(i.svg))
        break

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
                    description = "["+name+"]"+'('+link['href'].replace('/en-us', 'href="http://azure.microsoft.com')+')' + ": " + description
                else:
                    description=description.replace(name,"["+name+"]"+'('+link['href'].replace('/en-us', 'http://azure.microsoft.com')+')')
            elif description:
                description=name+": "+description
            else:
                description=name

            # If there's anything in the 3rd column, add it as an action
            if cols[2].find('a', href=True):
                actions.append(cols[2].find('a', href=True))
            
            articletext += "\n* " + description

    if len(actions) >0:
        articletext += "\n\n## Next Steps"
        for action in actions:
            articletext += "\n* "+ "["+action.string.strip()+"]"+'('+re.sub('^/en-us', 'href="http://azure.microsoft.com', action['href']).replace("/en-us/","/")+')'


file=open("./articles/" + filename,"w+")
file.write(articletext)
file.close

if svgtext:
    image=open("./articles/" + svgname, "w+")
    image.write(svgtext)
    image.close