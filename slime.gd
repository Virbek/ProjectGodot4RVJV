extends CharacterBody2D
@onready var vue_du_slime: CollisionShape2D = $VueDuSlime
@onready var player: CharacterBody2D = %player


func isSeeingPlayer() -> bool:
	if vue_du_slime.shape is CircleShape2D and player:
		# Position globale du joueur et du slime
		var player_global_pos = player.global_position
		var slime_global_pos = global_position

		# Calculer la distance entre le joueur et le slime
		var distance_to_player = slime_global_pos.distance_to(player_global_pos)

		# Obtenir le rayon du CircleShape2D
		var shape_radius = (vue_du_slime.shape as CircleShape2D).radius
		
		# Prendre en compte l'échelle globale du CollisionShape2D (du node ou de ses parents)
		var global_scale = vue_du_slime.global_scale

		# Compense le rayon avec l'échelle globale
		var adjusted_radius = shape_radius * global_scale.x  # On utilise l'échelle sur l'axe X (supposant un scaling uniforme)

		# Si la distance entre le joueur et le slime est inférieure ou égale au rayon ajusté, le joueur est dans la zone de vue
		if distance_to_player <= adjusted_radius:
			return true
	
	return false
