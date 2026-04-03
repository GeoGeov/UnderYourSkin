class_name RoomZoneCamera2D
extends Camera2D

@export var overlapping_zones: Array[RoomZoneArea2D] = []
@export var active_zone: RoomZoneArea2D
@export var cam_follow_node: Node2D
@export var follow_player: bool = true

func _ready() -> void:
	add_to_group("room_zone_camera")
	cam_follow_node = get_tree().get_first_node_in_group("CameraFollow") as Node2D

func _physics_process(_delta: float) -> void:
	if cam_follow_node == null:
		cam_follow_node = get_tree().get_first_node_in_group("CameraFollow") as Node2D
		if cam_follow_node == null:
			return

	if overlapping_zones.is_empty():
		return

	var new_zone := get_closest_zone()
	if new_zone != active_zone:
		active_zone = new_zone
		apply_zone_settings()

	if follow_player and active_zone and active_zone.follow_player:
		global_position = cam_follow_node.global_position
	elif active_zone:
		global_position = active_zone.fixed_position

func get_closest_zone() -> RoomZoneArea2D:
	var closest_zone: RoomZoneArea2D = overlapping_zones[0]
	var closest_distance := INF
	var player_pos := cam_follow_node.global_position

	for zone in overlapping_zones:
		var zone_shape := zone.collision_shape
		var zone_rect := Rect2(zone_shape.global_position - zone_shape.shape.get_rect().size * 0.5, zone_shape.shape.get_rect().size)
		var distance := zone_rect.position.distance_to(player_pos)

		if distance < closest_distance:
			closest_distance = distance
			closest_zone = zone

	return closest_zone

func apply_zone_settings() -> void:
	if active_zone == null:
		return

	zoom = active_zone.zoom
	follow_player = active_zone.follow_player

	if active_zone.limit_camera:
		limit_left = active_zone.limit_left
		limit_top = active_zone.limit_top
		limit_right = active_zone.limit_right
		limit_bottom = active_zone.limit_bottom
	else:
		limit_left = -2147483647
		limit_top = -2147483647
		limit_right = 2147483647
		limit_bottom = 2147483647
