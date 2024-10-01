extends StaticBody2D

signal player_immobilized

func _on_Trap_body_entered(body: Node) -> void:
	if body.is_in_group("players"):  # Vérifiez si le corps est le joueur
		emit_signal("player_immobilized")  # Émettre le signal pour immobiliser le joueur
