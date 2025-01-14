extends ColorRect

const WIDTH = 460.0
const HEIGHT = 460.0
const N_CELLS = Board.BD_SIZE
const CELL_WIDTH = WIDTH / (N_CELLS+1)
#const PADDING = (WIDTH - CELL_WIDTH*(N_CELLS+2)) / 2
#const X0 = PADDING + CELL_WIDTH
#const Y0 = PADDING + CELL_WIDTH
const X0 = CELL_WIDTH / 2
const Y0 = CELL_WIDTH / 2
const BD_WD = CELL_WIDTH * N_CELLS
const BD_HT = CELL_WIDTH * N_CELLS

var m_car
var m_to_hide = false		# 移動後に車を非表示に
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
	for i in range(N_CELLS):
		add_axis_label(xyToPos(i, -0.5), "%c"%(0x61+i))
		add_axis_label(xyToPos(-0.75, 0.25+i), "%d"%(i+1))
	for i in range(1, N_CELLS):
		red_cars.push_back(get_node("RedCar%d"%i))
		blue_cars.push_back(get_node("BlueCar%d"%i))
	init_cars()
	pass
func init_cars():
	for i in range(N_CELLS-1):
		red_cars[i].show()
		blue_cars[i].show()
		red_cars[i].position = xyToPos(i+1, 0)
		blue_cars[i].position = xyToPos(0, i+1)
		red_cars[i].scale = Vector2(3.5/N_CELLS, 3.5/N_CELLS)
		blue_cars[i].scale = Vector2(3.5/N_CELLS, 3.5/N_CELLS)
	#$RedCar1.show()
	#$RedCar2.show()
	#$BlueCar1.show()
	#$BlueCar2.show()
	#$RedCar1.position = xyToPos(1, 0)
	#$RedCar2.position = xyToPos(2, 0)
	#$BlueCar1.position = xyToPos(0, 1)
	#$BlueCar2.position = xyToPos(0, 2)
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
func do_move(mv : Vector2, goal : bool):
	m_to_hide = goal
	var tw = create_tween()
	var id = mv.x
	var pos : Vector2
	var dir = mv.y
	if id > 0:		# 赤
		m_car = red_cars[id-1]
		pos = m_car.position
		if dir == Board.FORWARD: pos.y -= CELL_WIDTH
		elif dir == Board.LEFT: pos.x -= CELL_WIDTH
		else: pos.x += CELL_WIDTH
	else:
		m_car = blue_cars[-id-1]
		pos = m_car.position
		if dir == Board.FORWARD: pos.x += CELL_WIDTH
		elif dir == Board.LEFT: pos.y -= CELL_WIDTH
		else: pos.y += CELL_WIDTH
	#m_car.position = pos
	tw.tween_property(m_car, "position", pos, 0.15)
	tw.tween_callback(move_finished)

func move_finished():
	print("move_finished.")
	if m_to_hide: m_car.hide()
	pass
func _process(delta):
	pass
