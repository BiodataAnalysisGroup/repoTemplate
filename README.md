# Bioanalytics
A summary template repository, which contains all nessecary scripts that perform various processes, like constructing diagrams, statistically analyzing data and so on.

# Scripts
Brief description of scripts in **alphabetical order**. 

## arc_diagram.R
- **Short description**: Creating arc diagrams (?)
- **input**: Inputs are placed inside the folder arc_diagram/input. Inputs should be of similar format as Clonotypes_X.txt files, where X = {14, 19, 20}. Inside the R script, inputs are specified in lines 28-30.   
- **output**: Output is placed in the folder arc_diagram/output.
- **execute**: Just run the script, but first remember to specify the inputs in the script, as descibed above.
- **Installing required packages**: Uncomment and run lines 7-11 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.

## cloning_comparison.R
- **Short description**: Cloning comparison (?).
- **input**: Input is placed inside the folder cloning_comparison/input. Inputs should be of similar format as Statistics_New.xlsx file. Inside he R script, input is specified in line 34.   
- **output**: Output is placed in the folder cloning_comparison/output.
- **execute**: Just run the script, but first remember to specify the input in the script, as descibed above.
- **Installing required packages**: Uncomment and run lines 6-14 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.

## gene_repertoire_comparison.R
- **Short description**: Gene repertoire comparison (?)
- **input**: Inputs are placed inside the folder gene_repertoire_comparison/input. Inputs should be of similar format as Repertoires_Summary.V.GENE_X.txt, where X is the file code (e.g. EN107). There is no need to specify the inputs inside the R script. The only two things which should be scpecified are the file code types and the corresponding groups, in lines 18 and 19 respectively. For example, in this case we have two types of file codes, the EN type (e.g. EN107) and the T type (e.g. T3166). The corresponding gene groups are "EN" and "CIN" and, thus, the two variables are named in the proper way.
- **output**: Output is placed in the folder gene_repertoire_comparison/output.
- **execute**: Just run the script, but first remember to specify the file code types and the corresponding gene groups, as descibed above.
- **Installing required packages**: Uncomment and run lines 6-9 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.
