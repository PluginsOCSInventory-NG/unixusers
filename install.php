<?php
function extension_init_unixusers()
{
    $object = new ExtensionCommon;
    $object -> sqlQuery("CREATE TABLE IF NOT EXISTS `unixusers` (
     `ID` INT(11) NOT NULL AUTO_INCREMENT,
     `HARDWARE_ID` INT(11) NOT NULL,
     `ID_USERS` VARCHAR(255) DEFAULT NULL,
     `GID_USERS` VARCHAR(255) DEFAULT NULL,
     `NAME_USERS` VARCHAR(255) DEFAULT NULL,
     `HOME_USERS` VARCHAR(255) DEFAULT NULL,
     `SHELL_USERS` VARCHAR(255) DEFAULT NULL,
     `LOGIN_USERS` VARCHAR(255) DEFAULT NULL,
     `ID_GROUP` VARCHAR(255) DEFAULT NULL,
     `NAME_GROUP` VARCHAR(255) DEFAULT NULL,
     `MEMBER_GROUP` VARCHAR(255) DEFAULT NULL,
     PRIMARY KEY  (`ID`,`HARDWARE_ID`)
     ) ENGINE=InnoDB ;");
}

function extension_delete_unixusers()
{
    $object = new ExtensionCommon;
    $object -> sqlQuery("DROP TABLE `unixusers`;");
}

function extension_upgrade_unixusers()
{

}
?>
