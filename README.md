# Xommelier is an XML Sommelier

## Overview

Xommelier is an XML Object Mapper. You could describe some namespace (e.g. Atom) in ruby DSL and use it for parsing XML to Ruby objects or for building XML from Ruby objects.

Look into {Xommelier::Atom}, {Xommelier::Atom::Threading}, and {Xommelier::Atom::History} module for implementation of http://www.w3.org/2005/Atom namespace, Atom Threading, and Feed Paging and Archiving extensions

## Project links

* [Sources](https://github.com/alsemyonov/xommelier)
* [Documentation](http://rubydoc.info/gems/xommelier)
* [Issue Tracker](https://github.com/alsemyonov/xommelier/issues)
* [Wiki](https://github.com/alsemyonov/xommelier/wiki)
* [![Code Climate](https://codeclimate.com/github/alsemyonov/xommelier/badges/gpa.svg)](https://codeclimate.com/github/alsemyonov/xommelier)
* [![Test Coverage](https://codeclimate.com/github/alsemyonov/xommelier/badges/coverage.svg)](https://codeclimate.com/github/alsemyonov/xommelier/coverage)
* [![Build Status](https://travis-ci.org/alsemyonov/xommelier.png?branch=master)](http://travis-ci.org/alsemyonov/xommelier)
* [![Dependency Status](https://gemnasium.com/alsemyonov/xommelier.png)](https://gemnasium.com/alsemyonov/xommelier)

## Examples

See `examples` dir for examples of:

* reading an Atom feed;
* building an Atom feed;
* building an Atom feed from hash;

## Built in XML namespaces:

1. {Xommelier::Atom} - http://www.w3.org/2005/Atom
2. {Xommelier::Atom::Threading} - http://purl.org/syndication/thread/1.0
3. {Xommelier::Atom::History} - http://purl.org/syndication/history/1.0
4. {Xommelier::OpenSearch} - http://a9.com/-/spec/opensearch/1.1/

## TODO

* Rebuild on top of ROM
* Validating built XML against RelaxNG
* Converting XML Schema, RelaxNG, RelaxNG Compact and DTD into Xommelier Ruby DSL
* ActiveRecord-like automatic loading of XML Schema, RelaxNG, RelaxNG Compact and DTD without needing to write it down into ruby code

## Contributors

* Art Semyonov, [@artps](https://github.com/artps)
* Sergey Ukustov, [@ukstv](https://github.com/ukstv)

© Alex Semyonov, 2011-2017. See LICENSE for details

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/alsemyonov/xommelier/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
