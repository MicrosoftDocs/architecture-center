const path = require('path');
const fs = require('fs');

var Liquid = require('liquidjs');

var engine = Liquid({
    root: path.resolve(__dirname, 'templates'),
    extname: '.liquid'
});

function buildTopicPage(indexFolder) {

    const basePath = path.resolve(__dirname, `../../docs/`, indexFolder);
    const outputhPath = path.resolve(basePath, 'index.md');
    const jsonPath = path.resolve(basePath, `index.json.txt`);

    const content = fs.readFileSync(jsonPath, 'utf8');
    const index = JSON.parse(content);

    engine.renderFile('index', index)
        .then(markdown => fs.writeFile(outputhPath, markdown));
}
buildTopicPage('microservices');
// buildTopicPage('big-data');
