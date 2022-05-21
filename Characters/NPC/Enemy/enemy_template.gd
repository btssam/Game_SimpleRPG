extends Node2D #eventually will want different enemy scenes for each when they have dif functions

export var enemy_name = ''
export var hp: int = randi()%30 + 1
export var maxhp: int = randi()%30 + 1
export var attack = 1
export var defence = 1
export var intellect = 1
export var speed = 1
export var mp = 1
export var maxmp = 1
