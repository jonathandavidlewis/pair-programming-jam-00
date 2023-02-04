extends Node

onready var DIALOG_POPUP = $PopupDialog
onready var DIALOG_LIST_NODE = DIALOG_POPUP.get_node("Dialog")
onready var dialog_nodes = DIALOG_LIST_NODE.get_children()
onready var dialogs = create_dialogs_dict(dialog_nodes)
onready var DIALOG_CONTAINER = DIALOG_POPUP.get_node("DialogContainer")
var on_close_signal_name = ""


func _ready():
	Signals.connect("all_goals_completed", self, "_on_all_goals_completed")
	open_dialog("ItLooksLikeUrStuck")

func _on_all_goals_completed():
	# TODO: actually completele level??
	# open dialog on level complete!!
	open_dialog("LevelComplete", "level_completed")
	

func show_end_level():
	open_dialog("LevelComplete")
	Signals.emit_signal("level_completed")
	

func open_dialog(name = "LevelComplete", on_close_signal = ""):
	on_close_signal_name = on_close_signal
	get_tree().paused = true
	print(DIALOG_CONTAINER)
	DIALOG_CONTAINER.text = dialogs[name]
	DIALOG_POPUP.popup()
	

func close_dialog():
	get_tree().paused = false
	DIALOG_POPUP.visible = false
	Signals.emit_signal(on_close_signal_name)
	on_close_signal_name = ""
	
func _on_popup_hidden():
	close_dialog()

func _input(event):
	if DIALOG_POPUP.visible and event.is_action_pressed("ui_accept"):
		close_dialog()

func create_dialogs_dict(dialogs) -> Dictionary:
	var dialogs_dict = {}
	for dialog_node in dialogs:
		dialogs_dict[dialog_node.name] = dialog_node.text
	print(dialogs_dict)
	return dialogs_dict

func _on_PopupDialog_popup_hide():
	pass # Replace with function body.
