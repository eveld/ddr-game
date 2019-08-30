extends Control

func _input(event):
	if event.is_action_pressed("e"):
		print("nothing")
		
	if event.is_action_pressed("q"):
		get_tree().change_scene("res://MainMenu.tscn")

func _on_options_ready():
	var headers = ["Content-Type: application/json"]
	var url = Game.get_server() + "/scores"
	$HTTPRequest_high_scores.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_high_scores_request_completed(result, response_code, headers, body):
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		var score_label = ""
		for score in response:
			var format_string = "%s     %d\n"
			var line = format_string % [score.player, score.points]
			score_label = score_label + line
		$menu/options/scores.text = score_label
