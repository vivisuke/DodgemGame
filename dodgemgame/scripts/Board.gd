class_name Board
extends Node

const EMPTY = 0
const BLUE_CAR = 1
const RED_CAR = -1

var m_width
var m_height
var m_cells = []			# ２次元配列、m_cells[y][x] で参照

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
func print():
	for v in range(m_height-1, -1, -1):
		print(m_cells[v])
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
