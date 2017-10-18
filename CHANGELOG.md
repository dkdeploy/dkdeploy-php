# Changelog
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [8.0.0] - 2017-09-18
### Summary

- `:ssl_verify_mode` for server properties, which takes SSL verify_mode constants (`OpenSSL::SSL::VERIFY_NONE`)
- `Dkdeploy::Php::Helpers::Http::http_get_with_redirect` gets arguments as options hash now
- Vagrant 2.0.x support
- rubocop upgrade to 0.50
- ruby upgrade to 2.2
- bundler upgrade
- rake upgrade
- dkdeploy-test_environment upgrade to 2.0
- dkdeploy-core upgrade 9.0
- Add dependencies for cucumber, rubocop, aruba and mysql2
- remove SSL certificate bypassing in http helper #5

## [7.0.0] - 2016-07-01
### Summary

- first public release

[Unreleased]: https://github.com/dkdeploy/dkdeploy-php/compare/master...develop
[8.0.0]: https://github.com/dkdeploy/dkdeploy-php/releases/tag/v8.0.0
[7.0.0]: https://github.com/dkdeploy/dkdeploy-php/releases/tag/v7.0.0
