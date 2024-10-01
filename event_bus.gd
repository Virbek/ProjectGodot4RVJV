extends Node

#signal level_started
#signal level_ended
#signal player_was_hit
#signal connectivity_changed(online: bool)

signal player_was_hit(damage: int)
signal player_died
