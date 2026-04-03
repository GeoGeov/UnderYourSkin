class_name RoomZoneArea2D
extends Area2D

@export var zoom: Vector2 = Vector2.ONE
@export var follow_player: bool = true
@export var fixed_position: Vector2 = Vector2.ZERO
@export var limit_camera: bool = false
var limit_left: int = 0
var limit_top: int = 0
var limit_right: int = 0
var limit_bottom: int = 0
@export var collision_shape: CollisionShape2D

var cam_node: RoomZoneCamera2D
var overlapping_zones: Array[RoomZoneArea2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_shape = get_child(0) as CollisionShape2D
	var size = collision_shape.shape.extents*2
	limit_left = collision_shape.global_position.x - size.x/2
	limit_top = collision_shape.global_position.y - size.y/2
	limit_right = limit_left + size.x
	limit_bottom = limit_top + size.y
	
	
	monitorable = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if cam_node == null:
			cam_node = get_tree().get_first_node_in_group("room_zone_camera") as RoomZoneCamera2D
		if cam_node and self not in cam_node.overlapping_zones:
			cam_node.overlapping_zones.append(self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if cam_node == null:
			cam_node = get_tree().get_first_node_in_group("room_zone_camera") as RoomZoneCamera2D
		if cam_node:
			cam_node.overlapping_zones.erase(self)
