Parse a party's agenda into elasticsearch.

## Install

Install docker and fig.

## Convert pdfs

- Try http://www.pdf2txt.de/
- See [zielformat.txt](zielformat.txt) for hint how to tweak the formatting

## Run

Build container & start elasticsearch:

    sudo fig up -d

Then let the parser do its work:

    cat CDU/Kommunalwahlprogramm_2014_markup_utf8.txt | sudo fig run parser CDU
