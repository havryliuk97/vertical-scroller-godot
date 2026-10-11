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

func get_team_mask(team):
	var team_layers_mask = 0
	for i in LAYERS_PER_TEAM:
		team_layers_mask += get_team_layer(team, i)
	
	var all_teams_mask = pow(2, TEAMS_COUNT*LAYERS_PER_TEAM) - 1 #get mask that represents all teams reserved bits set to 1
	
	return all_teams_mask - team_layers_mask
