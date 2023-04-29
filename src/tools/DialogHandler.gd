extends Node

signal dialog_playing(isPlaying, name)

func playDialogOption(name: String) -> void:
	emit_signal("dialog_playing", true, name)
	
	var dialog = Dialogic.start(name)
	dialog.connect("timeline_end", self, 'dialog_finished')
	dialog.connect("dialogic_signal", self, 'dialogic_signal')
	
	add_child(dialog)

func dialog_finished(timeline_name):
	emit_signal("dialog_playing", false, timeline_name)

func dialogic_signal(arg):
	if(arg == String(0)):
		Globals.killHost = true
	else:
		Globals.killHost = false
