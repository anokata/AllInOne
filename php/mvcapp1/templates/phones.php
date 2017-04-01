<article>
Phones:
<table border=1>
<?php foreach($data as $row) : ?>
    <tr>
    <td> <?= $row['name'] ?> </td>
    <td> <?= $row['phone'] ?> </td>
    </tr>
<?php endforeach ?>
</table>
</article>
