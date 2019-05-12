def is_ru(char):
    if ord(char) in range(ord("а"),ord("я")+1) or ord(char) in range(ord("А"),ord("Я")+1):
        return True
    if char in ["ё", "Ё"]:
        return True
    return False

def extract_ru(line):
    result = ""
    start_ru = False
    end_ru = False
    for char in line:
        if is_ru(char) and not end_ru:
            result += char
            start_ru = True
        if not start_ru: continue
        if start_ru and not end_ru and char == ",":
            end_ru = True
        if ord(char) in range(ord("0"),ord("9")+1):
            result += char
        if char in [" ", ".", "\t", "ё", "Ё"]:
            result += char
        if char == "-" and not end_ru:
            result += char
    return result

with open("cities15000.txt") as fin:
    line = fin.readline()
    while line:
        line = extract_ru(line)
        if len(line) > 5:
            print(line)
        line = fin.readline()

