###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2010
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
package Ocsinventory::Agent::Modules::Unixusers;

sub new {

    my $name="unixusers"; # Name of the module

    my (undef,$context) = @_;
    my $self = {};

    #Create a special logger for the module
    $self->{logger} = new Ocsinventory::Logger ({
        config => $context->{config}
    });
    $self->{logger}->{header}="[$name]";
    $self->{context}=$context;
    $self->{structure}= {
        name => $name,
        start_handler => undef,    #or undef if don't use this hook
        prolog_writer => undef,    #or undef if don't use this hook
        prolog_reader => undef,    #or undef if don't use this hook
        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
        end_handler => undef       #or undef if don't use this hook
    };
    bless $self;
}

######### Hook methods ############

sub unixusers_inventory_handler {

    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};

    $logger->debug("Yeah you are in unixusers_inventory_handler:)");

    # test if who command is available and /etc/passwd, /etc/group are readable :)
    sub check {

        my $params = shift;
        my $common = $params->{common};

        $common->can_run("who"); 
        $common->can_read("/etc/passwd");
        $common->can_read("/etc/group");

    }

    my %users;
    foreach my $user (_getLocalUsers()) {
    #push @{$users{$user->{gid}}}, $user->{LOGIN};
	#delete $user->{gid};

        push @{$common->{xmltags}->{LOCAL_USERS}},
        {
            LOGIN_USERS => [$user->{LOGIN}],
            ID_USERS    => [$user->{ID}],
            GID_USERS   => [$user->{gid}],
            NAME_USERS  => [$user->{NAME}],
            HOME_USERS  => [$user->{HOME}],
            SHELL_USERS => [$user->{SHELL}]
        };
    }

    foreach my $group (_getLocalGroups()) {
        push @{$group->{MEMBER}}, @{$users{$group->{ID}}} if $users{$group->{ID}};

        push @{$common->{xmltags}->{LOCAL_GROUPS}},
        {
            ID_GROUP     => [$group->{ID}],
            NAME_GROUP   => [$group->{NAME}],
            MEMBER_GROUP => [$group->{MEMBER}]
        };
    }

}

1;

sub _getLocalUsers{

     open(my $fh, '<:encoding(UTF-8)', "/etc/passwd") or warn;
     my @userinfo=<$fh>;
     close($fh);

     foreach my $line (@userinfo){
         next if $line =~ /^#/;
         next if $line =~ /^[+-]/; # old format for external inclusion
         chomp $line;
         my ($login, undef, $uid, $gid, $gecos, $home, $shell) = split(/:/, $line);

         push @users,
         {
             LOGIN => $login,
             ID    => $uid,
             gid   => $gid,
             NAME  => $gecos,
             HOME  => $home,
             SHELL => $shell
         };
     }

     return @users;

}

sub _getLocalGroups {

     open(my $fh, '<:encoding(UTF-8)', "/etc/group") or warn;
     my @groupinfo=<$fh>;
     close($fh);

     foreach my $line (@groupinfo){
         next if $line =~ /^#/;
         chomp $line;
         my ($name, undef, $gid, $members) = split(/:/, $line);

         # prevent warning for malformed group file (#2384)
         next unless $members;
         my @members = split(/,/, $members);

         push @groups, {
             ID     => $gid,
             NAME   => $name,
             MEMBER => @members,
         };
     }

     return @groups;

}
