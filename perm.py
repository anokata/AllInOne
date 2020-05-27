import itertools

a = [
"lisa",        
"^^",        
"krasa",        
"kisa",        
"nyaka",        
"kis",        
"234134",        
#"rainlin",        
#"8880748",        
#"kotic",        
"_",        
#"^^",        
"255134",        
]
#for i in list(itertools.permutations(a)):
    #print("".join(i))
for l in range(3,4):
    for i in list(itertools.combinations(a, l)):
        print("".join(i))
