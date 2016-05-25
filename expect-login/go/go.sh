#!/usr/bin/expect -f

## Global Conf ###
set timeout 10
set host_conf_file "/Users/helloworldwt/go/host.conf"
##################

## Global Var ####
array set host_map [list] 
##################

###  function defination ###

proc parse_host_conf {} {
    global host_conf_file host_map
    if {![file exist $host_conf_file]} {
        puts stderr "Host conf file doesn't exist..."
        exit 1
    }
    set fp [open "$host_conf_file" r]
    while {[gets $fp line] >= 0} {
        set host_info [split $line ","]
        foreach {key host port username password desc} $host_info break
        set host_map($key) [list $host $port $username $password $desc]
    }
}

proc get_ssh_info {host_alias} {    
    global host_map
    set count [array size host_map]
    if {$count == 0} {
        puts "The host list is empty..."
        exit 0
    }
    set flag 0
    foreach {k v} [array get host_map *] {
        if {$k == $host_alias} {
            set flag 1    
        }
    }
    if {$flag != 1} {
        puts "The host key $host_alias is not exist..."
        exit 0
    }
    set host_info $host_map($host_alias)
    set host [lindex $host_info 0]
    set port [lindex $host_info 1]
    set username [lindex $host_info 2]
    set passwd [lindex $host_info 3]
    set ssh_host "$username@$host"
    return [list $ssh_host $passwd $port]
}

proc get_host_list {} {
    set blanks3 ""
    set blanks4 ""
    set blanks5 ""
    set blanks6 ""
    for {set i 0} {$i < 30 - [string length "Host"]} {incr i} {
        append blanks3 " "
    }

    for {set i 0} {$i < 30 - [string length "Password"]} {incr i} {
        append blanks4 " "
    }

    for {set i 0} {$i < 20 - [string length "Username"]} {incr i} {
        append blanks5 " "
    }

    for {set i 0} {$i < 8 - [string length "Port"]} {incr i} {
        append blanks7 " "
    }

    set headLine "Index\t\tHost$blanks3"
    append headLine "Port$blanks7"
    append headLine "Username$blanks5"
    append headLine "Password$blanks4"
    append headLine "Description"
    puts $headLine

    global host_map
    set count [array size host_map]
    if {$count == 0} {
        puts "The host list is empty..."
        exit 0
    }
    foreach {k v} [array get host_map *] {
        set blanks ""
        set blanks2 ""
        set blanks6 ""
        set blanks8 ""
        for {set i 0} {$i < 20 - [string length [lindex $v 2]]} {incr i} {
            append blanks " "
        }

        for {set i 0} {$i < 30 - [string length [lindex $v 3]]} {incr i} {
            append blanks2 " "
        }
        
        for {set i 0} {$i < 30 - [string length [lindex $v 0]]} {incr i} {
            append blanks6 " "
        }
        
        for {set i 0} {$i < 8 - [string length [lindex $v 1]]} {incr i} {
            append blanks8 " "
        }
        
        puts "$k\t\t[lindex $v 0]$blanks6[lindex $v 1]$blanks8[lindex $v 2]$blanks[lindex $v 3]$blanks2[lindex $v 4]" 
    }
}

############################

### Main() ###

set host_alias [lindex $argv 0]

if {$argc < 1} { 
    puts stderr "Usage: $argv0 {host_alias}"
    exit 1 
}

parse_host_conf

switch $host_alias {

    "list" {
        get_host_list
        exit 0
    }

    default {
        set ssh_info [get_ssh_info $host_alias]
    }
}

set ssh_host [lindex $ssh_info 0]
set passwd [lindex $ssh_info 1]
set port [lindex $ssh_info 2]

# set timeout 2 minutes
set timeout 120

if {$port != 0} {
    spawn ssh $ssh_host -p$port
} else {
    spawn ssh $ssh_host
}
expect {
    "*yes/no" { send "yes\r"; exp_continue}
    "*assword:" { send "$passwd\r" }
}
interact
