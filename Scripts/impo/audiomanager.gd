extends Node
## AUDIO LIBRARY (move somewhere else maybe)?

var _cooldowns: Dictionary = {}

#expie sfx
@export var expie_whine: Array[AudioStream] = []
@export var expie_bark: Array[AudioStream] = []

#random sfx
@export var thudwoosh: AudioStream = load("res://assets/sounds/effects/thudswoosh.ogg")

func _ready() -> void:
	expie_whine = _load_sounds("res://assets/sounds/expie/whine/")
	expie_bark = _load_sounds("res://assets/sounds/expie/bark/")

## loads all sounds from this folder into an array
#is this the best way to do it? prob not. idk what's better though
func _load_sounds(path: String) -> Array[AudioStream]:
	var streams: Array[AudioStream] = []
	var dir := DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()

		while file_name != "":
			if not dir.current_is_dir():
				#clean up filetypes because exporting breaks this func
				var clean_name := file_name.replace(".import", "").replace(".remap", "")
				
				if clean_name.ends_with(".wav") or clean_name.ends_with(".ogg") or clean_name.ends_with(".mp3"):
					var full_path := path + clean_name
					var stream := load(full_path) as AudioStream
					
					# avoid dupes
					if stream and not streams.has(stream):
						streams.append(stream)
						
			file_name = dir.get_next()
	else:
		push_error("there is no file at this path: ", path)

	return streams


## plays a random sound from an array with a configurable chance (0.0 to 1.0)
func play_sfx(sound_list: Array[AudioStream], 
	chance: float = 1.0, 
	volume_db: float = 0.0, 
	pitch_scale: float = 1.0,
	cooldown_check = false, 
	cooldown_sec = 0.5, 
	cooldown_group = ""
) -> AudioStreamPlayer:
		
	if sound_list.is_empty() or randf() > chance or (check_cooldown and not check_cooldown(sound_list, cooldown_sec, cooldown_group)):
		return null

	var stream: AudioStream = sound_list.pick_random()
	return play_single_sfx(stream, 1.0, volume_db, pitch_scale)

## plays a single audiostream file directly
func play_single_sfx(stream: AudioStream, chance: float = 1.0, volume_db: float = 0.0, pitch_scale: float = 1.0) -> AudioStreamPlayer:
	if not stream or randf() > chance:
		return null

	# create temp audio node
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale

	# auto free the node once its done playing
	player.finished.connect(player.queue_free)

	add_child(player)
	player.play()
	return player

func check_cooldown(sound_list: Array[AudioStream], cooldown_sec: float, cooldown_group: String) -> bool:
	var key
	
	if not cooldown_group.is_empty():
		key = cooldown_group
	else:
		key = sound_list
		
	var current_time := Time.get_ticks_msec()
	var cooldown_ms := int(cooldown_sec * 1000.0)
	
	if _cooldowns.has(key):
		if current_time - _cooldowns[key] < cooldown_ms:
			return false

	_cooldowns[key] = current_time
	return true
