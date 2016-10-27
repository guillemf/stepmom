

#Description

stepmom is a command line tool that helps you to find duplicates and group different cucumber steps in a single one.
To do it you need to follow the standard commandline convention rules that apply to any 

#Synopsis

To use stemom utility you need to call in through the commandline using the following synopsis

~~~
stepmom [global options] command [command options] [arguments...]
~~~
#Global Options
All the options need to be prepended with a double hypen for long option as in 

~~~
--help
~~~

and with single hypen for short versions.

Some options have the short and large version, so for path option you can call it as 

~~~
-p /feature/steps/main_steps.rb
~~~

For the short version or 

~~~
--path=/feature/steps/main_steps.rb
~~~

For the long version. In both cases the result is the same.

The available options are:

+ **help**: Show a brief but complete help on how to use the tool
+ **i**, **[no-]info**: Show information about the file. The default is no so you just need to include it to show the 
+ **p**, **path=**_Path_: Path to the steps (default: ./steps). If a folder is selected will review all .rb files in the folder and if a single file is selected only that file will be inspected.
+ **version**: Display the tool version

#Commands
    
##check
Performs a check to compare all steps against all steps to find duplicates or possible substitutes

~~~
stepmom check
~~~

If duplicated or too similar steps are found will be displayed along the selected information in options.

##help
Shows a list of commands or help for one command

##initconfig
Initialize the config file using current global options. See YAML options file for more information.

##list
List all steps in the selected files

###Synopsis
~~~
    stepmom [global options] list [command options] file_pattern
~~~

###Description
This command will list all the steps contained in the files specified by path option. If no option is passed, the app will list the steps contained in current folder. If no file pattern is set, all files with 'rb' extension will be included in the list.

###Command Options
As in the global options short options when exist should be prepended with single hypen and long options with double

+ **f** : Show file name 
+ **k** : Show Keyword
+ **s**, **sort**=_sorting_ : Sort list. Options are ASC and DESC (default: No sort)

Example:
~~~
stepmom -p /feature/steps list --sort=ASC

stepmom --path=/features/steps list -s ASC
~~~


##search
Look for a specific step definition in the selected files

###Synopsis
~~~
    stepmom [global options] search [command options] steps_search
~~~

###Description
This command helps you find a step definition that matches a step description. If -r flag is set will execute regular expressions in the step definition, otherwise they will be threated like a regular step.

###Command Options

+ **d**, **definition**=_definition_ : Step definition to search, defaults to empty search
+ **m**, **max**=_maxdistance_ : Maximum distance measured using Demerau-Levenshtein algorithm, see explanation of distance below. Defaults 0
+ **r**, **regex**=_expression_ : Use regular expressions, defaults to empty expression.

Examples:
~~~
stepmom -p /feature/steps search --definition="Given(/^I am (.* )?on the Homepage$/) do"
stepmom -p /feature/steps search -d "Given(/^I am (.* )?on the Homepage$/) do" -m 8
stepmom -p /feature/steps search --regex="I tap MAC back button"
~~~

####Distance measurement between two steps
The Damerau–Levenshtein distance (named after Frederick J. Damerau and Vladimir I. Levenshtein) is a distance (string metric) between two strings, i.e., finite sequence of symbols, given by counting the minimum number of operations needed to transform one string into the other, where an operation is defined as an insertion, deletion, or substitution of a single character, or a transposition of two adjacent characters. In his seminal paper, Damerau not only distinguished these four edit operations but also stated that they correspond to more than 80% of all human misspellings. Damerau's paper considered only misspellings that could be corrected with at most one edit operation.

The Damerau–Levenshtein distance differs from the classical Levenshtein distance by including transpositions among its allowable operations. The classical Levenshtein distance only allows insertion, deletion, and substitution operations. Modifying this distance by including transpositions of adjacent symbols produces a different distance measure, known as the Damerau–Levenshtein distance.

##test
Test which steps would match a step description in the selected files

###Synopsis
~~~
    stepmom [global options] test step_test
~~~

###Description
This command helps you to test in which step definitions a specific step would be executed in the selected file or folder.

###Command Options

Examples:

~~~
stepmom -p /feature/steps test "Given I am on the Homepage"
~~~