str1 = input("Enter first string: ")
str2 = input("Enter second string: ")

result = str1 + " " + str2

print("Concatenated String:", result)

print("lower():", result.lower())

print("upper():", result.upper())

print("title():", result.title())

print("swapcase():", result.swapcase())

print("capitalize():", result.capitalize())

print("casefold():", result.casefold())

print("center():", result.center(40, '*'))

print("count():", result.count("a"))

print("endswith():", result.endswith("a"))

print("find():", result.find("a"))

print("isalnum():", result.isalnum())

print("isdigit():", result.isdigit())

print("isnumeric():", result.isnumeric())

print("isspace():", result.isspace())

print("replace():", result.replace("a", "@"))