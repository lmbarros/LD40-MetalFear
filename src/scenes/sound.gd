extends Node

func playStartAlarm():
	$sfx/startAlarm.play()
	
func playPunch():
	$sfx/punch.play()
	
func playGunfire():
	$sfx/gunfire.play()

func playTheme():
	stopMusic()
	$music/theme.play()

func playTense():
	stopMusic()
	$music/tense.play()

func playDanger():
	stopMusic()
	$music/danger.play()

func stopMusic():
	$music/theme.stop()
	$music/tense.stop()
	$music/danger.stop()
