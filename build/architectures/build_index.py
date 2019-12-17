#!/usr/bin/env python3

from collections import defaultdict
from pathlib import Path, PurePath
import re
import pprint
import json
import yaml
from dateutil import parser
import yaml
import readtime
from jinja2 import Environment, FileSystemLoader
import os.path as path
import logging

def find_all(iterable, searchtext, returned="key"):
    
    """Returns an iterator that returns all keys or values
       of a (nested) iterable.
       
       Arguments:
           - iterable: <list> or <dictionary>
           - returned: <string> "key", "value" or "item"
           
       Returns:
           - <iterator>
    """
  
    if isinstance(iterable, dict):
        for key, value in iterable.items():
            if key == searchtext or value == searchtext:
                if returned == "key":
                    yield key
                elif returned == "value":
                    yield value
                elif returned == "item":
                    yield iterable
                else:
                    raise ValueError("'returned' keyword only accepts 'key', 'value', or item.")
            for ret in find_all(value, searchtext, returned=returned):
                yield ret
    elif isinstance(iterable, list):
        for el in iterable:
            for ret in find_all(el, searchtext, returned=returned):
                yield ret

def get_topic_name(article, tag_metadata):
    for cat in tag_metadata['categories']:
        if cat['stub'] == 'technologies':
            for item in cat['items']:
                if any(list(set(item['tags']) & set(article['tags']))):
                    return item['name']

    return "Other Technologies"

def type_to_title(article_type):
    types = {
        'solution-idea': "Solution Ideas",
        'guide': "Guides",
        'example-scenario': "Example workloads",
        'reference-architecture': "Reference architectures",
    }
    return types.get(article_type, "Invalid Type")

def update_toc(article, toc):
    topic_name = get_topic_name(article, tag_metadata)
    toc_item = { 'href': article['file_url'], 'name': article['title']}
    topic_type = type_to_title(article['type'])
    updated = False
    if topic_name:
        for i in toc['items']:
            if i['name'] == 'Technologies':
                for t in i['items']:
                    if t['name'] == topic_name:
                        for s in t['items']:
                            if s['name'] == topic_type:
                                s['items'].append(toc_item)
                                updated=True

    if not updated:
        for i in toc['items']:
            if i['name'] == 'Technologies':
                i['items'].append({ 'name': topic_name, 'items':[{ 'name': topic_type, 'items':[toc_item]}]})
                updated=True
    
    return toc

def to_anchor(item):
    return item.strip()\
        .replace(" ", "-")\
        .replace("/", "-")\
        .replace("\\", "-")\
        .lower()

def unique(my_list, cleanup=True):
    filtered_list = []

    # Strip and unify the strings
    if cleanup:
        for item in my_list:
            filtered_list.append(to_anchor(item))
    else:
        filtered_list = my_list

    # insert the list to the set 
    unique_list = list(set(filtered_list))

    return unique_list

def is_excluded(file_path):
    skipped_paths = ["*example-scenario/index.md", "*/reference-architectures/index.md"]

    for sp in skipped_paths:
        if file_path.match(sp):
            return True

    return False

logging.basicConfig(level=logging.INFO)

root = path.dirname(path.abspath(__file__))
doc_directory = path.normpath(path.join(root, "..", ".." , "docs"))

pages=1
count=0
articles_per_page=9

ew_dir=path.join(doc_directory, "example-scenario")
ra_dir=path.join(doc_directory, "reference-architectures")
acom_dir=path.join(doc_directory, "solution-ideas", "articles")
index_dir=path.join(doc_directory, "solution-ideas")

templates_dir = path.join(root, 'templates')
env = Environment ( 
    loader = FileSystemLoader(templates_dir),
    trim_blocks = True,
    lstrip_blocks = True,
    keep_trailing_newline = True
    )

tag_file = open(path.join(index_dir, "metadata", "display-tags.json.txt"), "r")
tag_metadata=json.load(tag_file)

acom_diagrams = Path(acom_dir).glob('**/*.md')
example_workloads = Path(ew_dir).glob('**/*.md')
reference_architectures = Path(ra_dir).glob('**/*.md')

all_architectures_list = []

ra_list=[]
for ra in reference_architectures:
    ra_list.append(str(ra))
    all_architectures_list.append(ra)

ew_list=[]
for ew in example_workloads:
    ew_list.append(str(ew))
    all_architectures_list.append(ew)

acom_list=[]
for ad in acom_diagrams:
    acom_list.append(str(ad))
    all_architectures_list.append(ad)

all_architectures_list = sorted(all_architectures_list, key=lambda x: x.name)

parsed_articles = []

all_architectures_list = unique(all_architectures_list, cleanup=False)

for file in all_architectures_list:
    article = {}
    pricing = False
    deploy = False
    sample_code = False

    file_path = Path(file)
    str_path = str(file_path)

    # Skip index pages
    # print(str_path)
    if is_excluded(file_path):
        continue
    
    logging.info("Parsing: " + str_path)

    logging.debug("Checking Article Type")
    if str_path in list(ra_list):
        article.setdefault('tags', []).append("reference-architecture")
        root_dir = ra_dir
        article['type'] = "reference-architecture"

    if str_path in list(ew_list):
        article.setdefault('tags', []).append("example-workload")
        root_dir = ew_dir
        article['type'] = "example-workload"

    if str_path in list(acom_list):
        article.setdefault('tags', []).append("solution-idea")
        root_dir = acom_dir
        article['type'] = "solution-idea"

    logging.debug("Getting article URL")
    http_url="/azure/architecture/" + str(file_path.relative_to(doc_directory).as_posix()).replace(file_path.suffix, "")
    article['file_url'] = str(file_path.relative_to(doc_directory).as_posix())
    article['http_url'] = http_url

    # Strip SVG and convert to html
    logging.debug("Stripping tags")
    contents = file_path.read_text(encoding="utf8")
    htmltags = re.compile('<.*>')
    cleantext = re.sub(htmltags, '', contents)
    words=cleantext.lower().split()

    logging.debug("Getting word count")
    article['word_count'] = len(words)

    logging.debug("Get reading time")
    article['read_time'] = str(readtime.of_markdown(cleantext))

    logging.debug("Parsing Metadata")
    headers = re.findall(r"---\n(.*)\n---", contents, re.MULTILINE | re.DOTALL)
    if headers:
        try:
            logging.debug("Loadding YAML")
            article_meta = yaml.load("\n".join(headers), Loader=yaml.SafeLoader)
        except:
            print("Broken headers for: " + str_path)
            print("\n".join(headers))

    if article_meta.get('redirect_url'):
        logging.info("Found redirect for: " + str_path)
        continue

    logging.debug("Getting title")
    if article_meta['title']:
        article['title'] = article_meta['title']
    else:
        print("No title found for", str_path)
        continue

    logging.debug("Getting description")
    if article_meta['description']:
        article['description'] = article_meta['description']

    logging.debug("Finding images")
    # Find the first image in the article
    i = re.findall(r"^.*[ \(\"]([\.\/]*(?:media|images|_images)\/(?!github).*\.(?:png|jpg|svg)).*$", contents, re.MULTILINE)
    main_dir = file_path.resolve().parent.parent
    if len(i) > 0:
        image = i[0]
    else:
        # No image in the article, look for one on the filesystem
        file_glob = "*/" + str(file_path.name)[:-4] + "*.svg"
        i = list(main_dir.glob(file_glob))
        if len(i) != 0:
            image = i[0]
        else:
            image = ""

    logging.debug("Setting the image path")
    # Set the path
    if image:
        image=path.normpath(path.join(path.dirname(file_path), image))
        article['image'] = str(PurePath("/azure/architecture/" + str(Path(image).resolve().relative_to(doc_directory))).as_posix())
    else:
        article['image'] = "/azure/architecture/_images/reference-architectures.svg"

    logging.debug("Parsing ms.custom")
    if article_meta.get('ms.custom'):
        if isinstance(article_meta['ms.custom'], list):
            tags = article_meta['ms.custom']
        else:
            tags = list(article_meta['ms.custom'].split(","))

        article.setdefault('tags', []).extend(tags)
        
    logging.debug("Parsing Date")
    if article_meta.get('ms.date'):
        article['publish_date'] = str(parser.parse(article_meta['ms.date']).strftime('%m/%d/%Y').lstrip("0"))

    logging.debug("Looking for portal links")
    dp = re.findall(r"http[s]*:\/\/portal.azure.com/#create[0-9a-zA-Z\-\/\#\?\.\%_]+", contents, re.MULTILINE)
    if dp:
        article.setdefault('tags', []).append("is-deployable")
        article['deployable'] = dp[0]

    logging.debug("Looking for pricing calculator")
    pr = re.findall(r"http[s]*:\/\/(?:www.)*azure.com/e/[0-9a-zA-Z\-\/\#\?\.\%_]+", contents, re.MULTILINE)
    if pr:
        article.setdefault('tags', []).append("pricing-calculator")
        article['pricing_calculator'] = pr[0]

    logging.debug("Looking for pricing guidance")
    pg = re.findall(r"^(?:#*\s*)(pricing.*)$", contents, re.MULTILINE  | re.IGNORECASE)
    if pg:
        article.setdefault('tags', []).append("pricing-guidance")
        article['pricing_guidance'] = to_anchor(pg[0])

    logging.debug("Looking for alternatives")
    ac = re.findall(r"^(?:#*\s*)(alternative.*)$", contents, re.MULTILINE  | re.IGNORECASE)
    if ac:
        article.setdefault('tags', []).append("alternative-choices")
        article['alternative_choices'] = to_anchor(ac[0])

    logging.debug("Looking for Component Information")
    component = re.findall(r"^(?:#*\s*)(component.*)$", contents, re.MULTILINE | re.IGNORECASE)
    if component:
        article.setdefault('tags', []).append("components")
        article['components'] = to_anchor(component[0])

    logging.debug("Looking for Data Flow")
    flow = re.findall(r"^(?:#*\s*)([a-z ]*flow*)$", contents, re.MULTILINE | re.IGNORECASE)
    if flow:
        article.setdefault('tags', []).append("data-flow")
        article['data_flow'] = to_anchor(flow[0])

    logging.debug("Looking for github")
    sc = re.findall(r"http[s]*:\/\/(?:www.)*github.com/(?!.*\/issues\/)(?!.*\/Azure\/)[0-9a-zA-Z\-\/\#\?\.\%_]+", contents, re.MULTILINE)
    if sc:
        sample_code = True
        article.setdefault('tags', []).extend(["example-code", "github"])
        article['sample_code'] = True
        article['github_url'] = sc[0]

    logging.debug("Looking for visio")
    visio = re.findall(r"http.*vsdx", contents, re.MULTILINE)
    if visio:
        article.setdefault('tags', []).append("visio-diagram")
        article['visio_diagram'] = visio[0]

    logging.debug("Looking for diagram tag")
    idiagram = re.findall(r"interactive-diagram", contents, re.MULTILINE)
    if idiagram:
        article.setdefault('tags', []).append("interactive-diagram")
        article['interactive_diagram'] = True

    logging.debug("Looking for code blocks")
    sc = re.findall(r"```(.*)", contents, re.MULTILINE)
    if sc:
        for match in sc:
            article.setdefault('tags', []).append(sc[0].strip())
            article.setdefault('code_languages', []).append(sc[0].strip())
        
        sample_code = True
        article.setdefault('tags', []).append("example-code")
        article['sample_code'] = True

    logging.debug("Done parsing")

    if article['title']:
        logging.debug("Finalize config")

        # Have an everything tag
        article.setdefault('tags', []).append("all-items")

        # Remove duplicates from tags
        article['tags'] = unique(article['tags'])

        # Remove duplicates from code languages
        if article.get('code_languages'):
            article['code_languages'] = unique(article['code_languages'])

        logging.debug("Add to list")
        parsed_articles.append(article)

# Sort by title
parsed_articles = sorted(parsed_articles, key=lambda x: x['title'])

all_tags = []
all_langs = []

with open( path.join(doc_directory, "toc.yml"), 'r') as stream:
    main_toc = yaml.safe_load(stream)

for article in parsed_articles:  
    toc_link=list(find_all(main_toc,article['file_url'],'item'))
    if len(toc_link) == 0:
        main_toc = update_toc(article, main_toc)

    # Sort the tags
    article['tags'] = sorted(article['tags'])

    # Build tag list
    all_tags.extend(article['tags'])

    # Build Code languages list
    if article.get('code_languages'):
        article['code_languages'] = sorted(article['code_languages'])
        all_langs.extend(article['code_languages'])  

    article['filter_text'] = article['title'].lower() + " " + article['description'].lower()

all_langs = unique(all_langs)
all_tags = unique(all_tags)
#TODO Alert if a new tag was found

articles={"articles": parsed_articles}

output_file = open(path.join(doc_directory, "toc.yml"), "w")
output_file.write(yaml.dump(main_toc, default_flow_style=False, sort_keys=False))
output_file.close()

output_file = open(path.join(index_dir, "data", "output.json.txt"), "w")
output_file.write(json.dumps(articles, indent=4))
output_file.close()

output_file = open(path.join(index_dir, "data", "tags.json.txt"), "w")
output_file.write(json.dumps(sorted(all_tags), indent=4))
output_file.close()

output_file = open(path.join(index_dir, "data", "dev-langs.json.txt"), "w")
output_file.write(json.dumps(sorted(all_langs), indent=4))
output_file.close()