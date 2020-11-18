# Welcome to the new project!
# Please mind to maintain the structure of this file
# and the total project as it is

# Libraries - You hould add your own libraries here
import pathlib
import os

# Main
if __name__ == "__main__":

    # Getting parent directory
    current_path = pathlib.Path(__file__).parent.absolute()
    parent_path = pathlib.Path(current_path).parent

    # Specifying input and output folder
    inputFolder = str(parent_path) + '/input/analysis/'
    outputFolder = str(parent_path) + '/output/analysis/'

    # Checking if output folder exists, otherwise create it
    if not os.path.exists(outputFolder):
        os.makedirs(outputFolder)
    
    ############## ANALYSIS ###############
    # This is the analysis part
    # Feel free to write your own code here

    # EXAMPLE - Please read it and then remove the lines 28-44,
    # in order fill your own code

    # Reading input file
    inputFile = inputFolder + 'example.txt'
    f = open(inputFile, "r")
    print(f.read())
    f.close()
    
    # Storing data to output folder
    outputString = 'This is the output string.'
    outputFile = outputFolder + 'output.txt'
    f = open(outputFile, 'w')
    f.write(outputString)
    f.close()

    # GOOD LUCK