<?php
$result = false;
/**
 * Clear apc cache
 *
 * @see http://stackoverflow.com/questions/911158/how-to-clear-apc-cache-entries/3580939#3580939
 */
if (isset($_SERVER['REMOTE_ADDR']) && function_exists('apc_clear_cache')) {
	apc_clear_cache();
	apc_clear_cache('user');
	apc_clear_cache('opcode');
	$result = true;
}
echo json_encode(array('success' => $result));
