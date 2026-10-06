extends SceneTree
# Headless check for Crisp Juice Free. Run from the project folder:
#   godot --headless --path . --script res://tests/test_addon.gd
# Loads every effect scene, steps each one through its whole animation and exercises CrispVfx and the demo.

const ADDON := "res://addons/crisp_juice_free/"
# name: [frames, cell, cols, rows, loop, additive]  (from the pack's sheets.json)
const SHEETS := {
	"gem_burst_blue": [20, 192, 8, 3, false, false],
	"match_pop_pink": [16, 192, 8, 2, false, false],
	"star_burst_gold": [24, 192, 8, 3, false, false],
	"coin_burst_gold": [30, 256, 8, 4, false, false],
	"confetti_burst_01": [36, 256, 8, 5, false, false],
	"ring_shockwave_white": [16, 192, 8, 2, false, false],
	"tap_ripple": [14, 192, 8, 2, false, false],
	"sparkle_twinkle_white_loop": [24, 192, 8, 3, true, true],
}

var _bad: Array[String] = []
var _finished := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_bad.append(what)


func _on_finished() -> void:
	_finished += 1


func _initialize() -> void:
	await process_frame  # nodes added before the first frame would not get _ready() yet
	var holder := Node2D.new()
	root.add_child(holder)
	var scenes := 0
	var one_shots := 0
	for effect: String in SHEETS:
		var spec: Array = SHEETS[effect]
		var scene := load(ADDON + "scenes/" + effect + ".tscn") as PackedScene
		_check(scene != null, effect + ": scene did not load")
		if scene == null:
			continue
		scenes += 1
		var node := CrispVfx.spawn(scene, holder, Vector2(40, 50), 2.0)
		var vfx := node as CrispVfx
		_check(vfx != null, effect + ": root is not a CrispVfx")
		if vfx == null:
			continue
		_check(vfx.get_parent() == holder and vfx.position == Vector2(40, 50) and vfx.scale == Vector2(2, 2), effect + ": spawn() placement")
		_check(vfx.texture != null, effect + ": no texture")
		if vfx.texture != null:
			_check(vfx.texture.get_size() == Vector2(spec[1] * spec[2], spec[1] * spec[3]), effect + ": sheet size %s" % vfx.texture.get_size())
		_check(vfx.hframes == spec[2] and vfx.vframes == spec[3] and vfx.frame_count == spec[0], effect + ": grid / frame count")
		_check(vfx.loop == spec[4], effect + ": loop flag")
		_check((vfx.material != null) == spec[5], effect + ": additive material")
		_check(vfx.is_playing() and vfx.visible and vfx.frame == 0, effect + ": autoplay")
		_check(is_equal_approx(vfx.get_duration(), spec[0] / 30.0), effect + ": duration")
		vfx.finished.connect(_on_finished)
		var before := _finished
		var max_frame := 0
		for step in spec[0] * 2 + 10:  # two steps per sheet frame
			vfx._process(1.0 / 60.0)
			max_frame = maxi(max_frame, vfx.frame)
		_check(max_frame == spec[0] - 1, effect + ": last frame reached was %d" % max_frame)
		if spec[4]:
			_check(vfx.is_playing() and _finished == before and not vfx.is_queued_for_deletion(), effect + ": loop should keep playing")
			vfx.stop()
			_check(not vfx.is_playing() and not vfx.visible, effect + ": stop()")
			vfx.play()
			_check(vfx.is_playing() and vfx.visible and vfx.frame == 0, effect + ": play()")
			vfx.queue_free()
		else:
			one_shots += 1
			_check(not vfx.is_playing() and _finished == before + 1, effect + ": finished signal")
			_check(vfx.is_queued_for_deletion(), effect + ": free_on_finish")
	await process_frame

	# A reusable node: free_on_finish off, play() twice.
	var reuse := (load(ADDON + "scenes/tap_ripple.tscn") as PackedScene).instantiate() as CrispVfx
	reuse.autoplay = false
	reuse.free_on_finish = false
	holder.add_child(reuse)
	_check(not reuse.visible and not reuse.is_playing(), "autoplay off should start hidden")
	for pass_index in 2:
		reuse.play()
		for step in 40:
			reuse._process(1.0 / 60.0)
		_check(not reuse.is_playing() and not reuse.visible and not reuse.is_queued_for_deletion(), "reuse pass %d" % pass_index)

	# The demo scene: it spawns one of each on start; then select and play each effect by hand.
	var demo := (load(ADDON + "demo/vfx_demo.tscn") as PackedScene).instantiate()
	root.add_child(demo)
	await process_frame
	var started := demo.find_children("*", "Sprite2D", true, false).size()
	_check(started == SHEETS.size(), "demo should start with %d effects, has %d" % [SHEETS.size(), started])
	var played := 0
	for i in demo.EFFECTS.size():
		demo.select(i)
		var spawned: Node2D = demo.play_effect(i, Vector2(100 + 60 * i, 200))
		if spawned is CrispVfx and spawned.is_inside_tree():
			played += 1
	for frame_index in 5:
		await process_frame

	print("RESULT effect_scenes=%d/%d one_shots_finished=%d demo_effects_played=%d/%d bad=%s" % [
		scenes, SHEETS.size(), _finished, played, SHEETS.size(), str(_bad)])
	quit(0 if _bad.is_empty() and scenes == SHEETS.size() and played == SHEETS.size() else 1)
