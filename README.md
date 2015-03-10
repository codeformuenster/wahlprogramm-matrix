# Wahlprogramm-Matrix

Show similar passages in election manifestos of different parties side by side.

An experiment by Daniel Kirsch, Martin Honermeyer, Tobias Bradtke, Yannic Schencking for Code for Münster on the Kommunalwahl 2014

![screenshot](https://cloud.githubusercontent.com/assets/828496/6564261/7e03f16a-c6a7-11e4-97f9-f972e60f53cc.png)

## Install

You need ruby installed and then

    $ bundle install

## Development

    $ bundle exec middleman

## Deployment (on gh-pages)

    $ bundle exec middleman build
    $ bundle exec middleman deploy

## Data

Put markdown files into the `documents` folder and run

    $ rake

to generate `data/documents.json` (all the paragraph data), `data/important.json` (significant words per paragraph), and `data/distances.json` (the paragraph distances).

### Format

    # Parteiname

    ## Überschrift

    Text

    ### Zwischenüberschrift

    Text

The documents will be split at every ## Überschrift and ### Zwischenüberschrift

## Tweaking

See the top of `index.html.haml`

## License

The MIT License (MIT)

Copyright (c) 2014 Daniel Kirsch, Martin Honermeyer, Tobias Bradtke, Yannic Schencking

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
