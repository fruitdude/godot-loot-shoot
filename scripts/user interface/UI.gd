extends Control


export(NodePath) onready var _interaction_label = get_node(_interaction_label) as Label
export(NodePath) onready var _firemode_label = get_node(_firemode_label) as Label
export(NodePath) onready var _fadeout_timer = get_node(_fadeout_timer) as Timer
export(NodePath) onready var _tween = get_node(_tween) as Tween

var item_name = null
var start_fadeout : bool = false


func _ready():
	GameEvents.connect("looked_over", self, "_on_looked_over")
	GameEvents.connect("looked_out", self, "_on_looked_out")
	GameEvents.connect("interacted", self, "_on_interacted")
	GameEvents.connect("changed_firemode", self, "_on_firemode_changed")
	
	_firemode_label.visible = false


func _on_looked_over(object):
	_interaction_label.show()
	_interaction_label.text = str(object) + "\n" + "F"


func _on_looked_out():
	_interaction_label.hide()
	_interaction_label.text = ""
	
	
func _on_interacted(collided_area):
	if collided_area:
		_interaction_label.hide()
		_interaction_label.text = ""
		
		
func _on_firemode_changed(firemode : String):
	_firemode_label.visible = true
	_firemode_label.text = firemode
	_tween.interpolate_property(_firemode_label, "self_modulate", Color(1,1,1,1), Color(1,1,1,0), 2.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()


func _on_Timer_timeout():
	pass
#	_firemode_label.visible = false
