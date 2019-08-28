extends Control

var server = Game.get_server()

func _ready():
	var file = File.new()
	if(!file.file_exists("user://config.cfg")):
		file.open("user://config.cfg", File.WRITE)
		file.store_string("[server]\nurl=\"http://localhost:9090\"")
		file.close()
	
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err == OK:
		server = config.get_value("server", "url", "http://localhost:9090")
		$Server.text = server

func _on_Server_text_changed(endpoint):
	server = endpoint

func _on_Back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_HTTP_check_server_request_completed(result, response_code, headers, body):
	var message = self.get_node("Test_status")
	if(response_code == 200):
		message.set_text("Connected to Server")
		Game.set_server(server)
	else:
		message.set_text("Failed to Connect to Server")

func _on_Test_pressed():
	var url = server + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_check_server.request(url, headers, false, HTTPClient.METHOD_GET, "")


func _on_Save_pressed():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	if err == OK:
		config.set_value("server", "url", server)
		config.save("user://config.cfg")
