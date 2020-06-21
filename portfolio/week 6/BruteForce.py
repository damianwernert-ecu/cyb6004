#!/usr/bin/python3
import hashlib
import itertools
import string

#hidden password hash
passwordHash = "8b7df143d91c716ecfa5fc1730022f6b421b05cedee8fd52b1fc65a96030ad52"   # "blah", this cracks relatively quickly
#passwordHash = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"   # "hello", this takes a while longer

# Key space tokens
charList = string.ascii_lowercase + string.ascii_uppercase + "0123456789"

# Define a word separator. When the product method is called, it will generate a word in a tuple which needs to be combined
# into a single stext string. The separator between each character of this string is the null string.
wordSeparator = ""

# Run hash checks with passwords of length 1-8 inclusive. Note that the range function here produces a list of numbers from
# 0 - 7
for wordLength in range(8):

    # The itertools.product method produces a tuple of all combinations of the characters from "charList", for the length
    # described by "repeat=". As our wordLength values will begin at zero, we need to add 1 to wordLength to make
    # itertools.product work properly.
    for wordTuple in itertools.product(charList,repeat=wordLength + 1):

        # Join the tuple produced by itertools.product into a single string called word
        word = wordSeparator.join(wordTuple)

        # Hash the generated word and print plaintext password and its hash.
        wordHash = hashlib.sha256(word.encode("utf-8")).hexdigest()
        print("Trying password %s: %s" % (word,wordHash))

        #if the hash is the same as the correct password's hash then we have cracked the password!
        if(wordHash == passwordHash):
            print(f"Password has been cracked! It was {word}")
            exit(0)

# If we get this far, then we haven't figured out the hash. Exit with failure (i.e. we did not crack the password)
print("\n")
exit(1)
