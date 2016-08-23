import re
import sys
from string import Template

#read a file word by word and pass them into that method
def read_file():
    f = open("Alice.txt")#raw_input("Please Enter File to Translate:"))
    f_string = f.read()
    words = f_string.split()
    words = map(pigify_word,words)
    #could do below if youw ant pigify_word to return instead of just printing
    ##map(print,words)


#######this block pigifies 1 word
def pigify_word(word):
    w = str.lower(re.sub(r'(\w*?(?=[aeiou]))([aeiou]\w*)',('\g<2>\g<1>${voc}ay'),word))
    w = Template(w)
    if re.match(r'[aeiou]',word) is not None:
        w = w.substitute(voc="y")
    else:
        w = w.substitute(voc="")
    sys.stdout.write(str.capitalize(w) + " ")
#######


read_file()
