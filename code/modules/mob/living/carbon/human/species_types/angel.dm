/datum/species/angel
	name = "Angel"
	id = "angel"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("wings")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "Angel")
	use_skintones = 1
	armor = 50
	attack_type = BRAIN
	exotic_bloodtype = "Godblood"
	armour_penetration = 100
	environment_smash = 3
	allow_movement_on_non_turfs = TRUE
	force_threshold = 50
	limbs_id = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human
	inherent_traits = list(TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_IGNORESLOWDOWN, TRAIT_SLEEPIMMUNE, TRAIT_XRAY_VISION, TRAIT_NOSOFTCRIT,
							TRAIT_VIRUSIMMUNE, TRAIT_PIERCEIMMUNE, TRAIT_SHOCKIMMUNE, TRAIT_RADIMMUNE, TRAIT_NOHUNGER,
							TRAIT_NOLIMBDISABLE, TRAIT_NOBREATH, TRAIT_STABLEHEART, TRAIT_RESISTCOLD, TRAIT_RESISTHEAT, TRAIT_STUNIMMUNE,
							TRAIT_NODISMEMBER, TRAIT_NOFIRE, TRAIT_NODEATH,TRAIT_LIMBATTACHMENT,TRAIT_NOCRITDAMAGE,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,
							TRAIT_TIMELESS,TRAIT_NOSLIPALL,TRAIT_MAGIC_CHOKE,TRAIT_STRONG_GRABBER,TRAIT_THERMAL_VISION,EYE_OF_GOD_TRAIT,HAND_REPLACEMENT_TRAIT,TRAIT_ALWAYS_CLEAN,
							GAUNTLET_TRAIT,LAG_STONE_TRAIT,SUPERMATTER_STONE_TRAIT,SYNDIE_STONE_TRAIT,BLUESPACE_STONE_TRAIT,GHOST_STONE_TRAIT,TRAIT_SIXTHSENSE,TRAIT_XRAY_VISION,TRAIT_SURGEON,
							TRAIT_NOHARDCRIT,TRAIT_STABLELIVER,TRAIT_PACIFISM,)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN


	var/datum/action/innate/flight/fly


/datum/species/angel/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "Angel"))
		if(!("wings" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "wings"
		H.dna.features["wings"] = "Angel"
		H.update_body()
		H.internal_organs += new /obj/item/clothing/glasses/godeye
	H.ventcrawler = VENTCRAWLER_ALWAYS
	H.grant_all_languages(omnitongue=TRUE)
	if(ishuman(H) && !fly)
		fly = new
		fly.Grant(H)
	ADD_TRAIT(H, TRAIT_HOLY, SPECIES_TRAIT)

/datum/species/angel/on_species_loss(mob/living/carbon/human/H)
	if(fly)
		fly.Remove(H)
	if(H.movement_type & FLYING)
		H.setMovetype(H.movement_type & ~FLYING)
	ToggleFlight(H,0)
	if(H.dna && H.dna.species && (H.dna.features["wings"] == "Angel"))
		if("wings" in H.dna.species.mutant_bodyparts)
			H.dna.species.mutant_bodyparts -= "wings"
		H.dna.features["wings"] = "None"
		H.update_body()
	REMOVE_TRAIT(H, TRAIT_HOLY, SPECIES_TRAIT)
	..()

/datum/species/angel/spec_life(mob/living/carbon/human/H)
	HandleFlight(H)

/datum/species/angel/proc/HandleFlight(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		if(!CanFly(H))
			ToggleFlight(H,0)
			return 0
		return 1
	else
		return 0

/datum/species/angel/proc/CanFly(mob/living/carbon/human/H)
	if(H.stat || !(H.mobility_flags & MOBILITY_STAND))
		return 0
	if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		to_chat(H, "Your suit blocks your wings from extending!")
		return 0
	var/turf/T = get_turf(H)
	if(!T)
		return 0

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		to_chat(H, "<span class='warning'>The atmosphere is too thin for you to fly!</span>")
		return 0
	else
		return 1

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUN
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/angel/A = H.dna.species
	if(A.CanFly(H))
		if(H.movement_type & FLYING)
			to_chat(H, "<span class='notice'>You settle gently back onto the ground...</span>")
			A.ToggleFlight(H,FALSE)
			H.update_mobility()
		else
			to_chat(H, "<span class='notice'>You beat your wings and begin to hover gently above the ground...</span>")
			A.ToggleFlight(H,TRUE)
			H.set_resting(FALSE, FALSE)

/datum/species/angel/proc/flyslip(mob/living/carbon/human/H)
	var/obj/buckled_obj
	if(H.buckled)
		buckled_obj = H.buckled

	to_chat(H, "<span class='notice'>Your wings spazz out and launch you!</span>")

	playsound(H.loc, 'sound/misc/slip.ogg', 50, 1, -3)

	for(var/obj/item/I in H.held_items)
		H.accident(I)

	var/olddir = H.dir

	H.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(H)
		step(buckled_obj, olddir)
	else
		for(var/i=1, i<5, i++)
			spawn (i)
				step(H, olddir)
				H.spin(1,1)
	return 1


/datum/species/angel/spec_stun(mob/living/carbon/human/H,amount)
	if(H.movement_type & FLYING)
		ToggleFlight(H,0)
		flyslip(H)
	. = ..()

/datum/species/angel/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/angel/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return 1

/datum/species/angel/proc/ToggleFlight(mob/living/carbon/human/H,flight)
	if(flight && CanFly(H))
		stunmod = 1
		//speedmod = -0.35
		H.setMovetype(H.movement_type | FLYING)
		override_float = TRUE
		H.pass_flags |= PASSTABLE
		H.incorporeal_move = INCORPOREAL_MOVE_BASIC
//		ADD_TRAIT(H, TRAIT_SIXTHSENSE, GHOST_STONE_TRAIT)
//		ADD_TRAIT(H, TRAIT_XRAY_VISION, GHOST_STONE_TRAIT)
		H.dna.add_mutation(SPACEMUT)
		H.dna.add_mutation(TK)
		H.dna.add_mutation(FIREBREATH)
		H.dna.add_mutation(OLFACTION)
		H.dna.add_mutation(GLOW)
		H.dna.add_mutation(ANTENNA)
	//	H.dna.add_mutation(ANTIMAGICMUT)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/jesus_btw(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/knock/jesus(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/jesus_ascend(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/jesus_deconvert(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/jesus_revive(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/area_teleport(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/voice_of_god(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summonitem(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/pin(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall/hive(null))

		H.see_invisible = SEE_INVISIBLE_OBSERVER
	//.AddSpell(touch_attack)
		H.update_sight()
		H.OpenWings()
	else
		stunmod = 1
		speedmod = 0
		H.setMovetype(H.movement_type & ~FLYING)
		override_float = FALSE
		H.pass_flags &= ~PASSTABLE
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/jesus_btw(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/aoe_turf/knock/jesus(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/self/jesus_ascend(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/jesus_deconvert(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/jesus_revive(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/area_teleport(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/voice_of_god(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/summonitem(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/pin(null))
		H.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/forcewall/hive(null))
		H.incorporeal_move = NONE
		H.CloseWings()