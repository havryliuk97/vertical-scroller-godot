extends Node 

const TEAMS_COUNT: int = 3
const LAYERS_PER_TEAM: int = 2
const PARTICLES_BIT_OFFSET = 1

enum Options {
	PLAYER_TEAM = 1,
	ENEMIES_TEAM, 
}

# use bit offest to get needed layer inside team, like 0 -> entites layer, 1 -> projectiles layer, etc
func get_team_layer(team, bit_offset = 0):
	var shift = team - 1
	
	var team_first_bit = 1 << shift
	
	return team_first_bit << (bit_offset * TEAMS_COUNT)

# mask of one layer (by bit_offset) of every team except the given one, like 0 -> opponents entities
func get_opponents_mask(team, bit_offset = 0):
	var mask = 0
	for t in range(1, TEAMS_COUNT + 1):
		if t != team:
			mask |= get_team_layer(t, bit_offset)

	return mask
