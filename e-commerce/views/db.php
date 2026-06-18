<?php

$host = 'db-obligatorio.cfanplfpi7x9.us-east-1.rds.amazonaws.com';
$name = 'ecommerce';
$user = 'admin';
$password = 'admin1234';

try {
	$pdo = new PDO("mysql:host=$host;dbname=$name", $user, $password);
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch( PDOException $exception ) {
	echo "Connection error :" . $exception->getMessage();
}
