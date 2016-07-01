<?php
/**
 * Clear OPcache
 *
 */
$result = false;
if (isset($_SERVER['REMOTE_ADDR']) && function_exists('opcache_reset')) {
	$result = opcache_reset();
}
echo json_encode(array('success' => $result));
