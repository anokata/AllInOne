ask_name(Name) :-
        new(D, dialog('Register')),
        send(D, append(new(NameItem, text_item(name)))),
        send(D, append(button(ok, message(D, return,
                                          NameItem?selection)))),
        send(D, append(button(cancel, message(D, return, @nil)))),
        send(D, default_button(ok)),
        get(D, confirm, Rval),
        free(D),
        Rval \== @nil,
        Name = Rval.
%- manpce. -%
%help(some). "dsfdf" new send free or E
% [dfdf]

