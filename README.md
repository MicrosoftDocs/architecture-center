# patterns & practices

Some of the content is generated using a build script.
* `index.md` is completely generated. You should not edit it directly. Instead, edit `index.yml` and `index.liquid.md`, then run the build script.
* The metadata for series is generated and copied into the relevant docs. The metadata is derived from the corresponding toc.md. You should not directly editing any of the yml that starts with `pnp.series.`.

In order to run the build script, first install the supporting packages:

```bash
npm install
```

To generate the files, you can run the `start` task:
```bash
npm start
```
Or run the script directly:
```bash
node .\build\build.js
```

For convenience, you can build, commit, and push with a single command:
```bash
npm run build
```

## Legal Notices
Microsoft and any contributors grant you a license to the Microsoft documentation and other content
in this repository under the [Creative Commons Attribution 4.0 International Public License](https://creativecommons.org/licenses/by/4.0/legalcode),
see the [LICENSE](LICENSE) file, and grant you a license to any code in the repository under the [MIT License](https://opensource.org/licenses/MIT), see the
[LICENSE-CODE](LICENSE-CODE) file.

Microsoft, Windows, Microsoft Azure and/or other Microsoft products and services referenced in the documentation
may be either trademarks or registered trademarks of Microsoft in the United States and/or other countries.
The licenses for this project do not grant you rights to use any Microsoft names, logos, or trademarks.
Microsoft's general trademark guidelines can be found at http://go.microsoft.com/fwlink/?LinkID=254653.

Privacy information can be found at https://privacy.microsoft.com/en-us/

Microsoft and any contributors reserve all others rights, whether under their respective copyrights, patents,
or trademarks, whether by implication, estoppel or otherwise.
