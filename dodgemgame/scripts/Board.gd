class_name Board
extends Node

const EMPTY = 0
const BLUE_CAR = 1
const RED_CAR = -1

var m_width
var m_height
var m_cells = []			# ２次元配列、m_cells[y][x] で参照
var m_red_cars = PackedVector2Array()		# 赤車位置 (x, y)
var m_blue_cars = PackedVector2Array()

func _init(wd = 3, ht = 3):		# 横・縦サイズ
	init_board(wd, ht)
	pass
func init_board(wd, ht):
	m_width = wd
	m_height = ht
	m_cells.resize(m_height)
	for v in range(m_height):
		m_cells[v] = PackedInt32Array()
		m_cells[v].resize(m_width)
		m_cells[v].fill(EMPTY)
	for i in range(1, m_width):
		m_cells[0][i] = RED_CAR
		m_cells[i][0] = BLUE_CAR
	m_red_cars.resize(2)
	m_red_cars[0] = Vector2(1, 0)
	m_red_cars[1] = Vector2(2, 0)
	m_blue_cars.resize(2)
	m_blue_cars[0] = Vector2(0, 1)
	m_blue_cars[1] = Vector2(0, 2)
func print():
	for v in range(m_height-1, -1, -1):
		print(m_cells[v])
	print("red: ", m_red_cars)
	print("blue: ", m_blue_cars)
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
