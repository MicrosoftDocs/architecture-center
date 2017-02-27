module.exports = function (data) {
    var categories = data.categories;
    var patterns = data.patterns;

    // associate individual patterns with categories using their metadata
    categories.forEach(c => {
        c.patterns = patterns.filter(p => p.categories.includes(c.url));
    });

    return categories;
};