const path = require('path');
const fs = require('fs');

const Liquid = require('liquidjs');

const engine = Liquid({
    root: path.resolve(__dirname, 'templates'),
    extname: '.liquid'
});

module.exports = function () {

    const basePath = path.resolve(__dirname, `../../docs/reference-architectures/`);
    const outputhPath = path.resolve(basePath, 'index.md');
    const jsonPath = path.resolve(basePath, `index.json`);

    const content = fs.readFileSync(jsonPath, 'utf8');
    const index = JSON.parse(content);

    engine.renderFile('index', index)
        .then(markdown => fs.writeFile(outputhPath, markdown));
}