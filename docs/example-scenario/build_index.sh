#!/bin/bash
#
# Parse and generate article list for index file
#
# Usage (Bash or WSL): ./build_index.sh > articles.md

for folder in $(ls -d */ | cut -f1 -d'/'); do

	if [[ "$folder" == "ai" ]]; then
		echo -e "\n## AI Scenarios\n"
	fi
	if [[ "$folder" == "apps" ]]; then
		echo -e "\n## Application Scenarios\n"
	fi
	if [[ "$folder" == "data" ]]; then
		echo -e "\n## Data Scenarios\n"
	fi
	if [[ "$folder" == "infrastructure" ]]; then
		echo -e "\n## Infrastructure Scenarios\n"
	fi

	echo -e "<ul  class=\"panelContent cardsC\">"
	for article in $(ls $folder/*.md); do
		url="./$article"
		title=$(cat $article | grep "title:" | cut -d ":" -f 2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
		description=$(cat $article | grep "description:" | cut -d ":" -f 2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
		image="./${folder}/$(cat $article | grep media | grep -e ".png" -e ".jpg" | head -1 | sed -n 's/.*\(media.*\(png\|jpg\)\).*/\1/p')"

		cat <<EOF
<li style="display: flex; flex-direction: column;">
    <a href="${url}" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="${image}" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>${title}</h3>
                        <p>${description}</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
EOF
	done
	echo -e "</ul>\n"


done
