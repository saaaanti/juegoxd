extends Node

var team = {
	"ids": [],
	"score": 0,
}
var team0 = team.duplicate(true)
var team1 = team.duplicate(true)

@export
var teams = [team0, team1]

@rpc("any_peer")
func add_id(t, id):
	teams[t].ids.append(id)

@rpc("any_peer")
func remove_id(id):
	for t in teams:
		if id in t:
			t.remove(id)

@rpc("any_peer", "call_local")
func increase_score(t):
	teams[t].score += 1

func increase(t):
	rpc("increase_score", t)
