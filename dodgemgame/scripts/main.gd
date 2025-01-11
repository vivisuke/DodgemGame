extends Node2D

var bd

# Called when the node enters the scene tree for the first time.
func _ready():
	bd = Board.new(3, 3)
	bd.print()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
