use scripting additions

property MainUUID : ""

tell application id "DNtp"
	
	try
		set invalid to false
		
		set RTFLinks to false
		set UseAliases to false
		set AutoWikiLinks to false
		
	on error error_message number error_number
		set invalid to true
		if invalid then error "Error"
	end try
	
	set theRecord to (content record of think window 1)
	set theText to plain text of theRecord
	set theName to name of theRecord
	
	set theSearchList to "\"" & theName & "\""
	
	-- Perform the search
	set theGroup to get record with uuid MainUUID
	set theRecords to search "content:" & theSearchList & space & "kind:markdown" in theGroup
	
	set theList to {}
	repeat with each in theRecords
		set the end of theList to "- [" & name of each & "]" & "(" & reference URL of each & "?search=" & name of theRecord & ")" & "
"
	end repeat
	set theList to my sortlist(theList)
	
	-- Remove old Returnlinks section
	try
		set oldDelims to AppleScript's text item delimiters
		set AppleScript's text item delimiters to {"## Back links"}
		set delimitedList to every text item of theText
		set AppleScript's text item delimiters to oldDelims
	on error
		set AppleScript's text item delimiters to oldDelims
	end try
	
	-- Add new ReturnLinks section
	try
		set theText to item 1 of delimitedList
		set theText to my trimtext(theText, "
", "end")
		set the plain text of theRecord to theText & "

## Back links" & return & theList as text
	end try
	display notification "Hooray! Success!"
end tell



-- Handlers section

on replaceText(theString, old, new)
	set {TID, text item delimiters} to {text item delimiters, old}
	set theStringItems to text items of theString
	set text item delimiters to new
	set theString to theStringItems as text
	set text item delimiters to TID
	return theString
end replaceText

on trimtext(theText, theCharactersToTrim, theTrimDirection)
	set theTrimLength to length of theCharactersToTrim
	if theTrimDirection is in {"beginning", "both"} then
		repeat while theText begins with theCharactersToTrim
			try
				set theText to characters (theTrimLength + 1) thru -1 of theText as string
			on error
				-- text contains nothing but trim characters
				return ""
			end try
		end repeat
	end if
	if theTrimDirection is in {"end", "both"} then
		repeat while theText ends with theCharactersToTrim
			try
				set theText to characters 1 thru -(theTrimLength + 1) of theText as string
			on error
				-- text contains nothing but trim characters
				return ""
			end try
		end repeat
	end if
	return theText
end trimtext

on sortlist(theList)
	set theIndexList to {}
	set theSortedList to {}
	repeat (length of theList) times
		set theLowItem to ""
		repeat with a from 1 to (length of theList)
			if a is not in theIndexList then
				set theCurrentItem to item a of theList as text
				if theLowItem is "" then
					set theLowItem to theCurrentItem
					set theLowItemIndex to a
				else if theCurrentItem comes before theLowItem then
					set theLowItem to theCurrentItem
					set theLowItemIndex to a
				end if
			end if
		end repeat
		set end of theSortedList to theLowItem
		set end of theIndexList to theLowItemIndex
	end repeat
	return theSortedList
end sortlist
