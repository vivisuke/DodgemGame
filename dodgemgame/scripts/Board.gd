class_name Board
extends Node


const EMPTY = 0
const RED_CAR  =  1
const BLUE_CAR = -1

enum {
	FORWARD = 1, LEFT, RIGHT,
}

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
	m_red_cars.resize(m_bd_size-1)
	m_blue_cars.resize(m_bd_size-1)
	for i in range(m_bd_size-1):
		m_red_cars[i] = Vector2(i+1, 0)
		m_blue_cars[i] = Vector2(0, i+1)
	m_n_red = m_bd_size - 1
	m_n_blue = m_bd_size - 1
func copy_from(src: Board):
	m_bd_size = src.m_bd_size
	m_n_red = src.m_n_red
	m_n_blue = src.m_n_blue
	m_cells = src.m_cells.duplicate()
	m_red_cars = src.m_red_cars.duplicate()
	m_blue_cars = src.m_blue_cars.duplicate()
	m_moves = src.m_moves.duplicate()
	pass
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
func play_out(red_turn : bool = true) -> int:		# 1 for 赤勝ち, -1 for 青勝ち, 0 for 引き分け
	var bd : Board = Board.new(m_bd_size)
	bd.copy_from(self)
	while true:
		if red_turn:
			bd.gen_moves_red()
		else:
			bd.gen_moves_blue()
		var mv = bd.sel_move()
		if bd.do_move(mv):
			if bd.m_n_red == 0: return 1
			if bd.m_n_blue == 0: return -1
		red_turn = !red_turn
	return 0
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
