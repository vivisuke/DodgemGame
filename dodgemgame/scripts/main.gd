extends Node2D

var bd

# Called when the node enters the scene tree for the first time.
func _ready():
	bd = Board.new(3)
	bd.print()
	bd.gen_moves_red()
	print("moves: ", bd.m_moves)
	var mv = bd.m_moves[randi()%bd.m_moves.size()]
	print("move: ", mv)
	bd.do_move(mv)
	bd.print()
	bd.gen_moves_blue()
	print("moves: ", bd.m_moves)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
