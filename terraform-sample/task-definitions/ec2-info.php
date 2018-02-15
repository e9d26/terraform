<html>

<!-- インスタンスメタデータとユーザーデータ - Amazon Elastic Compute Cloud : https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-metadata.html -->
<!-- カスタム Docker イメージ「harashun/custom-nginx-php-fpm」に配置されているphpファイルです -->

  <head>
    <title>test application</title>
  </head>

  <body>

<!-- 1~5 -->

  <h3>Local IPv4 = <?php
   $localipv4 = file_get_contents('http://169.254.169.254/latest/meta-data/local-ipv4');
   echo $localipv4;
?></h3>

  <h3>Instance ID = <?php
   $instance_id = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id');
   echo $instance_id;
?></h3>

  <h3>AMI ID = <?php
   $amiid = file_get_contents('http://169.254.169.254/latest/meta-data/ami-id');
   echo $amiid;
?></h3>

  <h3>Host Name = <?php
   $hostname = file_get_contents('http://169.254.169.254/latest/meta-data/hostname');
   echo $hostname;
?></h3>

<h3>IAM = <?php
   $iam = file_get_contents('http://169.254.169.254/latest/meta-data/iam/');
   echo $iam;
?></h3>

<!-- 6~10 -->

<h3>AMI Launch Index = <?php
   $amilaunchindex = file_get_contents('http://169.254.169.254/latest/meta-data/ami-launch-index');
   echo $amilaunchindex;
?></h3>

<h3>Instance Action = <?php
   $instanceaction = file_get_contents('http://169.254.169.254/latest/meta-data/instance-action');
   echo $instanceaction;
?></h3>

<h3>Instance Type = <?php
   $instancetype = file_get_contents('http://169.254.169.254/latest/meta-data/instance-type');
   echo $instancetype;
?></h3>

<h3>Block Device Mapping = <?php
   $blockdevicemapping = file_get_contents('http://169.254.169.254/latest/meta-data/block-device-mapping/');
   echo $blockdevicemapping;
?></h3>

<h3>Local Hostname = <?php
   $localhostname = file_get_contents('http://169.254.169.254/latest/meta-data/local-hostname');
   echo $localhostname;
?></h3>

<!-- 11~15 -->

<h3>Mac = <?php
   $mac = file_get_contents('http://169.254.169.254/latest/meta-data/mac');
   echo $mac;
?></h3>

<h3>Metrics = <?php
   $metrics = file_get_contents('http://169.254.169.254/latest/meta-data/metrics/');
   echo $metrics;
?></h3>

<h3>Network = <?php
   $network = file_get_contents('http://169.254.169.254/latest/meta-data/network/');
   echo $network;
?></h3>

<h3>Placement = <?php
   $placement = file_get_contents('http://169.254.169.254/latest/meta-data/placement/');
   echo $placement;
?></h3>

<h3>AMI Manifest Path = <?php
   $amimanifestpath = file_get_contents('http://169.254.169.254/latest/meta-data/ami-manifest-path');
   echo $amimanifestpath;
?></h3>

<!-- 16~20 -->

<h3>Profile = <?php
   $profile = file_get_contents('http://169.254.169.254/latest/meta-data/profile');
   echo $profile;
?></h3>

<h3>Public Hostname = <?php
   $publichostname = file_get_contents('http://169.254.169.254/latest/meta-data/public-hostname');
   echo $publichostname;
?></h3>

<h3>Public IPv4 = <?php
   $publicipv4 = file_get_contents('http://169.254.169.254/latest/meta-data/public-ipv4');
   echo $publicipv4;
?></h3>

<h3>Public Keys = <?php
   $publickeys = file_get_contents('http://169.254.169.254/latest/meta-data/public-keys/');
   echo $publickeys;
?></h3>

<h3>Reservation ID = <?php
   $reservationid = file_get_contents('http://169.254.169.254/latest/meta-data/reservation-id');
   echo $reservationid;
?></h3>

<!-- 21~22 -->

<h3>Security Groups = <?php
   $securitygroups = file_get_contents('http://169.254.169.254/latest/meta-data/security-groups');
   echo $securitygroups;
?></h3>

<h3>Services = <?php
   $services = file_get_contents('http://169.254.169.254/latest/meta-data/services/');
   echo $services;
?></h3>

  </body>

</html>