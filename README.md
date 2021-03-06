Parse a party's agenda into elasticsearch.

## Install

Install docker and fig.

## Convert pdfs

- Put originals into the folder [`originals`](originals)
- Try http://www.pdf2txt.de/
- See [zielformat.md](zielformat.md) for hint how to tweak the formatting
- put the converted file as `{Parteiname}.md` into the folder [`converted`](converted)

## Run

### the old-school way

* Install & run Elasticsearch
* Install Ruby (>= 1.9)
* Run `bundle install`

Then let the parser do its work:

    ./parser.rb

This will import all files from the `converted` folder into elasticsearch.

### via Docker

Start elasticsearch:

    sudo fig up -d elasticsearch

Then let the parser do its work:

    sudo fig up parser

This will import all files from the `converted` folder into elasticsearch.

Note: The docker image for the parser will be built on the first run. This will take some time.


## Generate JSON for the Wahlprogramm-Matrix

## Generate agendas

    ruby agendas.rb | json_reformat >json/agendas.json

(To run via Docker, just put `sudo fig run parser` in front of that.)
