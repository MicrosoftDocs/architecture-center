const path = require('path');
const fs = require('fs');

module.exports = folder => {
    const articleRE = /^#+ \[([a-zA-Z-\s]*)\]\(([\.\/a-zA-Z-]*)\)/igm;

    const tocPath = path.resolve(folder, `toc.md`);
    const content = fs.readFileSync(tocPath, 'utf8');

    var output = [];

    // extract the main articles from the TOC
    var result = articleRE.exec(content);
    // first hit _should_ be the series overview
    // so we'll ignore it and move on...

    while ((result = articleRE.exec(content)) !== null) {
        output.push({
            title: result[1].trim(),
            filePath: result[2]
        });
    }

    return output;
}