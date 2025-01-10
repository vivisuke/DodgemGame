extends ColorRect

const WIDTH = 460
const HEIGHT = 460
const N_CELLS = 3
const CELL_WIDTH = WIDTH / (N_CELLS+1)
#const PADDING = (WIDTH - CELL_WIDTH*(N_CELLS+2)) / 2
#const X0 = PADDING + CELL_WIDTH
#const Y0 = PADDING + CELL_WIDTH
const X0 = CELL_WIDTH / 2
const Y0 = CELL_WIDTH / 2
const BD_WD = CELL_WIDTH * N_CELLS
const BD_HT = CELL_WIDTH * N_CELLS

func xyToPos(x, y):
	var px = X0 + (x+0.5) * CELL_WIDTH
	var py = X0 + (N_CELLS-0.5-y) * CELL_WIDTH
	return Vector2(px, py)
func _ready():
	$RedCar1.position = xyToPos(1, 0)
	$RedCar2.position = xyToPos(2, 0)
	$BlueCar1.position = xyToPos(0, 1)
	$BlueCar2.position = xyToPos(0, 2)
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
func _process(delta):
	pass
