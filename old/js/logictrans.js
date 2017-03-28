// ���������� ������� � �����
// (A -> (B -> A))
// �������, ��� ���� � ��, ���� � �� �.
// (A -> (B -> C)) -> ((A -> B) -> (A -> C))
// 

// A - A, -A - �� �
function translate_atom(atom) {
return atom.isNegated ? "not " + atom.text else atom.text;
}


function lex_parse(input) {
var tokens = [];

for (var i = 0; i < input.length; i++)
switch (input[i]) {
  case "-":
    if ((input[i+1]) == ">") tokens.push({
      "text":"->",
      "type":"implication"
    });
    break;
  case " ":
    break;
  
}

return tokens;
}