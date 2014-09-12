global lastTrack
global fullName
global slackLink

on run
	set fullName to "FULL NAME"
	set slackLink to "https://sq1.slack.com/services/hooks/incoming-webhook?token=API TOKEN"
	--Hermes (Pandora) Setup for launch of the code
	tell application "Hermes"
		set TrackName to the current song's title
		set TrackArtist to the current song's artist
		set lastTrack to TrackName
	end tell
	--the first track gets its own tell 
	do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"#music\", \"username\": \"MusicBot\", \"text\": \"" & fullName & " is listening to " & TrackName & " by " & TrackArtist & "\", \"icon_emoji\": \":notes:\"}' " & slackLink
end run

--now comes the idle checks
on idle
	tell application "Hermes"
		set TrackName to the current song's title
		set TrackArtist to the current song's artist
	end tell
	if TrackName is not lastTrack then
		set lastTrack to TrackName
		do shell script "curl -X POST --data-urlencode 'payload={\"channel\": \"#music\", \"username\": \"MusicBot\", \"text\": \"" & fullName & " is listening to " & TrackName & " by " & TrackArtist & "\", \"icon_emoji\": \":notes:\"}' " & slackLink
	end if
	return 10
end idle