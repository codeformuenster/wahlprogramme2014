Parse a party's agenda into elasticsearch.

## Install

Install docker and fig.

## Convert pdfs

- Put originals into the folder [`originals`](originals)
- Try http://www.pdf2txt.de/
- See [zielformat.md](zielformat.md) for hint how to tweak the formatting
- put the converted file as `{Parteiname}.md` into the folder [`converted`](converted)

## Run

Start elasticsearch:

    sudo fig up -d elasticsearch

Then let the parser do its work:

    sudo fig up parser

This will import all files from the `converted` folder into elasticsearch.

Note: The docker image for the parser will be built on the first run. This will take some time.
