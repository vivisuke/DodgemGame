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
var m_n_cars = 2			# 片方の車数
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
	m_blue_cars.resize(2)
	m_blue_cars[0] = Vector2(0, 1)
	m_blue_cars[1] = Vector2(0, 2)
func print():
	for v in range(m_bd_size-1, -1, -1):
		print(m_cells[v])
	print("red: ", m_red_cars)
	print("blue: ", m_blue_cars)
func gen_moves_red():
	m_moves.clear()
	var id = 0
	for pos in m_red_cars:
		id += 1
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
		if pos.x + 1 == m_bd_size || m_cells[pos.y][pos.x+1] == EMPTY:
			m_moves.push_back(Vector2(id, FORWARD))
		if pos.y > 0 && m_cells[pos.y-1][pos.x] == EMPTY:
			m_moves.push_back(Vector2(id, RIGHT))
		if pos.y < m_bd_size-1 && m_cells[pos.y+1][pos.x] == EMPTY:
			m_moves.push_back(Vector2(id, LEFT))
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
