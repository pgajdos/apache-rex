<?php

$plaintext = "message to be encrypted";
$method = 'AES-256-CBC';
$key = random_bytes(32);
$iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length($plaintext));
$encrypted = openssl_encrypt($plaintext, $method, $key, $options=0, $iv);
$decrypted = openssl_decrypt($encrypted, $method, $key, $options=0, $iv);

echo $decrypted." -> ".$encrypted." "."\n";

?>

