<?php
$host=$_SERVER['HTTP_HOST'];
/*
Directory Listing Script - Version 7
====================================
Script Author: Vitaliy Lednev. www.vrn.com.ru
*/
$startdir = '.';
$showthumbnails = false; 
$showdirs = true;
$forcedownloads = false;
$hide = array(
				'dlf',
				'public_html',				
				'index.php',
				'Thumbs',
				'.htaccess',
				'_file-manager',
				'.quarantine',
				'.tmb',
				'.htpasswd'
			);
$displayindex = false;
$allowuploads = false;
$overwrite = false;
 
$indexfiles = array (
				'index.html',
				'index.htm',
				'default.htm',
				'default.html'
			);
 
$filetypes = array (
				'png' => 'jpg.gif',
				'jpeg' => 'jpg.gif',
				'bmp' => 'jpg.gif',
				'jpg' => 'jpg.gif', 
				'gif' => 'gif.gif',
				'zip' => 'archive.png',
				'rar' => 'archive.png',
				'exe' => 'exe.gif',
				'setup' => 'setup.gif',
				'txt' => 'text.png',
				'htm' => 'html.gif',
				'html' => 'html.gif',
				'php' => 'php.gif',				
				'fla' => 'fla.gif',
				'swf' => 'swf.gif',
				'xls' => 'xls.gif',
				'doc' => 'doc.gif',
				'sig' => 'sig.gif',
				'fh10' => 'fh10.gif',
				'pdf' => 'pdf.gif',
				'psd' => 'psd.gif',
				'rm' => 'real.gif',
				'mpg' => 'video.gif',
				'mpeg' => 'video.gif',
				'mov' => 'video2.gif',
				'avi' => 'video.gif',
				'eps' => 'eps.gif',
				'gz' => 'archive.png',
				'asc' => 'sig.gif',
			);
 
error_reporting(0);
if(!function_exists('imagecreatetruecolor')) $showthumbnails = false;
$leadon = $startdir;
if($leadon=='.') $leadon = '';
if((substr($leadon, -1, 1)!='/') && $leadon!='') $leadon = $leadon . '/';
$startdir = $leadon;
 
if($_GET['dir']) {
	//check this is okay.
 
	if(substr($_GET['dir'], -1, 1)!='/') {
		$_GET['dir'] = $_GET['dir'] . '/';
	}
 
	$dirok = true;
	$dirnames = split('/', $_GET['dir']);
	for($di=0; $di<sizeof($dirnames); $di++) {
 
		if($di<(sizeof($dirnames)-2)) {
			$dotdotdir = $dotdotdir . $dirnames[$di] . '/';
		}
 
		if($dirnames[$di] == '..') {
			$dirok = false;
		}
	}
 
	if(substr($_GET['dir'], 0, 1)=='/') {
		$dirok = false;
	}
 
	if($dirok) {
		 $leadon = $leadon . $_GET['dir'];
	}
}
 
 
 
$opendir = $leadon;
if(!$leadon) $opendir = '.';
if(!file_exists($opendir)) {
	$opendir = '.';
	$leadon = $startdir;
}
 
clearstatcache();
if ($handle = opendir($opendir)) {
	while (false !== ($file = readdir($handle))) { 
		//first see if this file is required in the listing
		if ($file == "." || $file == "..")  continue;
		$discard = false;
		for($hi=0;$hi<sizeof($hide);$hi++) {
			if(strpos($file, $hide[$hi])!==false) {
				$discard = true;
			}
		}
 
		if($discard) continue;
		if (@filetype($leadon.$file) == "dir") {
			if(!$showdirs) continue;
 
			$n++;
			if($_GET['sort']=="date") {
				$key = @filemtime($leadon.$file) . ".$n";
			}
			else {
				$key = $n;
			}
			$dirs[$key] = $file . "/";
		}
		else {
			$n++;
			if($_GET['sort']=="date") {
				$key = @filemtime($leadon.$file) . ".$n";
			}
			elseif($_GET['sort']=="size") {
				$key = @filesize($leadon.$file) . ".$n";
			}
			else {
				$key = $n;
			}
			$files[$key] = $file;
 
			if($displayindex) {
				if(in_array(strtolower($file), $indexfiles)) {
					header("Location: $file");
					die();
				}
			}
		}
	}
	closedir($handle); 
}
 
//sort our files
if($_GET['sort']=="date") {
	@ksort($dirs, SORT_NUMERIC);
	@ksort($files, SORT_NUMERIC);
}
elseif($_GET['sort']=="size") {
	@natcasesort($dirs); 
	@ksort($files, SORT_NUMERIC);
}
else {
	@natcasesort($dirs); 
	@natcasesort($files);
}
 
//order correctly
if($_GET['order']=="desc" && $_GET['sort']!="size") {$dirs = @array_reverse($dirs);}
if($_GET['order']=="desc") {$files = @array_reverse($files);}
$dirs = @array_values($dirs); $files = @array_values($files);
 
 
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <link href="http://sitescopy.ru/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="77; url=http://vk.com/sitescopyru" />
<title>Добро пожаловать на <? print $host; ?>!</title>
<style type="text/css">
#container h1 {
	text-align: center;
}
h1 {
	text-align: center;
}
#container #breadcrumbs p {
	text-align: center;
}
p {
	text-align: center;
}
a:link {
	text-decoration: none;
	color: #039;
}
a:visited {
	text-decoration: none;
	color: #093;
}
a:hover {
	text-decoration: none;
	color: #999;
}
a:active {
	text-decoration: none;
	color: #666;
}
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
}
</style>
<link rel="stylesheet" type="text/css" href="http://cpanel.sitescopy.ru/images/index/styles.css" />
</head>
<body>
<div>
<p><a href="http://sitescopy.ru/" target="_blank"><img src="http://sitescopy.ru/e3w.png" alt="Райский хостинг в облаках" width="281" height="84" border="0" align="center" /></a>
<div  class="sitescopy" style="text-align: center; font-size: 33px;">
    Ваш веб-сайт<br /><a href="http://<? print $host; ?>" target="_blank"><strong><? print $host; ?></strong></a><br />уже работает!
  </div>
  <div>
    <p>Ваш аккаунт для нового сайта <strong><? print $host; ?></strong> активирован и готов к эксплуатации.</p>
    <p>Теперь Вы можете удалить этот файл &quot;<strong>default.php</strong>&quot; из папки <strong>public_html</strong><br /> и установить в эту папку свой сайт, используя FTP-клиент, Файл Менеджер,<br />
      Авто Установщик или Конструктор Сайтов своей <a href="http://cpanel.sitescopy.ru/" target="_blank">панели управления</a>.</p>
    <p>Ниже отображено текущее содержимое папки <strong>public_html</strong> этого сайта:</p>
  </div>
  <div id="container">
  <div id="listingcontainer">
    <div id="listingheader">
      <div id="headerfile">Файл</div>
      <div id="headersize">Размер</div>
      <div id="headermodified">Дата</div>
    </div>
    <div id="listing">
      <?
	$class = 'b';
	if($dirok) {
	?>
      <div><a href="<?=$dotdotdir;?>" class="<?=$class;?>"><img src="http://cpanel.sitescopy.ru/images/index/dirup.png" alt="Folder" /><strong>..</strong> <em>-</em>
        <?=date ("M d Y h:i:s A", filemtime($dotdotdir));?>
        </a></div>
      <?
		if($class=='b') $class='w';
		else $class = 'b';
	}
	$arsize = sizeof($dirs);
	for($i=0;$i<$arsize;$i++) {
	?>
      <div><a href="<?=$leadon.$dirs[$i];?>" class="<?=$class;?>"><img src="http://cpanel.sitescopy.ru/images/index/folder.png" alt="<?=$dirs[$i];?>" /><strong>
        <?=$dirs[$i];?>
        </strong> <em>-</em>
        <?=date ("M d Y h:i:s A", filemtime($leadon.$dirs[$i]));?>
        </a></div>
      <?
		if($class=='b') $class='w';
		else $class = 'b';	
	}
 
	$arsize = sizeof($files);
	for($i=0;$i<$arsize;$i++) {
		$icon = 'unknown.png';
		$ext = strtolower(substr($files[$i], strrpos($files[$i], '.')+1));
		$supportedimages = array('gif', 'png', 'jpeg', 'jpg');
		$thumb = '';
 
		if($filetypes[$ext]) {
			$icon = $filetypes[$ext];
		}
 
		$filename = $files[$i];
		if(strlen($filename)>43) {
			$filename = substr($files[$i], 0, 40) . '...';
		}
 
		$fileurl = $leadon . $files[$i];
	?>
      <div><a href="<?=$fileurl;?>" class="<?=$class;?>"<?=$thumb2;?>><img src="http://cpanel.sitescopy.ru/images/index/<?=$icon;?>" alt="<?=$files[$i];?>" /><strong>
        <?=$filename;?>
        </strong> <em>
        <?=round(filesize($leadon.$files[$i])/1024);?>
        Kб</em>
        <?=date ("M d Y h:i:s A", filemtime($leadon.$files[$i]));?>
        <?=$thumb;?>
        </a></div>
      <?
		if($class=='b') $class='w';
		else $class = 'b';	
	}	
	?>
    </div>
  </div>
  </div>
</div>
    <p><a href="http://sitescopy.ru/" target="_blank">Всегда с Вами - Ваш SitesCopy.ru - Райский хостинг в облаках</a></p>
</body>
</html>
<!--DEFAULT_WELCOME_PAGE-->
