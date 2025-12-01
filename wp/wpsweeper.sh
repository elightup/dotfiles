#!/usr/bin/env bash

#################################### WP SWEEPER #########################################
#     This script helps to clean infected WordPress sites, replace core/plugin/theme    #
#     files and find malacious code that was injected into the website.                 #
#     Developed by Brecht Ryckaert.                                                     #
#     Support: Please refer to the documentation of WP Sweeper.                         #
#########################################################################################

#################################### Requirements #######################################
#     Checking if all prerequisites are present to enable full functionality.           #
#########################################################################################
if ! hash awk 2>/dev/null
then
    echo "'awk' is not available for use."
    exit 1
elif ! hash cut 2>/dev/null
then
    echo "'cut' is not available for use."
    exit 1
elif ! hash egrep 2>/dev/null
then
    echo "'egrep' is not available for use."
    exit 1
elif ! hash find 2>/dev/null
then
    echo "'find' is not available for use."
    exit 1
elif ! hash grep 2>/dev/null
then
    echo "'grep' is not available for use."
    exit 1
elif ! hash printf 2>/dev/null
then
    echo "'printf' is not available for use."
    exit 1
elif ! hash uniq 2>/dev/null
then
    echo "'uniq' is not available for use."
    exit 1
elif ! hash xargs 2>/dev/null
then
    echo "'xargs' is not available for use."
    exit 1
else
    #all good, clear the screen
    clear
fi

###################################### Globals ##########################################
#     Setting global variables and functions used throught the entire script.           #
#########################################################################################

### Working directory ###
# Used to make sure the script can return to the "home" folder
workingdirectory=$(pwd)

### Date and time ###
# Meant for timestamping the logfile
datetime=$(date +%Y-%m-%d.%H:%M:%S)

### Core version ###
version=$(grep wp_version wp-includes/version.php | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")

### Backup ###
# Declare the variable "backup" and set its value to 0.
declare -i backup=0

### Display the logo ###
function display_logo {
    echo "__      ___ __  _____      _____  ___ _ __   ___ _ __ "
    echo "\ \ /\ / / '_ \/ __\ \ /\ / / _ \/ _ \ '_ \ / _ \ '__|"
    echo " \ V  V /| |_) \__ \\ V  V /  __/  __/ |_) |  __/ |   "
    echo "  \_/\_/ | .__/|___/ \_/\_/ \___|\___| .__/ \___|_|   "
    echo "         | |                         | |              "
    echo "         |_|                         |_|              "
    echo "                                         wpsweeper.com"
    echo "Version 1.0.3                                         "
    echo ""
}

###################################### Globals ##########################################
#             Declare functionalities used troughout several functions                  #
#########################################################################################
function initialize_logfile {
    display_logo >> $workingdirectory/wpsweeper-$datetime.log
}

################################ Malware definitions ####################################
#          Malware signatures for detection of malicious or suspicious files            #
#########################################################################################
function general_remove_onboarding_form_jpg {
    # Removes Malware.Expert.generic.eval.gzinflate.strrot13.base64.1
    echo "onboarding_form_jpg"
    find . -type f -name onboarding_form.jpg | xargs grep -F 'LUrXEqu4tvyaqTP3DVmu81HOOZqXRnEwOYevv2/PuHkshKQlpF7draUZ7r+3/lXWe6iWv8ehXGP0f/MypfPyajH86uL' | cut -d ":" -f1 | uniq | xargs rm -rfv >> $workingdirectory/infectionlist.log
}

function general_remove_win_trojan_hide_1 {
    # Removes Win.Trojan.Hide-1
    echo "win_trojan_hide_1"
    find . -type f \( -name "*.gif" -or -name "*.jpg" -or -name "*.jpeg" -or -name "*.php" \) | xargs grep -F 'GIF89a' | cut -d ":" -f1 | uniq | xargs rm -rfv >> $workingdirectory/infectionlist.log
}

function general_remove_inputfiles {
    echo "general_remove_inputfiles"
    general_inputfiles=$(find | grep -lP "./_input_\d_.[[:alnum:]]+")
    printf "%s\n" "$general_inputfiles" >> $workingdirectory/infectionlist.log
}

function general_remove_ico {
    echo "general_remove_ico"
    remove_icofiles=$(find . -name ".*.ico")
    printf "%s\n" "$remove_icofiles" >> $workingdirectory/infectionlist.log
}

function general_remove_suspected {
    echo "general_remove_suspected"
    remove_suspectedfiles=$(find . -name "*.suspected")
    printf "%s\n" "$remove_suspectedfiles" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_joomla_malware_1 {
    # Finds Malware.Expert.generic.joomla.malware.1 infections
    echo "generic_joomla_malware_1"
    generic_joomla_malware_1files=$(find . -type f \( -name "cjsxf.php" -or -name "gyovh.php" -or -name "dbpqz.php" -or -name "_input_1_test.php*"  \))
    printf "%s\n" "$generic_joomla_malware_1files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_base64_post_3 {
    # Finds Malware.Expert.Generic.Eval.Base64.Post.3
    echo "generic_eval_base64_post_3"
    generic_eval_base64_post_3files=$(find . -iname '*.php' -exec grep -lP '\<\?php\s\/\*457563643\*\/\serror_reporting\(0\)' {} \;)
    printf "%s\n" "$generic_eval_base64_post_3files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_base64_decode_21 {
    # Finds Malware.Expert.generic.base64.decode.21
    echo "generic_base64_decode_21"
    generic_base64_decode_21files=$(find . -iname '*.php' -exec grep -lP '\$xpg5l1\=\"8esJBn\+qkWeSSHuWdYtPTS2K2' {} \;)
    printf "%s\n" "$generic_base64_decode_21files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_uploader_max_706 {
    # Finds php.uploader.max.706
    echo "php_uploader_max_706"
    php_uploader_max_706files=$(find . -iname '*.php' -exec grep -lP "\{\sif\(\@copy\(\\\$\_FILES\['file\'\]\[\'tmp\_name\'\]\,\s\\\$\_FILES\[\'file\'\]\[\'name\'\]\)\)\s\{\secho\s\'\<b\>Upload\sSuccess\s\!\!\!\<\/b\>\<\<\/script\>\<br\>\<br\>\'\;\s\}\selse\s\{\secho\s\'\<b\>Upload\sFail\s\!\!\!\<\/b\>\<br\>\<br\>\'\;\s\}\}" {} \;)
    printf "%s\n" "$php_uploader_max_706files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_create_function_10 {
    # Finds Malware.Expert.generic.create.function.10
    echo "generic_create_function_10"
    generic_create_function_10files=$(find . -type f -name "*.php" -or -name "*.suspected" -exec grep -lP "for\s\(\\\$[a-zA-Z0-9_]+\s\=\s0\;\s\\\$[a-zA-Z0-9_]+\s\<\sstrlen\(\\\$[a-zA-Z0-9_]+\)\s\&\&\s\\\$[a-zA-Z0-9_]+\s\<\sstrlen\(\\\$[a-zA-Z0-9_]+\)\;\s\\\$[a-zA-Z0-9_]+\+\+\,\s\\\$[a-zA-Z0-9_]+\+\+\)" {} \;)
    printf "%s\n" "$generic_create_function_10files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_82 {
    # Finds Malware.Expert.generic.eval.82 infections
    echo "generic_eval_82"
    generic_eval_82files=$(find . -type f -name ".*.ico" -exec grep -lP "\\\$[a-zA-Z0-9_]+\s\=\sbasename\/[a-zA-Z0-9_*]+\/\(\/[a-zA-Z0-9_*]+\/trim\/[a-zA-Z0-9_*]+\/\(\/[a-zA-Z0-9_*]+\/preg_replace\/[a-zA-Z0-9_*]+\/\(\/[a-zA-Z0-9_*]+\/rawurldecode\/[a-zA-Z0-9_*]+\/\(\/[a-zA-Z0-9_*]+\/" {} \;)
    printf "%s\n" "$generic_eval_82files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_gzinflate_base64_15 {
    # Finds Malware.Expert.generic.eval.gzinflate.base64.15 infections
    echo "generic_eval_gzinflate_base64_15"
    generic_eval_gzinflate_base64_15files=$(find . -type f -exec grep -lP 'eval\(\"\\n\\\$dgreusdi\s\=\sintval\(\_\_LINE\_\_\)\s\*\s337\;\"\)\;' {} \;)
    printf "%s\n" "$generic_eval_gzinflate_base64_15files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_fwrite_htaccess_4 {
    # Finds Malware.Expert.generic.fwrite.htaccess.4 infections
    echo "generic_fwrite_htaccess_4"
    generic_fwrite_htaccess_4files=$(find . -type f \( -name "*.php" -or -name "*.zip" \) -exec grep -lP 'curl\_setopt\(\$ch\,\sCURLOPT\_URL\,\s\"http\:\/\/snijorsz\.pw\/story2\.php\?q\=\$query\_pars\_2\&pass\=qwerty8\"\)\;' {} \;)
    printf "%s\n" "$generic_fwrite_htaccess_4files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_webShellOrb_web_shell_0 {
    # Removes Malware.Expert.WebShellOrb.web.shell.0 infections
    echo "webShellOrb_web_shell_0"
    webShellOrb_web_shell_0files=$(find . -type f -name "*.php" -exec grep -lP '\\\$[a-zA-Z0-9]+\=file\(\_\_FILE\_\_\)\;eval\(base64\_decode\(\"[a-zA-Z0-9]+\"\)\)\;eval\(base64\_decode\([a-zA-Z0-9]+\(\\\$[a-zA-Z0-9]+\)\)\)\;' {} \;)
    printf "%s\n" "$webShellOrb_web_shell_0files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_b374k_shell_3 {
    # Finds Malware.Expert.b374k.shell.3 infections
    echo "b374k_shell_3"
    b374k_shell_3files=$(find . -type f -exec grep -lP '\\\$s\_func\=\"cr\"\.\"eat\"\.\"e\_fun\"\.\"cti\"\.\"on\"\;\$b374k\=\@\\\$s\_func\(' {} \;)
    printf "%s\n" "$b374k_shell_3files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_124 {
    # Finds Malware.Expert.generic.malware.124 infections
    echo "generic_malware_124"
    generic_malware_124files=$(find . -type f -name "*.php" -exec grep -lP '\<\?php\s\\\$\{\"\\x47L\\x4fBALS\"\}\[\"\\x6egajuf\\x66\"\]\=\"\\x6d\"\;\\\$\{\"\\x47\\x4cO\\x42A\\x4c\\x53\"\}' {} \;)
    printf "%s\n" "$generic_malware_124files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_172 {
    # Finds Malware.Expert.generic.malware.172 infections
    echo "generic_malware_172"
    generic_malware_172files=$(find . -type f -exec grep -lP '(\\\$q[0-9\s\=\s\"[O0]+\"\;){15}' {} \;)
    printf "%s\n" "$generic_malware_172files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_shell_black_id_700 {
    # Finds PHP.Shell.Black.Id.700 infections
    echo "php_shell_black_id_700"
    php_shell_black_id_700files=$(find . -type f -name "*.php" -exec grep -lP '\,\"\\x65\\x76\\x61\\x6C\\x28\\x67\\x7A\\x69\\x6E\\x66\\x6C\\x61\\x74\\x65\\x28\\x62\\x61' {} \;)
    printf "%s\n" "$php_shell_black_id_700files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_base64_v23au_187 {
    # Finds PHP.Base64.V23au.187 Variant A infections
    echo "php_base64_v23au_187"
    php_base64_v23au_187files=$(find . -type f \( -name "*.php" -or -name "*.ico" \) -exec grep -lP "\\\$[a-z]+\s\=\s[0-9]+\;\sfunction\s[a-z]+\(\\\$[a-z]+\,\s\\\$[a-z]+\)\{\\\$[a-z]+\s\=\s\'\'\;\sfor\(\\\$i\=0\;\s\\\$i\s\<\sstrlen\(\\\$[a-z]+\)\;\s\\\$i\+\+\)" {} \;)
    printf "%s\n" "$php_base64_v23au_187files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_79 {
    # Finds Malware.Expert.Generic.Eval.79 infections
    echo "generic_eval_79"
    generic_eval_79files=$(find . -type f -name "*.php" -exec grep -lP "\<\?php\s\\\$[a-z0-9]+\s\=\s[0-9]+\;\\\$GLOBALS\[\'[a-z0-9]+\'\]\s\=\sArray\(\)\;global\s\\\$[a-z0-9]+\;\\\$[a-z0-9]+\s\=\s\\\$GLOBALS\;\\\$\{" {} \;)
    printf "%s\n" "$generic_eval_79files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_135 {
    # Finds Malware.Expert.Generic.Malware.135 infections
    echo "generic_malware_135"
    generic_malware_135files=$(find . -type f -name "*.php" -exec grep -lP '\<\?php\s\\\$[a-z]+\s\=\s\"[a-z]+\"\;\\\$[a-z]+\s\=\s\"\"\;foreach\s\(\\\$\_POST\sas\s\\\$[a-z]+\s\=\>\s\\\$[a-z]+\)\{if\s\(strlen\(\\\$[a-z]+\)\s\=\=\s16\sand\ssubstr\_count\(\\\$[a-z]+\,\s\"\%\"\)\s\>\s10\)' {} \;)
    printf "%s\n" "$generic_malware_135files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_27 {
    # Finds Malware.Expert.Generic.Eval.27 infections
    echo "generic_eval_27"
    generic_eval_27files=$(find . -type f -name "*.php" -exec grep -lP '\<\?php\serror\_reporting\(0\)\;\\\$\_[a-zA-Z0-9]+\=\"[a-zA-Z0-9]+\"\;\\\$\_[a-zA-Z0-9]+\=array\([0-9,]+\)\;\$payload\=\"([a-zA-Z0-9+]+\/){25}' {} \; )
    printf "%s\n" "$generic_eval_27files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_uploader_6 {
    # Finds Malware.Expert.Generic.Uploader.6 infections
    echo "generic_uploader_6"
    generic_uploader_6files=$(find . -type f -name "info.php" -exec grep -lP '\\\$write\s\=\sfwrite\s\(\\\$file\s\,base64\_decode\(\\\$azx\)\)\;' {} \;)
    printf "%s\n" "$generic_uploader_6files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_136 {
    # Finds Malware.Expert.Generic.Malware.136 infections
    echo "generic_malware_136"
    generic_malware_136files=$(find . -type f -name "*.php" -exec grep -lP 'if\(\!function\_exists\(\"TC9A16C47DA8EEE87\"\)\)\{function\sTC9A16C47DA8EEE87\(\\\$T059EC46CFE335260\)\{\\\$T059EC46CFE335260\=base64\_decode\(\\\$T059EC46CFE335260\)\;' {} \;)
    printf "%s\n" "$generic_malware_136files" >> $workingdirectory/infectionlist.log
}

function general_remove_dropsforums_ru_bruteforce_1 {
    # Finds Dropforums.Ru.Bruteforce.1 infections
    echo "dropsforums_ru_bruteforce_1"
    dropsforums_ru_bruteforce_1files=$(find . -type f -name "info.php" -exec grep -lP "\\\$server\_url\s\=\s\'http\:\/\/dropsforums\.ru\/panel[a-zA-Z_/]+\.php\'\;" {} \;)
    printf "%s\n" "$dropsforums_ru_bruteforce_1files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_encoded_zip_file_0 {
    # Removes Malware.Expert.Generic.Encoded.Zip.File.0 infections
    echo "generic_encoded_zip_file_0"
    generic_encoded_zip_file_0files=$(find . -type f -name "*.php" -exec grep -lP 'base64\_decode\(\"UEsDBAoAAAAAAMio204AAAAAAAAAAAAAAAAGAAAAcm9hd2svUEsDBAoAAAAAAKS02U' {} \;)
    printf "%s\n" "$generic_encoded_zip_file_0files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_base64_decode_14 {
    # Finds Malware.Expert.Generic.Eval.Base64.Decode.14A infections
    echo "generic_eval_base64_decode_14A"
    generic_eval_base64_decode_14Afiles=$(find . -type f -name "*.php" -exec grep -lP 'base64\_decode\(\"PD9waHANCmhlYWRlcignQ29udGVudC1UeXBlOnRleHQvaHRtbDsgY2hhcnNldD1VVEYtOCcpOw0KDQpAc2V0X3Rp' {} \;)
    printf "%s\n" "$generic_eval_base64_decode_14Afiles" >> $workingdirectory/infectionlist.log
    # Finds Malware.Expert.Generic.Eval.Base64.Decode.14B infections
    echo "generic_eval_base64_decode_14B"
    generic_eval_base64_decode_14Bfiles=$(find . -type f -name "*.php" -exec grep -lP "\\\$[a-z]+\_code\s\=\s\'PD9waHANCmhlYWRlcignQ29udGVudC1UeXBlOnRleHQvaHRtbDsgY2hhcnNldD1VVEYtOCcpOw0K" {} \;)
    printf "%s\n" "$generic_eval_base64_decode_14Bfiles" >> $workingdirectory/infectionlist.log
    # Finds Malware.Expert.Generic.Eval.Base64.Decode.14C infections
    echo "generic_eval_base64_decode_14C"
    generic_eval_base64_decode_14Cfiles=$(find . -type f -name "*.php" -exec grep -lP 'base64\_decode\(\"Z2lmODlhPD9waHAgQGV2YWwoJF[a-zA-Z0-9+/]+\=\"\)\)\;\s\?\>' {} \;)
    printf "%s\n" "$generic_eval_base64_decode_14Cfiles" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_leaf_mailer_0 {
    # Finds Malware.Expert.Leaf.Mailer.0 infections
    echo "leaf_mailer_0"
    leaf_mailer_0files=$(find . -type f -name "*.php" -exec grep -lP '\*\sLeaf\sPHP\sMailer\sby\s\[leafmailer\.pw\]' {} \;)
    printf "%s\n" "$leaf_mailer_0files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_php_print_md5_0 {
    # Finds Malware.Expert.Php.Print.Md5.0 infections
    echo "php_print_md5_0"
    php_print_md5_0files=$(find . -type f -exec grep -lP 'php\%20print\(md5\(222\)\)\;\$a\=str\_replace\(\%22vbnm\%22\,\%22\%22\,\%22asvbnmsert\%22\)' {} \;)
    printf "%s\n" "$php_print_md5_0files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_post_0 {
    # Finds Malware.Expert.Generic.Eval.Post.0 infections
    echo "generic_eval_post_0"
    generic_eval_post_0files=$(find . -type f -name "vuln.php" -exec grep -lP 'Vuln\!\!\<\?php\s\@eval\(\$\_POST\[pass\]\)\s\?\>' {} \;)
    printf "%s\n" "$generic_eval_post_0files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_178 {
    # Finds Malware.Expert.Generic.Malware.178 Variant A infections
    echo "generic_malware_178"
    generic_malware_178files=$(find . -type f -exec grep -lP "(\\\$[a-zA-Z0-9]+\[[0-9]+\]\.){10,}" {} \;)
    printf "%s\n" "$generic_malware_178files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_base64_decode_24 {
    # Finds Malware.Expert.Generic.Eval.Base64.Decode.24 infections
    echo "generic_eval_base64_decode_24"
    generic_eval_base64_decode_24files=$(find . -type f -name "*.php" -exec grep -lP 'PD9waHAK[a-zA-Z0-9]+' {} \;)
    printf "%s\n" "$generic_eval_base64_decode_24files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_wordpress_file_put_contents_1 {
    # Finds Malware.Expert.WordPress.File.Put.Contents.1 infections
    echo "wordpress_file_put_contents_1"
    wordpress_file_put_contents_1files=$(find . -type f -name "*.php" -exec grep -lP 'PD9waHAK[a-zA-Z0-9]+' {} \;)
    printf "%s\n" "$wordpress_file_put_contents_1files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_98 {
    # Finds Malware.Expert.Generic.Malware.98 infections
    echo "generic_malware_98"
    generic_malware_98files=$(find . -type f \( -name "wp-blogs.php" -or -name "license" -or -name "index.php" \) -exec grep -lP '([b6-9])+\"\)\;foreach\(\$([b6-9])+\sas\\\$([b6-9])+\=\>\\\$([b6-9])+\)' {} \;)
    printf "%s\n" "$generic_malware_98files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_158 {
    # Finds Malware.Expert.Generic.Malware.158 infections
    echo "generic_malware_158"
    generic_malware_158files=$(find . -type f -name "*.php" -exec grep -lP '\{function\sstr\_ireplace\(\$from,\$to\,\\\$string\)\{return\strim\(preg\_replace\(\"\/\"\.addcslashes\(\$from\,\"\?\:\\\\\/\*\^\$\"\)\.\"\/si\"' {} \;)
    printf "%s\n" "$generic_malware_158files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_189 {
    # Finds Malware.Expert.Generic.Malware.189 infections
    echo "generic_malware_189"
    generic_malware_189files=$(find . -type f -name "eval-81809123.php")
    printf "%s\n" "$generic_malware_189files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_malware_magento_594 {
    # Finds PHP.Malware.Magento.594 infections
    echo "php_malware_magento_594"
    php_malware_magento_594files=$(find . -type f -exec grep -lP "\\\$post\=\'[a-z=_&]+\'\.urlencode\(\\\$eval\_sub\)\.\'[a-zA-F0-9=_&.%]+\'\.urlencode\(base64\_encode\(\\\$code\)\)\;" {} \;)
    printf "%s\n" "$php_malware_magento_594files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_nested_base64_641 {
    # Finds PHP.Nested.Base64.641 infections
    echo "php_nested_base64_641"
    php_nested_base64_641files=$(find . -type f \( -name "agger.*.j" -or -name "magic.*.j" \) -exec grep -lP "eval\(gzinflate\(str\_rot13\(base64\_decode\(\'[a-zA-Z0-9/+=]+\'\)\)\)\)\;\s\?\>" {} \;)
    printf "%s\n" "$php_nested_base64_641files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_165 {
    # Finds Malware.Expert.Generic.Malware.165 infections
    echo "generic_malware_165"
    generic_malware_165files=$(find . -type f -name "*.php" -exec grep -lP "[pP]reman[kK]eyboard" {} \;)
    printf "%s\n" "$generic_malware_165files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_steal_user_pass_2 {
    # Finds Malware.Expert.Steal.User.Pass.2 infections
    echo "generic_steal_user_pass_2"
    generic_steal_user_pass_2files=$(find . -type f -name "index.php" -exec grep -lP '\(\"Location\:\shttps\:\/\/aromasnadal.com\/bl\"\)\;' {} \;)
    printf "%s\n" "$generic_steal_user_pass_2files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_cmdshell_cih_233 {
    # Finds PHP CmdShell CIH 233 infections
    echo "generic_php_cmdshell_cih_233"
    generic_php_cmdshell_cih_233files=$(find . -type f -name "*.php" -exec grep -lP 'R0lGODlhJgAWAIAAAAAAAP\/\/\/yH5BAUUAAEALAAAAAAmABYAAAIvjI\+py\+0PF4i0gVvzuVxXDnoQ' {} \;)
    printf "%s\n" "$generic_php_cmdshell_cih_233files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_cmdshell_egyspider_240 {
    # Finds WebShellOrb.Web.Shell.0 infections
    echo "php_cmdshell_egyspider_240"
    php_cmdshell_egyspider_240files=$(find . -type f -name "*.php" -exec grep -lP '\\\$back\_connect\_c\=\"I2luY2x1ZGUgPHN0ZGlvLmg\+[a-zA-Z0-9]+\"\;' {} \;)
    printf "%s\n" "$php_cmdshell_egyspider_240files" >> $workingdirectory/infectionlist.log
}

function general_remove_php_cmdshell_generic_276 {
    # Finds Php.Cmdshell.generic.276 infections
    echo "php_cmdshell_generic_276"
    php_cmdshell_generic_276files=$(find . -type f -name "*.php" -exec grep -lP "\/\*\s\(1n73ction\sshell\sv3\.3\sby\sx\'1n73ct\s\|\sdefault\spass\:" {} \; )
    printf "%s\n" "$php_cmdshell_generic_276files" >> $workingdirectory/infectionlist.log
}

function general_remove_cmb_base64decode_hex {
    # Finds CMB.Base64decode.Hex infections
    echo "cmb_base64decode_hex"
    cmb_base64decode_hexfiles=$(find . -type f -name "*.php" -exec grep -lP 'Configuration\:\:get\(\"(\\[x0-9a-f]+){21}\"\)\;\sgoto\s[A-Za-z0-9]+\;' {} \;)
    printf "%s\n" "$cmb_base64decode_hexfiles" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_155 {
    # Finds Malware.Expert.Generic.Malware.155 infections
    echo "generic_malware_155"
    generic_malware_155files=$(find . -type f -name "*.php" -exec grep -lP "\<\?php\s\\\$GLOBALS\[\'\_[0-9]+\_\'\]\=Array\(\'str\_\'\s\.\'rot13\'\,\'pack\'\,\'st\'\s\.\'rrev\'\)\;\s\?\>\<\?php\sfunction\s\_[0-9]+\(\\\$i\)\{\\\$a\=Array\(" {} \;)
    printf "%s\n" "$generic_malware_155files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_41 {
    # Finds Malware.Expert.Generic.Malware.41 infections
    echo "generic_malware_41"
    generic_malware_41files=$(find . -type f -exec grep -lP '(\$arr\_word\[[0-9]+\]\[\]\s\=\"[0-9]\"\;){120}' {} \;)
    printf "%s\n" "$generic_malware_41files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_uploader_4 {
    # Finds Malware.Expert.Generic.Uploader.4 infections
    echo "generic_uploader_4"
    generic_uploader_4files=$(find . -type f -name "*.php" -exec grep -lP '<\?php\sif\s\(isset\(\\\$\_GET\[\"CONFIG\"\]\)\)\sif\s\(\"02a2e55e48c352aec1c6543581533d38\"\s\=\=\smd5\(\$\_GET\[\"CONFIG\"\]\)\)\{echo\s\"\<form\smethod\=\\\"post\\\"\senctype\=\\\"multipart\/form\-data\\\"\>' {} \;)
    printf "%s\n" "$generic_uploader_4files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_post_8 {
    # Finds Malware.Expert.Generic.Eval.Post.8 infections
    echo "generic_eval_post_8"
    generic_eval_post_8files=$(find . -type f -name "*.php" -exec grep -lP "gif89a\<\?php\s\@eval\(\\\$\_POST\[\'pass\'\]\)\;\?\>" {} \;)
    printf "%s\n" "$generic_eval_post_8files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_filebox_1 {
    # Finds Malware.Expert.Filebox.1 infections
    echo "filebox_1"
    filebox_1files=$(find . -type f -name "*.php" -exec grep -lP "\{if\(\!\@ereg\(\\\$c\,\\\$j\)\)\{\\\$j\=\$c\;\}\}\\\$l\=\\\$j\;if\(\@\\\$\_COOKIE\[\'pass\'\]\!\=md5\(\\\$f\)\)\{if\(\@\\\$\_REQUEST\[\'pass\'\]\=\=\\\$f\)\{setcookie\(\'pass\'\,md5\(\\\$f\)\,time\(\)\+60\*60\*24\*1\)\;\}else\{if\(\@\\\$\_REQUEST\[\'pass\'\]\)\\\$m\=true\;login\(\@\\\$m\)\;\}\}function\smaintop\(\\\$n\,\\\$o\=true\)" {} \;)
    printf "%s\n" "$filebox_1files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_444 {
    # Finds Malware.Expert.generic.malware.444 infections
    echo "generic_malware_444"
    generic_malware_444files=$(find . -type f -name "*.php" -exec grep -lP "(\\\$GLOBALS\[\'[a-zA-Z0-9]+\'\]\[[0-9]+]\.){15}" {} \;)
    printf "%s\n" "$generic_malware_444files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_9 {
    # Finds Malware.Expert.Generic.Eval.9 infections
    echo "generic_eval_9"
    generic_eval_9files=$(find . -type f -name "*.php" -exec grep -lP "\<\?php\s\\\$[a-zA-Z0-9]+\=\'[a-zA-Z0-9]+\([a-zA-Z0-9$_]+\\\'[a-zA-Z0-9$_]+\'\;if\(isset\(\\\$\{(\\\$[a-zA-Z0-9]+\[[0-9]+\]\.){6}\\\$[a-zA-Z0-9]+\[[0-9]+\]\}" {} \;)
    printf "%s\n" "$generic_eval_9files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_uploader_72 {
    # Finds Malware.Expert.Generic.Uploader.4 infections
    echo "generic_uploader_72"
    generic_uploader_72files=$(find . -type f -exec grep -lP "echo\s\'JSSPWNED\!\<br\/\>\<form\saction\=" {} \;)
    printf "%s\n" "$generic_uploader_72files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_mailer_19 {
    # Finds Malware.Expert.Generic.Mailer.19 infections
    echo "generic_mailer_19"
    generic_mailer_19files=$(find . -type f -exec grep -lP 'loader\.php\?email\=\$login\&\.rand\=13InboxLight\.aspx\?n\=1774256418\&fid\=4\#n\=1252899642\&fid\=1\&fav\=1\"\)\;' {} \;)
    printf "%s\n" "$generic_mailer_19files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_preg_replace_post_11 {
    # Finds Malware.Expert.Generic.Preg.Replace.Post.11 infections
    echo "preg_replace_post_11"
    generic_preg_replace_post11files=$(find . -type f -exec grep -lP "\<\?php\sif\s\(\!isset\(\\\$\_REQUEST\[\'e[0-9][0-9]e\'\]\)\)\sheader\(" {} \;)
    printf "%s\n" "$generic_preg_replace_post11files" >> $workingdirectory/infectionlist.log
    cd /tmp
    generic_preg_replace_post11Bfiles=$(find . -type f -exec grep -lP "\<\?php\sif\s\(\!isset\(\\\$\_REQUEST\[\'e[0-9][0-9]e\'\]\)\)\sheader\(" {} \;)
    printf "%s\n" "$generic_preg_replace_post11Bfiles" >> $workingdirectory/infectionlist.log
    cd $workingdirectory
}

function general_remove_malware_expert_generic_malware_86 {
    # Finds Malware.Expert.Generic.Malware.86 infections
    echo "generic_malware_86"
    generic_malware_86files=$(find . -type f -name "*.php" -exec grep -lP "\{(\\\$[a-zA-Z]+.){2,}\.\\\$[a-zA-Z0-9]+\}\;if\(isset\(\\\$[\/*a-zA-Z0-9]+\[\'[a-zA-Z]+\'\]\)\)\{\\\$[a-zA-Z0-9]+\=[\/*\\\$\@!=a-zA-Z0-9]+\[\'[a-zA-Z0-9]+\'\]\." {} \;)
    printf "%s\n" "$generic_malware_86files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_159 {
    # Finds Malware.Expert.Generic.Malware.159 infections
    echo "generic_malware_159"
    generic_malware_159files=$(find . -type f -exec grep -lP "\<\?php\sif\(\!class\_exists\(\'Ratel\'\)\)\{if\(function\_exists\(\'is\_user\_logged\_in\'\)\)\{if\(is\_user\_logged\_in\(\)\)\{return\sfalse\;\}\}if\(\@preg\_match" {} \;)
    printf "%s\n" "$generic_malware_159files" >> $workingdirectory/infectionlist.log
}

function general_remove_win_trojan_hide_2 {
    echo "win_trojan_hide_2"
    win_trojan_hide_2files=$(find . -type f -exec grep -lP '\<\?php\secho\s\"RKntC\-InJ\"\s\.\s\"eCt\.\"\.\"TeSt\"\;\?\>' {} \;)
    printf "%s\n" "$win_trojan_hide_2files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_malware_7 {
    # Finds Malware.Expert.Generic.Malware.7 infections
    echo "generic_malware_7"
    generic_malware_7files=$(find . -type f -name "*.php" -exec grep -lP "(\\\$[a-zA-Z0-9]+\[\'[a-zA-Z0-9]+\'\]\[[0-9]+\]\.){10}" {} \;)
    printf "%s\n" "$generic_malware_7files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_cookie_7 {
    # Finds Malware.Expert.Generic.Cookie.7 infections
    echo "generic_cookie_7"
    generic_cookie_7files=$(find . -type f -name "*.php" -exec grep -lP "\<\?php\sif\(isset\(\\\$\_COOKIE\[\"[a-zA-Z]+\"\]\)\)\{\\\$\_COOKIE\[\"[a-zA-Z]+\"\]\(\\\$\_COOKIE\[\"[a-zA-Z]+\"\]\)\;exit\;\}" {} \;)
    printf "%s\n" "$generic_cookie_7files" >> $workingdirectory/infectionlist.log
}

function general_remove_malware_expert_generic_eval_base64_decode_0 {
    # Finds Malware.Expert.Generic.Eval.Base64.Decode.0 infections
    echo "generic_eval_base64_decode_0"
    generic_eval_base64_decode_0files=$(find . -type f -name "haccess.php" -exec grep -lP '\<\?php\seval\(base64\_decode\(\"[a-zA-Z0-9+]+\"\)\)\;\s\?\>' {} \;)
    printf "%s\n" "$generic_eval_base64_decode_0files" >> $workingdirectory/infectionlist.log
}

############################### Create Restore Point ####################################
#  Creates a backup of the files, folders and database to restore to in case of issues. #
#########################################################################################
function create_backup {
    echo "Will be added in next release!"
  # Function coming in the next update!
}

######################## Restore Backup from Restore Point ##############################
#  Creates a backup of the files, folders and database to restore to in case of issues. #
#########################################################################################
function restore_backup {
    echo "Will be added in next release!"
  # Function coming in the next update!
}

################################# Core Replacement ######################################
#     Replaces the WordPress core files with new versions from the same release.        #
#########################################################################################
function sweep_wp_core {
    # Clear the screen first
    clear
    # Notice onscreen
    echo "Detected WordPress $version. Replacing core files."
    echo "Please hold..."
    # Move into temp folder and check if current version is present in /tmp, else download release zipfile
    cd /tmp
        if [ ! -f wordpress-"$version".zip ]; then
            wget -q https://wordpress.org/wordpress-"$version".zip
        else
            rm -rf wordpress-"$version".zip
            wget -q https://wordpress.org/wordpress-"$version".zip
        fi
    # Extract zipfile
    unzip -q wordpress-"$version".zip
    # Remove zipfile
    rm -rf wordpress-"$version".zip
    # Go to the installed WordPress and remove files and folders (except wp-config.php)
    cd "$workingdirectory"
    rm -rf {wp-admin,wp-includes}
    rm -rf {wp-activate.php,wp-blog-header.php,wp-comments-post.php,wp-config-sample.php,wp-cron.php,wp-links-opml.php,wp-load.php,wp-login.php,wp-mail.php,wp-signup.php,wp-trackback.php,xmlrpc.php}
    # Go to the downloaded release and copy over files and folders (except wp-config.php) to the workingdirectory location
    cd /tmp/wordpress/
    cp -r {wp-admin,wp-includes} "$workingdirectory"/
    cp {index.php,wp-activate.php,wp-blog-header.php,wp-comments-post.php,wp-cron.php,wp-links-opml.php,wp-load.php,wp-login.php,wp-mail.php,wp-settings.php,wp-signup.php,wp-trackback.php,xmlrpc.php} "$workingdirectory"/
    # Remove unzipped WordPress folder after copying the files over
    cd "$workingdirectory"
    rm -rf /tmp/wordpress/
    # Add replaced version to wpsweeper logfile
    echo "######### WordPress Plugins #########" >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    echo "Replaced WordPress version $version with new corefiles from the WordPress.org repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    # Clear the screen and go back to the menu
    gotomenu
}

################################ Plugin Replacement #####################################
#     Replaces the WordPress plugin files with new versions from the same release.      #
#########################################################################################
function plugin_start_logentry {
    echo "Replacing plugins with new version from WordPress.org repository."
    echo "######### WordPress Plugins #########" >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    echo "Below you'll find the plugins that were succesfully replaced by a new version, downloaded from the WordPress.org repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "If a replacement is listed as FAILED, this is caused by one of these reasons:" >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The plugin is a premium plugin (which we can't automatically replace for you)." >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The plugin was removed from the WordPress.org repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The plugin a custom developed code that isn't published to the WordPress.org plugin repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    echo ""
    echo "Currently processing:"
    echo ""
}

function get_plugin_version {
    # Get plugin version and put it into variable $pluginversion
    if [ -f "$plugin/$plugin.php" ]; then
        pluginversion=$(grep Version $plugin/$plugin.php | egrep -o "([0-9]{1,}\.)+[0-9]{1,}"| head -1)
    else
        pluginversion=$(echo '')
    fi
}

function sweep_plugin_noversion {
    # Variable is empty, version not set
    cd /tmp
    wget -q https://downloads.wordpress.org/plugin/$plugin.zip
    # Check if present and deploy  
    if test -f "/tmp/$plugin.zip"; then
        mv $plugin.zip $workingdirectory/wp-content/plugins/
        cd $workingdirectory/wp-content/plugins
        rm -rf $workingdirectory/wp-content/plugins/$plugin
        unzip -q $workingdirectory/wp-content/plugins/$plugin.zip
        rm -rf $plugin.zip
        echo "SUCCESS: $plugin" >> $workingdirectory/wpsweeper-$datetime.log;
    else
        # Plugin not found - reporting
        echo "FAILED: $plugin was not replaced. Not available for download on the wordpress.org plugin repository." >> $workingdirectory/wpsweeper-$datetime.log;
    fi
}

function sweep_plugin_withversion {
    # Variable contains value, version is set
    cd /tmp
    wget -q https://downloads.wordpress.org/plugin/$plugin.$pluginversion.zip
    # Check if present and deploy  
    if test -f "/tmp/$plugin.$pluginversion.zip"; then
        mv $plugin.$pluginversion.zip $workingdirectory/wp-content/plugins/
        cd $workingdirectory/wp-content/plugins
        rm -rf $workingdirectory/wp-content/plugins/$plugin
        unzip -q $workingdirectory/wp-content/plugins/$plugin.$pluginversion.zip
        rm -rf $plugin.$pluginversion.zip
        echo "SUCCESS: $plugin $pluginversion" >> $workingdirectory/wpsweeper-$datetime.log;
    else
        # Plugin not found - reporting
        echo "FAILED: $plugin $pluginversion was not replaced. Not available for download on the wordpress.org plugin repository." >> $workingdirectory/wpsweeper-$datetime.log;
    fi
}

function sweep_wp_plugins {
    # Runner function for the plugin replacement logic.
    clear
    plugin_start_logentry
    # Check is wp-content/plugins is accessible, then cd into it.
    if [[ -d wp-content/plugins ]]
        then 
        cd wp-content/plugins/
        # Run a loop indexing all plugins.
        for plugin in $(ls -d */ | cut -f1 -d'/'); do
            get_plugin_version
            if [ "$plugin" == "index.php" ]; then 
                continue
            elif [ -z "$pluginversion" ]; then
                echo $plugin
                sweep_plugin_noversion
            else
                echo $plugin
                sweep_plugin_withversion
            fi
        done
        cd $workingdirectory
    else
        echo "FAILED: directory "wp-content/plugins" was not accessible/present." >> $workingdirectory/wpsweeper-$datetime.log;
    fi
    echo "" >> $workingdirectory/wpsweeper-$datetime.log;
    # Clear the screen and go back to the menu
    gotomenu
}

################################ Theme Replacement ######################################
#     Replaces the WordPress theme files with new versions from the same release.       #
#########################################################################################
function sweep_wp_themes {
    clear
    echo "Replacing themes with new version from WordPress.org repository..."
    echo ""
    echo "######### WordPress Themes #########" >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    echo "Below you'll find the themes that were succesfully replaced by a new version, downloaded from the WordPress.org theme repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "If a replacement is listed as FAILED, this is caused by one of these reasons:" >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The theme is a premium theme (which we can't automatically replace for you)." >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The theme was removed from the WordPress.org repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "- The theme a custom developed theme that isn't published to the WordPress.org theme repository." >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
        if [[ -d wp-content/themes ]]
        then 
            cd wp-content/themes/
                for theme in $(ls -d */ | cut -f1 -d'/'); do
                    cd /tmp
                    wget -q https://downloads.wordpress.org/theme/$theme.zip
                    # Check if present and deploy  
                    if test -f "/tmp/$theme.zip"; then 
                        cp $theme.zip $workingdirectory/wp-content/themes/
                        cd $workingdirectory/wp-content/themes
                        rm -rf $workingdirectory/wp-content/themes/$theme
                        unzip -q $workingdirectory/wp-content/themes/$theme.zip
                        rm -rf $theme.zip
                        echo "SUCCESS: $theme" >> $workingdirectory/wpsweeper-$datetime.log;
                    else
                        # Theme not found - reporting
                        echo "FAILED: $theme was not replaced. Not available on the wordpress.org theme repository." >> $workingdirectory/wpsweeper-$datetime.log;
                    fi
                done
            cd $workingdirectory
        else
            echo "FAILED: directory "wp-content/themes" was not accessible/present." >> $workingdirectory/wpsweeper-$datetime.log;
        fi
    echo "" >> $workingdirectory/wpsweeper-$datetime.log;
    # Clear the screen and go back to the menu
    gotomenu
}

################################## Malware Scan #########################################
#        Scans the entire working directory for malicious or suspicious files.          #
#########################################################################################
function sweep_malware_scan {
    clear
    echo "Running a malware scan on your website."
    echo "Please hold... This can take a while."
    echo ""
    echo "######### Malware Scan #########" >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    echo "The malicious or suspicious files were found:" >> $workingdirectory/wpsweeper-$datetime.log
    echo "" >> $workingdirectory/wpsweeper-$datetime.log
    # Functions to run the individual signature scans:
    general_remove_inputfiles
    general_remove_ico
    general_remove_suspected
    # Maldet Infection Type signatures below
    general_remove_cmb_base64decode_hex
    general_remove_dropsforums_ru_bruteforce_1
    general_remove_malware_expert_b374k_shell_3
    general_remove_malware_expert_filebox_1
    general_remove_malware_expert_generic_cookie_7
    general_remove_malware_expert_generic_create_function_10
    general_remove_malware_expert_generic_encoded_zip_file_0
    general_remove_malware_expert_generic_eval_27
    general_remove_malware_expert_generic_eval_79
    general_remove_malware_expert_generic_eval_82
    general_remove_malware_expert_generic_eval_base64_decode_0
    general_remove_malware_expert_generic_eval_base64_decode_14
    general_remove_malware_expert_generic_eval_base64_decode_24
    general_remove_malware_expert_generic_eval_base64_post_3
    general_remove_malware_expert_generic_eval_gzinflate_base64_15
    general_remove_malware_expert_generic_eval_post_0
    general_remove_malware_expert_generic_eval_post_8
    general_remove_malware_expert_generic_fwrite_htaccess_4
    general_remove_malware_expert_generic_mailer_19
    general_remove_malware_expert_generic_malware_7
    general_remove_malware_expert_generic_malware_41
    general_remove_malware_expert_generic_malware_86
    general_remove_malware_expert_generic_malware_98
    general_remove_malware_expert_generic_malware_124
    general_remove_malware_expert_generic_malware_135
    general_remove_malware_expert_generic_malware_136
    general_remove_malware_expert_generic_malware_155
    general_remove_malware_expert_generic_malware_158
    general_remove_malware_expert_generic_malware_165
    general_remove_malware_expert_generic_malware_172
    general_remove_malware_expert_generic_malware_178
    general_remove_malware_expert_generic_malware_189
    general_remove_malware_expert_generic_malware_444
    general_remove_malware_expert_generic_preg_replace_post_11
    general_remove_malware_expert_generic_uploader_4
    general_remove_malware_expert_generic_uploader_6
    general_remove_malware_expert_leaf_mailer_0
    general_remove_malware_expert_php_print_md5_0
    general_remove_malware_expert_steal_user_pass_2
    general_remove_malware_expert_webShellOrb_web_shell_0
    general_remove_malware_expert_wordpress_file_put_contents_1
    general_remove_php_base64_v23au_187
    general_remove_php_cmdshell_cih_233
    general_remove_php_cmdshell_egyspider_240
    general_remove_php_cmdshell_generic_276
    general_remove_php_malware_magento_594
    general_remove_php_nested_base64_641
    general_remove_php_shell_black_id_700
    general_remove_php_uploader_max_706
    general_remove_win_trojan_hide_2
    # Put infection.list content in variable
    infections=$(cat $workingdirectory/infectionlist.log)
    # Check if infectionlistlog is empty or not.
    if [ -z $workingdirectory/infectionlist.log ]; then
        echo "No known infections or suspicious files detected. Just fine and dandy!" >> $workingdirectory/wpsweeper-$datetime.log
    else 
        cat $workingdirectory/infectionlist.log >> $workingdirectory/wpsweeper-$datetime.log
    fi
    # Remove infectionlist.log
    rm -rf infectionlist.log
    # Clear the screen and go back to the menu
    gotomenu
}

####################################### Exit ############################################
#                       Cleanup before the exit command is executed.                    #
#########################################################################################
function prepare_to_exit {
    # Clear the tmp folder
    # Clear the infectionlist.log
    # Finish up with clearing the screen
    clear
}

####################################### Menu ############################################
#         Draws the onscreen menu. Is triggered by the runner function below.           #
#########################################################################################
function wpsweeper_menu {
    clear
    display_logo
    echo "Please select by entering the corresponding number.   "
    echo "                                                      "

select choice in \
    "Sweep WordPress Core files" \
    "Sweep Plugin files" \
    "Sweep Theme files" \
    "Malware scan" \
    "Exit"
do
    case $choice in
        "Sweep WordPress Core files")
            sweep_wp_core;
            ;;
        "Sweep Plugin files")
            sweep_wp_plugins;
            ;;
        "Sweep Theme files")
            sweep_wp_themes;
            ;;
        "Malware scan")
            sweep_malware_scan;
            ;;
        "Exit")
            prepare_to_exit;
            exit;
            ;;
        *)
            echo "Please select an option by inputting the corresponding number";
            ;;
    esac
done

clear
}

# Clear the screen and return to the menu
function gotomenu {
    clear
    display_logo
    wpsweeper_menu
}

###################################### Runner ###########################################
#     Initiates the script. Will trigger the menu function above upon startup.          #
#########################################################################################
initialize_logfile
wpsweeper_menu