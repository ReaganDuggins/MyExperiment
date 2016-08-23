set fp [open "alice.txt" r]
set file_data [read $fp]
set wordRe {([^aeiouAEIOU]*)([aeiouAEIOU][\w]*)}
set yay "yay"
set data [split $file_data]
    foreach line $data {
      if {[regexp {[aeiouAEIOU]} [string range $line 0 1]]} { set yay "ay" }
      regsub $wordRe $line {\2\1} newline
      set line [string tolower $newline]
      puts -nonewline $line$yay
      puts -nonewline " "
    }
puts "\n"