extends Node2D

var bd
var is_blue_turn = true
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#seed(0)
	bd = Board.new(3)
	bd.print()
	$MessLabel.text = "青 の手番です。"
	if false:
		bd.gen_moves_red()
		print("moves: ", bd.m_moves)
		var mv = bd.m_moves[randi()%bd.m_moves.size()]
		print("move: ", mv)
		$BoardRect.do_move(mv)
		bd.do_move(mv)
		bd.print()
		bd.gen_moves_blue()
		print("moves: ", bd.m_moves)
		mv = bd.m_moves[randi()%bd.m_moves.size()]
		print("move: ", mv)
		$BoardRect.do_move(mv)
		bd.do_move(mv)
		bd.print()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_step_button_pressed():
	if is_game_over: return
	var mv : Vector2
	if is_blue_turn:
		bd.gen_moves_blue()
		if bd.m_moves.is_empty():
			is_game_over = true
			$MessLabel.text = "青 の勝ちです。"
			return
		mv = bd.m_moves[randi()%bd.m_moves.size()]
	else:
		bd.gen_moves_red()
		if bd.m_moves.is_empty():
			is_game_over = true
			$MessLabel.text = "赤 の勝ちです。"
			return
		mv = bd.m_moves[randi()%bd.m_moves.size()]
	print("moves: ", bd.m_moves)
	print("move: ", mv)
	var goal = bd.do_move(mv)
	bd.print()
	$BoardRect.do_move(mv, goal)
	if bd.m_n_red == 0 || bd.m_n_blue == 0:
		is_game_over = true
		if bd.m_n_red == 0:
			$MessLabel.text = "赤 の勝ちです。"
		else:
			$MessLabel.text = "青 の勝ちです。"
	else:
		is_blue_turn = !is_blue_turn
		if is_blue_turn:
			$MessLabel.text = "青 の手番です。"
		else:
			$MessLabel.text = "赤 の手番です。"

	pass # Replace with function body.


func _on_restart_button_pressed():
	is_game_over = false
	is_blue_turn = true
	$MessLabel.text = "青 の手番です。"
	bd.init_board(3)
	$BoardRect.init_cars_position()
	pass # Replace with function body.
