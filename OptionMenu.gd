extends Control

var server = Server.get_server()

func _on_Server_text_changed(endpoint):
	server = endpoint

func _on_Back_pressed():
	get_tree().change_scene("res://GameMenu.tscn")

func _on_HTTP_check_server_request_completed(result, response_code, headers, body):
	var message = self.get_node("Test_status")
	if(response_code == 200):
		message.set_text("Connected to Server")
		Server.set_server(server)
	else:
		message.set_text("Failed to Connect to Server")

func _on_Test_pressed():
	var url = server + "/games"
	var headers = ["Content-Type: application/json"]
	$HTTP_check_server.request(url, headers, false, HTTPClient.METHOD_GET, "")
