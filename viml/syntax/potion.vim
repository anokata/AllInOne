if exists("b:current_syntax")
    finish
endif

syntax keyword potionKeyword loop times to while
syntax keyword potionKeyword if elsif else
syntax keyword potionKeyword class return
syntax keyword potionFunction print join string
highlight link potionKeyword Keyword
highlight link potionFunction Function
syntax match potionComment "\v#.*$"
highlight link potionComment Comment

syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\="
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="

syntax match potionNumber "\v\d+"
"0xffaf, 123.23, 1e-2, 1.9956e+2
syntax match potionNumber "\v\d+"
syntax match potionNumber "\v\d+e[+-]?\d+"
syntax match potionNumber "\v\d+.\d+"
syntax match potionNumber "\v\dx[0-9abcdef]*"

syntax region potionString start=/\v"/ skip=/\v\\./ end=/\v"/

highlight link potionOperator Operator
highlight link  potionNumber Number
highlight link potionString String

let b:current_syntax = "potion"
