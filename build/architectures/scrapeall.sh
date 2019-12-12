#!/bin/bash

for article in $(cat url_list.txt); do 
	echo "Scraping ${article}"
        ./scrape.py "${article}"
done
