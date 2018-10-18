#!/bin/bash

for article in $(cat articles.txt); do 
	echo "Scraping ${article}"
        ./scrape.py "${article}"
done
