extends Node2D
## Crisp Juice Free demo. Click anywhere to play the selected effect there.
## Pick an effect with the buttons, the Left / Right keys or the mouse wheel.

const SCENES := "res://addons/crisp_juice_free/scenes/"
const EFFECTS: Array[String] = [
	"gem_burst_blue",
	"match_pop_pink",
	"star_burst_gold",
	"coin_burst_gold",
	"confetti_burst_01",
	"ring_shockwave_white",
	"tap_ripple",
	"sparkle_twinkle_white_loop",
]
## How long a looping effect stays on screen in this demo.
const LOOP_SECONDS := 2.0

var _scenes: Array[PackedScene] = []
var _buttons: Array[Button] = []
var _index := 0
var _hint: Label


func _ready() -> void:
	for effect in EFFECTS:
		_scenes.append(load(SCENES + effect + ".tscn") as PackedScene)
	_build_ui()
	select(0)
	# One of each, so the screen is not empty on start.
	var size := get_viewport_rect().size
	for i in EFFECTS.size():
		var column := i % 4
		var row := floori(i / 4.0)
		play_effect(i, Vector2(size.x * (column + 0.5) / 4.0, size.y * (0.3 + 0.36 * row)))


func _build_ui() -> void:
	var backdrop := CanvasLayer.new()
	backdrop.layer = -1
	add_child(backdrop)
	var background := ColorRect.new()
	background.color = Color("171b2e")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.add_child(background)
	var layer := CanvasLayer.new()
	add_child(layer)
	_hint = Label.new()
	_hint.position = Vector2(16, 12)
	layer.add_child(_hint)
	var bar := HFlowContainer.new()
	bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE, Control.PRESET_MODE_MINSIZE, 12)
	bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
	bar.alignment = FlowContainer.ALIGNMENT_CENTER
	layer.add_child(bar)
	var group := ButtonGroup.new()
	for i in EFFECTS.size():
		var button := Button.new()
		button.text = EFFECTS[i].trim_suffix("_loop").replace("_", " ")
		button.toggle_mode = true
		button.button_group = group
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(select.bind(i))
		bar.add_child(button)
		_buttons.append(button)


## Make effect number [param index] the one that a click plays.
func select(index: int) -> void:
	_index = wrapi(index, 0, EFFECTS.size())
	_buttons[_index].set_pressed_no_signal(true)
	_hint.text = "%s  (%d / %d)\nClick anywhere to play it  -  Left / Right or mouse wheel to change" % [
		EFFECTS[_index], _index + 1, EFFECTS.size()]


## Spawn effect number [param index] at [param at] and return the node.
func play_effect(index: int, at: Vector2) -> Node2D:
	var node := CrispVfx.spawn(_scenes[index], self, at)
	if node is CrispVfx and (node as CrispVfx).loop:
		# Loops never finish on their own, so the demo removes them after a moment.
		get_tree().create_timer(LOOP_SECONDS).timeout.connect(node.queue_free)
	return node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			play_effect(_index, get_local_mouse_position())
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			select(_index + 1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			select(_index - 1)
	elif event.is_action_pressed("ui_right"):
		select(_index + 1)
	elif event.is_action_pressed("ui_left"):
		select(_index - 1)
