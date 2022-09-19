#!/usr/bin/env python3

from collections import defaultdict, OrderedDict
from pathlib import Path, PurePath
import os
import re
import pprint
import json
import yaml
from dateutil import parser
import yaml
import readtime
from jinja2 import Environment, FileSystemLoader, select_autoescape
import os.path as path
import logging
import csv
import markdown
import frontmatter
import shutil
from urllib.parse import urljoin
from PIL import Image
import tempfile

#hardcoded options 
include_hybrid_in_all_architectures= True

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
            if re.search(searchtext, str(key)) or re.search(searchtext, str(value)):
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

def update_paths(text, base_path):
    # Remove any markdown extensions
    text = re.sub(r'href=".*\w(\.md)\W', '', text)

    # Function to replace URLs with absolute docs paths
    def url_update(match):
        return match.group(1) + '="' + urljoin(urljoin("https://learn.microsoft.com", base_path), match.group(2)) + '"'

    return re.sub(r'(src|href)=\"([\.|\/][^\"]*)\"',url_update,text)


# def get_topic_name(article, tag_metadata):
#     for cat in tag_metadata['categories']:
#         if cat['stub'] == 'technologies':
#             for item in cat['items']:
#                 if any(list(set(item['tags']) & set(article['tags']))):
#                     return item['name']

#     return "Other Technologies"

def type_to_title(article_type):
    types = {
        'solution-idea': "Solution Ideas",
        'guide': "Guides",
        'example-scenario': "Example workloads",
        'reference-architecture': "Reference architectures",
    }
    return types.get(article_type, "Invalid Type")

# def update_toc(article, toc):
#     topic_name = get_topic_name(article, tag_metadata)
#     toc_item = { 'href': article['file_url'], 'name': article['title']}
#     topic_type = type_to_title(article['type'])
#     updated = False
#     if topic_name:
#         for i in toc['items']:
#             if i['name'] == 'Technologies':
#                 for t in i['items']:
#                     if t['name'] == topic_name:
#                         for s in t['items']:
#                             if s['name'] == topic_type:
#                                 s['items'].append(toc_item)
#                                 updated=True

    # if not updated:
    #     for i in toc['items']:
    #         if i['name'] == 'Technologies':
    #             i['items'].append({ 'name': topic_name, 'items':[{ 'name': topic_type, 'items':[toc_item]}]})
    #             updated=True
    # return toc, topic_name

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

def stepnum_letter(n):
    letter = ""
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        letter = chr(65 + remainder) + letter
    return letter.upper()

def acom_json(item):
    def_data = {}
    if item.get("Title"):
        def_data['titleLocKey'] = "Title"
    if item.get("MetaDescription"):
        def_data['MetaDescriptionLocKey'] = "MetaDescription"
    if item.get("Summary"):
        def_data['summaryLocKey'] = "Summary"
    if item.get("Flow"):
        def_data['flowStepLocKeys'] = list(item['Flow'].keys())

    return def_data

def expand2square(pil_img, background_color):
    width, height = pil_img.size
    if width == height:
        return pil_img
    elif width > height:
        result = Image.new(pil_img.mode, (width, width), background_color)
        result.paste(pil_img, (0, (width - height) // 2))
        return result
    else:
        result = Image.new(pil_img.mode, (height, height), background_color)
        result.paste(pil_img, ((height - width) // 2, 0))
        return result

# Returns the value associated with the first key found in descriptionsDict. 
def get_first_description_found(keys, descriptionsDict, keysToIgnore=[]):
    for key in keys:
        if key in keysToIgnore:
            continue
        if key in descriptionsDict:
            return descriptionsDict[key]
    if keys[0] in descriptionsDict:
        return descriptionsDict[keys[0]]
    else:
        return ""

def should_generate_hybrid_index():
    #generate the hybrid index page only when the template has been added to the branch
    return path.exists(path.join(root, ".\\templates\\hybrid_architecture_index.md"))

logging.basicConfig(level=logging.INFO)

root = path.dirname(path.abspath(__file__))
doc_directory = path.normpath(path.join(root, "..", ".." , "docs"))
includes_dir = path.normpath(path.join(root, "..", ".." , "includes"))
ew_dir=path.join(doc_directory, "example-scenario")
ra_dir=path.join(doc_directory, "reference-architectures")
hybrid_ra_dir=path.join(doc_directory, "hybrid")
acom_dir=path.join(doc_directory, "solution-ideas", "articles")
index_dir=path.join(doc_directory, "solution-ideas")

templates_dir = path.join(root, 'templates')
env = Environment ( 
    loader = FileSystemLoader(templates_dir),
    trim_blocks = True,
    lstrip_blocks = True,
    keep_trailing_newline = True,
    autoescape=select_autoescape(['resx'])
    )

# tag_file = open(path.join(index_dir, "metadata", "display-tags.json"), "r")
# tag_metadata=json.load(tag_file)

category_file = open(path.join(root, "categories.json"), "r")
categories=json.load(category_file)['categories']
if should_generate_hybrid_index():
    category_file.seek(0,0)
    hybrid_categories=json.load(category_file)['hybrid-categories']
category_file.close()

acom_diagrams = Path(acom_dir).glob('**/*.md')
example_workloads = Path(ew_dir).glob('**/*.md')
reference_architectures = Path(ra_dir).glob('**/*.md')
hybrid_reference_architectures= Path(hybrid_ra_dir).glob('**/*.md')

all_architectures_list = []

ra_list=[]
for ra in reference_architectures:
    ra_list.append(str(ra))
    all_architectures_list.append(ra)

for ra in hybrid_reference_architectures:
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

root = path.dirname(path.abspath(__file__))
popularity = []
with open(path.join(root, "popularity.csv"), newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for line in reader:
        popularity.append(dict(line))

bad_articles = []
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
    http_url="/azure/architecture/" + str(file_path.relative_to(doc_directory).as_posix()).replace(file_path.suffix, "").replace("/index", "")
    article['file_url'] = str(file_path.relative_to(doc_directory).as_posix())
    article['http_url'] = http_url.lower()

    # Strip SVG and convert to html
    logging.debug("Stripping tags")
    with open(file, encoding="utf8") as f:
        article_meta, contents = frontmatter.parse(f.read())
    htmltags = re.compile('<.*>')
    cleantext = re.sub(htmltags, '', contents)
    words=cleantext.lower().split()
    logging.debug("Getting word count")
    article['word_count'] = len(words)

    includes = re.compile('\[\!INCLUDE.*')
    contents = re.sub(includes, '', contents)

    logging.debug("Get reading time")
    article['read_time'] = str(readtime.of_markdown(cleantext))

    if article_meta.get('redirect_url'):
        logging.info("Found redirect for: " + str_path)
        continue

    logging.debug("Getting title")
    if article_meta['title']:
        article['Title'] = article_meta['title']
    else:
        print("No title found for", str_path)
        continue

    logging.debug("Getting description")
    if article_meta['description']:
        article['MetaDescription'] = article_meta['description']

    logging.debug("Getting categories")
    try:
        if article_meta['ms.category']:
            article['category'] = article_meta['ms.category']
    except:
        print("Unable to get category for "+ str_path)
        bad_articles.append(str_path)
        article_meta['ms.category']= []
        continue

    logging.debug("Finding images")
    # Find the first image in the article
    i = re.findall(r"^.*[ \(\"]([\.\/]*(?:media|images|_images)\/(?!github).*\.(?:png|jpg|svg)).*$", contents, re.MULTILINE)
    main_dir = file_path.resolve().parent.parent
    if len(i) > 0:
        image = i[0]
    else:
        # No image in the article, look for one on the filesystem
        image= str(file_path)[:-3] + ".png"
        if not path.isfile(image):
            file_glob = "*/" + str(file_path.name)[:-3] + "*.svg"
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
        article['imagepath'] = str(Path(image).resolve())
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

    logging.debug("Finding any link definitions")
    links = re.findall(r"^\[.*]:.*$", contents, re.MULTILINE)

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
    component = re.findall(r"^#(.*component.*\n*)((?:\s[-|\*]\s[^#]*\n)+)", contents, re.MULTILINE | re.IGNORECASE)
    if component:
        components = re.findall(r"^(?:\s*[-|\*]\s*)(.*$)", component[0][1], re.MULTILINE  | re.IGNORECASE)
        components = [markdown.markdown((c + "\n" + "\n".join(links))) for c in components]
        article['components'] = [update_paths(x, article['http_url']) for x in components]

    logging.debug("Looking for Introduction text")
    introduction = re.findall(r"^(?:#[\s|\w][\w|\s]*\n)(.*?)^#", contents, re.MULTILINE | re.IGNORECASE | re.DOTALL)
    if introduction:
        article['Summary'] = update_paths(markdown.markdown(introduction[0] + "\n" + "\n".join(links)), article['http_url'])

    logging.debug("Looking for Flow details")
    flow = re.findall(r"^(.*flow.*\n*)((?:\s*\d\.\s[^#]*\n)+)", contents, re.MULTILINE  | re.IGNORECASE)
    if flow:
        steps = re.findall(r"(?:\s*\d\. )(.*$)\n", flow[0][1], re.MULTILINE  | re.IGNORECASE)
        article.setdefault('tags', []).append("data-flow")
        article['Flow'] = {"FlowStep_" + str(stepnum_letter(k)): update_paths(v, article['http_url']) for k, v in enumerate(steps, start=1)}

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

    if article.get('Title'):
        logging.debug("Finalize config")

        # Set article short name
        if file_path.stem == "index":
            article['name'] = file_path.parent.stem
        else:
            article['name'] = file_path.stem

        # Have an everything tag
        article.setdefault('tags', []).append("all-items")

        # Remove duplicates from tags
        article['tags'] = unique(article['tags'])

        # Remove duplicates from code languages
        if article.get('code_languages'):
            article['code_languages'] = unique(article['code_languages'])

        rank = list(find_all(popularity, article['http_url'], 'item'))
        if rank:
            article['popularity'] = int(rank[0]['Ranking'])
        else:
            article['popularity'] = 0

        logging.debug("Add to list")
        parsed_articles.append(article)

# Sort by title
parsed_articles = sorted(parsed_articles, key=lambda x: x['Title'])

all_tags = []
all_langs = []

with open( path.join(doc_directory, "toc.yml"), 'r') as stream:
    main_toc = yaml.safe_load(stream)

for article in parsed_articles:  
    # toc_link=list(find_all(main_toc,article['file_url'],'item'))
    # if len(toc_link) == 0:
    #     main_toc= update_toc(article, main_toc)

    # Sort the tags
    article['tags'] = sorted(article['tags'])

    # Define the primary topic for the article
    article['topic'] = get_first_description_found(article['category'], categories, ['hybrid'])


    # Build tag list
    all_tags.extend(article['tags'])

    # Build Code languages list
    if article.get('code_languages'):
        article['code_languages'] = sorted(article['code_languages'])
        all_langs.extend(article['code_languages'])  

    # acom_def = acom_json(article)
    # output_file = open(path.join(root, "acom_data", "json", article['name'] + ".json"), "w")
    # output_file.write(json.dumps(acom_def, indent=4))
    # output_file.close()

    # template = env.get_template('acom_data.resx')
    # output_file = open(path.join(root, "acom_data", "resx", article['name'] + ".resx"), "w")
    # output_file.write(template.render(article))
    # output_file.close()

    if article.get('imagepath'):
        if os.path.splitext(article['imagepath'])[1] == ".svg":
            imagefile = os.path.splitext(article['imagepath'])[0] + ".png"
        else:
            imagefile = article['imagepath']
          
        #TODO: Check if thumbnail exists before making one
        if not path.isfile(path.join(doc_directory, "browse", "thumbs", article['name'] + ".png")):
            image = Image.open(imagefile)
            image_thumb = expand2square(image, (255, 255, 255))
            image_thumb.thumbnail((200,200), Image.ANTIALIAS)
            image_thumb.save(path.join(doc_directory, "browse", "thumbs", article['name'] + ".png"))
        
        # acom_image = path.join(root, "acom_data", "images", article['name'] + os.path.splitext(article['imagepath'])[1])
        # shutil.copyfile(article['imagepath'], acom_image)

    card_template = env.get_template('card.md')
    card_file = open(path.join(includes_dir, "cards", article['name'] + ".md"), "w")
    card_file.write(card_template.render(article=article, categories=categories))
    card_file.close()

all_langs = unique(all_langs)
all_tags = unique(all_tags)

articles={"articles": parsed_articles}

# index_template = env.get_template('architecture_index.md')
# index_file = open(path.join(doc_directory, "architectures", "browse.md"), "wb")
# index_file.write(index_template.render(topics=all_topics.items()).encode('utf-8'))
# index_file.close()

# article_template = env.get_template('rough_index.yaml')
# article_file = open(path.join(doc_directory, "architectures", "test", "index.yml"), "wb")
# article_file.write(article_template.render(articles=articles, azure_categories=azure_categories).encode('utf-8'))
# article_file.close()

#render template to generate the architecture_index page

if should_generate_hybrid_index() and not include_hybrid_in_all_architectures:
    azure_articles= { "articles": list(filter(lambda a: ( 'hybrid' not in a['category']), parsed_articles)) }
else:
    azure_articles= { "articles": parsed_articles }

azure_topics = defaultdict(list)
for article in azure_articles['articles']:
    azure_topics[article['topic']].append(article)

hub_file = open(path.join(doc_directory, "browse", "index.md"), "wb")
hub_template = env.get_template('architecture_index.md')
hub_file.write(hub_template.render(articles=azure_topics, topics=azure_topics.items(), categories=categories).encode('utf-8'))
hub_file.close()

# generate the hybrid browse index page - following the same pattern currently used for the all architetures browse page
if should_generate_hybrid_index():
    hybrid_articles= {"articles": list(filter(lambda a: ( 'hybrid' in a['category']), parsed_articles)) }
    for article in hybrid_articles['articles']:
        article['hybrid-topic']= get_first_description_found(article['category'], hybrid_categories)

    hybrid_topics= defaultdict(list)
    for article in hybrid_articles['articles']:
        hybrid_topics[article['hybrid-topic']].append(article)

    hybrid_hub_file = open(path.join(doc_directory, "browse", "hybrid_index.md"), "wb")
    hybrid_hub_template = env.get_template('hybrid_architecture_index.md')
    hybrid_hub_file.write(hybrid_hub_template.render(articles=hybrid_articles, topics=hybrid_topics.items(), categories=hybrid_categories).encode('utf-8'))
    hybrid_hub_file.close()

# toc_template = env.get_template('topic_toc.yaml')
# toc_file = open(path.join(root_dir, "toc_stub.yaml"), "wb")
# toc_file.write(toc_template.render(articles=articles, topics=all_topics.items(), categories=categories).encode('utf-8'))
# toc_file.close()

# output_file = open(path.join(doc_directory, "toc.yml"), "wb")
# output_file.write(yaml.dump(main_toc, default_flow_style=False, sort_keys=False).encode('utf-8'))
# output_file.close()

output_file = open(path.join(doc_directory, "browse", "data", "architectures.json"), "wb")
output_file.write(json.dumps(articles, indent=4).encode('utf-8'))
output_file.close()

# output_file = open(path.join(root_dir, "data", "tags.json"), "wb")
# output_file.write(json.dumps(sorted(all_tags), indent=4).encode('utf-8'))
# output_file.close()

# output_file = open(path.join(root_dir, "data", "dev-langs.json"), "wb")
# output_file.write(json.dumps(sorted(all_langs), indent=4).encode('utf-8'))
# output_file.close()

if bad_articles:
    print("\n\nUpdate ms.category for: \n")
    print("\n".join(bad_articles))