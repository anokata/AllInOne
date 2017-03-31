<?php

# :let file=expand('%:t:r')
# :vnew
# :for i in [1, 2, 3] 
# :normal ggdG
# :execute "silent r! make " . g:file . " && sleep"
# :endfor


echo 'hello';



