# Already implemented scripts
In this folder are placed already implemented scripts that perfrom specific jobs.

## arc_diagram.R
- **input**: Inputs are placed inside the '/input/arc_diagram' folder of the remote project directory. Inputs should be of similar format as Clonotypes_X.txt files, where X = {14, 19, 20}. Inside the R script, inputs are specified in lines 30-32.
- **output**: Output is placed in the folder '/output/arc_diagram' folder of the remote project directory.
- **execute**: Just run the script, but first remember to specify the inputs in the script, as descibed above.
- **Installing required packages**: Uncomment and run lines 7-11 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.


## cloning_comparison.R
- **input**: Inputs are placed inside the '/input/cloning_comparison' folder of the remote project directory. Inputs should be of similar format as Statistics_New.xlsx file. Inside he R script, input is specified in line 38.   
- **output**: Output is placed in the folder '/output/cloning_comparison' folder of the remote project directory.
- **execute**: Just run the script, but first remember to specify the input in the script, as descibed above.
- **Installing required packages**: Uncomment and run lines 6-14 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.

## gene_repertoire_comparison.R
- **input**: Inputs are placed inside the '/input/gene_repertoire_comparison' folder of the remote project directory. Inputs should be of similar format as Repertoires_Summary.V.GENE_X.txt, where X is the file code (e.g. EN107). There is no need to specify the inputs inside the R script. The only two things which should be specified are the file code types and the corresponding groups, in lines 22 and 23 respectively. For example, in this case we have two types of file codes, the EN type (e.g. EN107) and the T type (e.g. T3166). The corresponding gene groups are "EN" and "CIN" and, thus, the two variables are named in the proper way.
- **output**: Output is placed in the folder '/output/gene_repertoire_comparison' folder of the remote project directory.
- **execute**: Just run the script, but first remember to specify the file code types and the corresponding gene groups, as descibed above.
- **Installing required packages**: Uncomment and run lines 6-9 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.


## Important note
**If you add any script in this folder, please don't skip to add details in this README file**
