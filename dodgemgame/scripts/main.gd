extends Node2D

var bd
var is_blue_turn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(0)
	bd = Board.new(3)
	bd.print()
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
	var mv : Vector2
	if is_blue_turn:
		bd.gen_moves_blue()
		mv = bd.m_moves[randi()%bd.m_moves.size()]
	else:
		bd.gen_moves_red()
		mv = bd.m_moves[randi()%bd.m_moves.size()]
	print("moves: ", bd.m_moves)
	print("move: ", mv)
	$BoardRect.do_move(mv)
	bd.do_move(mv)
	bd.print()
	is_blue_turn = !is_blue_turn

	pass # Replace with function body.
