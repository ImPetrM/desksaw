extends Node

class_name SaveLoadSys


"""
###

This is the thing that handles saving and loading. 

Heres the steps that it does through:

    Loading:
        1: Check if there is a save file. If there is, load it into data
        2: Check for a translation file in deedee/expet/lang. If there is, load it into the translation system.
        3: If there isnt. load yapENG into text.
        
    Saving:
        1: Check if there is a save file. If there isnt, make one.
        2: Save data inside the data variable to the save file.

    Creating a new file:
        1: Read SaveTemplate.json.
        2: Apply save template to data. 
        3: Randomize some variables 
        4: Create a new JSON file based on whats in data


this shit sound like ai wrote it im sorry it sounds like that 

looking back now that im publicizing this this probably isnt even right anymore
"""

var temp = {"expies": {}} # temp dictionary, not to be saved but used instead used to store things like expies currently spawned (to add to save if setting is enabled mid-play)

var data = {}
var text = {}
var settings = {}

var skinData = []

var template = "res://Scripts/singletons/SaveTemplate.json"


# DO NOT FORGET TO DISABLE THIS WHENBUILDING 
var devMode = false

const currver = "v0.0.2"

const savePath = "user://SAVE.json"
const transPath = "user://TRANSLATION.json"
const conPath = "user://CONFIG.json"
const skinfilepath = "user://skin"


func _ready():
	# Load save file
	if FileAccess.file_exists(savePath):
		data = loadjson(savePath)
		if data["save"]["expies"] == {}: data["save"]["expies"] = {"Default": 1} # force a default expie to spawn if no expie data on load. avoids crash

	else:
		newsave()
	
	# Load translation file
	if FileAccess.file_exists(transPath):
		text = loadjson(transPath)

	else:
		newTrans()

	# Load settings/config file
	if FileAccess.file_exists(conPath):
		settings = loadjson(conPath)

	else:
		newConfig()

	if DirAccess.dir_exists_absolute(skinfilepath):
		skinData = loadSkin()
		#print(skinData)
		#load file
		pass
		#settings = loadjson(conPath)
	else:
		newSkinFile()


	InitAutosave()


func newsave():
	# Read the save template
	if template == null:
		print("template not found")
		return
	
	#set data json to template
	data = loadjson(template).duplicate(true)

	randomize()

	data.save["mood"] += randi_range(-5, 5)
	data.save["hunger"] -= randi_range(1, 5)
	data.save["trust"] += randi_range(-10, 0)

	savetodisk(savePath, data)

func newTrans():
	#fix this later make it bassdfjogsdjfoigjsdfgjosdifgjiosdfjg nvm its good as it
	var defaultTrans = "res://Scripts/singletons/TEMPDialogue.json"
	
	text = loadjson(defaultTrans).duplicate(true)
	savetodisk(transPath, text)

func newConfig():
	var configFile = "res://Scripts/singletons/config.json"

	settings = loadjson(configFile).duplicate(true)
	savetodisk(conPath, settings)

func newSkinFile():
	var readMeF = skinfilepath + "/READ.txt"
	

	if not DirAccess.dir_exists_absolute(skinfilepath):
		var error = DirAccess.make_dir_recursive_absolute(skinfilepath)
		
		if error == OK:
			var txt = FileAccess.open(readMeF, FileAccess.WRITE)
			

			if txt:
				txt.store_line("""Drop the Body folder of your skin into this folder!


In theory, everything on https://skin.cat-bot.de/ should be compatible with this!

If you want multiple skins, just rename your 'Body' folder to whatever you want to call it, then use the skin spawner.
(however you have to keep a 'Body' folder with any skin in it for it to work!)
If you have both a 'Body' and 'Head' folder, combine the files inside them into a new folder and drag them in here.

If your skin is only on the head, try restarting the app. That usually fixes it.""")
				txt.close()
	
	var folder_to_copy = "res://assets/Body"
	
	var new_dir_path : String = "user://skin/Body"
	DirAccess.make_dir_absolute(new_dir_path)
	
	#Copy each file and folder into the new folder
	var old_files : PackedStringArray = DirAccess.get_files_at(folder_to_copy)
	for f : String in old_files:
		DirAccess.copy_absolute(folder_to_copy + "/" + f, new_dir_path + "/" + f)
	var old_directories : PackedStringArray = DirAccess.get_directories_at(folder_to_copy)


func loadSkin():
		var _ifliterallyanythingisthere = false
		var added = []
		var pt = skinfilepath + "/Body"
		if DirAccess.dir_exists_absolute(pt):
			var files = DirAccess.get_files_at(pt)
			for file in files:
				if file.get_extension().to_lower() == "png":
					_ifliterallyanythingisthere = true
					added.append(skinfilepath.path_join(file))
			
		return added


# my favorite helpers!
#theyre gone nvm
func loadjson(filepath: String):
	if FileAccess.file_exists(filepath):
		var datafile = FileAccess.open(filepath, FileAccess.READ)
		var parsedresult = JSON.parse_string(datafile.get_as_text())
		if parsedresult is Dictionary:
			return parsedresult
		else:
			if gbData.devMode:
				print("Error parsing JSON file: " + filepath)
			return {}
	else:
		if gbData.devMode:
			print("File not found: " + filepath)
		return {}

func savetodisk(path, dt):
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var json_string = JSON.stringify(dt, "\t")
			file.store_line(json_string)
			file.close()


func InitAutosave():
	while true:
		await get_tree().create_timer(3.0).timeout
		if gbData.devMode:
			print("saved")
		if gbData.settings.expiePersistence: # check if persistence is enabled
			gbData.data["save"]["expies"] = gbData.temp.expies # copy temp expie data to save
		
		savetodisk(savePath, data)
		savetodisk(conPath, settings)


func killEverything():
	newsave()
	newTrans()
	newSkinFile()
	newConfig()
	pass

func outdated():
	if settings.outdated:
		print("what")
		return
	settings.outdated = true
	killEverything()

func checkupdated():
	if !settings.outdated: return
	print("what")
	settings.outdated = false
	killEverything()
