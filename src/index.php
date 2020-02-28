<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
<?php
$annee = date('Y');
$noel = mktime(8, 0, 0, 03, 26, $annee);
		
 if ($noel < time())
 $noel = mktime(8, 0, 0, 03, 26, ++$annee);

 $tps_restant = $noel - time(); // $noel sera toujours plus grand que le timestamp actuel, vu que c'est dans le futur. ;)

//============ CONVERSIONS

$i_restantes = $tps_restant / 60;
$H_restantes = $i_restantes / 60;
$d_restants = $H_restantes / 24;


$s_restantes = floor($tps_restant % 60); // Secondes restantes
$i_restantes = floor($i_restantes % 60); // Minutes restantes
$H_restantes = floor($H_restantes % 24); // Heures restantes
$d_restants = floor($d_restants); // Jours restants
//==================

setlocale(LC_ALL, 'fr_FR');

echo 'Nous sommes le '. strftime('<strong>%d %B %Y</strong>, et il est <strong>%Hh%M</strong>') .'.<br />'

   . 'Il reste exactement <strong>'. $d_restants .' jours</strong>, <strong>'. $H_restantes .' heures</strong>,'
   . ' <strong>'. $i_restantes .' minutes</strong> et <strong>'. $s_restantes .'s</strong> avant de boire un coup ! <:o).';

?>
 </body>
</html>
