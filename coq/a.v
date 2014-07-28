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

Inductive yn : Type :=
  | yes : yn
  | no : yn.

Print yn_rect.

Definition not (a:yn):yn :=
  match a with
  | yes => no
  | no => yes
end.

Inductive bin : Type :=
  | t : bin
  | f : bin.
(* not *)
Definition nt (a:bin):bin :=
  match a with 
  | t => f
  | f => t
end.
(* and *)
Definition n (a:bin) (b:bin) :bin :=
  match a with
  | f => f
  | t => b
end.
(* or *)
Definition v (a:bin) (b:bin) :bin :=
  match a with
  | t => t
  | f => b
end.
Example test_or1: (v t f) = t.
Proof. reflexivity. Qed.
Example test_or2: (v f f) = f.
Proof. reflexivity. Qed.
Example test_or3: (v f t) = t.
Proof. reflexivity. Qed.
Example test_or4: (v t t) = t.
Proof. reflexivity. Qed.

(* not and *)
Definition nn (a:bin) (b:bin) : bin :=
  nt (n a b).

Definition n3 (a:bin) (b:bin) (c:bin) : bin :=
  (n a (n b c)).

Example test_andb31: (n3 t t t) = t.
Proof. reflexivity.  Qed.
Example test_andb32: (n3 f t t) = f.
Proof. reflexivity. Qed.
Example test_andb33: (n3 t f t) = f.
Proof. reflexivity. Qed.
Example test_andb34: (n3 t t f) = f.
Proof. reflexivity. Qed.

Check (n3 t t).

Module Play.

Inductive nat : Type :=
 | O : nat
 | S : nat -> nat.

Definition pred (n:nat) : nat :=
  match n with
    | O => O
    | S nn => nn
end.

End Play.

Check (S (S (S (S O)))).

Fixpoint evenn (n:nat) : bin :=
match n with
 | O => t
 | S 0 => f
 | S (S n') => evenn n'
end.

Check (evenn 5).
Eval compute in (evenn 5).
Eval compute in (evenn 6).

Module Play2.
Fixpoint plus (n:nat) (m:nat) : nat :=
match n with 
 | O => m
 | S n' => S (plus n' m)
end.
Eval compute in (plus (S (S 0)) 8).

Fixpoint mul (n m :nat):nat :=
match n with
| O => O
| S n' => plus m (mult n' m)
end.
Example testmul: (mult 8 (S (S (S O)))) = 24.
Proof. reflexivity. Qed.

Fixpoint fac(n:nat):nat :=
match n with
| O => S O
| S m => mul (S m) (fac m)
end.

Eval compute in fac 8.
Example testfac1 : fac 3 = 6.
Proof. reflexivity. Qed.
Example tetsfac2 : fac 5 = (mult 10 12).
Proof. reflexivity. Qed.

Notation "x + y" := (plus x y) 
  (at level 50, left associativity) : nat_scope.
Notation "x - y" := (minus x y)
                       (at level 50, left associativity)
                       : nat_scope.
Notation "x * y" := (mult x y)
                       (at level 40, left associativity)
                       : nat_scope.
Notation "x !" := (fac x)
  (at level 60) : nat_scope.

Eval compute in  7 ! + 1.
Example testnotat: 7 ! + 1 = 50 * 100 + 41.
Proof. reflexivity. Qed.


End Play2.


