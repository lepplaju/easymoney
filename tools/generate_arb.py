#!/usr/bin/env python3

#TODO: Recursive search from folders for input files

import sys, getopt
import os

is_first_run_en = True
is_first_run_fi = True

def write_arb_en(filename, output_file, input_path):
    
    global is_first_run_en
    with open(input_path+"/"+filename, "r") as input_file:
        print("[CONVERTING FILE] "+input_path+"/"+filename)
        for line in input_file:
            if line.startswith("//") or line.startswith("\n"):
                continue
            if line.startswith("name"):
                name = line.split(":")
                name = name[1].strip()
                if not is_first_run_en:
                    output_file.write(",\n")
                else:
                    is_first_run_en = False
                output_file.write("\t"+name+": ")
            if line.startswith("text_en"):
                text = line.split(":")
                text = text[1].strip()
                output_file.write(text+",\n\t"+"\"@"+name[1:]+": {\n\t\t")
            if line.startswith("description"):
                desc = line.split(":")
                desc = desc[1].strip()
                output_file.write("\"description\": "+desc+",\n\t\t")
            if line.startswith("type"):
                type = line.split(":")
                type = type[1].strip()
                output_file.write("\"type\": "+type+",\n\t\t")
            if line.startswith("placeholders"):
                place = line.split(":")
                place = place[1].strip()
                place = place.strip("\"")
                output_file.write("\"placeholders\": "+place+"\n\t}")

def write_arb_fi(filename, output_file, input_path):
    global is_first_run_fi
    with open(input_path+"/"+filename, "r") as input_file:
        print("[CONVERTING FILE] "+input_path+"/"+filename)
        for line in input_file:
            if line.startswith("//") or line.startswith("\n"):
                continue
            if line.startswith("name"):
                name = line.split(":")
                name = name[1].strip()
                if not is_first_run_fi:
                    output_file.write(",\n")
                else:
                    is_first_run_fi = False
                output_file.write("\t"+name+": ")
            if line.startswith("text_fi"):
                text = line.split(":")
                text = text[1].strip()
                output_file.write(text)
        

def main():
    input_path = ""
    output_path = ""
    # Parses arguments without the program name
    argumentList = sys.argv[1:]
    options = "hi:o:"
    long_options = ["help", "inputpath", "outputpath"]

    try:
        arguments, values = getopt.getopt(argumentList, options, long_options)
        for currentArgument, currentValue in arguments:
            if currentArgument in ("-h", "--help"):
                print("""-i\tIs the path to location which holds all input 
                files. This shoul look something like <./lib/l10n/locals>""")
                print("\n")
                print("""-o\tIs the path to location which will be used to hold the 
                output files. This should look something like <./lib/l10n>""")
                return
            elif currentArgument in ("-i", "--inputpath"):
                print("[Input path is]: "+currentValue)
                input_path = currentValue
            elif currentArgument in ("-o", "--outputpath"):
                print("[Output path is]: "+currentValue)
                output_path = currentValue
    except:
        print("Could not parse. Check --help")
    

    if not os.path.isdir(input_path):
        print("ERROR - input path - [No such directory]: "+input_path)
        return
    if not os.path.isdir(output_path):
        print("ERROR - output path - [-No such directory]: "+output_path)
        print("Generated directory "+output_path)
        os.mkdir(output_path)

    output_file = open(output_path+"/app_en.arb", "w")
    print("================================================")
    print("[GENERATING FILE] "+output_path+"/app_en.arb")
    output_file.write("{\n")
    for filename in os.listdir(input_path):
        print("[Input file found]: "+filename)
        write_arb_en(filename, output_file, input_path)
    output_file.write("\n}")
    output_file.close()

    output_file = open(output_path+"/app_fi.arb", "w")
    print("================================================")
    print("[GENERATING FILE] "+output_path+"/app_fi.arb")
    output_file.write("{\n")
    for filename in os.listdir(input_path):
        write_arb_fi(filename, output_file, input_path)
    output_file.write("\n}")
    output_file.close()

if __name__ == "__main__":
    main()