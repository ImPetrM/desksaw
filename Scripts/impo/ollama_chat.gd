extends Control

var messages: Array = []
var http: HTTPRequest
var chat_log: RichTextLabel
var input_field: LineEdit

func _ready() -> void:
	print("OllamaChat: _ready() started")
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_response)
	print("OllamaChat: HTTPRequest created")

	chat_log = $ScrollContainer/ChatLog
	input_field = $HBoxContainer/LineEdit
	input_field.add_theme_font_size_override("font_size", 18)
	chat_log.add_theme_font_size_override("normal_font_size", 14)
	var enabled = gbData.settings.get("ollamaEnabled", false)
	print("OllamaChat: enabled = ", enabled, ", model = ", gbData.settings.get("ollamaModel", ""))
	append_message("System", "Chat ready. Enable Ollama in Settings and type a message.")

func _on_send(text: String = "") -> void:
	print("OllamaChat: _on_send called, text='", text, "'")
	if text.is_empty():
		text = input_field.text
		print("OllamaChat: read from input_field, text='", text, "'")
	if text.strip_edges().is_empty():
		print("OllamaChat: empty message, ignoring")
		return
	if not gbData.settings.get("ollamaEnabled", false):
		append_message("System", "Ollama is disabled. Enable it in Settings.")
		print("OllamaChat: Ollama disabled")
		input_field.clear()
		return

	append_message("You", text)
	messages.append({"role": "user", "content": text})
	input_field.clear()
	input_field.editable = false
	print("OllamaChat: calling _send_to_ollama")
	_send_to_ollama()

func _send_to_ollama() -> void:
	var url = gbData.settings.get("ollamaUrl", "http://127.0.0.1:11434")
	var model = gbData.settings.get("ollamaModel", "llama3.2:latest")

	var dia = gbData.text.get("diaGlobal", {})
	var examples = ""
	var categories = ["start", "passive", "pet", "beingDragged", "getUp"]
	for cat in categories:
		var lines = dia.get(cat, [])
		if lines.size() > 0:
			examples += "\n" + cat + ": " + "; ".join(lines)

	var system_prompt = "You are an expie, a cute desktop pet creature. You are shy, meek, and easily flustered. Keep responses VERY short (1 sentence max, rarely 2). Never use emoji. Never break character. Do NOT use asterisks or roleplay actions like *looks down* or *smiles* — only speak dialogue. Here are examples of how the expie talks:" + examples

	var ollama_messages = [{"role": "system", "content": system_prompt}]
	for m in messages:
		ollama_messages.append(m.duplicate())

	var body = {
		"model": model,
		"messages": ollama_messages,
		"stream": false
	}

	var json_body = JSON.stringify(body)
	var headers = PackedStringArray(["Content-Type: application/json"])

	var full_url = url + "/api/chat"
	print("Ollama: sending request to ", full_url)
	print("Ollama: body length = ", json_body.length())

	var err = http.request(full_url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		var msg = "Failed to send request (error " + str(err) + ")"
		append_message("System", msg)
		print("Ollama: ", msg)
		input_field.editable = true
	else:
		append_message("System", "Waiting for Ollama response...")
		print("Ollama: request sent successfully")

func _on_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	input_field.editable = true
	print("Ollama: response received, result=", result, " code=", response_code)
	if result != HTTPRequest.RESULT_SUCCESS:
		append_message("System", "Request failed (result " + str(result) + ")")
		return
	if response_code != 200:
		var body_text = body.get_string_from_utf8()
		print("Ollama: error body: ", body_text)
		append_message("System", "Ollama returned HTTP " + str(response_code))
		return

	var body_text = body.get_string_from_utf8()
	print("Ollama: response body length = ", body_text.length())

	var json = JSON.parse_string(body_text)
	if json == null or not json.has("message"):
		append_message("System", "Failed to parse Ollama response")
		print("Ollama: parse failed, body start: ", body_text.left(200))
		return

	var reply = json.message.content.strip_edges()
	messages.append({"role": "assistant", "content": reply})
	append_message("Expie", reply)

	_speak_via_expie(reply)

func append_message(who: String, text: String) -> void:
	var bb = "[b]" + who + "[/b]: " + text
	if chat_log.text.is_empty():
		chat_log.text = bb
	else:
		chat_log.text += "\n" + bb
	await get_tree().process_frame
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value

func _speak_via_expie(text: String) -> void:
	var expie = get_tree().current_scene.find_child("dialogue", true, false)
	if expie and expie.has_method("setDia"):
		expie.setDia(text, 1.0, 2.0, true)
