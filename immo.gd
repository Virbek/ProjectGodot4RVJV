extends CharacterBody2D

# Temps avant d'immobiliser le joueur
var immobilize_delay: float = 3.0  # Le joueur sera immobilisé après 3 secondes
var timer: float = 0.0  # Compte le temps écoulé

# Appelé à chaque frame
func _process(delta: float) -> void:
	# Compte le temps écoulé
	timer += delta

	# Si le temps écoulé dépasse 3 secondes, immobiliser le joueur
	if timer >= immobilize_delay:
		immobilize_player()


# Fonction pour immobiliser le joueur
func immobilize_player() -> void:
	set_physics_process(false)  # Désactive les mouvements du joueur
	print("Le joueur est immobilisé après 3 secondes de jeu !")
