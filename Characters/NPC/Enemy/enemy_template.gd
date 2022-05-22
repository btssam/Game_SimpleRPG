extends Node2D

export var enemy_name = ''
export var hp: int = randi()%30 + 1
export var maxhp: int = randi()%30 + 1
export var attack = 1
export var defence = 1 #I dont see why to use this. Just increase the HP. Unless I want to effect only certain attacks
export var intellect = 1
export var speed = 1
export var mp = 1
export var maxmp = 1
export var initiative = 0
