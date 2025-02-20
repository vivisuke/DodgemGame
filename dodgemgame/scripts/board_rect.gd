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

var m_bd
var m_car
var m_to_hide = false		# 移動後に車を非表示に
var red_cars = []
var blue_cars = []
var src_pos = Vector2(-1, -1)	# 移動元位置
var dst_pos = Vector2(-1, -1)	# 移動先位置
var sel_pos = Vector2(-1, -1)	# 選択位置

func xyToPos(x, y):				# (x,y) → セル中心座標
	var px = X0 + (x+0.5) * CELL_WIDTH
	var py = X0 + (N_CELLS-0.5-y) * CELL_WIDTH
	return Vector2(px, py)
func vec2ToPos(vec2):
	return xyToPos(vec2.x, vec2.y)
func posToVec2(pos):
	var v2 = (pos - Vector2(X0, Y0)) / CELL_WIDTH
	v2.x = floor(v2.x)
	v2.y = N_CELLS - 1 - floor(v2.y)
	return v2
func set_sel_pos(vec2):
	#sel_pos = vec2ToPos(vec2);
	sel_pos = vec2
	src_pos = Vector2(-1, -1)
	dst_pos = Vector2(-1, -1)
	queue_redraw()
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
		add_axis_label(xyToPos(i, -0.45), "%c"%(0x61+i))
		add_axis_label(xyToPos(-0.80, 0.25+i), "%d"%(i+1))
	red_cars.clear()
	blue_cars.clear()
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
	src_pos = Vector2(-1, -1)
	dst_pos = Vector2(-1, -1)
	queue_redraw()
func set_cars(bd: Board):
	#red_cars.resize(bd.m_red_cars.size())
	# 前提条件：盤面サイズは同一
	for i in range(bd.m_red_cars.size()):
		if bd.m_red_cars[i].x >= 0:
			red_cars[i].position = vec2ToPos(bd.m_red_cars[i])
		else:
			red_cars[i].hide()
	for i in range(bd.m_blue_cars.size()):
		if bd.m_blue_cars[i].x >= 0:
			blue_cars[i].position = vec2ToPos(bd.m_blue_cars[i])
		else:
			blue_cars[i].hide()
	pass
func draw_bg(vec2, col):
	var pos = vec2ToPos(vec2) - Vector2(CELL_WIDTH/2, CELL_WIDTH/2)
	draw_rect(Rect2(pos, Vector2(CELL_WIDTH, CELL_WIDTH)), col)
func _draw():
	draw_rect(Rect2(0, 0, WIDTH, WIDTH), Color.WHITE)
	if src_pos.x >= 0:
		draw_bg(src_pos, Color.LIGHT_GRAY)
		#draw_rect(Rect2(vec2ToPos(src_pos), Vector2(CELL_WIDTH, CELL_WIDTH)), Color.LIGHT_GRAY)
	if dst_pos.x >= 0:
		draw_bg(dst_pos, Color.NAVAJO_WHITE)
		#draw_rect(Rect2(dst_pos, Vector2(CELL_WIDTH, CELL_WIDTH)), Color.NAVAJO_WHITE)
	if sel_pos.x >= 0:
		draw_bg(sel_pos, Color.YELLOW)
		#draw_rect(Rect2(sel_pos, Vector2(CELL_WIDTH, CELL_WIDTH)), Color.YELLOW)
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
	sel_pos = Vector2(-1, -1)
	var tw = create_tween()
	var id = mv.x
	var pos : Vector2
	var dir = mv.y
	dst_pos = Vector2(-1, -1)
	if id > 0:		# 赤
		m_car = red_cars[id-1]
		#src_pos = m_bd.m_red_cars[id-1]
		#src_pos = m_car.position - Vector2(CELL_WIDTH/2, CELL_WIDTH/2)
		src_pos = posToVec2(m_car.position)
		pos = m_car.position
		if dir == Board.FORWARD: pos.y -= CELL_WIDTH
		elif dir == Board.LEFT: pos.x -= CELL_WIDTH
		else: pos.x += CELL_WIDTH
	else:
		m_car = blue_cars[-id-1]
		pos = m_car.position
		#src_pos = m_car.position - Vector2(CELL_WIDTH/2, CELL_WIDTH/2)
		src_pos = posToVec2(m_car.position)
		if dir == Board.FORWARD: pos.x += CELL_WIDTH
		elif dir == Board.LEFT: pos.y -= CELL_WIDTH
		else: pos.y += CELL_WIDTH
	#m_car.position = pos
	tw.tween_property(m_car, "position", pos, 0.15)
	tw.tween_callback(move_finished)
	queue_redraw()

func move_finished():
	print("move_finished.")
	if m_to_hide:
		m_car.hide()
	else:
		dst_pos = posToVec2(m_car.position)
		#dst_pos = m_car.position - Vector2(CELL_WIDTH/2, CELL_WIDTH/2)
	queue_redraw()
	pass
func _process(delta):
	pass
