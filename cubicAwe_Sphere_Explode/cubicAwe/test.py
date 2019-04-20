import glob

read_files = sorted(glob.glob("./frames/*.txt"))

with open("result.txt", "wb") as outfile:
    for f in read_files:
        with open(f, "rb") as infile:
            outfile.write(infile.read())


# cat result.txt | tr -d '\n' > oneline.txt
