#define init
	global.spr_charselect  = sprite_add("sprites/races/yc/select.png", 1, 0, 0);
	global.spr_portrait[0] = sprite_add("sprites/races/yc/portrait.png", 1, 10, 237);
	global.spr_mapicon  = sprite_add("sprites/races/yc/map.png", 1, 10, 10);
	global.spr_ultport[1] = sprite_add("sprites/races/yc/ultra1.png", 1, 12, 16);
	global.spr_ultport[2] = sprite_add("sprites/races/yc/ultra2.png", 1, 12, 16);
	global.spr_ulticon[1] = sprite_add("sprites/races/yc/ultraicon1.png", 1, 9, 9);
	global.spr_ulticon[2] = sprite_add("sprites/races/yc/ultraicon2.png", 1, 9, 9);
	
	global.spr_molefriend_idle[0]  = sprite_add("sprites/races/yc/molefriendidle.png", 4, 12, 12);
	global.spr_molefriend_walk[0]  = sprite_add("sprites/races/yc/molefriendwalk.png", 6, 12, 12);
	global.spr_couchvenuz		   = sprite_add("sprites/races/yc/couchvenuz.png", 1, 13, 7);
	global.spr_molefriend_alert    = sprite_add("sprites/races/yc/molefriendalert.png", 1, 7, 7);
	global.spr_player_alert        = sprite_add("sprites/races/yc/playeralert.png", 1, 7, 7);
	global.spr_gun_alert           = sprite_add("sprites/races/yc/gunalert.png", 1, 7, 7);
	global.spr_pickup_alert        = sprite_add("sprites/races/yc/pickupalert.png", 3, 7, 7);
	global.spr_enemy_alert         = sprite_add("sprites/races/yc/enemyalert.png", 1, 7, 7);
	global.spr_guard_alert         = sprite_add("sprites/races/yc/guardalert.png", 1, 7, 7);
	global.spr_punch			   = sprite_add("sprites/races/yc/punch.png", 2, 4, 8);
	global.spr_ultra_punch		   = sprite_add("sprites/races/yc/ultrapunch.png", 2, 4, 8);
	global.spr_ultra_toss		   = sprite_add("sprites/races/yc/ultratoss.png", 6, 16, 16);
	//global.spr_hurt[0]  = sprite_add("sprites/races/yc/hurt.png", 3, 12, 12);
	//global.spr_dead[0]  = sprite_add("sprites/races/yc/dead.png", 6, 12, 12);
	//global.spr_sit[0]   = sprite_add("sprites/races/yc/sit.png", 1, 12, 12);
	//global.spr_gosit[0] = sprite_add("sprites/races/yc/gosit.png", 3, 12, 12);
	
	global.interactable = [chestprop, Pickup, WepPickup, enemy, RadChest, Player];
	global.newLevel 	= false;
	
	

#macro infinity 1/0
#macro anim_end                                                                                (image_index + image_speed >= image_number || image_index + image_speed < 0)
#macro enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))

#define race_name
	return "Y.C.";

#define race_text
	return "LIL BUDDY#GOT UR BACK";

#define race_tb_text
	return "@wGO 4 IT@s";

#define race_portrait
	return global.spr_portrait[0];

#define race_menu_button
	sprite_index = global.spr_charselect;

#define race_mapicon
	return global.spr_mapicon;

#define race_ultra_name
	switch(argument0)
	{
		case 1: return "GAME GOD"; break;
		case 2: return "CAR GOD"; break;
	}

#define race_ultra_text
	switch(argument0)
	{
		case 1: return "@gPLAY HARD@s";
		case 2: return "@yFAST LYFE@s";
	}
	
#define race_ultra_take(u, n)
	if(GameCont.area = 0) GameCont.loops--;
	GameCont.area = 107;
	GameCont.subarea = 0;
	with(MusCont) event_perform(ev_alarm, 11);
	
	if(u = 1) sound_play(sndYVUltraA);
	else if (u = 2) sound_play(sndYVUltraB);

#define race_ultra_button
	sprite_index = global.spr_ultport[argument0];
	
#define race_ultra_icon
	return global.spr_ulticon[argument0];

#define race_ttip
	if(random(1000) < 1) return "@qAUSTIN";

	 // ULTRA TIPS //
	if(instance_exists(GameCont) and GameCont.level >= 10 and random(5) < 1) return choose("SPONSORED", "IT'S JUST A GAME", "ACHIEVEMENT UNLOCKED", "BESTEST OF FRIENDS :)", "WISH Y.V. COULD SEE THIS", "NEW PB", "WHAT A GOOD TIME");
	
	 // NORMAL TIPS //
	else return choose("WHAT'S POPPIN'", "LET'S GO", "BIG MONY PLAYS", "BEST FRIENDS :)", "COOL", "NICE", "THIS IS AWESOME", "BRRT BRRT");


#define race_soundbank
	return "cuz";

#define race_swep
	return wep_golden_revolver;

#define create
	spr_idle = sprMutant16Idle;
	spr_walk = sprMutant16Walk;
	spr_hurt = sprMutant16Hurt;
	spr_dead = sprMutant16Dead;
	spr_sit1 = sprMutant16GoSit;
	spr_sit2 = sprMutant16Sit;
	
	mode = "";

#define step
	if(button_pressed(index, "horn")) {
		sound_play(sndVenuz);
		sound_play(sndCuzHorn);
	}
	
	with(instances_matching(Player, "id", id)) {
		if(race = "venuz" and button_pressed(index, "horn")) sound_play(sndCuzHorn);
	}
	
	if(array_length(instances_matching(instances_matching(CustomHitme, "name", "MOLEFRIEND"), "leader", other)) = 0) {
		molefriend_create(x, y, 0).leader = id;
	}
	
	if(instance_exists(GenCont)) global.newLevel = true;
	else if(global.newLevel){
		global.newLevel = false;
		with(instances_matching(instances_matching(CustomHitme, "name", "MOLEFRIEND"), "leader", other)) {
	 		x = other.x;
	 		y = other.y;
	 	}
	}
	
	 // Crib stuff
	with(instances_matching(YungCuz, "cuzified", null)) {
		cuzified = "yeah";
		
		if(array_length(instances_matching(Player, "race", "venuz")) = 0) {
			with(instance_create(x - 24, y, CustomHitme)) {
				sprite_index = global.spr_couchvenuz;
				mask_index = mskNone;
				spr_shadow = mskNone;
				depth = other.depth;
			}
		}
		
		instance_delete(self);
	}
	
	if(usespec or (canspec and button_check(index, "spec"))) {
		if(button_pressed(index, "spec")) sound_play(sndCuzGreet);
		
		var t = instance_nearest_array(mouse_x[index], mouse_y[index], 
			 instance_rectangle(mouse_x[index] - 24, mouse_y[index] - 24, mouse_x[index] + 24, mouse_y[index] + 24, global.interactable));
		
		if(instance_exists(t)) script_bind_draw(interactable_draw, t.depth, t, index);
		if(!audio_is_playing(sndCarLoop)) sound_play_pitchvol(sndCarLoop, 0.9, 0.8);
		
		wait 0;
		
		if(button_released(index, "spec")) {
			if(instance_exists(t)) with(t) {
			 	sound_play_pitch(choose(sndCuzWep, sndCuzGreet, sndCuzBye), 1 + random(0.2));
			 	instance_create(x, y, AssassinNotice);
			 	
			 	if(fork()) {
			 		wait 7;
			 		if(instance_exists(self)) {
					 	sound_play_pitch(sndMolefishFire, 1 + random(0.2));
					 	with(instances_matching(instances_matching(CustomHitme, "name", "MOLEFRIEND"), "leader", other)) {
					 		var addon = "",
					 			ind  = t.object_index;
					 			
					 		if(check_type(ind, Pickup) or check_type(ind, chestprop) or check_type(ind, RadChest)) addon = global.spr_pickup_alert;
					 		if(check_type(ind, WepPickup)) addon = global.spr_gun_alert;
					 		if(check_type(ind, enemy)) addon = global.spr_enemy_alert;
					 		if(check_type(ind, Player)) {
					 			addon = global.spr_guard_alert;
					 			guard = t;
					 		}
					 		
					 		alert(`@2(${global.spr_molefriend_alert})@2(${addon}:-0.4)`);
					 		target = other;
					 		for(i = 0; i < array_length(global.interactable); i++) {
					 			if(check_type(ind, global.interactable[i])) {
					 				leader.mode = global.interactable[i];
					 			}
					 		}
					 		
					 		for(i = 0; i < array_length(carrying); i++) {
					 			carrying[i].mask_index = carrying_mask[i];
					 			carrying = [];
					 			carrying_mask = [];
					 		}
					 	}
			 		}
				 	exit;
			 	}
			}
		
			else with(instances_matching(instances_matching(CustomHitme, "name", "MOLEFRIEND"), "leader", other)) {
				target = noone;
				leader.mode = "";
				alert(`@2(${global.spr_molefriend_alert})@2(${global.spr_player_alert})`);
				sound_play_pitch(sndCuzOpen, 1 + random(0.2));
			}
			
			sound_stop(sndCarLoop);
		}
		
		exit;
	}

#define interactable_draw(_t, ind)
	draw_set_visible_all(0);
	draw_set_visible(ind, 1);
	
	with(_t) {
	 	d3d_set_fog(true, player_get_color(ind), 0, 0);
	 	var r = "right" in self ? right : 1, 
	 		a = "rotation" in self ? rotation : image_angle,
	 		s = (1.1 + (abs(sin(current_frame * 0.1)) * 0.2));
		draw_sprite_ext(sprite_index, image_index, x, y, (image_xscale * r) * s, image_yscale * s, a, image_blend, visible);
		d3d_set_fog(false, c_white, 0, 0);
	}
	
	draw_set_visible_all(1);
	
	instance_destroy();

#define molefriend_create(_x, _y, _skin)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle       = global.spr_molefriend_idle[_skin];
		spr_walk       = global.spr_molefriend_walk[_skin];
		spr_hurt       = sprMolefishHurt;
		spr_dead       = sprMolefishDead;
		spr_shadow     = shd24;
		spr_shadow_x   = 0;
		spr_shadow_y   = 0;
		name		   = "MOLEFRIEND";
		hitid          = [spr_idle, name];
		right          = choose(1, -1);
		skin           = _skin;
		image_speed    = 0.4;
		depth          = -1;
		
		 // Sound:
		snd_hurt = sndMolefishHurt;
		snd_dead = sndMolefishDead;
		
		 // Vars:
		mask_index    = mskPlayer;
		direction     = random(360);
		friction      = 0.4;
		leader        = noone;
		target		  = noone;
		carrying      = [];
		guard		  = noone;
		carrying_mask = [];
		hop           = 0;
		hopspd        = 0;
		can_take      = true;
		can_path      = true;
		path          = [];
		path_dir      = 0;
		path_wall     = [Wall, InvisiWall];
		path_delay    = 0;
		maxhealth     = 999;
		my_health     = maxhealth;
		team          = 2;
		size          = 1;
		push          = 1;
		wave          = random(1000);
		walk          = 0;
		walkspeed     = 2.5;
		maxspeed      = 3;
		persistent    = 1;
		
		 // Scripts:
		on_step = script_ref_create(molefriend_step);
		on_end_step = script_ref_create(molefriend_end_step);
		on_alrm0 = script_ref_create(molefriend_alrm0);
		on_alrm1 = script_ref_create(molefriend_alrm1);
		on_hurt = script_ref_create(molefriend_hurt);
		on_draw = script_ref_create(draw_self_molefriend);
		
		 // Alarms:
		alarm0 = 20 + random(10);
		
		return id;
	}

#define molefriend_step
	if(instance_exists(Menu)) {
		instance_delete(self);
		exit;
	}

 	// Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;

	my_health = maxhealth;
	
	 // Pathfinding Delay:
	if(path_delay > 0){
		path_delay -= current_time_scale;
	}
	
	if(instance_exists(leader)){
		if(instance_exists(LevCont) or instance_exists(GenCont)) {
			x = leader.x;
			y = leader.y;
		}
		
		maxspeed = leader.maxspeed + 1 + ultra_get(mod_current, 2);
		
		if(leader.mode = Pickup or leader.mode = chestprop or leader.mode = RadChest or leader.mode = WepPickup) {
			if(hop <= 0 and array_length(carrying) < 1 + skill_get(mut_throne_butt) + ultra_get(mod_current, 2) and instance_exists(target) and target != leader and array_length(instances_matching(instances_matching(CustomObject, "name", "MOLETOSS"), "creator", target)) = 0 and point_distance(target.x, target.y, leader.x, leader.y) > 64 and place_meeting(x, y, target)) {
				array_push(carrying, target);
				array_push(carrying_mask, target.mask_index);
				if(!check_type(target, WepPickup)) target.mask_index = mskNone;
				target.depth = depth - 1;
				hopspd = 5;
				sound_play_pitch(sndChickenThrow, 0.8 + random(0.4));
				sound_play_pitch(sndAmmoPickup, 1.2 + random(0.2));
				target = leader;
			}
		}
		
		
		if(hop > 0) {
			if(array_length(carrying) > 0 and instance_exists(carrying[array_length(carrying) - 1]) and carrying[array_length(carrying) - 1].object_index = WepPickup) carrying[array_length(carrying) - 1].rotation += 10;
			hopspd -= 0.9 * current_time_scale; 
		}
		
		hop += hopspd * current_time_scale;
		
		if(hop < 0) {
			if(hopspd < current_time_scale) {
				sound_play_pitch(sndMolefishFire, 1.2 + random(0.2));
				hop = 0;
				hopspd = 0;
			}
		}
		
		if(array_length(carrying) > 0) {
			var tcarry = carrying[array_length(carrying) - 1];
			if(instance_exists(tcarry)) {
				if(hop <= 0 and tcarry.object_index != WepPickup and target = leader and point_distance(leader.x, leader.y, x, y) < 48) {
					var c = tcarry;
					with(molefriendtoss_create(c.x, c.y)){
						direction    = point_direction(x, y, other.leader.x, other.leader.y);
						friction	 = 0;
						speed        = other.leader.speed > 0 ? point_distance(x, y, other.leader.x, other.leader.y) * 0.50 : 3;
						creator      = c;
						depth        = c.depth;
						if(!sprite_exists(other.carrying_mask[array_length(other.carrying) - 1])) mask_index = mskPlayer;
						else mask_index   = other.carrying_mask[array_length(other.carrying) - 1];
						if("spr_shadow_y" in c) spr_shadow_y = c.spr_shadow_y;
					}
					
					sound_play_pitch(sndChickenThrow, 1 + random(0.2));
					carrying = array_slice(carrying, 0, array_length(carrying) - 1);
					carrying_mask = array_slice(carrying_mask, 0, array_length(carrying_mask) - 1);
				}
				
				else with(carrying) {
					if(other.carrying[array_length(other.carrying) - 1] = id) mask_index = mskPlayer; else mask_index = mskNone;
					x = other.x + lengthdir_x(other.speed * 2, other.direction);
					y = other.y + lengthdir_y(other.speed * 2, other.direction) - other.hop + (array_find_index(other.carrying, id) * 6);
					xprevious = x;
					yprevious = y;
				}
			}
			
			else {
				carrying = array_slice(carrying, 0, array_length(carrying) - 1);
				carrying_mask = array_slice(carrying_mask, 0, array_length(carrying_mask) - 1);
			}
		}
		
		 // Check if Target in Line of Sight:
		if(!instance_exists(target) or target = leader) target = decide_target(leader.mode);
		var	_xtarget    = target.x,
			_ytarget    = target.y,
			_targetSeen = true;
		
		for(var i = 0; i < array_length(path_wall); i++){
			var _wall = path_wall[i];
			if(collision_line(x, y, _xtarget, _ytarget, _wall, false, false)){
				_targetSeen = false;
				break;
			}
		}
		
		 // Create Path:
		if(visible && can_path && !_targetSeen){
			if(!path_reaches(path, _xtarget, _ytarget, path_wall)){
				if(path_delay <= 0){
					path_delay = 300;
					path = path_create(x, y, _xtarget, _ytarget, path_wall);
					path = path_shrink(path, path_wall, 10);
				}
			}
			else path_delay = 0;
		}
		else{
			path = [];
			path_delay = 0;
		}
	}
	
	else {
		if(instance_exists(Player)) instance_delete(self);
		else {
			corpse_drop(direction, speed);
			sound_play(snd_dead);
			instance_destroy();
		}
		exit;
	}
	
	if(visible){
		 // Movement:
		molefish_walk(walkspeed, maxspeed);
		
		 // Animate:
		sprite_index = enemy_sprite;
		
		 // Push:
		if(place_meeting(x, y, hitme)){
			if(place_meeting(x, y, enemy)){
				with(instances_meeting(x, y, enemy)){
					if(place_meeting(x, y, other)){
						if(size <= other.size){
							motion_add_ct(point_direction(other.x, other.y, x, y), 1);
						}
						
						if(size >= other.size){
							with(other){
								motion_add_ct(point_direction(other.x, other.y, x, y), push);
							}
						}
					}
				}
			}
		}
		if(place_meeting(x, y, object_index)){
			with(instances_meeting(x, y, instances_matching_ge(instances_matching(instances_matching(object_index, "name", name), "visible", true), "size", size))){
				if(place_meeting(x, y, other)){
					with(other){
						motion_add_ct(point_direction(other.x, other.y, x, y), push);
					}
				}
			}
		}
	}
	else walk = 0;
	
#define molefriend_alrm0
	if(visible){
		 // Where leader be:
		var	_leaderDir = 0,
			_leaderDis = 0;
			
		if(instance_exists(target)){
			_leaderDir = point_direction(x, y, target.x, target.y);
			_leaderDis = point_distance(x, y, target.x, target.y);
			
			if((leader.mode = enemy or leader.mode = Player) and alarm1 <= 0) alarm1 = 10;
		}
		
		 // Find Current Path Direction:
		path_dir = path_direction(path, x, y, path_wall);
		 // Follow Leader Around:
		if(instance_exists(leader)){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir + random_range(20, -20), 5);
			}
			
			 // Move Toward Leader:
			else if(_leaderDis > (target = leader ? 36 : 12)) {	
				alarm0 = 30;
				scrWalk(_leaderDir + random_range(10, -10), 10);
			}
		}
		
		 // Wander:
		else scrWalk(random(360), 15);
	}
	
	alarm0 = max(walk, 5);

#define molefriend_alrm1
	if(instance_exists(leader)) {
		if(leader.mode = enemy and instance_exists(target) and "team" in target and target.team != leader.team) {
			var t = target,
				l = leader;
			if(point_distance(x, y, t.x, t.y) < 48 and array_length(instances_matching(instances_matching(CustomObject, "name", "MOLETOSS"), "creator", t)) = 0) {
				with(molefriendtoss_create(t.x, t.y)){
					direction    = point_direction(l.x, l.y, t.x, t.y);
					speed        = ultra_get(mod_current, 1) ? 8 : 4;
					creator      = t;
					depth        = t.depth;
					mask_index   = t.mask_index;
					spr_shadow_y = t.spr_shadow_y;
					canfly		 = t.canfly;
				}
				
				with(instance_create(t.x, t.y, BulletHit)) {
					sprite_index = ultra_get(mod_current, 1) ? global.spr_ultra_toss : sprChickenB;
					image_speed = 0.6;
					depth = t.depth;
				}
				
				if(ultra_get(mod_current, 1)) {
					with(instance_rectangle(t.x - 24, t.y - 24, t.x + 24, t.y + 24, enemy)) {
						if(id != other.id) {
							with(molefriendtoss_create(x, y)){
								direction    = point_direction(l.x, l.y, x, y);
								speed        = ultra_get(mod_current, 1) ? 8 : 4;
								creator      = other;
								depth        = other.depth;
								mask_index   = other.mask_index;
								spr_shadow_y = other.spr_shadow_y;
								canfly		 = other.canfly;
							}
							
							canfly = true;
							
							with(instance_create(x, y, BulletHit)) {
								sprite_index = ultra_get(mod_current, 1) ? global.spr_ultra_toss : sprChickenB;
								image_speed = 0.6;
								depth = t.depth;
							}
						}
					}
				}
				
				t.canfly = true;
				t.mask_index = mskNone;
				
				sound_play_pitch(sndMolefishFire, 0.8 + random(0.2));
				
				if(ultra_get(mod_current, 1)) {
					sound_play_pitch(sndUltraGrenade, 1.6 + random(0.4));
					sound_play_pitch(sndHammer, 1.4 + random(0.2));
				}
					
				else {
					sound_play_pitch(sndChickenThrow, 1.4 + random(0.2));
					sound_play_pitch(sndImpWristHit, 0.8 + random(0.2));
				}
			}
			
			
			
			alarm1 = 10 + random(5);
		}
		
		if(leader.mode = Player and instance_exists(guard)) {
			target = decide_target(leader.mode);
			
			if(instance_exists(target) and target != guard) {
				if(point_distance(x, y, target.x, target.y) < 48) {
					var dir = point_direction(other.x, other.y, other.target.x, other.target.y);
					
					motion_add(dir, 2);
					
					with(instance_create(x + lengthdir_x(4 + skill_get(mut_long_arms), dir), y + lengthdir_y(4 + skill_get(mut_long_arms), dir), Shank)) {
						hitid = [global.spr_molefriend_idle, "VIOLENCE"];
						sprite_index = ultra_get(mod_current, 1) ? global.spr_ultra_punch : global.spr_punch;
						motion_add(dir + ((random_range(10, -10) + choose(60, -60)) * other.leader.accuracy), 4 + skill_get(mut_long_arms));
						image_angle = direction;
						image_yscale *= choose(1, -1);
						depth = other.depth - 1;
						canfix = 0;
						
						if(ultra_get(mod_current, 1)) mask_index = mskSlash;
						
						team = other.team;
						creator = other.id;
						damage = 2;
					}
					
					sound_play_pitch(sndMolefishFire, 0.8 + random(0.2));
					sound_play_pitch(ultra_get(mod_current, 1) ? sndUltraShovel : sndGoldWrench, 0.8 + random(0.2));
					sound_play_pitch(sndGoldScrewdriver, 0.7 + random(0.2));
				}
			}
			
			alarm1 = 10 + random(5);
		}
	}

#define molefriend_end_step
	 // Wall Collision:
	if(visible){
		with(path_wall){
			var _walled = false;
			with(other){
				if(place_meeting(x, y, other)){
					_walled = true;
					
					x = xprevious;
					y = yprevious;
					
					with(path_wall) with(other){
						while(speed != 0 && place_meeting(x + hspeed, y + vspeed, other)){
							if(hspeed != 0 && place_meeting(x + hspeed, y, other)){
								if(abs(hspeed) > 1){
									hspeed /= 2;
								}
								else hspeed = 0;
							}
							else if(vspeed != 0 && place_meeting(x, y + vspeed, other)){
								if(abs(vspeed) > 1){
									vspeed /= 2;
								}
								else vspeed = 0;
							}
							else if(abs(speed) > 1){
								speed /= 2;
							}
							else speed = 0;
						}
					}
					
					x += hspeed;
					y += vspeed;
				}
			}
			if(_walled) break;
		}
	}
	
#define molefriend_hurt(_damage, _force, _direction)
	if(visible && !instance_is(other, Corpse)){
		 // Hurt:
		if(my_health > 0){
			if(!instance_is(other, Debris)){
				 // Manual debris exit cause debris don't call on_hurt correctly:
				if(other == self && _force == 0 && _direction == 0){
					if(place_meeting(x, y, Debris)){
						with(instances_meeting(x, y, instances_matching_ge(instances_matching_gt(Debris, "speed", 2), "size", size - 1))){
							if(place_meeting(x, y, other)){
								if(_damage == round(1 + (speed / 10))){
									exit;
								}
							}
						}
					}
				}
				
				enemy_hurt(_damage, _force, _direction);
			}
		}
	}

#define molefriendtoss_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		name = "MOLETOSS";
		 // Vars:
		direction = random(360);
		friction  = 0.2;
		creator   = noone;
		z         = 0;
		zspeed    = 3;
		zfriction = 0.5;
		team      = -1;
		
		 // Saved Vars:
		depth        = -2;
		mask_index   = mskPlayer;
		spr_shadow_y = 0;
		
		on_step = script_ref_create(molefriendtoss_step)
		on_end_step = script_ref_create(molefriendtoss_end_step);
		on_cleanup = script_ref_create(molefriendtoss_cleanup);
		
		return id;
	}

#define molefriendtoss_step
	move_bounce_solid(true);

#define molefriendtoss_end_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	
	if(instance_exists(creator) && (z > 0 || zspeed > 0)){
		if(instance_is(creator, Player)){
			hspeed += (creator.hspeed / 10) * current_time_scale;
			vspeed += (creator.vspeed / 10) * current_time_scale;
		}
		
		speed = clamp(speed, 2, 6);
		
		with(creator){
			x = other.x;
			y = other.y - other.z;
			mask_index = mskNone;
			depth = -9;
			
			 // Shadow:
			if("spr_shadow_y" in self){
				spr_shadow_y = other.spr_shadow_y + other.z;
			}
			
			 // Aerodynamic:
			var _ang = point_direction(0, 0, other.hspeed, -other.zspeed) - 90;
			if("angle" in self) angle = _ang;
			else image_angle = _ang;
			
			 // Trail:
			if((current_frame % 1) < current_time_scale && instance_is(self, Player)){
				with(instance_create(x + random_range(4, -4), y + random_range(4, -4), Dust)){
					depth = other.depth;
				}
			}
		}
	}
	else{
		script_ref_call(on_cleanup);
		on_cleanup = undefined;
		
		with(creator){
			 // Damage:
			if(instance_is(self, hitme) && (place_meeting(x, y, Floor) || GameCont.area != "coast")){
				projectile_hit(self, GameCont.level);
			}
			
			 // On Walls:
			if(place_meeting(x, y, Wall)){
				with(instance_create(x, y, PortalClear)) {
					mask_index = other.mask_index;
				}
			}
			
			if("canfly" in self) canfly = other.canfly;
		}
		
		 // Effects:
		repeat(3 + variable_instance_get(creator, "size", 0)){
			with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
				motion_add(other.direction, 1);
			}
		}
		
		instance_destroy();
	}
	
#define molefriendtoss_cleanup
	 // Reset Vars:
	with(creator){
		mask_index = other.mask_index;
		depth = other.depth;
		if("spr_shadow_y" in self) spr_shadow_y = other.spr_shadow_y;
		if("angle" in self) angle = 0;
		else image_angle = 0;
	}

#define decide_target(_target)
	var dtarget = noone;

	switch(_target) {
		case Pickup: 
		case chestprop:
		case RadChest:
			if(array_length(carrying) < 1 + skill_get(mut_throne_butt) + ultra_get(mod_current, 2)) {
				var dist = 128 + (skill_get(mut_throne_butt) * 32),
					l = leader.index;
				
				dtarget = instance_nearest_array(mouse_x[l], mouse_y[l], instance_rectangle(mouse_x[l] - dist, mouse_y[l] - dist, mouse_x[l] + dist, mouse_y[l] + dist, instances_matching_ne(instances_matching_ne([Pickup, chestprop, RadChest], "object_index", Rad, BigRad, WepPickup), "id", carrying)));
			}
		break;
		
		case WepPickup: 
			if(array_length(carrying) < 1 + skill_get(mut_throne_butt) + ultra_get(mod_current, 2)) dtarget = instance_nearest(leader.x, leader.y, WepPickup);
		break;
		
		case Player: 
			var dist = 48;
			if(!instance_exists(guard)) guard = instance_nearest(x, y, Player);
			if(instance_exists(guard)) dtarget = instance_nearest_array(guard.x, guard.y, instance_rectangle(guard.x - dist, guard.y - dist, guard.x + dist, guard.y + dist, instances_matching_ne(projectile, "team", guard.team)));
		break;
		
		case enemy: 
			var dist = 64 + (skill_get(mut_throne_butt) * 32);
			dtarget = instance_nearest_array(mouse_x[l], mouse_y[l], instance_rectangle(mouse_x[l] - dist, mouse_y[l] - dist, mouse_x[l] + dist, mouse_y[l] + dist, instances_matching_ne(enemy, "object_index", Turret)));
		break;
	}
	
	if(!instance_exists(dtarget)) return instance_exists(guard) and leader.mode = Player ? guard : leader;
	
	return dtarget;

#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)
	 // Auto-Determine Grid Size:
	var	_tileSize   = 16,
		_areaWidth  = pceil(abs(_xtarget - _xstart), _tileSize) + 320,
		_areaHeight = pceil(abs(_ytarget - _ystart), _tileSize) + 320;
		
	_areaWidth = max(_areaWidth, _areaHeight);
	_areaHeight = max(_areaWidth, _areaHeight);
	
	var _triesMax = 4 * ceil((_areaWidth + _areaHeight) / _tileSize);
	
	 // Clamp Path X/Y:
	_xstart  = pfloor(_xstart,  _tileSize);
	_ystart  = pfloor(_ystart,  _tileSize);
	_xtarget = pfloor(_xtarget, _tileSize);
	_ytarget = pfloor(_ytarget, _tileSize);
	
	 // Grid Setup:
	var	_gridw    = ceil(_areaWidth  / _tileSize),
		_gridh    = ceil(_areaHeight / _tileSize),
		_gridx    = pround(((_xstart + _xtarget) / 2) - (_areaWidth  / 2), _tileSize),
		_gridy    = pround(((_ystart + _ytarget) / 2) - (_areaHeight / 2), _tileSize),
		_grid     = ds_grid_create(_gridw, _gridh),
		_gridCost = ds_grid_create(_gridw, _gridh);
		
	ds_grid_clear(_grid, -1);
	
	 // Mark Walls:
	with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, _wall)){
		if(position_meeting(x, y, self)){
			_grid[# (x - _gridx) / _tileSize, (y - _gridy) / _tileSize] = -2;
		}
	}
	
	 // Pathing:
	var	_x1         = (_xtarget - _gridx) / _tileSize,
		_y1         = (_ytarget - _gridy) / _tileSize,
		_x2         = (_xstart  - _gridx) / _tileSize,
		_y2         = (_ystart  - _gridy) / _tileSize,
		_searchList = [[_x1, _y1, 0]],
		_tries      = _triesMax;
		
	while(_tries-- > 0){
		var	_search = _searchList[0],
			_sx     = _search[0],
			_sy     = _search[1],
			_sp     = _search[2];
			
		if(_sp >= infinity) break; // No more searchable tiles
		_search[2] = infinity;
		
		 // Sort Through Neighboring Tiles:
		var _costSoFar = _gridCost[# _sx, _sy];
		for(var i = 0; i < 2*pi; i += pi/2){
			var	_nx = _sx + cos(i),
				_ny = _sy - sin(i),
				_nc = _costSoFar + 1;
				
			if(
				_nx >= 0     &&
				_ny >= 0     &&
				_nx < _gridw &&
				_ny < _gridh &&
				_grid[# _nx, _ny] == -1
			){
				_gridCost[# _nx, _ny] = _nc;
				_grid[# _nx, _ny] = point_direction(_nx, _ny, _sx, _sy);
				
				 // Add to Search List:
				array_push(_searchList, [
					_nx,
					_ny,
					point_distance(_x2, _y2, _nx, _ny) + (abs(_x2 - _nx) + abs(_y2 - _ny)) + _nc
				]);
			}
			
			 // Path Complete:
			if(_nx == _x2 && _ny == _y2){
				_tries = 0;
				break;
			}
		}
		
		 // Next:
		array_sort_sub(_searchList, 2, true);
	}
	
	 // Pack Path into Array:
	var	_x     = _xstart,
		_y     = _ystart,
		_path  = [[_x + (_tileSize / 2), _y + (_tileSize / 2)]],
		_tries = _triesMax;
		
	while(_tries-- > 0){
		var _dir = _grid[# ((_x - _gridx) / _tileSize), ((_y - _gridy) / _tileSize)];
		if(_dir >= 0){
			_x += lengthdir_x(_tileSize, _dir);
			_y += lengthdir_y(_tileSize, _dir);
			array_push(_path, [_x + (_tileSize / 2), _y + (_tileSize / 2)]);
		}
		else{
			_path = []; // Couldn't find path
			break;
		}
		
		 // Done:
		if(_x == _xtarget && _y == _ytarget){
			break;
		}
	}
	if(_tries <= 0) _path = []; // Couldn't find path
	
	ds_grid_destroy(_grid);
	ds_grid_destroy(_gridCost);
	
	return _path;
	
#define path_shrink(_path, _wall, _skipMax)
	var	_pathNew = [],
		_link    = 0;
		
	if(!is_array(_wall)){
		_wall = [_wall];
	}
	
	for(var i = 0; i < array_length(_path); i++){
		 // Save Important Points on Path:
		var _save = (
			i <= 0                       ||
			i >= array_length(_path) - 1 ||
			i - _link >= _skipMax
		);
		
		 // Save Points Going Around Walls:
		if(!_save){
			var	_x1 = _path[i + 1, 0],
				_y1 = _path[i + 1, 1],
				_x2 = _path[_link, 0],
				_y2 = _path[_link, 1];
				
			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x1, _y1, _x2, _y2, _wall[j], false, false)){
					_save = true;
					break;
				}
			}
		}
		
		 // Store:
		if(_save){
			array_push(_pathNew, _path[i]);
			_link = i;
		}
	}
	
	return _pathNew;
	
#define path_reaches(_path, _xtarget, _ytarget, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	var m = array_length(_path);
	if(m > 0){
		var	_x = _path[m - 1, 0],
			_y = _path[m - 1, 1];
			
		for(var i = 0; i < array_length(_wall); i++){
			if(collision_line(_x, _y, _xtarget, _ytarget, _wall[i], false, false)){
				return false;
			}
		}
		
		return true;
	}
	
	return false;

#define path_direction(_path, _x, _y, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	 // Find Nearest Unobstructed Point on Path:
	var	_disMax  = infinity,
		_nearest = -1;
		
	for(var i = 0; i < array_length(_path); i++){
		var	_px = _path[i, 0],
			_py = _path[i, 1],
			_dis = point_distance(_x, _y, _px, _py);
			
		if(_dis < _disMax){
			var _walled = false;
			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x, _y, _px, _py, _wall[j], false, false)){
					_walled = true;
					break;
				}
			}
			if(!_walled){
				_disMax = _dis;
				_nearest = i;
			}
		}
	}
	
	 // Find Direction to Next Point on Path:
	if(_nearest >= 0){
		var	_follow = min(_nearest + 1, array_length(_path) - 1),
			_nx = _path[_follow, 0],
			_ny = _path[_follow, 1];
			
		 // Go to Nearest Point if Path to Next Point Obstructed:
		for(var j = 0; j < array_length(_wall); j++){
			if(collision_line(x, y, _nx, _ny, _wall[j], false, false)){
				_nx = _path[_nearest, 0];
				_ny = _path[_nearest, 1];
				break;
			}
		}
		
		return point_direction(x, y, _nx, _ny);
	}
	
	return null;
	
#define path_draw(_path)
	var	_x = x,
		_y = y;
		
	with(_path){
		draw_line(self[0], self[1], _x, _y);
		_x = self[0];
		_y = self[1];
	}

#define instances_meeting(_x, _y, _obj)
	/*
		Returns all instances whose bounding boxes overlap the calling instance's bounding box at the given position
		Much better performance than manually performing 'place_meeting(x, y, other)' on every instance
	*/
	
	var	_tx = x,
		_ty = y;
		
	x = _x;
	y = _y;
	
	var _inst = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
	
	x = _tx;
	y = _ty;
	
	return _inst;

#define molefish_walk(_add, _max)                                                                  
	if(walk > 0){ 
		walk -= current_time_scale; 
		motion_add_ct(direction, _add); 
		if(speed > 0 and ultra_get(mod_current, 2)) {
			if(current_frame mod (4 * current_time_scale) = 0) {
				instance_create(x, y, GroundFlame).depth = depth + 2;
			}
			
			if(random(50/room_speed) < 1) {
				instance_create(x, y, Smoke).depth = depth + 1;
			}
		}
	} if(speed > _max) speed = _max;

#define enemy_hurt(_damage, _force, _direction)
	my_health -= _damage;           // Damage
	nexthurt = current_frame + 6;   // I-Frames
	motion_add(_direction, _force); // Knockback
	sound_play_hit(snd_hurt, 0.3);  // Sound
	
	 // Hurt Sprite:
	sprite_index = spr_hurt;
	image_index  = 0;

#define draw_self_molefriend()
	/*
		'draw_self()' for enemies
	*/
	
	image_xscale *= right;
	if(player_get_outlines(leader.index)) {
		d3d_set_fog(true, player_get_color(leader.index), 0, 0);
		draw_sprite_ext(sprite_index, image_index, x - 1, y - 1, image_xscale, image_yscale, image_angle, image_blend, visible);
		draw_sprite_ext(sprite_index, image_index, x - 1, y + 1, image_xscale, image_yscale, image_angle, image_blend, visible);
		draw_sprite_ext(sprite_index, image_index, x + 1, y - 1, image_xscale, image_yscale, image_angle, image_blend, visible);
		draw_sprite_ext(sprite_index, image_index, x + 1, y + 1, image_xscale, image_yscale, image_angle, image_blend, visible);
		d3d_set_fog(false, c_white, 0, 0);
	}
	
	draw_self(); // This is faster than draw_sprite_ext yea
	
	image_xscale /= right;

#define corpse_drop(_dir, _spd)
	/*
		Creates a corpse with a given direction and speed
		Automatically transfers standard variables to the corpse and applies impact wrists
	*/
	
	with(instance_create(x, y, Corpse)){
		size         = other.size;
		sprite_index = other.spr_dead;
		image_xscale = variable_instance_get(other, "right", other.image_xscale);
		direction    = _dir;
		speed        = _spd;
		
		 // Non-Props:
		if(!instance_is(other, prop) && instance_is(other, hitme)){
			mask_index = other.mask_index;
			speed += max(0, -other.my_health / 5);
			speed += 8 * skill_get(mut_impact_wrists) * instance_is(other, enemy);
		}
		
		 // Clamp Speed:
		speed = min(speed, 16);
		if(size > 0) speed /= size;
		
        return self;
	}

#define pround(_num, _precision)
	/*
		Precision 'round()'
		
		Ex:
			pround(7, 3) == 6
	*/
	
	if(_precision != 0){
		return round(_num / _precision) * _precision;
	}
	
	return _num;
	
#define pfloor(_num, _precision)
	/*
		Precision 'floor()'
		
		Ex:
			pfloor(2.7, 0.5) == 2.5
	*/
	
	if(_precision != 0){
		return floor(_num / _precision) * _precision;
	}
	
	return _num;
	
#define pceil(_num, _precision)
	/*
		Precision 'ceil()'
		
		Ex:
			pceil(-9, 5) == -5
	*/
	
	if(_precision != 0){
		return ceil(_num / _precision) * _precision;
	}
	
	return _num;

#define instance_nearest_array(_x, _y, _obj)
	/*
		Returns the instance closest to a given point from an array of instances
		
		Ex:
			instance_nearest_array(x, y, instances_matching_ne(hitme, "team", 2));
	*/
	
	var	_disMax  = infinity,
		_nearest = noone;
		
	with(instances_matching(_obj, "", null)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < _disMax){
			_disMax  = _dis;
			_nearest = self;
		}
	}
	
	return _nearest;

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all given instances with their coordinates touching a given rectangle
		Much better performance than manually performing "point_in_rectangle()" with every instance
	*/
	
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);
	
#define scrWalk(_dir, _walk)
	walk      = (is_array(_walk) ? random_range(_walk[0], _walk[1]) : _walk);
	speed     = max(speed, friction);
	direction = _dir;
	
	if("gunangle" not in self){
		scrRight(direction);
	}

#define scrRight(_dir)
	_dir = ((_dir % 360) + 360) % 360;
	if(_dir < 90 || _dir > 270) right = 1;
	if(_dir > 90 && _dir < 270) right = -1;

#define alert(_text)
	with(instance_create(x, y, PopupText)) {
		mytext = _text;
		//time *= 0.5;
		alarm1 *= 0.25;
		return id;
	}
	
#define check_type(ind, _type)
	return object_is_ancestor(ind, _type) or ind = _type;
