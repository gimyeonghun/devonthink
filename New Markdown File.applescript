tell application id "DNtp"
	set theName to the text returned of (display dialog "Name?" default answer "")
	set theDatabase to get record at "/z"
	create record with {name:theName, type:markdown, plain text:"# " & theName & "
 {{TOC}} 
"} in display group selector
	set theID to uuid of result
	open location "x-devonthink-item://" & theID
end tell