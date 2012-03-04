# Xommelier is an XML Sommelier

## Overview

Xommelier is an XML Object Mapper. You could describe some namespace (e.g. Atom) in ruby DSL and use it for parsing XML to Ruby objects or for building XML from Ruby objects.

Look into {Xommelier::Atom} module for implementation of http://www.w3.org/2005/Atom namespace

Xommelier is work in progress.

## Future tasks

* Implementation that support more than one namespace in XML class
* Converting XML Schema, RelaxNG, RelaxNG Compact and DTD into Xommelier Ruby DSL
* ActiveRecord-like automatic loading of XML Schema, RelaxNG, RelaxNG Compact and DTD without needing to write it down into ruby code
