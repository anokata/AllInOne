Inductive day : Type :=
  | mon : day
  | tue : day
  | sun : day.

Definition nextWknd ( d : day ) : day :=
  match d with 
  | mon => sun
  | tue => tue
  | sun => mon
end.

(* Print nextWknd. *)
Eval compute in (nextWknd tue).
Eval compute in (nextWknd sun).
Example testnw :  (nextWknd ( nextWknd sun)) = sun.

Proof. simpl. reflexivity. Qed.

