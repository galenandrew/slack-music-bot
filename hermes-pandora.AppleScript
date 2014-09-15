global lastTrack
global fullName
global slackLink
global searchLink

on run
	set fullName to "FULL NAME"
	set slackLink to "https://sq1.slack.com/services/hooks/incoming-webhook?token=API TOKEN"
	set searchLink to "https://www.youtube.com/results?search_query="
	--Hermes (Pandora) Setup for launch of the code
	tell application "Hermes"
		set TrackName to the current song's title
		set TrackArtist to the current song's artist
		set lastTrack to TrackName
	end tell
	set searchQuery to encode_text(TrackArtist & " " & TrackName, true, false)
	set query to searchLink & searchQuery
	--the first track gets its own tell 
	do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"#music\", \"username\": \"MusicBot\", \"text\": \"" & fullName & " is listening to <" & query & "|" & TrackName & " by " & TrackArtist & ">\", \"icon_emoji\": \":notes:\"}' " & slackLink
end run

--now comes the idle checks
on idle
	tell application "Hermes"
		set TrackName to the current song's title
		set TrackArtist to the current song's artist
	end tell
	if TrackName is not lastTrack then
		set searchQuery to encode_text(TrackArtist & " " & TrackName, true, false)
		set query to searchLink & searchQuery
		set lastTrack to TrackName
		do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"#music\", \"username\": \"MusicBot\", \"text\": \"" & fullName & " is listening to <" & query & "|" & TrackName & " by " & TrackArtist & ">\", \"icon_emoji\": \":notes:\"}' " & slackLink
	end if
	return 10
end idle

on encode_char(this_char)
	set the ASCII_num to (the ASCII number this_char)
	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set x to item ((ASCII_num div 16) + 1) of the hex_list
	set y to item ((ASCII_num mod 16) + 1) of the hex_list
	return ("%" & x & y) as string
end encode_char

-- this sub-routine is used to encode text 
on encode_text(this_text, encode_URL_A, encode_URL_B)
	set the standard_characters to "abcdefghijklmnopqrstuvwxyz0123456789"
	set the URL_A_chars to "$+!'/?;&@=#%><{}[]\"~`^\\|*"
	set the URL_B_chars to ".-_:"
	set the acceptable_characters to the standard_characters
	if encode_URL_A is false then set the acceptable_characters to the acceptable_characters & the URL_A_chars
	if encode_URL_B is false then set the acceptable_characters to the acceptable_characters & the URL_B_chars
	set the encoded_text to ""
	repeat with this_char in this_text
		if this_char is in the acceptable_characters then
			set the encoded_text to (the encoded_text & this_char)
		else
			set the encoded_text to (the encoded_text & encode_char(this_char)) as string
		end if
	end repeat
	return the encoded_text
end encode_text