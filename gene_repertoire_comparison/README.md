# gene_repertoire_comparison
Gene repertoire comparison (?)

## Execution instructions
- **input**: Inputs are placed inside the folder /input. Inputs should be of similar format as Repertoires_Summary.V.GENE_X.txt, where X is the file code (e.g. EN107). There is no need to specify the inputs inside the R script. The only two things which should be scpecified are the file code types and the corresponding groups, in lines 18 and 19 respectively. For example, in this case we have two types of file codes, the EN type (e.g. EN107) and the T type (e.g. T3166). The corresponding gene groups are "EN" and "CIN" and, thus, the two variables are named in the proper way.
- **output**: Output is placed in the folder /output.
- **execute**: Just run the script, but first remember to specify the file code types and the corresponding gene groups, as descibed above.
- **Installing required packages**: Uncomment and run lines 6-9 of the script. Hopefully, everything will be installed in the proper way, however it obviously depends on the R version.
