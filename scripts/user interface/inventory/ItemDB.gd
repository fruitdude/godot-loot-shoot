extends Node

const ICON_PATH = "res://assets/icons/"
const DRINKS_PATH = "res://scenes/drinks/"


const ITEMS = {
	"milk": {
		"asset_vertical": ICON_PATH + "milk.png",
		"asset_horizontal": ICON_PATH + "milk_hor.png",
		"slot": "NONE",
		"stackable": "FALSE",
		"scene" : DRINKS_PATH + "milk.tscn"
	},
	"error": {
		"asset_vertical": ICON_PATH + "error.png",
		"slot": "NONE",
		"stackable": "FALSE",
	},
}


func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
