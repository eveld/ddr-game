extends Node

var server = "http://localhost:9090"

func set_server(endpoint):
	server = endpoint
	
func get_server():
	return server