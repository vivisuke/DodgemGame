extends Node2D

#const BD_WIDTH = 3

var bd
var is_red_turn = false
var is_game_over = false
var src_pos = Vector2(-1, -1)
var dst_pos = Vector2(-1, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	#seed(0)
	if false:
		var bd = Board.new()
		bd.set_cars([Vector2(2, 0)], [Vector2(0, 2)])
		bd.print()
		var mv = Vector2(-1, Board.FORWARD)
		bd.do_move(mv)
		bd.print()
		bd.undo_move(mv)
		bd.print()
	bd = Board.new()
	$BoardRect.m_bd = bd
	if false:
		bd.set_cars([Vector2(2, 1)], [Vector2(1, 2)])
		bd.print()
		$BoardRect.set_cars(bd)
		bd.gen_moves_red()
		bd.print_moves()
		bd.sel_move_mc(true)
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
func sdToMove(src, dst):
	var id = bd.m_cells[src.y][src.x]
	var dir = Board.FORWARD
	if is_red_turn:
		if dst.x < src.x: dir = Board.LEFT
		elif dst.x > src.x: dir = Board.RIGHT
	else:
		if dst.y > src.y: dir = Board.LEFT
		elif dst.y < src.y: dir = Board.RIGHT
	return Vector2(id, dir)
func can_move_to(dst):
	if !bd.is_empty_cell(dst): return false
	if is_red_turn:
		if dst.y == src_pos.y + 1: return true
		if dst.y == src_pos.y && abs(dst.x - src_pos.x) == 1: return true
	else:
		if dst.x == src_pos.x + 1: return true
		if dst.x == src_pos.x && abs(dst.y - src_pos.y) == 1: return true
	return false
func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		var pos = get_global_mouse_position() - $BoardRect.position
		pos = (pos - Vector2($BoardRect.X0, $BoardRect.Y0)) / $BoardRect.CELL_WIDTH
		pos.x = floor(pos.x)
		pos.y = Board.BD_SIZE - 1 - floor(pos.y)
		if pos.x >= 0 && pos.x < Board.BD_SIZE && pos.y >= 0 && pos.y < Board.BD_SIZE:
			if is_red_turn && bd.is_red(pos) || !is_red_turn && bd.is_blue(pos):
				$BoardRect.set_sel_pos(pos)
				src_pos = pos
				print("src_pos = ", pos)
			elif can_move_to(pos):
				print("dst_pos = ", pos)
				var mv = sdToMove(src_pos, pos)
				print("move = ", mv)
				var goal = bd.do_move(mv)
				bd.print()
				$BoardRect.do_move(mv, goal)
				is_red_turn = !is_red_turn
		if is_red_turn && pos.x >= 0 && pos.x < Board.BD_SIZE && pos.y >= Board.BD_SIZE:
			pos.x = src_pos.x
			var mv = sdToMove(src_pos, pos)
			print("move = ", mv)
			var goal = bd.do_move(mv)
			bd.print()
			$BoardRect.do_move(mv, goal)
			is_red_turn = !is_red_turn
		if !is_red_turn && pos.y >= 0 && pos.y < Board.BD_SIZE && pos.x >= Board.BD_SIZE:
			pos.y = src_pos.y
			var mv = sdToMove(src_pos, pos)
			print("move = ", mv)
			var goal = bd.do_move(mv)
			bd.print()
			$BoardRect.do_move(mv, goal)
			is_red_turn = !is_red_turn
	pass
func _on_step_button_pressed():		# １手進める
	if is_game_over: return
	var mv : Vector2
	if !is_red_turn:
		bd.gen_moves_blue()
		if bd.m_moves.is_empty():
			is_game_over = true
			$MessLabel.text = "青 の勝ちです。"
			return
		#mv = bd.m_moves[randi()%bd.m_moves.size()]
		#mv = bd.sel_move()
		mv = bd.sel_move_mc(false)
	else:
		#var r = bd.play_out(true)
		#var r = bd.estimate_win_rate(100, true)
		#print("win rate = ", r)
		bd.gen_moves_red()
		if bd.m_moves.is_empty():
			is_game_over = true
			$MessLabel.text = "赤 の勝ちです。"
			return
		#mv = bd.m_moves[randi()%bd.m_moves.size()]
		mv = bd.sel_move_mc(true)
	#mv = bd.sel_move()
	$EvalLabel.text = "eval = %.2f"%bd.m_eval
	bd.print_moves()
	#print("moves: ", bd.m_moves)
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
		is_red_turn = !is_red_turn
		if !is_red_turn:
			$MessLabel.text = "青 の手番です。"
		else:
			$MessLabel.text = "赤 の手番です。"

	pass # Replace with function body.


func _on_restart_button_pressed():
	is_game_over = false
	is_red_turn = false
	$MessLabel.text = "青 の手番です。"
	$EvalLabel.text = "eval = 0.0"
	bd.init_board(Board.BD_SIZE)
	bd.print()
	$BoardRect.init_cars()
	pass # Replace with function body.
