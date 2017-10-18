![dkdeploy::php](assets/dkdeploy-logo.png)

# Dkdeploy::Php

[![Build Status](https://travis-ci.org/dkdeploy/dkdeploy-php.svg?branch=develop)](https://travis-ci.org/dkdeploy/dkdeploy-php)
[![Gem Version](https://badge.fury.io/rb/dkdeploy-php.svg)](https://badge.fury.io/rb/dkdeploy-php) [![Inline docs](http://inch-ci.org/github/dkdeploy/dkdeploy-php.svg?branch=develop)](http://inch-ci.org/github/dkdeploy/dkdeploy-php)

## Description

This Rubygem `dkdeploy-php` ruby gem represents the extension of [Capistrano](http://capistranorb.com/) tasks directed to the advanced deployment process.

## Installation

Add this line to your application's `Gemfile`

	gem 'dkdeploy-php', '~> 8.0'

and then execute

	bundle install

or install it yourself as

	gem install dkdeploy-php

## Usage

Run in your project root

	cap install STAGES='dev,integration,testing,production'

This command will create the following Capistrano file structure with all the standard pre-configured constants.
Please be aware of the difference to the [native installation](http://capistranorb.com/documentation/getting-started/preparing-your-application/) of Capistrano.
Certainly you have to adjust `config/deploy.rb` and respective stages and customize them for your needs.

<pre>
  ├── Capfile
  └── config
     ├── deploy
     │   ├── dev.rb
     │   ├── integration.rb
     │   ├── testing.rb
     │   └── production.rb
     └── deploy.rb
</pre>

As next you have to append the following line to the `Capfile` in order to make use of dkdeploy extensions in addition to the standard Capistrano tasks:

	require 'capistrano/dkdeploy/php'

To convince yourself, that Capistrano tasks list has been extended, please run

	cap -T

Please note, that dkdeploy uses the local copy strategy and overwrites the `:scm` constant. If you want to use it,
you should do nothing more. However if you want to change it for example to `:git`, please add the following line to `deploy.rb`

	set :scm, :git

For more information about available Capistrano constants please use the [Capistrano documentation](http://capistranorb.com/documentation/getting-started/preparing-your-application/).
The complete list of the dkdeploy-php constants you find in `/lib/capistrano/dkdeploy/php.rb`.

## Testing

### Prerequisite

Vagrant `landrush` plugin is needed. If there are issues, make sure that the following IPv4 address is used for this domain

	192.168.156.181 dkdeploy-php.dev

### Running tests

1. Starting the local box (`vagrant up --provision`)
2. Checking coding styles (`rubocop`)
3. Running BDD cucumber tests (`cucumber`)

## Contributing

1. Install [git flow](https://github.com/nvie/gitflow)
2. If project is not checked out already do git clone `git@github.com:dkdeploy/dkdeploy-php.git`
3. Checkout origin develop branch (`git checkout --track -b develop origin/develop`)
4. Git flow initialze `git flow init -d`
5. Installing gems `bundle install`
6. Create new feature branch (`git flow feature start my-new-feature`)
7. Run tests (README.md Testing)
8. Commit your changes (`git commit -am 'Add some feature'`)
