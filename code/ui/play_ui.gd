class_name PlayUi extends RidControl


var _player_data:PlayerCharacterData
var _heart_ps:PackedScene
var _hearts:Array[Heart] = []
var _heart_updates := 0
var _updating_hearts := false
var _life_ps:PackedScene
var _lives:Array[Life] = []

@onready var timer: Label = %timer
@onready var start_timer: Label = %start_timer
@onready var hp_bar: HBoxContainer = %hp_bar
@onready var lives: HBoxContainer = %lives


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.toggle_ground_color.connect(_swap_color)
	Signals.timer_updated.connect(_update_timer)
	Signals.start_countdown.connect(_start_countdown)
	Signals.character_data_ready.connect(_player_data_ready)
	Signals.character_hp_updated.connect(_hp_updated)
	Signals.character_lives_updated.connect(_update_lives)
	_heart_ps = load(Data.HEART_PATH)
	_life_ps = load(Data.LIFE_PATH)


func _process(_delta: float) -> void:
	if _heart_updates > 0 and not _updating_hearts: _update_hearts()


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			timer.text = "00:00:00"
			show()
		else:
			hide()


func _swap_color(color:Color) -> void:
	if color == Data.WHITE:
		timer.modulate = Data.BLACK
	else:
		timer.modulate = Data.WHITE


func _update_timer(value:String) -> void:
	timer.text = value


func _start_countdown() -> void:
	await get_tree().create_timer(0.4, false).timeout
	start_timer.show()
	var c := 3
	for x in c:
		if x < c:
			start_timer.text = str(c - x)
		await get_tree().create_timer(1.0, false).timeout
	start_timer.text = "GO!"
	Signals.start_round.emit()
	await get_tree().create_timer(1.0, false).timeout
	start_timer.hide()


func _hp_updated() -> void:
	_heart_updates += 1


func _update_hearts() -> void:
	_updating_hearts = true
	if _player_data.max_hp > _hearts.size():
		_construct_hp()
	var x := 0
	while x < _player_data.max_hp:
		if x > _player_data.current_hp-1:
			_hearts[x].toggle_heart(false)
		else:
			_hearts[x].toggle_heart(true)
		x += 1
	
	_heart_updates -= 1
	if _heart_updates < 0: _heart_updates = 0
	_updating_hearts = false


func _player_data_ready(data:PlayerCharacterData) -> void:
	_player_data = data
	_construct_hp()
	_update_lives()


func _construct_hp() -> void:
	var amount := _player_data.max_hp - _hearts.size()
	for x in amount:
		var new_heart:Heart = _heart_ps.instantiate()
		hp_bar.add_child(new_heart)
		_hearts.append(new_heart)


func _update_lives() -> void:
	if _lives.size() > _player_data.current_lives:
		var amount = _lives.size() - _player_data.current_lives
		for x in amount:
			var temp = _lives.pop_back()
			temp.queue_free.call_deferred()
	elif _lives.size() < _player_data.current_lives:
		var amount = _player_data.current_lives - _lives.size()
		for x in amount:
			var new_life:Life = _life_ps.instantiate()
			lives.add_child(new_life)
			_lives.append(new_life)
