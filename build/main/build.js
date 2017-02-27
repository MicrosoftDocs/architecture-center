var path = require('path');
var fs = require('fs');

var yamlFront = require('yaml-front-matter');
var Liquid = require('shopify-liquid');

var series = require('./series');

var engine = Liquid({
    root: path.resolve(__dirname, 'templates'),
    extname: '.liquid'
});

module.exports = function () {
    var dataPath = path.resolve(__dirname, '../../docs/index.yml');
    var content = fs.readFileSync(dataPath, 'utf8');
    var yml = yamlFront.loadFront(content);

    ['index'].forEach(x => {
        console.log(`templated page: ${x}`);
        var templatePath = path.resolve(__dirname, `../../docs/${x}.liquid.md`);
        var outputhPath = path.resolve(__dirname, `../../docs/${x}.md`);
        var template = engine.parse(fs.readFileSync(templatePath, 'utf8'));

        return engine.render(template, yml)
            .then(function (markdown) {
                fs.writeFile(outputhPath, markdown);
            });
    });

    ['multitenant-identity', 'elasticsearch'].forEach(slug => series(slug));
}
