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

    cat CDU/Kommunalwahlprogramm_2014_markup_utf8.txt | sudo fig run parser CDU

This will take some time at the first run, as the docker image for the
parser will be built first.
