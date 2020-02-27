###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2013
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
 
package Apache::Ocsinventory::Plugins::Unixusers::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

#Plugin Unix/Linux USERS
$DATA_MAP{unixusers} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME_USERS',
    writeDiff => 0,
    cache => 0,
    fields => {
         ID_USERS => {},
         GID_USERS => {},
         HOME_USERS => {},
         LOGIN_USERS => {},
         NAME_USERS => {},
         GROUP_USERS => {},
         SHELL_USERS => {},
         ID_GROUP => {},
         MEMBER_GROUP => {},
         NAME_GROUP => {}
    }
 
};
1;
