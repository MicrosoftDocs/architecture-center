var commonmark = require('commonmark');

function getHeadingText(node) {
    var walker = node.walker();
    while ((event = walker.next())) {
        node = event.node;
        if (event.entering && node.type === 'text') {
            return node._literal;
        }
    }
    return null;
}

function getHeadingLink(node) {
    var walker = node.walker();
    while ((event = walker.next())) {
        node = event.node;
        if (event.entering && node._destination) {
            return node._destination;
        }
    }
    return null;
}

function adorn(model) {
    var articles = model.articles;

    articles.forEach((article, i) => {
        var prevIndex = i - 1;
        var nextIndex = i + 1;
        if (prevIndex >= 0) {
            article.prev = articles[prevIndex].url;
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
    var result = this.articles.find(x => (x.filePath.indexOf(file) >= 0));
    if (result) return result;
    throw Error(`${file} was not found in articles for ${this.root}.`);
}

module.exports = function (toc, slug) {

    var model = {
        root: slug,
        title: null,
        articles: [],
        getArticleByFile: getArticleByFile
    };

    var reader = new commonmark.Parser();
    var parsed = reader.parse(toc);

    var walker = parsed.walker();
    var event, node;

    while ((event = walker.next())) {
        node = event.node;
        if (event.entering && node.type === 'heading') {
            if (node.level === 1) {
                model.title = getHeadingText(node);
            }
            if (node.level === 2) {
                var title = getHeadingText(node);
                var filePath = getHeadingLink(node);

                var article = {
                    title: title,
                    filePath: filePath,
                    url: resolveUrl(filePath)
                };
                model.articles.push(article);
            }
        }
    }
    adorn(model);
    return model;
}