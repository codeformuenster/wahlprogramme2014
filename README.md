Parse a party's agenda into elasticsearch.

## Install

Install docker and fig.

## Convert pdfs

- Put originals into the folder [`originals`](originals)
- Try http://www.pdf2txt.de/
- See [zielformat.md](zielformat.md) for hint how to tweak the formatting
- put the converted file as `{Parteiname}.md` into the folder [`converted`](converted)

## Run

Build container & start elasticsearch:

    sudo fig up -d

Then let the parser do its work:

    cat CDU/Kommunalwahlprogramm_2014_markup_utf8.txt | sudo fig run parser CDU
