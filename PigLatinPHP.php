<html>
<head>
<title>Pig Latin Translator</title>
</head>
<body>
<?php
    $fp = fopen("alice.txt", "r") or die("can't read alice.txt");
    while (!feof($fp)) {
        $line = fgets($fp);
        $line = strtolower($line);
        $line = preg_replace_callback(
            '|([^aeiou]*)([aeiou]\w*)|',
            function ($matches) {
                if(substr($matches[1],0,1) === "a" || substr($matches[1],0,1) === "e" || substr($matches[1],0,1) === "i" || substr($matches[1],0,1) === "o" || substr($matches[1],0,1) === "u"){
                return trim($matches[2]).trim($matches[1])."yay ";
                }else{
                return trim($matches[2]).trim($matches[1])."ay ";
                }
            },
            $line
        );
        echo ucfirst($line);
    }
    fclose($fp);
?>
</body>
</html>
