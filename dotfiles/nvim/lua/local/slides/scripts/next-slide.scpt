#!/usr/bin/osascript

on run argv
	-- Get count from command line argument, default to 1
	if (count of argv) > 0 then
		set slideCount to item 1 of argv as integer
	else
		set slideCount to 1
	end if

	-- Store the current application
	tell application "System Events"
		set frontApp to name of first application process whose frontmost is true
	end tell

	tell application "Google Chrome"
		-- Search through all windows and tabs
		repeat with w in windows
			repeat with t in tabs of w
				if URL of t contains "slides.google.com" then
					set active tab index of w to index of t
					-- Bring this window to the front
					set index of w to 1
					exit repeat
				end if
			end repeat
		end repeat

		activate
	end tell

	tell application "System Events"
		-- Send arrow key multiple times based on count
		repeat slideCount times
			key code 124 -- Right arrow
			if slideCount > 1 then
				delay 0.05 -- Small delay between slides only if multiple
			end if
		end repeat
	end tell

	-- Return to previous application immediately
	tell application frontApp
		activate
	end tell
end run
