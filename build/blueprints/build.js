var path = require('path');
var fs = require('fs');
var series = require('./series');

var yamlFront = require('yaml-front-matter')
var Liquid = require('shopify-liquid');

var engine = Liquid({
    root: path.resolve(__dirname, 'templates'),
    extname: '.liquid'
});

module.exports = function () {
    var basePath = path.resolve(__dirname, `../../docs/blueprints/`);
    var catalog = { series: [] };

    // render series overviews
    var seriesTemplate = engine.parse("{%- include 'series-overview' -%}");
    [
        'virtual-machines-linux',
        'virtual-machines-windows',
        'app-service',
        'identity',
        'hybrid-networking',
        'dmz'
    ].forEach(slug => {
        var seriesPath = path.resolve(basePath, `${slug}`);
        var model = series(slug, seriesPath);

        var ymlPath = path.resolve(seriesPath, `series.yml`);
        var content = fs.readFileSync(ymlPath, 'utf8');
        var yml = yamlFront.loadFront(content);

        Object.assign(model, yml);

        model.next = model.articles[0].url;
        model.path = slug;
        catalog.series.push(model);

        var outputhPath = path.resolve(seriesPath, `index.md`);
        engine.render(seriesTemplate, { series: model })
            .then(markdown => fs.writeFile(outputhPath, markdown));
    });

    // render main index
    ['index'].forEach(x => {
        var templatePath = path.resolve(basePath, `${x}.liquid.md`);
        var outputhPath = path.resolve(basePath, `${x}.md`);
        var template = engine.parse(fs.readFileSync(templatePath, 'utf8'));

        console.log(x);
        engine.render(template, catalog)
            .then(markdown => fs.writeFile(outputhPath, markdown));
    });
}