##
# Public Commands v0.0.0.5 (beta for v1.0)
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.6.13 or greater.
#
#    R.I.P. Mom, To always be remembered; Nancy Marie Gregory.
#
# My Website - http://mc.purehype.net/
# Have a bug?  http://mc.purehype.net/bugzilla/
##

##
# This script will make certain commands such as op or voice available
# publicly.  If there is a command that you would like this script to handle,
# e-mail me your idea at mc8@purehype.net.
#
# Please note, public commands are very risky.  They subject the channel to one
# more degree of vulnerability.  I have done everything in my power to ensure
# this is secure, but I am only human.  If you find a possible risk in the
# script, please report it to my e-mail address, mc8@purehype.net.
#
# Tricks:
#   If you want to un-verify users upon being idle, you can use mc.on_idle.tcl
#   (found at http://mc.purehype.net/).  Just have the idle timer action do:
#     /tcl mc:pc:list is_verified [nick2hand %nick] %nick [getchanhost %nick] 0
#   This will increase security, an AFK user needs not be verified.
##

##
# Commands
##
# Public:
#   op [nick1 [nick2 [nickN]]]
#     This will op the specified nick.  You must have the +o flag to use this
#     command.  If nick is exempt, will op you.  You can specify as many nicks
#     as you want, they must be seperated by a space.  You can use wildcards in
#     the nicknames if you like.  If the channel is set to +bitch, only users
#     with the +o flag will be opped.
#     Examples:
#       op *xdcc*
#         This will op all users in the channel that have xdcc in there
#         nickname.
#       op *
#         This will op all users in the channel.
#       op guppy Paladin MC_*
#         This will op guppy, Paladin and all nicks that start with MC_ in the
#         channel.
#   
#   voice [nick1 [nick2 [nickN]]]
#     This will voice the specified nick.  You must not have the +q flag to use
#     this command.  If nick is exempt, will voice you.  You can specify as many
#     nicks as you want, they must be seperated by a space.  You can use
#     wildcards in the nicknames if you like.  Anyone who has the +q flag will
#     not be voiced.
#     Examples:
#       voice *xdcc*
#         This will voice all users in the channel that have xdcc in there
#         nickname.
#       voice *
#         This will voice all users in the channel.
#       voice guppy Paladin MC_*
#         This will voice guppy, Paladin and all nicks that start with MC_ in
#         the channel.
#
#   kick <nick> [reason]
#     This will kick nick from the channel.  If reason is not supplied, the kick
#     message will be the script name and the version.
#     Examples:
#       kick Paladin I am your god.
#         This will kick Paladin from the channel, with the kick message of 'I
#         am your god.'.
#       kick MaSsKilla
#         This will kick MaSsKilla from the channel, kick message is the name of
#         the script and version number (ie: Public Commands v1.0).
#
#   ban <hostmask|nick> [banmask_type] [XdXhXm] [reason]
#     This will ban either a hostmask or nick from the channel.
#     banmask_type can be any of the following numbers;
#         0 - *!user@host.domain
#         1 - *!*user@host.domain
#         2 - *!*@host.domain
#         3 - *!*user@*.domain
#         4 - *!*@*.domain
#         5 - nick!user@host.domain
#         6 - nick!*user@host.domain
#         7 - nick!*@host.domain
#         8 - nick!*user@*.domain
#         9 - nick!*@*.domain
#       You can also specify a type of 10-19 which corresponds to types 0-9,
#       using this sub rule;  If host.domain is a(n)-
#         name - Instead of using a * wildcard to replace portions of the
#                host.domain, it replaces the numbers in the host.domain with a
#                '?' (question mark) wildcard.
#         ip   - It will mask as normal, with no '?' (question mark)
#                replacements as does hostname.
#       If not specified, it will default to banmask type number 2.  If you
#       supplied a hostmask instead of a nick, there is no need for the
#       banmask_type for your masking it yourself.
#     XdXhXm states how long the ban should be for.  1d2h3m means 1 day 2
#       hours and 3 minutes.  This is optional, if you leave it blank then the
#       ban will be a server side ban only, meaning the ban will be removed from
#       the channel whenever someone removes it.  You can set the expire to
#      0d0h0m to make it permanent.
#     reason is the reason for the ban.  If you leave this blank, will default
#       to the script's name and version, ie: Public Commands v1.0.
#     Examples:
#       ban guppy 1d
#         This will ban guppy from the channel.  The ban will expire in 1 day.
#         Since no banmask_type was specified, the type will be 2.  Since no
#         reason was specified, the reason will be the name of the script and
#         the version.
#       ban Paladin 5 Heh, sup now?
#         This will ban Paladin from the channel.  The banmask_type will be 5.
#         No expiration of the ban was specified, so it will be a server ban
#         (whenever someone removes it from the channel is when it expires).
#         The reason will be 'Heh, sup now?'.
#
#   topic <topic>
#     This will change the topic to whatever you specify.
#
#   lockchannel
#     This will lock the channel.  Locking a channel means to set it's modes to
#     +im, making it invite only and moderated.  This is handy in the event of
#     an attack, to stop the user from either flooding the channel with
#     join/part's or public messages.  Once locked down, you can then evaluate
#     the appropriate action without haste.
#
#   unlockchannel
#     This will un-lock the channel.  Locking a channel means to set it's modes
#     to +im, making it invite only and moderated, so unlocking will set the
#     modes to -im.
#
# Private (DCC):
#   chanset <channel> <+|->mc.public_commands
#     You can set each channel to enable (+) or disable (-) the public commands.
#
# Private (message):
#   verify <password>
#     This will mark you as verified, if the password is correct.  You must be
#     verified before you can use any commands.
#
##

##
# Settings
##
#

# You can setup what you want the command name to be for each command, as well
# as the access required to preform it.  This may a bit complex for users new to
# eggdrop, but I will explain it as best as possible.  Each line should be in
# such a syntax as <command> <public_command> <access_required>.
# First is the <command>;
#   The valid commands are op, voice, kick, ban, topic, lockchannel and
#   unlockchannel -- anything other than that is ignored.  This is basically
#   telling the script what the line is to be for, nothing more.  If a command
#   is not specified in this set, it is disabled -- say you don't want people to
#   use a public op command, then just don't list it.
# Second is <public_command>;
#   The public_command is what you want people to type to do the command, if you
#   want users to type something like '!foobar' to op then you would have the
#   line such as 'op !foobar o|o'. Keep in mind, the public command must not
#   contain a space.
# Third is <access_required>;
#   You set this to the access the user must have to do the command.  If you
#   only want ops (specified with the o flag, either globally or for the
#   channel), then you would use o|o. You can review the dcc command '.help
#   whois' for a list of valid flags.  Keep in mind, only valid users (users
#   added to the bot) that have verified can use these commands.  You can set
#   this argument to -|- to make it so anyone who is a valid user and has
#   verified themselves to the bot can use the command.
# Examples:
#   voice !blah -q|-q
#     This will enable the voice public command.  The command trigger in the
#     channel will be !blah.  Only users that do not have the q flag, either
#     globally or for the channel, can use the public command ... provided they
#     are a valid user and have verified themselves to the bot.  The voice
#     command will now have a syntax of '!blah [nick1 [nick2 [nickN]]]'.
#   op @ m|-
#     This will enable the op public command.  The command trigger in the
#     channel will be @.  Only users that have the m flag (which means master),
#     globally only regardless of channel flags, can use the public command ...
#     provided they are a valid user and have verified themselves to the bot.
#     The op command will now have a syntax of '@ [nick1 [nick2 [nickN]]]'.
set mc_pc(:config:commands) {
  op            .op      +o-d|+o-d
  voice         .voice  +ov-q|+ov-q
  kick          .kick      +o|+o
  ban           .ban       +o|+o
  topic         .topic    +ov|+ov 
  lockchannel   .lc        +o|+o
  unlockchannel .ul        +o|+o
}

# If a user tries to verify and puts the wrong password, how many retries is he
# allowed before considering it a hack attempt and ignoring him from the verify
# command.  This is set by <number_of_attempts>:<in_how_many_seconds>.  You can
# set it to 0:0 to disable this feature.
# Example:
#   set ... "2:60"
#     This will ensure that the user cannot fail a verify command 2 times within
#     a 60 second period or else he will be ignored.
set mc_pc(:config:hack_max_verify_attempts) "2:60"

## SVS Client (Script Version Service) v4.0.4 ##
# Once a day, the SVS Client will connect to MC_8's SVS Server to determine if
# there is a newer version of this script available.  If a newer version is
# found, the script will be auto updated.

# [0=no/1=yes] Do you want to enable auto updating?  If you chose to disable
# auto updating, it will not automatically update the script upon finding a
# newer version.
set mc_pc(:config:svs:enable) 1


##
# End of configuration, do not edit past here unless you know TCL.
##

#Script:mc_pc

## SVS insert (pre code)
catch {unset temp}
set mc_pc(info:vars) ""
foreach {temp(name) temp(value)} [array get mc_pc :config:*] {
  lappend mc_pc(info:vars) [list $temp(name) $temp(value)]
}
set mc_pc(info:loc) [info script]
array set mc_pc [list \
  script                 "Public Commands" \
  version                "v0.0.0.5 (beta for v1.0)" \
  svs:script             "public_commands" \
  svs:version            "000000000005" \
  svs:client_version     "v4.0.4" \
  svs:client_svs_version "004000004000" \
  svs:server             "mc.svs.purehype.net" \
  svs:port               "80" \
  svs:get                "/index.tcl"]
set mc_pc(svs:query)    "svs=$mc_pc(svs:script)&"
append mc_pc(svs:query) "version=$mc_pc(svs:version)&"
append mc_pc(svs:query) \
  "svs_version=$mc_pc(svs:client_svs_version)"

if {![info exists numversion] || 
    ([string range $numversion 0 4] < "10613") ||
    (([string range $numversion 0 4] == "10613") &&
     ([string range $numversion 5 6] != "00"))} {
  set temp(tag) "$mc_pc(script) $mc_pc(version)"
  putloglev o * \
    "$temp(tag) by MC_8 will only work on eggdrop 1.6.13 (stable) or greater."
  putloglev o * "$temp(tag)  will not work with eggdrop $version."
  putloglev o * "$temp(tag)  not loaded."
  return 1
}
## ^

setudef flag mc.public_commands

# Error system, v3.1
proc mc:pc:error {command error arg} {
  global mc_pc version lastbind errorInfo
  putloglev o * "Error in script $mc_pc(script) $mc_pc(version)."
  putloglev o * "    Error System: v3.0"
  putloglev o * \
    "       Last Bind: [expr {[info exists lastbind]?$lastbind:"-NULL-"}]"
  putloglev o * "         Command: $command"
  putloglev o * "       Arguments: $arg"
  putloglev o * "       Error Msg: $error"
  putloglev o * \
    "    Egg. Version: [expr {[info exists version]?$version:"-NULL-"}]"
  putloglev o * "     TCL Version: [info tclversion]"
  putloglev o * "  TCL Patchlevel: [info patchlevel]"
  putloglev o * "*** Please submit this bug so MC_8 can fix it.  Visit"
  putloglev o * \
    "*** http://mc.purehype.net/bugzilla/ to properly report the bug."
  putloglev o * \
    "*** Please include ALL info. in the bug report, including the next(s)."
  error $errorInfo
}

proc mc:pc:errchk {command arg} {
  lappend ::lastCommand "$command $arg"
  set ::lastCommand\
    [lrange $::lastCommand [expr [llength $::lastCommand]-5] end]
  if {![catch {eval $command $arg} return]} {return $return}
  mc:pc:error $command $return $arg
  return 0
}
# ^

proc mc:pc:list {command {args ""}} {
  return [mc:pc:errchk mc:pc:list_ [list $command $args]]
}
proc mc:pc:list_ {command args} {
  global mc_pc
  set args [lindex $args 0]

  if {[info tclversion] > 8.0} {
    set new_args [list]
    foreach item $args {
      lappend new_args [encoding convertto [encoding system] $item]
    }; set args $new_args
  }

  switch -- $command {
    
    "is_max_verify_attempts_enabled" {
      set split [split $mc_pc(:config:hack_max_verify_attempts) :]
      if {([lindex $split 0] != "0") && ([lindex $split 1] != "0")} {return 1}
      return 0
    }

    "add_failed_verify" {
      # return: try max
      foreach handle $args break
      set handle [string tolower $handle]
      
      if {![mc:pc:list is_max_verify_attempts_enabled]} {return [list 0 0]}

      foreach {max seconds} \
        [split $mc_pc(:config:hack_max_verify_attempts) :] break
      
      set array [list ! verify !passwdok $handle]
      if {![info exists mc_pc($array)]} {set mc_pc($array) 0}
      incr mc_pc($array) 1
      set try $mc_pc($array)
      
      utimer $seconds [list mc:pc:list subtract_failed_verify $handle]
      
      return [list $try $max]
    }
    
    "subtract_failed_verify" {
      foreach handle $args break
      set handle [string tolower $handle]
      
      set array [list ! verify !passwdok $handle]
      if {(![info exists mc_pc($array)]) ||
          ($mc_pc($array) == "0")} {return}
      incr mc_pc($array) -1
      
      return
    }
    
    "is_on_ignore" {
      set from_what ""
      foreach {handle from_what} $args break
      set handle [string tolower $handle]
      
      switch -- $from_what {
        
        "verify" {
          if {![mc:pc:list is_max_verify_attempts_enabled]} {return 0}

          foreach {max seconds} \
            [split $mc_pc(:config:hack_max_verify_attempts) :] break
          
          set array [list ! verify !passwdok $handle]
          if {![info exists mc_pc($array)]} {set mc_pc($array) 0}
          set try $mc_pc($array)
        
          if {$try >= $max} {return 1} else {return 0}
        }
        
      }
    }
    
    "is_verified" {
      # Returns (for set 0):
      #           0 == Invalid user.
      #           1 == Done.
      #           2 == Not verified.
      #         (for set 1):
      #           0 == Invalid user.
      #           1 == Done.
      #           2 == Already verified.
      #         (for set ""):
      #           0 == No.
      #           1 == Yes.
      set set ""
      foreach {handle nick uhost set} $args break

      set array [list ! verified $handle]
      if {![validuser $handle]} {
        catch {unset mc_pc($array)}
        return 0
      }
      
      switch -- $set {
        
        "0" {
          if {![mc:pc:list is_verified $handle $nick $uhost]} {return 2}
          if {![info exists mc_pc($array)]} {return 1}

          set verify_list [list]          
          foreach host $mc_pc($array) {
            if {$host == "$nick!$uhost"} {continue}
            lappend verify_list $host
          }
          
          if {$verify_list == [list]} {unset mc_pc($array)} \
          else {set mc_pc($array) $verify_list}
          putloglev d * "$mc_pc(script): $nick no longer verified."
          return 1
        }
        
        "1" {
          if {[mc:pc:list is_verified $handle $nick $uhost]} {return 2}
          if {![info exists mc_pc($array)]} {set mc_pc($array) [list]}
          
          lappend mc_pc($array) $nick!$uhost
          
          putloglev d * "$mc_pc(script): $nick now verified."
          return 1
        }
        
        "" {
          if {![info exists mc_pc($array)]} {return 0}
          
          if {[lsearch -exact $mc_pc($array) "$nick!$uhost"] > "-1"} {return 1}
          return 0
        }
        
      }      
    }
    
    
    "clear_verified" {
      foreach name [array get mc_pc] {
        if {[catch {llength $name}]} {continue}
        set a ""; set b ""; set c ""
        foreach {a b c} $name break
        
        if {[list $a $b] == [list ! verified]} {
          unset mc_pc($name)
        }
      }
      
      putloglev d * "$mc_pc(script): Everyone has been unverified."
    }
    
    "get_command_data" {
      # Return: <trigger> <access>
      foreach command $args break

      foreach line [split $mc_pc(:config:commands) \n] {
        set line [string trim $line " \t"]
        if {$line == ""} {continue}
        regsub -all \t $line " " line
        while {[regsub -all "  " $line " " line]} {}
        set line [split $line]
        if {[llength $line] != "3"} {continue}
        foreach {line_command trigger access} $line break
        
        if {$line_command == $command} {
          return [list $trigger $access]
        }
      }
      
      return ""
    }
     
  }
}

bind time - * mc:pc:time
proc mc:pc:time {{args ""}} {
  return [mc:pc:errchk mc:pc:time_ [list $args]]
}
proc mc:pc:time_ {arg} {
  global mc_pc
  foreach name [array names mc_pc] {
    if {[catch {llength $name}]} {continue}
    if {([lindex $name 0] == "!") &&
        ([lindex $name 1] == "verified") &&
        ([llength $name] == "3")} {
      set handle [lindex $name 2]
      set array [list ! verified $handle]
      if {![validuser $handle]} {
        catch {unset mc_pc($array)}
      }
    }
  }
}

set temp(commands) "ident|info|invite|jump|key|memory|notes|op|pass"
append temp(commands) "|rehash|reset|save|status|voice"
foreach bind [binds msg] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  if {[regexp -- "^($temp(commands))\$" $temp(command)]} {
    set temp(new_proc) "mc:pc:msg:autoauth:$temp(command)"
    if {$temp(new_proc) == $temp(proc)} {continue}
    unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
    bind $temp(type) $temp(flag) $temp(command) $temp(new_proc)
    proc $temp(new_proc) {nick uhost handle text} "
      mc:pc:msg:autoauth \$nick \$uhost \$handle \$text \
        $temp(command) $temp(proc)
      return 0
    "
  }
}

proc mc:pc:msg:autoauth {nick uhost handle text command proc} {
  return [mc:pc:errchk mc:pc:msg:autoauth_ \
    [list $nick $uhost $handle $text $command $proc]]
}
proc mc:pc:msg:autoauth_ {nick uhost handle text command proc} {
  set text [split $text]
  if {$command == "ident"} {
    set text_handle ""
    foreach {password text_handle} $text break
    if {$text_handle != ""} {set handle $text_handle}
  } elseif {$command == "pass"} {
    set newpass ""
    foreach {oldpass newpass} $text break
    if {$newpass == ""} {
      $proc $nick $uhost $handle $text
      return 0
    }
    set password $oldpass
  } else {set password [lindex $text 0]}
  
  if {[validuser $handle] && [passwdok $handle $password]} {
    mc:pc:list is_verified $handle $nick $uhost 1
  }

  $proc $nick $uhost $handle $text
  return 0
}

bind evnt -|- init-server mc:pc:evnt:init-server
proc mc:pc:evnt:init-server {type} {
  return [mc:pc:errchk mc:pc:evnt:init-server_ [list $type]]
}
proc mc:pc:evnt:init-server_ {type} {
  mc:pc:list clear_verified
}

bind kick -|- * mc:pc:kick
proc mc:pc:kick {nick uhost handle channel target reason} {
  return [mc:pc:errchk mc:pc:kick_ \
    [list $nick $uhost $handle $channel $target $reason]]
}
proc mc:pc:kick_ {nick uhost handle channel target reason} {
  set unverify [list]
  
  if {[isbotnick $target]} {
    foreach nick [chanlist $channel] {
      if {[isbotnick $nick]} {continue}
      set handle [nick2hand $nick]
      set uhost [getchanhost $nick]
      
      lappend unverify [list $handle $nick $uhost]
    }
  } else {
    lappend unverify [list [nick2hand $target] $target [getchanhost $target]]
  }
  
  set other_nicks [list]
  foreach foreach_channel [channels] {
    if {$channel == $foreach_channel} {continue}
    
    foreach user [chanlist $foreach_channel] {lappend other_nicks $user}
  }
    
  foreach item $unverify {
    foreach {handle nick uhost} $item {}
    
    if {[lsearch -exact $other_nicks $nick] > "-1"} {continue}
      
    mc:pc:list is_verified $handle $nick $uhost 0
  }
}

bind msg -|- verify mc:pc:msg:verify
proc mc:pc:msg:verify {nick uhost handle text} {
  return [mc:pc:errchk mc:pc:msg:verify_ [list $nick $uhost $handle $text]]
}
proc mc:pc:msg:verify_ {nick uhost handle text} {
  global mc_pc
  set password [lindex [split $text] 0]
  
  if {[mc:pc:list is_on_ignore $handle verify]} {
    putloglev c * "($nick!$uhost) !$handle! (ignored) verify \[hidden\]"
    return 0
  }
  
  if {![validuser $handle]} {
    putserv "NOTICE $nick :Sorry, I don't know who you are."
    set found 0
    foreach bind [binds *msg:ident] {
      if {[lindex $bind 4] == "*msg:ident"} {
        set found 1
        break
      }
    }
    if {$found} {set found "identify to the bot"} \
    else {set found "ask the admin to add your host"}
    putserv "NOTICE $nick :If your added to the bot, ${found}."
    
    putloglev c * \
      "($nick!$uhost) !$handle! (failed, unknown user) verify \[hidden\]"
    return 0
  }
        
  if {![passwdok $handle $password]} {
    if {[mc:pc:list is_verified $handle $nick $uhost]} {
      # Even if already verified, unverify user due to bad password.
      mc:pc:list is_verified $handle $nick $uhost 0
    }
    
    set return [mc:pc:list add_failed_verify]
    foreach {try max} $return {}
    
    if {"$try$max" != "00"} {
      putserv "NOTICE $nick :Invalid password, try $try of $max."
      
      if {$try >= $max} {
        set temp() "You are now on ignore for exceeding $max bad passwords"
        putserv "NOTICE $nick :$temp()."
        set temp() "(failed, invalid password ($try/$max))"
        putloglev c * "($nick!$uhost) !$handle! $temp() verify \[hidden\]"
      }
    } else {
      putserv "NOTICE $nick :Invalid password."
      set temp() "(failed, invalid password)"
      putloglev c * "($nick!$uhost) !$handle! $temp() verify \[hidden\]"
    }
    return 0
  }
  
  switch -- [mc:pc:list is_verified $handle $nick $uhost 1] {
    "0" -
    "1" {putserv "NOTICE $nick :Verified."}
    "2" {putserv "NOTICE $nick :Already verified."}
  }
  putloglev c * "($nick!$uhost) !$handle! verify \[hidden\]"
  return 0      
}

bind nick -|- * mc:pc:nick
proc mc:pc:nick {nick uhost handle channel newnick} {
  return [mc:pc:errchk mc:pc:nick_ \
    [list $nick $uhost $handle $channel $newnick]]
}
proc mc:pc:nick_ {nick uhost handle channel newnick} {
  if {[isbotnick $nick]} {return}
  
  mc:pc:list is_verified $handle $nick $uhost 0
  set newhandle [finduser $newnick!$uhost]
  if {$newhandle == $handle} {
    mc:pc:list is_verified $handle $newnick $uhost 1
  }
}

bind part -|- * mc:pc:part
proc mc:pc:part {nick uhost handle channel text} {
  return [mc:pc:errchk mc:pc:part_ [list $nick $uhost $handle $channel $text]]
}
proc mc:pc:part_ {nick uhost handle channel text} {
  set unverify [list]
  
  if {![validchan $channel]} {
    foreach handle [array names mc_pc] {
      if {[lrange $handle 0 1] != [list ! verified]} {continue}
      set handle [lindex $handle 2]
      set nick [nick2hand $handle]
      if {[onchan $nick]} {continue}
      set uhost [getchanhost $nick]
      lappend unverify [list $handle $nick $uhost]
    }
  } elseif {[isbotnick $nick]} {
    foreach nick [chanlist $channel] {
      if {[isbotnick $nick]} {continue}
      set handle [nick2hand $nick]
      set uhost [getchanhost $nick]
      
      lappend unverify [list $handle $nick $uhost]
    }
  } else {
    lappend unverify [list $handle $nick $uhost]
  }
   
  set other_nicks [list]
  foreach foreach_channel [channels] {
    if {$channel == $foreach_channel} {continue}
    
    foreach user [chanlist $foreach_channel] {lappend other_nicks $user}
  }
  
  foreach item $unverify {
    foreach {handle nick uhost} $item {}
    
    if {[lsearch -exact $other_nicks $nick] > "-1"} {continue}
      
    mc:pc:list is_verified $handle $nick $uhost 0
  }
}

foreach bind [binds mc:pc:pub:ban] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data ban]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:ban {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:ban
  proc mc:pc:pub:ban {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:ban_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:ban_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data ban]
    if {$command_data == ""} {
      proc mc:pc:pub:ban {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }
    
    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }
    
    set text [split $text]
    set target [lindex $text 0]
    set target_nick ""
    set target_hostmask ""
    if {[onchan $target]} {
      set target_nick $target
    } elseif {(![onchan $target]) && (![string match "*!*@*" $target])} {
      putserv "NOTICE $nick :$target not on $channel."
      
      putloglev c * "$loglevc_prefix (target not on chan) $command $text"
      return 0
    } elseif {[string match "*!*@*" $target]} {
      set target_hostmask $target
    } else {
      set temp() "ban <hostmask|nick> \[banmask_type\] \[XdXhXm\] \[reason\]"
      putserv "NOTICE $nick :Usage: $temp()"
      return 0
    }
    set banmask_type [lindex $text 1]
    if {![regexp -- {^1?[0-9]$} $banmask_type]} {
      set index 1
      set banmask_type 2
    } else {set index 2}
    set expire [lindex $text $index]
    if {![regexp -- {^([0-9]*[dhm])([0-9]*[dhm])?([0-9]*[dhm])?$} $expire]} {
      set expire -1
    } else {
      set e $expire
      if {![regexp -- {([0-9]*)m} $e -> min]  || ($min == "")}  {set min  0}
      if {![regexp -- {([0-9]*)h} $e -> hour] || ($hour == "")} {set hour 0}
      if {![regexp -- {([0-9]*)d} $e -> day]  || ($day == "")}  {set day  0}
      set expire [expr ($min*60)+($hour*3600)+($day*86400)]
      incr index
    }
    set reason [join [lrange $text $index end]]
    if {$reason == ""} {set reason "$mc_pc(script) $mc_pc(version)"}
    if {$target_hostmask == ""} {
      set target_uhost [getchanhost $target_nick]
      set target_hostmask \
        [mc:pc:maskhostbytype $target_nick!$target_uhost $banmask_type] 
    }
    if {$target_nick == ""} {
      set target_nick [list]
      foreach user [chanlist $channel] {
        set temp(uhost) [getchanhost $user]
        if {[string match $target_hostmask $user!$temp(uhost)]} {
          lappend target_nick $user
        }
      }
      set target_nick $list
    } else {set target_nick [list $target_nick]}
    
    if {([llength $target_nick] == "1") &&
        ([isbotnick [lindex $target_nick 0]])} {
      putserv "NOTICE $nick :$target is me, failed."
      
      putloglev c * "$loglevc_prefix (target is me) $command $text"
      return 0
    }
    
    if {$expire != "-1"} {
      newchanban $channel $target_hostmask $nick $reason $expire none
    }
    
    if {$expire == "-1"} {
      putserv "MODE $channel +b $target_hostmask"
    } elseif {[channel get $channel dynamicbans]} {
      if {[channel get $channel dontkickops]} {
        set pushban 0
        foreach temp(nick) $target_nick {
          if {([matchattr [nick2hand $temp(nick)] o|o $channel]) ||
              ([isbotnick $temp(nick)])} {continue}
          set pushban 1
          break
        }
      } elseif {[llength $target_nick]} {set pushban 1} \
      else {set pushban 0}
      if {$pushban} {
        putserv "MODE $channel +b $target_hostmask"
      }
    } else {
      putserv "MODE $channel +b $target_hostmask"
    }
    
    foreach temp(nick) $target_nick {
      if {(([matchattr [nick2hand $temp(nick)] o|o $channel]) && 
           ([channel get $channel dontkickops])) ||
          ([isbotnick $temp(nick)])} {continue}
      putserv "KICK $channel $temp(nick) :$reason"
    }
      
    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:kick] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data kick]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:kick {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:kick
  proc mc:pc:pub:kick {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:kick_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:kick_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data kick]
    if {$command_data == ""} {
      proc mc:pc:pub:kick {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }
    
    if {$text == ""} {
      putserv "NOTICE $nick :Usage: $command <nick> \[reason\]"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }
    
    set text [split $text]
    set kick_nick [lindex $text 0]
    set kick_reason [join [lrange $text 1 end]]
    
    if {[isbotnick $kick_nick]} {
      putserv "NOTICE $nick :$target is me, failed."
      
      putloglev c * "$loglevc_prefix (target is me) $command $text"
      return 0
    }
    
    if {![onchan $kick_nick]} {
      putserv "NOTICE $nick :$kick_nick isn't on $channel."
      
      putloglev c * "$loglevc_prefix (target not on chan) $command $text"
      return 0
    }
    
    if {([channel get $channel dontkickops]) &&
        ([matchattr [nick2hand $kick_nick] o|o $channel])} {
      set temp() "$channel is set to +dontkickops,"
      putserv "NOTICE $nick :$temp() $kick_nick is a valid op."
      
      putloglev c * "$loglevc_prefix (failed, +dontkickops) $command $text"
      return 0
    }
    
    if {$kick_reason == ""} {set kick_reason "$mc_pc(script) $mc_pc(version)"}
    
    putkick $channel $kick_nick $kick_reason

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:lockchannel] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data lockchannel]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:lockchannel {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:lockchannel
  proc mc:pc:pub:lockchannel {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:lockchannel_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:lockchannel_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data lockchannel]
    if {$command_data == ""} {
      proc mc:pc:pub:lockchannel {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }

    putquick "MODE $channel +mi"

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:op] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data op]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:op {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:op
  proc mc:pc:pub:op {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:op_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:op_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data op]
    if {$command_data == ""} {
      proc mc:pc:pub:op {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }

    if {$text == ""} {set text $nick}

    set userlist [split [string tolower $text]]

    catch {unset temp}
    foreach user $userlist {set temp([string tolower $user]) $user}
    set userlist [list]
    foreach {a user} [array get temp] {lappend userlist $user}

    set +userlist [list]
    set -userlist [list]
    set chanlist [string tolower [chanlist $channel]]

    foreach list_user $userlist {
      set found 0
      set list_user_modified [mc:pc:replace -- $list_user \
        [list \[ \\\[ \] \\\]]]
      foreach chan_user $chanlist {
        if {[string match $list_user_modified $chan_user]} {
          set found 1
          lappend +userlist $chan_user
        }
      }
      if {!$found} {lappend -userlist $list_user}
    }

    catch {unset temp}
    foreach user ${-userlist} {set temp([string tolower $user]) $user}
    set -userlist [list]
    foreach {a user} [array get temp] {lappend -userlist $user}

    catch {unset temp}
    foreach user ${+userlist} {set temp([string tolower $user]) $user}
    set +userlist [list]
    foreach {a user} [array get temp] {lappend +userlist $user}

    if {[llength ${-userlist}]} {
      set temp() [join ${-userlist} ", "]
      putserv "NOTICE $nick :No matches for these nicks: $temp()"
    }

    set userlist ${+userlist}
    set +userlist [list]
    set -userlist [list]

    foreach user $userlist {
      if {([channel get $channel bitch]) &&
          (![matchattr [nick2hand $user] o|o $channel])} {
        lappend -userlist $user
      } else {lappend +userlist $user}
    }

    if {[llength ${-userlist}]} {
      set temp() "$channel is set to +bitch, the following don't"
      putserv "NOTICE $nick :$temp() have op access: [join ${-userlist} ", "]"
    }

    set userlist ${+userlist}
    set +userlist [list]
    set -userlist [list]

    foreach user $userlist {
      if {[isop $user $channel]} {
        lappend -userlist $user
        continue
      }
      pushmode $channel +o $user
    }
    
    if {[llength ${-userlist}]} {
      putserv "NOTICE $nick :Users already opped: [join ${-userlist} ", "]"
    }

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:topic] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data topic]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:topic {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:topic
  proc mc:pc:pub:topic {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:topic_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:topic_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data topic]
    if {$command_data == ""} {
      proc mc:pc:pub:topic {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }

    putserv "TOPIC $channel :$text"

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:unlockchannel] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data unlockchannel]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:unlockchannel {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:unlockchannel
  proc mc:pc:pub:unlockchannel {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:unlockchannel_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:unlockchannel_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data unlockchannel]
    if {$command_data == ""} {
      proc mc:pc:pub:unlockchannel {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }

    putquick "MODE $channel -mi"

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

foreach bind [binds mc:pc:pub:voice] {
  foreach {temp(type) temp(flag) temp(command) temp(n) temp(proc)} $bind break
  unbind $temp(type) $temp(flag) $temp(command) $temp(proc)
}
set temp(command_data) [mc:pc:list get_command_data voice]

if {$temp(command_data) == ""} {
  proc mc:pc:pub:voice {{args ""}} {}
} else {
  foreach {temp(command) temp(access)} $temp(command_data) break
  bind pub -|- $temp(command) mc:pc:pub:voice
  proc mc:pc:pub:voice {nick uhost handle channel text} {
    return [mc:pc:errchk mc:pc:pub:voice_ \
      [list $nick $uhost $handle $channel $text]]
  }
  proc mc:pc:pub:voice_ {nick uhost handle channel text} {
    global mc_pc
    
    set command_data [mc:pc:list get_command_data voice]
    if {$command_data == ""} {
      proc mc:pc:pub:voice {{args ""}} {}
      return 0
    }
    foreach {command access} $command_data break
    set loglevc_prefix "<<$nick@$channel>> !$handle!"

    if {![channel get $channel mc.public_commands]} {
      putloglev c * "$loglevc_prefix (disabled channel) $command $text"
      return 0
    }

    if {![mc:pc:list is_verified $handle $nick $uhost]} {
      putserv "NOTICE $nick :You must verify yourself first."
      putserv "NOTICE $nick :Usage: /msg $::botnick VERIFY <password>"

      putloglev c * "$loglevc_prefix (not verified) $command $text"
      return 0
    }

    if {![matchattr $handle $access $channel]} {
      putserv "NOTICE $nick :You do not have access to this command."

      putloglev c * "$loglevc_prefix (no access) $command $text"
      return 0
    }

    if {![botisop $channel]} {
      putserv "NOTICE $nick :I'm not an op in $channel, sorry."

      putloglev c * "$loglevc_prefix (bot not opped) $command $text"
      return 0
    }

    if {$text == ""} {set text $nick}

    set userlist [split [string tolower $text]]

    catch {unset temp}
    foreach user $userlist {set temp([string tolower $user]) $user}
    set userlist [list]
    foreach {a user} [array get temp] {lappend userlist $user}

    set +userlist [list]
    set -userlist [list]
    set chanlist [string tolower [chanlist $channel]]

    foreach list_user $userlist {
      set found 0
      set list_user_modified [mc:pc:replace -- $list_user \
        [list \[ \\\[ \] \\\]]]
      foreach chan_user $chanlist {
        if {[string match $list_user_modified $chan_user]} {
          set found 1
          lappend +userlist $chan_user
        }
      }
      if {!$found} {lappend -userlist $list_user}
    }

    catch {unset temp}
    foreach user ${-userlist} {set temp([string tolower $user]) $user}
    set -userlist [list]
    foreach {a user} [array get temp] {lappend -userlist $user}

    catch {unset temp}
    foreach user ${+userlist} {set temp([string tolower $user]) $user}
    set +userlist [list]
    foreach {a user} [array get temp] {lappend +userlist $user}

    if {[llength ${-userlist}]} {
      set temp() [join ${-userlist} ", "]
      putserv "NOTICE $nick :No matches for these nicks: $temp()"
    }

    set userlist ${+userlist}
    set +userlist [list]
    set -userlist [list]

    foreach user $userlist {
      if {[matchattr [nick2hand $user] q|q $channel]} {
        lappend -userlist $user
      } else {lappend +userlist $user}
    }

    if {[llength ${-userlist}]} {
      putserv \
        "NOTICE $nick :Cannot voice, has quiet flag: [join ${-userlist} ", "]"
    }

    set userlist ${+userlist}
    set +userlist [list]
    set -userlist [list]

    foreach user $userlist {
      if {[isvoice $user $channel]} {
        lappend -userlist $user
        continue
      }
      pushmode $channel +v $user
    }
    
    if {[llength ${-userlist}]} {
      putserv "NOTICE $nick :Users already voiced: [join ${-userlist} ", "]"
    }

    putloglev c * "$loglevc_prefix $command $text"
    return 0
  }
}

bind sign -|- * mc:pc:sign
proc mc:pc:sign {nick uhost handle channel text} {
  return [mc:pc:errchk mc:pc:sign_ \
    [list $nick $uhost $handle $channel $text]]
}
proc mc:pc:sign_ {nick uhost handle channel text} {
  if {[isbotnick $nick]} {
    foreach nick [chanlist $channel] {
      if {[isbotnick $nick]} {continue}
      set handle [nick2hand $nick]
      set uhost [getchanhost $nick]
      
      mc:pc:list is_verified $handle $nick $uhost 0
    }
  } else {
    mc:pc:list is_verified $handle $nick $uhost 0
  }
}

bind splt -|- * mc:pc:splt
proc mc:pc:splt {nick uhost handle channel} {
  return [mc:pc:errchk mc:pc:splt_ [list $nick $uhost $handle $channel]]
}
proc mc:pc:splt_ {nick uhost handle channel} {
  if {[isbotnick $nick]} {
    foreach nick [chanlist $channel] {
      if {[isbotnick $nick]} {continue}
      set handle [nick2hand $nick]
      set uhost [getchanhost $nick]
      
      mc:pc:list is_verified $handle $nick $uhost 0
    }
  } else {
    mc:pc:list is_verified $handle $nick $uhost 0
  }
}

## More Tools quick procs.
## -- http://mc.purehype.net:81/script_info.tcl?script=moretools

# badargs <args> <min_llength> <max_llength|end> <argNames>
#     version:
#       v1.0
proc mc:pc:badargs {{args ""}} {
  if {[llength $args] < 4} {
    error {
   wrong # args: should be "mc:pc:badargs args min_llength max_llength argNames"
    }
  }

  set index 0
  foreach varName [list args min max names] {
    set check_$varName [lindex $args $index]
    incr index
  }

  if {[regexp -- {([^0-9])} $check_min -> bad]} {
    error "bad number \"$bad\" in: $check_min"
  }
  if {[regexp -- {([^0-9])} $check_max -> bad] && ($check_max != "end")} {
    error "bad number \"$bad\" in: $check_max"
  }

  # Make sure $check_args is in list format, if not then make it so.
  # Were not going to use 2list here, don't want to evoke a 'too many nested
  # calls to Tcl_EvalObj' error since '2list' uses on this proc.
  if {[catch {llength $check_args} llength]} {
    set check_args [split $check_args]
    set llength $check_args
  }

  if {($llength < $check_min) || (($llength != "end") &&
      ($llength > $check_max))} {
    if {[info level] == "1"} {return 1}
    error "wrong # args: should be \"[lindex [info level -1] 0] $check_names\""
  }; return 0
}

# 2list <text>
#     version:
#       v1.0
proc mc:pc:2list {{args ""}} {
  mc:pc:badargs $args 1 1 "text"
  mc:pc:unlist $args text

  return [expr {([catch {llength $text}])?[split $text]:$text}]
}

# replace [switches] <text> <substitutions>
#     version:
#       v1.3
proc mc:pc:replace {{args ""}} {
  mc:pc:badargs $args 2 4 "?switches? text substitutions"
  set switches ""
  for {set i 0} {[string match -* [set arg [lindex $args $i]]]} {incr i} {
    if {![regexp -- {^-(nocase|-)$} $arg -> switch]} {
      error "bad switch \"$arg\": must be -nocase, or --"
    }
    if {$switch == "-"} {
      incr i
      break
    }; lappend switches $switch
  }
  set nocase [expr {([lsearch -exact $switches "nocase"] >= "0") ? 1 : 0}]
  set text [lindex $args $i]
  set substitutions [lindex $args [expr $i+1]]
  mc:pc:badargs [lrange $args $i end] 2 2 "?switches? text substitutions"

  # Check to see if $substitutions is in list format, if not make it so.
  set substitutions [mc:pc:2list $substitutions]

  if {[info tclversion] >= "8.1"} {
    return [expr {($nocase)?
      [string map -nocase $substitutions $text]:
      [string map $substitutions $text]}]
  }

  set re_syntax {([][\\\*\+\?\{\}\,\(\)\:\.\^\$\=\!\|])}
  foreach {a b} $substitutions {
    regsub -all -- $re_syntax $a {\\\1} a
    if {$nocase} {regsub -all -nocase -- $a $text $b text} \
    else {regsub -all -- $a $text $b text}
  }; return $text
}

# unlist <argsList> [varName1] [varName2] ... [varNameN]
#     version:
#       v1.0
proc mc:pc:unlist {{args ""}} {
  mc:pc:badargs $args 1 end "argsList ?varName varName ...?"
  set argList [lindex $args 0]
  set argList [expr {([catch {llength $argList}])?[split $argList]:$argList}]
  set argNames [lrange $args 1 end]
  if {![llength $argNames]} {
    return [expr {(![catch {llength $argList}])?
      [join $argList]:$argList}]
  }
  for {set index 0} {$index < [llength $argNames]} {incr index 1} {
    set argName     [lindex $argNames $index]
    set argListItem [lindex $argList  $index]

    set argName_ [expr {([catch {llength $argName}])?[split $argName]:$argName}]
    set setTo   [lindex $argName_ 1]
    set argName [lindex $argName_ 0]

    if {$argName == ""} {continue}

    upvar 1 $argName var

    if {[expr $index+1] > [llength $argList]} {
      if {[llength $argName_] == "2"} {set var $setTo}
    } else {
      if {$argName == "args"} {
        set var [lrange $argList $index end]
        incr index [expr [llength $var]-1]
      } else {set var $argListItem}
    }
  }; return $index
}

# maskhostbytype <nick!ident@host.domain> [type]
#     version:
#       v2.1
proc mc:pc:maskhostbytype {{args ""}} {
  mc:pc:badargs $args 1 2 "nick!ident@host.domain ?type?"
  mc:pc:unlist $args nuhost type

  set type [expr {($type == "")?5:$type}]
  if {![regexp -- {^1?[0-9]$} $type]} {
    set valid "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {or 19}"
    error "bad type \"$type\": must be [join $valid ", "]"
  }

  # Define the maximum length the ircd allows for an ident.  Standard is 9,
  # however I made it to a variable incase someone wants to change it up.
  set ident_max-length 9

  # Define the maximum length the ircd allows for a hostname/ ip.  Standard is
  # 63, however I made it to a variable incase someone wants to change it up.
  set host_max-length 63

  if {![regexp -- {^(.*[^!])!((.*)@(.*))$} $nuhost -> nick uhost ident host]} {
    error "invalid nick!ident@host.domain: $nuhost"
  }

  set maskhost 1
  if {[string length $type] == "2"} {
    # Type must be 10-19.
    if {[info tclversion] < "8.1"} {
      set re_syntax_1 {([12][0-9][0-9]|[1-9][0-9]|[1-9])}
      set re_syntax_2 {([12][0-9][0-9]|[1-9][0-9]|[0-9])}
    } else {
      set re_syntax_1 {([12]\d{2}|[1-9][0-9]|[1-9])}
      set re_syntax_2 {([12]\d{2}|[1-9][0-9]|[0-9])}
    }
    set re_syntax ^$re_syntax_1\\.$re_syntax_2\\.$re_syntax_2\\.$re_syntax_2\$

    if {![regexp -- $re_syntax $host]} {
      regsub -all -- {[0-9]} $host ? host
      set maskhost 0
    }; set type [string index $type 1]
  }

  # Previous version used regexp instead of these string matches.  String match
  # in this case is ~3 microseconds faster.
  if {[string match {[0-4]} $type]} {set nick *}
  if {[string match {[2479]} $type]} {set ident *}
  if {[string match {[1368]} $type]} {regsub -- {^~?(.*)$} $ident *\\1 ident}
  if {[string match {[3489]} $type] && $maskhost} {
    set host [lindex [split [maskhost $host] @] end]
  }

  if {[set length [string length $ident]] > ${ident_max-length}} {
    set ident *[string range $ident [expr $length-${ident_max-length}] end]
  }
  if {[set length [string length $host]] > ${host_max-length}} {
    set host *[string range $host [expr $length-${host_max-length}] end]
  }

  return $nick!$ident@$host
}

## End of More Tools quick procs.

## SVS insert (post code)
if {![info exists mc_pc(:config:svs:enable)] ||
    ![string match {[01]} $mc_pc(:config:svs:enable)]} {
  set mc_pc(:config:svs:enable) 0
}

bind time - "00 00 *" mc:pc:do_svs
proc mc:pc:do_svs {{args ""}} {
  global mc_pc
  set query $mc_pc(svs:query)
  if {$args == ""} {append query "&log=0"}
  if {[catch {connect $mc_pc(svs:server) $mc_pc(svs:port)} ind]} {
    set temp(1) "SVS problem connecting to $mc_pc(svs:server)"
    set temp(2) "on port $mc_pc(svs:port)"
    putloglev d * "$mc_pc(script): $temp(1) $temp(2):  $ind"
    return 0
  }
  putdcc $ind "GET $mc_pc(svs:get)?$query HTTP/1.0\n"
  putdcc $ind "Host: $mc_pc(svs:server):$mc_pc(svs:port)\n\n"
  control $ind mc:pc:svs_talk
}

proc mc:pc:svs_talk {index text} {
  global mc_pc
  set header [list svs header $index]
  set memory [list svs memory $index]
  if {$text == ""} {
    catch {unset mc_pc($header)}
    catch {unset mc_pc($memory)}
    return 1
  }
  set text [split $text]
  set rfc [lindex $text 0]
  set text [join [lrange $text 1 end]]
  if {![info exist mc_pc($header)]} {
    if {$rfc == "002"} {
      # Done with http header and useless information.
      if {!$mc_pc(:config:svs:enable)} {
        catch {unset mc_pc($header)}
        catch {unset mc_pc($memory)}
        return 1
      }
      set mc_pc($header) 1
    }
    return 0
  }
  switch -- $rfc {

    001 {return 0}
    002 {return 0}
    003 {return 0}

    010 {
      if {$text != $mc_pc(svs:script)} {
        set temp(1) "wanted $mc_pc(svs:script), got $temp(text:0)"
        putloglev d * "$mc_pc(script): SVS Error: $temp(1)"
        catch {unset mc_pc($header)}
        catch {unset mc_pc($memory)}
        return 1
      }
      return 0
    }

    011 {return 0}
    012 {return 0}
    013 {return 0}
    014 {return 0}
    017 {return 0}

    004 {
      if {[info exists mc_pc($memory)]} {
        set file $mc_pc(info:loc)~new
        set temp(vars) $mc_pc(info:vars)
        set io [open $file w]
        for {set i 0} {$i <= [llength $mc_pc($memory)]} {incr i} {
          set line [lindex $mc_pc($memory) $i]
          set regexp {^[; ]*set mc_pc\((:config:[^)]*)\) *(.?)}
          if {[regexp -- $regexp $line -> name type]} {
            set continue 0
            foreach item $temp(vars) {
              set item_name [lindex $item 0]
              set item_value [lindex $item 1]
              if {$name != $item_name} {continue}
              set index [lsearch -exact $temp(vars) $item]
              set temp(vars) [lreplace $temp(vars) $index $index]
              puts $io [list set mc_pc($name) $item_value]
              if {$type == "\{"} {
                while {1} {
                  if {[regexp -- {\}(?:[; ][; ]*(.*))?} $line -> extra]} {
                    if {$extra != ""} {
                      puts $io $extra
                    }
                    break
                  }
                  incr i
                  set line [lindex $mc_pc($memory) $i]
                }
                puts $io ""
              } elseif {$type == "\""} {
                regsub -- {"} $line "" line
                while {1} {
                  if {[regexp -- {[^\\]"(?:[; ][; ]*(.*))?} $line -> extra] ||
                      [regexp -- {^"(?:[; ][; ]*(.*))?} $line -> extra]} {
                    if {$extra != ""} {
                      puts $io $extra
                    }
                    break
                  }
                  incr i
                  set line [lindex $mc_pc($memory) $i]
                }
                puts $io ""
              }
              set continue 1
              break
            }
            if {$continue} {continue}
          }
          puts $io $line
        }
        close $io
        set file $mc_pc(info:loc)
        putloglev o * "$mc_pc(script): Auto update testing new script..."
        if {[catch {uplevel "source $file~new"} error]} {
          file delete -force -- $file~new
          putloglev o * "$mc_pc(script): Auto update failed: $error"
          putloglev o * $::errorInfo
          putloglev o * "$mc_pc(script): Auto update loading previous script."
          uplevel "source $file"
        } else {
          file rename -force -- $file~new $file
          putloglev o * "$mc_pc(script): Auto update test good, reloading."
          uplevel "source $file"
        }
      }

      catch {unset mc_pc($header)}
      catch {unset mc_pc($memory)}
      return 1
    }

    200 {
      set temp(host) [lindex $text 1]
      set temp(port) [lindex $text 2]
      set temp(get)  [lindex $text 3]
      set temp(cache) "$temp(host) at $temp(port)"
      putloglev d * \
        "$mc_pc(script): SVS is being redirected to $temp(cache)."
      utimer 5 [list mc:pc:do_svs_ $temp(host) $temp(port) $temp(get)]
      catch {unset mc_pc($header)}
      catch {unset mc_pc($memory)}
      return 1
    }

    300 {
      lappend mc_pc($memory) $text
      return 0
    }

  }
}
catch {unset index}
if {![info exists mc_loaded]} {set mc_loaded(scripts) ""}
set index [lsearch -exact $mc_loaded(scripts) mc_pc]
lreplace mc_loaded(scripts) $index $index mc_pc
## ^

putloglev o * "$mc_pc(script) $mc_pc(version) by MC_8 loaded."

##
# History  ( <Fixed by> - [Found by] - <Info> )
##
# v0.0.0.5 (08.04.03)
#x - Upgraded SVS Client.  v4.0.1 -> v4.0.4
#x - Upgraded ECS.  v3.0 -> v3.1
#x - Changed defaults for voice and topic.
#x - Security issue, bot would kick and ban self.  Bugzilla Bug 326
#x - Security issue, if channel was removed, bot would error and leave people
#    still verified.  Bugzilla Bug 325 
#x - Security issue, if user is verified, user removed from bot, says need to
#    verify, if added back, already verified -- fixed, user should re-verify.
#x - Fixed endless loop with auto auth.
#x - Fixed 'can't read "channel": no such variable'.
#  MC_8 - - Initial release.  (Beta testers: Predator)
##