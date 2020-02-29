/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0

	// Strings.
	var/surgery_name					// A special name that replaces item name in surgery messages
	var/organ_tag = "organ"				// Unique identifier.
	var/parent_organ = BP_CHEST			// Organ holding this object.
	var/dead_icon

	// Status tracking.
	var/status = NONE					// Various status flags
	var/vital = FALSE					// Lose a vital limb, die immediately.
	var/damage = 0						// Current damage to the organ

	// Type of modification, (If you ever need to apply several types make this a bit flag)
	var/nature = MODIFICATION_ORGANIC

	// Reference data.
	var/mob/living/carbon/human/owner	// Current mob owning the organ.
	var/obj/item/organ/external/parent
	var/list/transplant_data			// Transplant match data.
	var/list/autopsy_data = list()		// Trauma data for forensics.
	var/list/trace_chemicals = list()	// Traces of chemicals in the organ.
	var/datum/dna/dna
	var/datum/species/species

	// Damage vars.
	var/min_bruised_damage = 10			// Damage before considered bruised
	var/min_broken_damage = 30			// Damage before becoming broken
	var/max_damage						// Damage cap
	var/rejecting						// Is this organ already being rejected?
	matter = list(MATERIAL_BIOMATTER = 20)

	var/death_time						// limits organ self recovery

/obj/item/organ/Destroy()
	if(owner)
		if(src in owner.contents)
			owner.contents -= src
		owner = null
	parent = null
	QDEL_NULL(dna)
	species = null

	return ..()

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/New(mob/living/carbon/holder, datum/organ_description/OD)
	..(holder)
	var/internal = !istype(src, /obj/item/organ/external)
	create_reagents(5)
	if(!max_damage)
		max_damage = min_broken_damage * 2
	if(istype(holder))
		src.owner = holder
		species = all_species["Human"]
		if(holder.dna)
			dna = holder.dna.Clone()
			species = all_species[dna.species]
		else
			log_debug("[src] at [loc] spawned without a proper DNA.")
		var/mob/living/carbon/human/H = holder
		if(istype(H))
			if(internal)
				var/obj/item/organ/external/E = H.get_organ(parent_organ)
				if(E)
					if(E.internal_organs == null)
						E.internal_organs = list()
					E.internal_organs |= src
			if(dna)
				if(!blood_DNA)
					blood_DNA = list()
				blood_DNA[dna.unique_enzymes] = dna.b_type
				if(internal)
					H.internal_organs_by_name[src.organ_tag] = src
		if(internal)
			holder.internal_organs |= src
	if(internal)
		update_icon()

// Surgery hooks
/obj/item/organ/attack_self(mob/living/user)
	if(do_surgery(user, null))
		return
	return ..()

/obj/item/organ/attackby(obj/item/I, mob/living/user)
	if(do_surgery(user, I))
		return
	return ..()


/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA.Cut()
		blood_DNA[dna.unique_enzymes] = dna.b_type
		species = all_species[new_dna.species]

/obj/item/organ/proc/die()
	if(BP_IS_ROBOTIC(src))
		return
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	death_time = world.time
	if(dead_icon)
		icon_state = dead_icon
	if(owner && vital)
		owner.death()

/obj/item/organ/get_item_cost()
	if((status & ORGAN_DEAD) || species != all_species["Human"]) //No dead or monkey organs!
		return 0
	return ..()


// Checks if the organ is in a freezer, an MMI or a stasis bag - it will not be processed then
/obj/item/organ/proc/is_in_stasis()
	if(istype(loc, /obj/item/device/mmi))
		return TRUE

	if(istype(loc, /obj/structure/closet/body_bag/cryobag) || istype(loc, /obj/structure/closet/crate/freezer) || istype(loc, /obj/item/weapon/storage/box/freezer))
		return TRUE

	return FALSE


/obj/item/organ/Process()

	if(loc != owner)
		owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(is_in_stasis())
		return

	//Process infections
	if (BP_IS_ROBOTIC(src) || (owner && owner.species && (owner.species.flags & IS_PLANT)))
		germ_level = 0
		return

	if(!owner)
		var/datum/reagent/organic/blood/B = locate(/datum/reagent/organic/blood) in reagents.reagent_list
		if(B && prob(40))
			reagents.remove_reagent("blood",0.1)
			blood_splatter(src,B,1)
		if(config.organs_decay) damage += rand(1,3)
		if(damage >= max_damage)
			damage = max_damage
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner && owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()

/obj/item/organ/examine(mob/user)
	..(user)
	if(status & ORGAN_DEAD)
		to_chat(user, SPAN_NOTICE("The decay has set in."))

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(antibiotics < 5 && prob(round(germ_level/6)))
			germ_level++

	if(germ_level >= INFECTION_LEVEL_ONE)
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(dna)
		if(!rejecting)
			if(blood_incompatible(dna.b_type, owner.dna.b_type, species, owner.species))
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						germ_level++
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to INFINITY)
						germ_level += rand(3,5)
						owner.reagents.add_reagent("toxin", rand(1,2))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/rejuvenate()
	damage = 0

/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = 0
	if(owner)
		antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a minute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 5 minutes

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own version of this proc
/obj/item/organ/proc/take_damage(amount, var/silent=0)
	if(BP_IS_ROBOTIC(src))
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", 1)

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if (1)
			take_damage(9)
		if (2)
			take_damage(3)
		if (3)
			take_damage(1)

// Gets the limb this organ is located in, if any
/obj/item/organ/proc/get_limb()
	if(owner)
		return owner.get_organ(parent_organ)

	else if(istype(loc, /obj/item/organ/external))
		return loc

	return null

/obj/item/organ/proc/removed(mob/living/user)
	var/obj/item/organ/external/affected = get_limb()

	if(affected)
		affected.internal_organs -= src
		forceMove(affected.drop_location())
	else
		forceMove(get_turf(src))

	if(!istype(owner))
		return

	owner.internal_organs_by_name[organ_tag] = null
	owner.internal_organs_by_name -= organ_tag
	owner.internal_organs_by_name -= null
	owner.internal_organs -= src

	START_PROCESSING(SSobj, src)
	rejecting = null
	var/datum/reagent/organic/blood/organ_blood = locate(/datum/reagent/organic/blood) in reagents.reagent_list
	if(!organ_blood || !organ_blood.data["blood_DNA"])
		owner.vessel.trans_to(src, 5, 1, 1)

	if(owner && vital)
		if(user)
			user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [owner.name] ([owner.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
			owner.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
			msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [owner.name] ([owner.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		owner.death()

	owner = null

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/organic/blood/transplant_blood = locate(/datum/reagent/organic/blood) in reagents.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data["species"] =    target.species.name
		transplant_data["blood_type"] = target.dna.b_type
		transplant_data["blood_DNA"] =  target.dna.unique_enzymes
	else
		transplant_data["species"] =    transplant_blood.data["species"]
		transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	owner = target
	loc = owner
	STOP_PROCESSING(SSobj, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src

/obj/item/organ/proc/install(mob/living/carbon/human/H)
	if(!istype(H))
		return 1

	owner = H
	forceMove(owner)
	if(parent_organ)
		parent = H.get_organ(parent_organ)

	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type
	STOP_PROCESSING(SSobj, src)

/obj/item/organ/proc/heal_damage(amount)
	return

/obj/item/organ/proc/can_recover()
	return (max_damage > 0) && !(status & ORGAN_DEAD) || death_time >= world.time - ORGAN_RECOVERY_THRESHOLD

/obj/item/organ/proc/can_feel_pain()
	if(!owner)
		return FALSE

	if(BP_IS_ROBOTIC(src))
		return FALSE

	if(status & ORGAN_DEAD)
		return FALSE

	if(species && (species.flags & NO_PAIN))
		return FALSE

	if(owner.stat >= UNCONSCIOUS)
		return FALSE

	if(owner.analgesic >= 100)
		return FALSE

	return TRUE

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))