/datum/game_mode/pillarmen
	name = "pillarmen"
	config_tag = "pillarmen"
	antag_flag = ROLE_PILLARMEN
	required_players = 25
	required_enemies = 2
	recommended_enemies = 3
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_races = list(/datum/species/lizard, /datum/species/ipc, /datum/species/bird, /datum/species/tarajan)
	var/list/datum/team/pillarmen/pillarManTeams = list()
	var/list/datum/mind/pre_pillars = list()

/datum/game_mode/pillarmen/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/pillar_amt = CLAMP(round(num_players() / 10), 2, 3)
	for(var/j = 0, j < pillar_amt, j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/pillar = antag_pick(antag_candidates)
		pre_pillars += pillar
		pillar.special_role = "Pillar Man"
		pillar.restricted_roles = restricted_jobs
		log_game("[key_name(pillar)] has been selected as a Pillar Men")
		antag_candidates.Remove(pillar)
	
	if(!GLOB.Debug2 && pre_pillars.len < 2)
		setup_error = "Not enough Pillar Men candidates"
		return FALSE
	else
		return TRUE

/datum/game_mode/pillarmen/post_setup()
	for(var/datum/mind/pillar in pre_pillars)
		var/datum/team/pillarmen/team = new
		pillarManTeams += team
		pillar.add_antag_datum(/datum/antagonist/pillarmen, team)
	SSshuttle.registerHostileEnvironment(src)

/datum/game_mode/pillarmen/check_finished()
	if((SSshuttle.emergency.mode == SHUTTLE_ENDGAME) || station_was_nuked)
		return TRUE
	for(var/datum/team/pillarmen/PT in pillarManTeams)
		var/mob/PM = PT.pillarMan?.current
		if(PM && istype(PM))
			if((is_station_level(PM.z) || is_reserved_level(PM.z) || is_centcom_level(PM.z) || isobj(PM.loc)) && considered_alive(PT.pillarMan, TRUE))
				return FALSE
	return TRUE

/datum/game_mode/pillarmen/generate_report()
	return "Reports of an ancient evil, who were launched into space a thousand years ago, have resurfaced on a NanoTrasen space station. \
			It is said they are after a mysterious artifact, the details of which are unknown."
