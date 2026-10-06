class_name CrispVfx
extends Sprite2D
## Plays a sprite-sheet effect. One-shot effects free themselves when they finish; loops keep playing.
##
## Drop a scene from addons/crisp_juice_free/scenes into your level, or spawn one from code:
## [codeblock]
## const BURST := preload("res://addons/crisp_juice_free/scenes/gem_burst_blue.tscn")
## CrispVfx.spawn(BURST, self, gem.position)
## [/codeblock]

## Emitted when a one-shot effect has shown its last frame (never emitted while [member loop] is on).
signal finished

## Frames per second. The sheets were drawn for 30.
@export var fps: float = 30.0
## Loop forever instead of finishing.
@export var loop: bool = false
## Start playing as soon as the node enters the tree.
@export var autoplay: bool = true
## One-shot effects: remove the node when the last frame has shown. Turn off to reuse it with play().
@export var free_on_finish: bool = true
## Number of frames in the sheet (0 = hframes * vframes).
@export var frame_count: int = 0

var _time := 0.0
var _playing := false


func _ready() -> void:
	if autoplay:
		play()
	else:
		visible = false


## Restart the effect from its first frame.
func play() -> void:
	_time = 0.0
	frame = 0
	_playing = true
	visible = true


## Stop and hide the effect without freeing it.
func stop() -> void:
	_playing = false
	visible = false


func is_playing() -> bool:
	return _playing


## Length of one pass through the sheet, in seconds.
func get_duration() -> float:
	return _count() / maxf(fps, 0.001)


func _count() -> int:
	return frame_count if frame_count > 0 else hframes * vframes


func _process(delta: float) -> void:
	if not _playing:
		return
	_time += delta
	var count := _count()
	var index := int(_time * fps)
	if index >= count:
		if loop:
			_time = fmod(_time, count / maxf(fps, 0.001))
			index = int(_time * fps) % count
		else:
			_playing = false
			finished.emit()
			if free_on_finish:
				queue_free()
			else:
				visible = false
			return
	frame = index


## Instance an effect scene under [param parent] at [param at] (in the parent's local space) and return it.
## [param scale_by] scales the effect uniformly.
static func spawn(scene: PackedScene, parent: Node, at: Vector2 = Vector2.ZERO, scale_by: float = 1.0) -> Node2D:
	var node := scene.instantiate() as Node2D
	node.position = at
	node.scale = Vector2.ONE * scale_by
	parent.add_child(node)
	return node
