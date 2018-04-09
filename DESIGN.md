# Overall Design

## Dependencies
 - PMD <https://pmd.github.io/pmd-6.2.0/>
 	- Used to find some design/code smells in the code
 - CPD <https://pmd.github.io/pmd-6.2.0/>
 	- Used to find duplicated code
 - Cloc <http://cloc.sourceforge.net/>
 	- Used to find basic code statistics
 - Git <https://git-scm.com/>
 	- Used to download projects from github
 - Saxon <http://www.saxonica.com/welcome/welcome.xml>
 	- Used to create the final report

## Files
Tablep
| File                                       | Purpose                                      |
|:------------------------------------------:|:--------------------------------------------:|
| /usr/local/bin/                            | All executables should be saved here include project-analyzer.sh |
| /usr/local/var/project-analyzer/resources/ | Holds xslt and ruleset files described below |
| /usr/local/var/project-analyzer/tmp/       | Holds temporary files such as cpd and cloc output which will be deleted after run |
| Project-analyzer.sh                        | The main shell script saved in /usr/local/bin |
| Ruleset.xml                                | Describes a custom rulset for PMD            |
| pmd-filter.xslt                            | A xslt transform used to change the output XML of PMD into a formatted HTML Table |
| cpd-filter.xslt                            | A xslt transform used to change the output XML of CPD into a formatted HTML Table |
| cloc-filter.xslt                           | A xslt transform used to change the output XML of Cloc into a formatted HTML Table |


## Architecture/Program Flow
In short, the tool works by using a shell script (Project-analyzer.sh) to download a project using git and then execute 3 static analysis tools (PMD, CPD, Cloc). Each of these tools outputs in xml format the tool then uses Saxon (A tool that uses executes XSLT transforms) to change the XML output of each tool into an HTML Table and save it into a report file which is then saved to the desktop. So in short the project works in 7 basic steps...
1) Initialization
	- In this step the script reads in command line arguments and initializes the necessary variables for this run.
	- Currently the only command line option is `-p` which indicates the github link for the project to analyze
2) Get Project
	- Using Git the project given in the command line arguments will be downloaded
	- The project is saved in `usr/local/var/project-analyzer/githubowner_projectName.git/`
	- The project location is saved with the `$projectLocation` variable in `project-analyzer.sh`
3) Run PMD
	- Runs CPD on the project
	- Uses the ruleset saved in `Ruleset.xml` described in the Files section
	- PMD has an option to automatically run an xslt transform on its outputted xml which is used
	- Final output is `githubowner_projectName.git-report.html` with just the pmd table and is saved in `/usr/local/var/project-analyzer/tmp/`
4) Run CPD
	- Runs CPD on the project
	- Uses minimum-tokens=100 This means two pieces of code must share at least 100 tokens to be counted as duplicate
	- Outputs an XML File called `githubowner_projectName.git-cpd.xml` in `/usr/local/var/project-analyzer/tmp/`
5) Run Cloc
	- Runs cloc on the project
	- Outputs an XML File called `githubowner_projectName.git-cloc.xml` in `/usr/local/var/project-analyzer/tmp/`
6) Compile Report
	- Uses Saxon to execute xslt transforms saved in `/usr/local/var/project-analyzer/resources/` on `githubowner_projectName.git-cpd.xml` and `githubowner_projectName.git-cloc.xml`
	- XML Reports are transformed into HTML tables and appended to `githubowner_projectName.git-report.html` created after running pmd
7) Delete Project
	- Copies `githubowner_projectName.git-report.html` to the users desktop
	- Uses `rm` call to delete the project and the temporary file saved in `/usr/local/var/project-analyzer/tmp/`

## The script

TODO: Add links to helpful documents

The project-analyzer is a simple bash shell script that runs three static analysis tools and creates a report. The Script works in 7 steps.

- 1) Initialzation
	In this step the script takes in the command line arugments and sets up some variable locations that will be needed when executing commands later.
	
	The name of the project is set as the github user and the project name .git.

	For Example if the given project https://github.com/camdenvoigt/Project-Analyzer.git
	than the `$projectName` variable would be set to `camdenvoigt_Project-Analyzer.git`.

	The `$projectName` is then used to create complete paths saved in the rest of the variables.

- 2) Get Project
	In this step the script downloads the source files using the project link provided from the command line and the git clone command. The files are saved in /usr/local/var/project-analyzer/$projectName.

	Example command would be 
		`git clone --quiet https://github.com/camdenvoigt/Project-Analyzer.git /usr/local/var/project-analyzer/camdenvoigt_Project-Analyzer.git

- 3) Run PMD
	In this step PMD is run on the source files and html file is outputted with the results formatted in a table via an xslt transformation.

	PMD command line options used
		- -d : This specifies the location of the source files
		- -r : This specifies the name and location of the output file
		- -R : This specifies the custom ruleset file that exisits in /usr/local/var/project-analyzer/resources
		- -f : xslt This tells pmd take the output xml and do an xslt transformation on it before sending it to the output file
		- -property xsltFilename= : This option is just to tell pmd where the xslt file is located. It is located in /usr/local/var/project-analyzer/resources/ and called pmd-filter.xslt

	The ruleset is specified in an XML file as this is the easiest way to maintain a large number of rules as the other option was to specifiy them all in a comma seperated list in the command line call. 

- 4) Run CPD
	In this step CPD is run on the source file and an xml file is outputted with the results.

	CPD command line options used
		- --minimum-tokens=100 : this tells CPD that it should only find duplicates with 100 or more tokens matched. I thought this was a good number as it would cover even small duplicated methods and loops, but leaves out duplicate variable names or simple duplicated one liners. This is one area that could easily be changed and could produce very different results

		- --files <$projectLocation> : This tells CPD where the source files are
		- --format xml : This tells cpd to output the results in xml format

	The `> $cpdOut` at the end writes the stdout into the file specified by the `$cpdOut` variable. This lets the script acces the results later.

- 5) Run Cloc
	In this step Cloc is run on the source files and an xml file is outputted with the results.

	Cloc command line arguments used
		- --xml : Tells cloc to output in xml format
		- --quiet : gets rid of unneeded output
		- --report-file= : Tells Cloc where the output file is located
		- the last argument is the location of the project but does not have a tag

	The `2> /dev/null` outputs some extranious output to nowhere so it is not seen.

- 6) Compile Report
	In this step xslt transformations are run on the CPD and Cloc output files and saved into the report file that was created when PMD ran. The report file is than moved to the Desktop of the user.

	The xslt transformations are done using a command line tool called saxon.
	Saxon command line arguments used
		- -s:<source-file> : tells saxon where to find the source file. In this case these are the CPD and Cloc output files located in /usr/local/var/project-analyzer/tmp.
		- -xsl:<xsl-file> : tells saxon where to find the xslt file. In this case these are the CPD and Cloc output files located in /usr/local/var/project-analyzer/resources. (cpd-filter.xslt or cloc-filter.xslt)

	The `>> $report` at the end of the commands append the output of the saxon command to the report file. 

	Finally the report is moved to the desktop using the `mv <source> <target>` command.

- 7) Delete Project
	After compiling the report the script removes all the temporary output files and all the files from the project using the `rm` command. Multiple of these are needed to ensure all files are deleted. the 2> /dev/null ensures output does not print.

