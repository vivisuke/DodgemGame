class_name Board
extends Node


const EMPTY = 0
const RED_CAR  =  1
const BLUE_CAR = -1

enum {
	FORWARD = 1, LEFT, RIGHT,
}

#var m_width
#var m_height
var m_bd_size				# 盤面縦・横セル数
var m_n_cars = 2			# 片方の車数初期値
var m_n_red = 2
var m_n_blue = 2
var m_cells = []			# ２次元配列、m_cells[y][x] で参照
var m_red_cars = PackedVector2Array()		# 赤車位置 (x, y)
var m_blue_cars = PackedVector2Array()
var m_moves = PackedVector2Array()			# (車ID, 移動方向)、※ ID は 1 org for RED, -1, -2, ... for BLUE

func _init(bd_size = 3):		# 横・縦サイズ
	init_board(bd_size)
	pass
func init_board(bd_size):
	#m_width = wd
	#m_height = ht
	m_bd_size = bd_size
	m_n_cars = m_bd_size - 1
	m_cells.resize(m_bd_size)
	for v in range(m_bd_size):
		m_cells[v] = PackedInt32Array()
		m_cells[v].resize(m_bd_size)
		m_cells[v].fill(EMPTY)
	for i in range(1, m_bd_size):
		m_cells[0][i] = i	#RED_CAR
		m_cells[i][0] = -i	#BLUE_CAR
	m_red_cars.resize(2)
	m_red_cars[0] = Vector2(1, 0)
	m_red_cars[1] = Vector2(2, 0)
	m_n_red = 2
	m_blue_cars.resize(2)
	m_blue_cars[0] = Vector2(0, 1)
	m_blue_cars[1] = Vector2(0, 2)
	m_n_blue = 2
func print():
	for v in range(m_bd_size-1, -1, -1):
		print(m_cells[v])
	print("red: ", m_red_cars, ", num = ", m_n_red)
	print("blue: ", m_blue_cars, ", num = ", m_n_blue)
func gen_moves_red():
	m_moves.clear()
	var id = 0
	for pos in m_red_cars:
		id += 1
		if pos.y == m_bd_size: continue
		if pos.y + 1 == m_bd_size || m_cells[pos.y+1][pos.x] == EMPTY:
			m_moves.push_back(Vector2(id, FORWARD))
		if pos.x > 0 && m_cells[pos.y][pos.x-1] == EMPTY:
			m_moves.push_back(Vector2(id, LEFT))
		if pos.x < m_bd_size-1 && m_cells[pos.y][pos.x+1] == EMPTY:
			m_moves.push_back(Vector2(id, RIGHT))
func gen_moves_blue():
	m_moves.clear()
	var id = 0
	for pos in m_blue_cars:
		id -= 1
		if pos.x == m_bd_size: continue
		if pos.x + 1 == m_bd_size || m_cells[pos.y][pos.x+1] == EMPTY:
			m_moves.push_back(Vector2(id, FORWARD))
		if pos.y > 0 && m_cells[pos.y-1][pos.x] == EMPTY:
			m_moves.push_back(Vector2(id, RIGHT))
		if pos.y < m_bd_size-1 && m_cells[pos.y+1][pos.x] == EMPTY:
			m_moves.push_back(Vector2(id, LEFT))
func sel_move() -> Vector2:
	var sum = 0
	for mv in m_moves:
		sum += 2 if mv.y == FORWARD else 1
	if sum != 0:
		var r = randi() % sum
		for mv in m_moves:
			var sz = 2 if mv.y == FORWARD else 1
			if r < sz: return mv
			r -= sz
	return Vector2(0, 0)
func do_move(mv : Vector2) -> bool:		# return: ゴールした
	var id = mv.x
	if id > 0:	# 赤移動
		var ix = id - 1
		m_cells[m_red_cars[ix].y][m_red_cars[ix].x] = EMPTY
		if mv.y == FORWARD:
			m_red_cars[ix].y += 1
		elif mv.y == LEFT:
			m_red_cars[ix].x -= 1
		else:
			m_red_cars[ix].x += 1
		if m_red_cars[ix].y < m_bd_size:
			m_cells[m_red_cars[id-1].y][m_red_cars[id-1].x] = id
			return false
		else:
			m_n_red -= 1
			return true
	else:		# 青移動
		var ix = -id - 1
		m_cells[m_blue_cars[ix].y][m_blue_cars[ix].x] = EMPTY
		if mv.y == FORWARD:
			m_blue_cars[ix].x += 1
		elif mv.y == LEFT:
			m_blue_cars[ix].y += 1
		else:
			m_blue_cars[ix].y -= 1
		if m_blue_cars[ix].x < m_bd_size:
			m_cells[m_blue_cars[ix].y][m_blue_cars[ix].x] = id
			return false;
		else:
			m_n_blue -= 1
			return true
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
