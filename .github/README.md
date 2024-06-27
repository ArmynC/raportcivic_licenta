## Raport Civic bachelor thesis

This repo contains the source code, release, and documentation of my little bachelor thesis project RaportCivic, which in all means, its purpose is to encourage the civic participation. 

#### Project details
The app is based on Qt Framework (multiplatform), at the time of conception v6.7.1, which has a C++/Qt Core back-end and QML/JS front-end. Some libraries were included and implemented (but not limited to), such as libsodium with Argon2id hasher for account security, tinyexif & tinyxml for image GPS coordinate on lat. and long. extraction, and perhaps some other smaller ones (e.g. networking). The project has some utilies such as parsers, that iterates throught the entire .json files to retrieve the counties and cities from a local database, and also, the key topic of this project, it retrieves and maps the given templates, building a report out of the master templates, which are inherited by their submodules counterparts. It also has a connection to an aiven cloud postgresql database (digitalocean cloud region hosting).


## License
[MIT](https://www.tldrlegal.com/license/mit-license)