extends Control

func _input(event):
	if event.is_action_pressed("q"):
		var _err = get_tree().change_scene("res://MainMenu.tscn")

func _on_options_ready():
	var headers = ["Content-Type: application/json"]
	var url = Game.get_server() + "/scores"
	$HTTPRequest_high_scores.request(url, headers, false, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_high_scores_request_completed(_result, response_code, _headers, body):	
	if(response_code == 200):
		var response = JSON.parse(body.get_string_from_utf8()).result
		for score in response:
			var format_string = "%s     %d\n"
			var line = format_string % [score.player, score.points]
			
			if score.player == Game.get_player_id():
				$menu/options/scores.push_color(Color(1, 0.32, 0.03))
				$menu/options/scores.append_bbcode(line)
				$menu/options/scores.pop()
			else:
				$menu/options/scores.append_bbcode(line)