<?php

$PATH_INFO = $_SERVER['PATH_INFO'];//pass from htaccss
$PI = explode("/", mb_substr(trim($PATH_INFO), 1));
//print_r($PI);
$REQ_URI = $_SERVER['REQUEST_URI'];
$CONTENT = explode("?", mb_substr(trim($REQ_URI), 1));
$deeplink_type = "";
$deeplink_id = "";

if (count($CONTENT)>=2){
    $deeplink_id = trim($CONTENT[0]);   //deeplink/
    $deeplink_type = trim($CONTENT[1]); //addfriend&code...
}

//Detect special conditions devices
$iPod = stripos($_SERVER['HTTP_USER_AGENT'], "iPod");
$iPhone = stripos($_SERVER['HTTP_USER_AGENT'], "iPhone");
$iPad = stripos($_SERVER['HTTP_USER_AGENT'], "iPad");
$Android = stripos($_SERVER['HTTP_USER_AGENT'], "Android");
$AndroidDownurl = "https://play.google.com/store/apps/details?id=de.bladenight.bladenight_app_flutter";
$iOSDownurl = "https://apps.apple.com/de/app/bladenight-m%C3%BCnchen/id1629988473";

$deeplink_url = "bna://bladenight.app/" . $deeplink_type . "/" . $deeplink_id;
$app_url = "";
if ($iPod || $iPhone) {
    //browser reported as an iPhone/iPod touch -- do something here
    //header("Location: $iOSDownurl");
    $app_url = $iOSDownurl;
} else if ($iPad) {
    //browser reported as an iPad -- do something here
    header("Location: $iOSDownurl");
    $app_url = $iOSDownurl;
} else if ($Android) {
    //browser reported as an Android device -- do something here
    //header("Location: $AndroidDownurl");
    $app_url = $AndroidDownurl;
} else {
    //browser reported as a webOS device -- do something here
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Win") !== FALSE) {
        //header("Location: $AndroidDownurl");
        $app_url = $AndroidDownurl;
    } else if (strpos($_SERVER['HTTP_USER_AGENT'], "Mac") !== FALSE) {
        //header("Location: $iOSDownurl");
        $app_url = $iOSDownurl;
    }
}

$bn_url="bna://bladenight.app/?". $deeplink_id;
$bn_site_name = "Bladenight App";
$bn_title = "Bladenight App";
$bn_description = "Bladnight App Unilinks";
$bn_image = "BnLogo.png";
$bn_image_width = "512";
$bn_image_height = "512";

if (!empty($deeplink_type) && (!empty($deeplink_id))) {
    if (in_array($deeplink_type, ['addFriend', 'dl','message'])) {
        //fetch some information to replace og data.
        //$bn_image='...';
        //$bn_description='...';
        $deeplink_url=$bn_url;
    } else {
        $deeplink_url=$bn_url;
    }
} else {
    $deeplink_url="";
}
if (!empty($deeplink_url)) {
    sleep(1);
    //header("Location:".$deeplink_url);
} else {
    $deeplink_url = $app_url;
}
//echo $PATH_INFO;
//schemes https://developers.facebook.com/docs/applinks/metadata-reference/
?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo $bn_title; ?></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./css/bootstrap.min.css">
    <script src="./js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="./css/smartbanner.min.css">
    <script src="./js/smartbanner.min.js"></script>

    <meta name="smartbanner:title" content="BladeNight App">
    <meta name="smartbanner:author" content="Lars Huth Skatemunich e.V.">
    <meta name="smartbanner:button" content="Öffnen">
    <meta name="smartbanner:button-url-apple" content="<?php echo $iOSDownurl ?>">
    <meta name="smartbanner:button-url-google" content="<?php echo $AndroidDownurl ?>">
    <meta name="smartbanner:close-label" content="Schließen">

    <link rel="icon" href="../favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="../favicon.ico" type="image/x-icon" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-itunes-app" content="app-id=app.huth.bn, app-argument=<?php echo $CONTENT ?>"/>
    <meta name="google-play-app" content="app-id=de.bladenight.bladenight_app_flutter">


</head>
<body>
<div class="row">
    <div class="col-md-8 text-center">
        <h2>Öffne BladeNight App</h2>
        <a class="btn btn-block"><img src="BnLogo.png" height="100"/></a>
    </div>
    <div class="col-md-8 text-center">
        <a class="btn btn-block" href="<?php echo $AndroidDownurl;?>"><img src="PlayStore.png" height="100"/></a>
        <a class="btn btn-block" href="<?php echo $iOSDownurl;?>"><img src="AppleStore.png" height="100"/></a>
    </div>
</div>
<div class="text-center">
    <button type="submit" onclick="location.href = '<?php echo $bn_url;?>';">App öffnen</button>
</div>
<?php
if (!empty($deeplink_url)) {
    echo '<script type="text/javascript">
        setTimeout(function () {
            location.href = "' , $deeplink_url .'"
            return false;
        }, 500);
    </script>';
}
?>
</body>
</html>
