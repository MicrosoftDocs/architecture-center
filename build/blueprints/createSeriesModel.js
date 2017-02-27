const toc = require('./toc');

function adorn(model) {
    var articles = model.articles;

    articles.forEach((article, i) => {
        var prevIndex = i - 1;
        var nextIndex = i + 1;
        if (prevIndex >= 0) {
            article.prev = articles[prevIndex].url;
        } else {
            article.prev = './index';
        }
        if (nextIndex < articles.length) {
            article.next = articles[nextIndex].url;
        }
    });
}

function resolveUrl(url) {
    return url.replace('.md', '').replace('./', '');
}

function getArticleByFile(file) {
    return this.articles.find(x => (x.filePath.indexOf(file) >= 0));
}

module.exports = (slug, path) => {

    var contents = toc(path);

    var model = {
        root: slug,
        title: contents[0].title,
        description: null,
        articles: [],
        getArticleByFile: getArticleByFile
    };

    contents.shift();

    model.articles = contents.map(x => {
        return {
            title: x.title,
            filePath: x.filePath,
            url: resolveUrl(x.filePath)
        };
    });

    adorn(model);
    
    return model;
}