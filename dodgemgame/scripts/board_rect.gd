extends ColorRect

const WIDTH = 460.0
const HEIGHT = 460.0
const N_CELLS = 3
const CELL_WIDTH = WIDTH / (N_CELLS+1)
#const PADDING = (WIDTH - CELL_WIDTH*(N_CELLS+2)) / 2
#const X0 = PADDING + CELL_WIDTH
#const Y0 = PADDING + CELL_WIDTH
const X0 = CELL_WIDTH / 2
const Y0 = CELL_WIDTH / 2
const BD_WD = CELL_WIDTH * N_CELLS
const BD_HT = CELL_WIDTH * N_CELLS

var red_cars = []
var blue_cars = []

func xyToPos(x, y):
	var px = X0 + (x+0.5) * CELL_WIDTH
	var py = X0 + (N_CELLS-0.5-y) * CELL_WIDTH
	return Vector2(px, py)
# 目盛り値ラベル設置
func add_axis_label(pos, txt):
	var lbl = Label.new()
	lbl.add_theme_color_override("font_color", Color.BLACK)
	lbl.add_theme_font_size_override("font_size", 36)
	lbl.text = txt
	lbl.position = pos + Vector2(-CELL_WIDTH/10.0, 0)
	add_child(lbl)
	return lbl
func _ready():
	add_axis_label(xyToPos(0, -0.5), "a")
	add_axis_label(xyToPos(1, -0.5), "b")
	add_axis_label(xyToPos(2, -0.5), "c")
	add_axis_label(xyToPos(-0.75, 0.25), "1")
	add_axis_label(xyToPos(-0.75, 1.25), "2")
	add_axis_label(xyToPos(-0.75, 2.25), "3")
	$RedCar1.position = xyToPos(1, 0)
	$RedCar2.position = xyToPos(2, 0)
	$BlueCar1.position = xyToPos(0, 1)
	$BlueCar2.position = xyToPos(0, 2)
	red_cars.push_back($RedCar1)
	red_cars.push_back($RedCar2)
	blue_cars.push_back($BlueCar1)
	blue_cars.push_back($BlueCar2)
	pass
func _draw():
	draw_line(Vector2(X0, Y0), Vector2(X0+BD_WD, Y0), Color.BLACK, 2.0)
	draw_line(Vector2(X0, Y0), Vector2(X0, Y0+BD_HT), Color.BLACK, 2.0)
	draw_line(Vector2(X0+BD_WD, Y0), Vector2(X0+BD_WD, Y0+BD_HT), Color.BLACK, 2.0)
	draw_line(Vector2(X0, Y0+BD_HT), Vector2(X0+BD_WD, Y0+BD_HT), Color.BLACK, 2.0)
	var px = X0 + CELL_WIDTH
	for x in range(N_CELLS-1):
		draw_line(Vector2(px, Y0), Vector2(px, Y0+BD_HT), Color.BLACK, 1.0)
		draw_line(Vector2(X0, px), Vector2(X0+BD_WD, px), Color.BLACK, 1.0)
		px += CELL_WIDTH
	pass
func do_move(mv : Vector2):
	var id = mv.x
	var dir = mv.y
	if id > 0:		# 赤
		var car = red_cars[id-1]
		var pos : Vector2 = car.position
		if dir == Board.FORWARD: pos.y -= CELL_WIDTH
		elif dir == Board.LEFT: pos.x -= CELL_WIDTH
		else: pos.x += CELL_WIDTH
		car.position = pos
	else:
		var car = blue_cars[-id-1]
		var pos : Vector2 = car.position
		if dir == Board.FORWARD: pos.x += CELL_WIDTH
		elif dir == Board.LEFT: pos.y -= CELL_WIDTH
		else: pos.y += CELL_WIDTH
		car.position = pos

func _process(delta):
	pass
