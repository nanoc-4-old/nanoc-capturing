[![Build Status](https://travis-ci.org/nanoc/nanoc-capturing.png)](https://travis-ci.org/nanoc/nanoc-capturing)
[![Code Climate](https://codeclimate.com/github/nanoc/nanoc-capturing.png)](https://codeclimate.com/github/nanoc/nanoc-capturing)
[![Coverage Status](https://coveralls.io/repos/nanoc/nanoc-capturing/badge.png?branch=master)](https://coveralls.io/r/nanoc/nanoc-capturing)

# nanoc-capturing

This provides functionality for capturing for [nanoc](http://nanoc.ws).

## Installation

`gem install nanoc-capturing`

## Usage

### `content_for(name, &block)`

Captures the content inside the block and stores it so that it can be referenced later on. When capturing, the content of the block itself will not be outputted.

* `name`: the name to associate with the captured content

### `content_for(item, name)`

Fetches the capture with the given name from the given item and returns it.

* `item`: the item for which to get the capture
* `name`: the name associated with the captured content to fetch

### `capture(&block)`

Evaluates the given block and returns its contents. The contents of the block is not outputted.
