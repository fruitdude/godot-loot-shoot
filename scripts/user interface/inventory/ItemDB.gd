extends Node

const ICON_PATH = "res://assets/icons/"
const milk_scene = preload("res://scenes/drinks/Milk.tscn")

const ITEMS = {
	"milk": {
		"asset": ICON_PATH + "milk.png",
		"slot": "NONE",
		"stackable": "FALSE",
		"scene": "res://scenes/drinks/Milk.tscn"
	},
	"error": {
		"asset": ICON_PATH + "error.png",
		"slot": "NONE",
		"stackable": "FALSE",
		"scene": "NONE"
	},
}


func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
