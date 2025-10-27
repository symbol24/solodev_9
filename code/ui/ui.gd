extends CanvasLayer


var _screens:Array[RidControl] = []
var _active_screen:RidControl
var previous := &""


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.toggle_screen.connect(toggle_screen)


func toggle_screen(id:StringName, display:bool) -> void:
	var found := false
	for each in _screens:
		each.toggle_rid_control(id, display)
		if each.id == id: 
			found = true
			previous = _active_screen.id if _active_screen != null else &""
			_active_screen = each
			if display: move_child(each, get_child_count()-1)
	
	if not found:
		if Data.SCENES.controls.has(id):
			var new:RidControl = load(Data.SCENES.controls[id]).instantiate()
			add_child(new)
			_screens.append(new)
			move_child(new, get_child_count()-1)
			new.toggle_rid_control(id, display)
			previous = _active_screen.id if _active_screen != null else &""
			_active_screen = new
	
