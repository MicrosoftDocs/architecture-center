[![Board Status](https://dev.azure.com/ceapex/0ed5b4a0-21d8-4dc2-8b95-5fdb8449e2bd/2084ccd3-8289-487c-beb0-4d82fe06fa10/_apis/work/boardbadge/391ad978-8343-4e79-880e-4bf6e988dc09)](https://dev.azure.com/ceapex/0ed5b4a0-21d8-4dc2-8b95-5fdb8449e2bd/_boards/board/t/2084ccd3-8289-487c-beb0-4d82fe06fa10/Microsoft.EpicCategory)
# Azure Architecture Center
Microsoft patterns & practices

http://aka.ms/architecture

## Understanding the local build process

Some of the markdown files are generated from data stored in json files.
This is primarily to avoid human error for pages that still require some HTML.
The process that converts the json to markdown uses a utility script located in the `build` folder.
To run the build script, navigate to the root folder of this repository.

```bash
npm install
node .\build\build.js
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
