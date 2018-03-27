# Project-Analyzer
A Unix tool that runs pmd, cpd, and cloc on java github projects and return an html report.

## Depedencies
Must have pmd installed with pmd run script in the `/usr/local/bin` and called `pmd.sh`

Must have pmd libraries in `/usr/local/lib` in a directory called `pmd`

Must have cloc installed in `/usr/local/bin` and called `cloc`

## Installation

On Mac or Linux simply execute the install script from inside the project directory
`$ ./install.sh`

Currently no installation for windows

## Usage

To run the tool simply pass use the following command in terminal
`project-analyzer.sh -p <HTTP github link>

Example...
`project-analyzer.sh -p https://github.com/chennaione/sugar.git`
