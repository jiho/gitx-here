(*
 *	AppleScript app which opens GitX in the current Finder directory
 *	
 *	Pressing OPTION or COMMAND opens GitX in commit mode
 *	
 *	Modified from the OpenTerminalHere described there:
 *		http://jo.irisson.free.fr/?p=59
 *
 *	(c) 2009 Jean-Olivier Irisson <irisson@normalesup.org>. 
 *	GNU General Public License http://www.gnu.org/copyleft/gpl.html
 *)


(*
 *	Defaults
 *)

-- Whether to use commit mode (1 = false)
property commit : 1
-- TODO: add a second property triggered when option is down which presents a dialog to input command line options


(* 
 * Event Handlers
 *)

-- this is triggered when the application icon is clicked
on open untitled theObject
	
	-- when the command key is pressed, open GitX in commit mode
	set commandKeyDown to (call method "cmdKeyDown" of class "StartupController") as boolean
	if (commandKeyDown) then
		set commit to 0
	end if
	
	-- when the option key is pressed, open GitX in commit mode
	set optionKeyDown to (call method "optKeyDown" of class "StartupController") as boolean
	if (optionKeyDown) then
		set commit to 0
	end if
	
	-- get the folder *displayed* in the frontmost Finder window
	-- NB: folders with a .git extension are considered as files by the Finder. This means that when the folder /Users/joe/code/whatever.git is selected in the Finder, thisFolder contains "/Users/joe/code/", *not* "/Users/joe/code/whatever.git". However, this is not a problem because whatever.git can be double clicked or dropped on the icon to open it with GitX
	tell application "Finder"
		set thisFolder to (the target of the front window) as alias
		-- display dialog thisFolder as string
	end tell
	
	-- open GitX targetting this folder
	my openGitX(thisFolder)
	
	quit
	
end open untitled


-- this is triggered when some documents/folders are dropped on the icon
on open theObject
	
	-- same key events detection
	set commandKeyDown to (call method "cmdKeyDown" of class "StartupController") as boolean
	if (commandKeyDown) then
		set commit to 0
	end if
	
	set optionKeyDown to (call method "optKeyDown" of class "StartupController") as boolean
	if (optionKeyDown) then
		set commit to 0
	end if
	
	-- open each dropped element separately
	-- useful to open several git repositories at once
	repeat with thisItem in theObject
		my openGitX(thisItem)
	end repeat
	
	quit
	
end open


(*
 * 	Open GitX
 *)

on openGitX(theItem)
	-- The command line version of gitx is called here because it allows to add command line options. Therefore, obviously, it must be installed
	-- The actual app could be called in Applescript using something like:
	-- 	tell application "GitX"
	-- 		open thePath
	-- 	end tell
	-- but only in the default case.

	-- get the POSIX path of theItem (dropped or Finder selection)
	set thePath to POSIX path of theItem
	-- display dialog thePath
	
	-- strip file name out of the path to get a directory (i.e. `dirname` in Applescript)
	-- this allows a file within a git repository to be dropped on the icon and GitX to open the parent repository
	repeat until thePath ends with "/"
		set thePath to text 1 thru -2 of thePath
	end repeat
	--display dialog thePath
	
	-- set options
	if commit is equal to 0 then
		set options to "-c"
	-- here would come another if condition with a display dialog which could collect command line options 
	else
		set options to ""
	end if
	
	-- construct command line	
	set command to "cd " & quoted form of thePath & " && " & "/usr/local/bin/gitx " & options
	--display dialog command
	
	-- execute command
	do shell script command
	-- TODO: detect the exit status and display an information dialog when the an error occurs (such as when the folder is not a git repository)
	
end openGitX
