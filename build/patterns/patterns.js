var yamlFront = require('yaml-front-matter');
var path = require('path');
var fs = require('fs');

module.exports = function () {

    var model = [];
    var patternsPath = path.resolve(__dirname, `../../docs/patterns`);

    var files = fs.readdirSync(patternsPath);
    files.forEach(file => {
        if (file.substr(-3) != ".md") return;
        if (['index.md','index.liquid.md','toc.md'].indexOf(file) > -1) return;

        var filePath = path.resolve(patternsPath, file);
        var content = fs.readFileSync(filePath, 'utf8');
        var yml = yamlFront.loadFront(content);

        model.push({
            title: yml['title'],
            description: yml['description'],
            file: file,
            categories: yml['pnp.pattern.categories']
        });
    });

    return model;
};