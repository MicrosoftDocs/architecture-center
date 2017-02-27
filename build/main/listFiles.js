const Glob = require('glob').Glob;

module.exports = ctx => {

    return new Promise((resolve, reject) => {

        var globbing = new Glob(ctx.pattern, { cwd: ctx.cwd }, (err, files) => {

            if (err) {
                reject(err);
                return;
            }

            resolve({ files: files, ctx: ctx });
        });
    });
};