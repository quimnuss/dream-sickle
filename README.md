# dream sickle

a ShovelJam submission done in 10 days with the just-get-started theme

# Gameflow

flowchart TD
	H(House) --> W{win condition?} -- yes --> Sunrise
	W -- no --> prep("Prep drawer (night)")
	prep --> sleep{"Go to sleep"}
	sleep --> w["Welcome dungeon room"] --> doors{doors}
	loot(loot)
	doors --> D(Puzzle) --> loot
	doors --> P(Platformer) --> loot
	doors --> Enemies(Enemies) --> loot
	doors --> Boss(Boss) --> loot
	doors --> Shop --> loot
	doors --> Alarm("Alarm timeout") --> H
	loot --> doors
