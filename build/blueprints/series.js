var createSeriesModel = require('./createSeriesModel');
var lec = require('line-ending-corrector').LineEndingCorrector.correctSync;
var yamlFront = require('yaml-front-matter');
var path = require('path');
var fs = require('fs');
var os = require('os');

module.exports = function (seriesSlug, seriesPath) {
    console.log(`series: ${seriesSlug}`);

    var tocPath = path.resolve(seriesPath, `toc.md`);
    var toc = fs.readFileSync(tocPath, 'utf8');

    var series = createSeriesModel(seriesSlug, seriesPath);

    var files = fs.readdirSync(seriesPath);
    files.forEach(file => {
        if (file.substr(-3) != ".md") return;
        if (['index.md', 'toc.md'].indexOf(file) > -1) return;

        var filePath = path.resolve(seriesPath, file);
        var content = fs.readFileSync(filePath, 'utf8');

        var yml = yamlFront.loadFront(content);
        var original = yml.__content;
        delete yml.__content;

        var article = series.getArticleByFile(file);
        if (!article) return;

        var cardTitle = article.title;

        Object.assign(article, yml);


        if (article.prev) {
            yml['pnp.series.prev'] = article.prev;
        }
        if (article.next) {
            yml['pnp.series.next'] = article.next;
        }
        yml['pnp.series.title'] = series.title;
        yml['cardTitle'] = cardTitle;

        var updated = lec('---' + os.EOL + yamlFront.dump(yml) + '---' + original, { eolc: 'CRLF' });
        fs.writeFileSync(filePath, updated[1]);
    });

    return series;
}