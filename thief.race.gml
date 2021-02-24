#define init
	global.spr_charselect  = sprite_add("sprites/races/thief/charselect.png", 1, 0, 0);
	global.spr_portrait[0] = sprite_add("sprites/races/thief/portrait.png", 1, 40, 217);
	global.spr_mapicon[0]  = sprite_add("sprites/races/thief/mapicon.png", 1, 10, 10);
	/*global.spr_ultport[1] = sprite_add("sprites/races/thief/ultra1.png", 1, 12, 16);
	global.spr_ultport[2] = sprite_add("sprites/races/thief/ultra2.png", 1, 12, 16);
	global.spr_ulticon[1] = sprite_add("sprites/races/thief/ultraicon1.png", 1, 9, 9);
	global.spr_ulticon[2] = sprite_add("sprites/races/thief/ultraicon2.png", 1, 9, 9);*/
	
	global.spr_idle[0]  = sprite_add("sprites/races/thief/idle.png", 4, 12, 12);
	global.spr_walk[0]  = sprite_add("sprites/races/thief/walk.png", 6, 12, 12);
	global.spr_hurt[0]  = sprite_add("sprites/races/thief/hurt.png", 3, 12, 12);
	global.spr_dead[0]  = sprite_add("sprites/races/thief/dead.png", 6, 12, 12);
	global.spr_sit[0]   = sprite_add("sprites/races/thief/sit.png", 1, 12, 12);
	global.spr_gosit[0] = sprite_add("sprites/races/thief/gosit.png", 3, 12, 12);
	
	global.spr_orb = {};
	
	global.level_start = false;

	 // STOLE THIS FROM YOKIN, GO CHECK OUT HIS BALLMOM RACE
	while(true) {
		if(array_length(instances_matching(Player, "race", mod_current)) > 0) {
			 // Level Start:
			if(instance_exists(GenCont) || instance_exists(Menu)){
				global.level_start = true;
			}
			else if(global.level_start){
				global.level_start = false;
				
				if(instance_exists(GameCont)) {
					var c = choose(WeaponChest, AmmoChest, RadChest),
						f = instances_matching(Floor, "", null),
						rf = f[irandom_range(0, array_length(f) - 1)];
						
					repeat(ceil(GameCont.level/2)) {
						c = choose(WeaponChest, AmmoChest, RadChest);
						rf = f[irandom_range(0, array_length(f) - 1)];
						with(instance_create(rf.x + 16, rf.y + 16, c)) instance_budge([chestprop, RadChest]);
					}
				}
			}
		}
		
		wait 1;
	}

#define race_name
	return "THIEF";

#define race_text
	return "GETS MORE @yCHESTS@w#CAN REROLL WEAPONS";

#define race_tb_text
	return "REROLLING GIVES A @wFREE WEAPON@s";

#define race_portrait
	return global.spr_portrait[argument1];
	
#define race_menu_button
	sprite_index = global.spr_charselect;

#define race_mapicon
	return global.spr_mapicon[argument1];

#define race_ultra_name
	switch(argument0)
	{
		case 1: return "FINDERS KEEPERS @d(NYI)@w"; break;
		case 2: return "GETAWAY"; break;
	}

#define race_ultra_text
	switch(argument0)
	{
		case 1: return "@wCHESTS@s GIVE PROTECTION";
		case 2: return "REROLLING GIVES @rINVINCIBILITY@s";
	}

#define race_ttip
	 // ULTRA TIPS //
	if(instance_exists(GameCont) and GameCont.level >= 10 and random(5) < 1) return choose("BLACK MARKET DEALS", "BURN A FEW BRIDGES", "IT WASN'T WORTH IT ANYWAY", "ALL FOR THE FAMILY", "TRADE SECRETS");
	
	 // NORMAL TIPS //
	else return choose("KNOW SOME PEOPLE", "MAKE CONNECTIONS", "EAT OR BE EATEN", "IT'S A CUTTHROAT BUSINESS", "BEST OF THE BEST", "SECRET STASH", "STOCKPILE");

#define create
	spr_idle = global.spr_idle[bskin];
	spr_walk = global.spr_walk[bskin];
	spr_hurt = global.spr_hurt[bskin];
	spr_dead = global.spr_dead[bskin];
	spr_sit1 = global.spr_sit[bskin];
	spr_sit2 = global.spr_gosit[bskin];
	
	chestshield = [];
	rerollinv = 0;

#define step
	if(usespec or (canspec and button_pressed(index, "spec"))) {
		if(reload <= 0) {
			if(instance_exists(GameCont) and (ammo[weapon_get_type(wep)] >= typ_ammo[weapon_get_type(wep)] or infammo != 0)) {
				if(infammo = 0 and weapon_get_type(wep) != 0) ammo[weapon_get_type(wep)] -= typ_ammo[weapon_get_type(wep)];
				wep = weapon_decide(min(GameCont.hard, 7), GameCont.hard + 2, false, [wep, bwep]);
				reload += weapon_get_load(wep);
				instance_create(x, y, GunGun).depth = depth - 1;
				if(skill_get(mut_throne_butt)) {
					with(instance_create(x, y, WepPickup)) {
						wep = weapon_decide(min(GameCont.hard, 7), GameCont.hard + 2, false, [other.wep, other.bwep]);
						ammo = 0;
					}
					
					sound_play_pitch(sndGrenade, 0.8 + random(0.2));
				}
				
				if(ultra_get(mod_current, 2)) {
					rerollinv = 45 * ultra_get(mod_current, 2);
					sound_play_pitch(sndCrystalShield, 0.7 + random(0.2));
					sound_play_pitch(sndSwapHammer, 0.8 + random(0.2));
				}
				
				weapon_post(-4, 0, 0);
				sound_play_pitch(sndGunGun, 0.6 + random(0.4));
				sound_play_pitch(sndSodaMachineBreak, 0.8 + random(0.2));
				sound_play_pitch(sndClusterOpen, 0.7 + random(0.2));
				sound_play_pitch(sndSwapMotorized, 0.8 + random(0.2));
				sound_play_pitch(sndAmmoPickup, 0.8 + random(0.3));
			}
			
			else {
				weapon_post(-4, 0, 0);
				sound_play_pitch(sndWeaponPickup, 0.8 + random(0.2));
				sound_play_pitch(sndEmpty, 1.2 + random(0.4));
			}
		}
	}
	
	 // INVINCIBILITY
	if(rerollinv > 0) {
		rerollinv -= current_time_scale;
		if(round(rerollinv) mod 3 = 0) with(instance_create(x + random_range(8, -8), y + random_range(8, -8), PlasmaTrail)) {
			image_angle = random(360);
			sound_play_pitchvol(sndLightningCrystalHit, 4 + random(0.6), 0.5);
			sound_play_pitchvol(sndPlasmaReload, 6 + random(0.6), 0.5);
			sound_play_pitchvol(sndLightningReload, 2 + random(0.2), 0.5);
			
			sprite_index = sprEnemyLaserEnd;
		}
		
		var curhp = my_health;
		if(fork()) {
			wait 1;
			if(instance_exists(self) and curhp > my_health) {
				sound_play_pitchvol(sndSwapEnergy, 2 + random(0.2), 0.4);
				sound_play_pitchvol(sndPlasmaRifleUpg, 2.4 + random(0.2), 0.4);
				my_health = curhp;
			}
		}
	}
	
	 //SCRAP DEFENSE ULTRA THING
	if(false){
		if("orb" not in self || !instance_exists(orb)){
			with(instance_create(x, y, CustomHitme)){
				name = "ThiefOrb";
				sprite_index = mskNone;
				mask_index = mskNone;
				shad = spr_shadow;
				thiefScrap = 0;
				my_health = maxhealth;
				creator = other;
				team = other.team;
				on_step = Orb_step;
				on_hurt = Orb_hurt;
				persistent = true;
				other.orb = self;
			}
		}
		if(instance_exists(chestprop)){
			var _inst = instances_matching(chestprop, "thiefcheck", null);
			if(array_length(_inst) && !instance_exists(GenCont) && !instance_exists(SpiralCont)) with(_inst){
				thiefcheck = 1;
				if(fork()){
					if(lq_defget(global.spr_orb, sprite_index, -4) == -4){
						var sprList = [];
						if(sprite_get_number(sprite_index) > 0){
							for(var i = 0; i < 360; i += 45){
								array_push(sprList, sprites_add_merged(i, 45, sprite_index, mskNone, mskNone, mskNone, mskNone, mskNone, mskNone, mskNone));
							}
						}
						lq_set(global.spr_orb, sprite_index, sprList);
					}
					var _x = x;
					var _y = y;
					var _spr = sprite_index;
					var _targ = other;
					var _orb = other.orb;
					while(instance_exists(self)){
						_x = x;
						_y = y;
						if(instance_exists(GenCont) || instance_exists(Menu)){
							exit;
						}
						wait(0);
					}
					if(instance_exists(GenCont) || instance_exists(Menu)){
						exit;
					}
					for(var i = 0; i < 360; i += 45){
						with(instance_create(_x, _y, CustomObject)){
							name = "ThiefScrap";
							depth            = -8;
							
							 // Vars:
							mask_index     = mskLaser;
							creator        = _targ;
							target         = _orb;
							
							 // Push:
							motion_add(random(360), 4 + random(2));
							image_angle = direction + 135;
							index = creator.index;
							
							stick = false;
							stickx = 0;
							sticky = 0;
							stick_wait = 3;
							
							on_step = Scrap_step;
							on_end_step = Scrap_end_step;
							
							image_speed = 0;
							sprite_index = lq_defget(global.spr_orb, _spr, [mskNone,mskNone,mskNone,mskNone,mskNone,mskNone,mskNone,mskNone])[i/45];
						}
					}
					exit;
				}
			}
		}
	}

#define Orb_step
	if("creator" not in self || !instance_exists(creator)){
		instance_destroy();
		exit;
	}
	if(thiefScrap > 0){
		mask_index = mskPlayer;
		spr_shadow = shad;
	}else{
		mask_index = mskNone;
		spr_shadow = mskNone;
	}
	x = creator.x + lengthdir_x(12,current_time/5);
	y = creator.y + lengthdir_y(12,current_time/5);

#define Orb_hurt(_hitdmg, _hitvel, _hitdir)
	thiefScrap -= _hitdmg;
	with(instances_matching(instances_matching(instances_matching(CustomObject, "name", "ThiefScrap"), "target", self), "stick", true)){
		_hitdmg--;
		motion_add_ct(_hitdir + random_range(-30, 30), 5);
		target = noone;
		stick = false;
		if(_hitdmg <= 0){
			break;
		}
	}
	
//yoinked TE feather shenanigans
#define Scrap_step
	speed -= speed_raw * 0.1;
	if("timer" in self && timer <= 0){
		speed -= speed_raw * 0.3;
		exit;
	}
	if(instance_exists(target) && !stick){
		// Fly Towards Target:
		motion_add_ct(point_direction(x, y, target.x, target.y) + random_range(-30, 30), 1);
		
		if(distance_to_point(target.x,target.y) < 4){
			 // Effects:
			with(instance_create(x, y, Dust)) depth = other.depth - 1;
			sound_play_pitchvol(sndFlyFire,        2 + random(0.2),  0.05);
 			sound_play_pitchvol(sndHitMetal,   1.3 + random(0.2), 0.45);
 			sound_play_pitchvol(sndMoneyPileBreak, 1 + random(3),    0.35);
			stick       = true;
			stickx      = random(x - target.x) * (("right" in target) ? target.right : 1);
			sticky      = random(y - target.y);
			image_angle = random(360);
			speed       = 0;
			if("thiefScrap" not in target){
				thiefScrap = 0;
			}
			target.thiefScrap++;
			exit;
		}
	}else if(!stick){
		//if the instance doesn't exist, it's USELESS. Throw it away.
		if("timer" not in self){
			target = noone;
			motion_add_ct(90,5);
			timer = 15;
		}
		motion_add_ct(270,0.4);
		timer--;
		depth++;
	}

#define Scrap_end_step
	if("timer" in self){
		exit;
	}
	if(stick && instance_exists(target)){
		x       = target.x + (stickx * image_xscale * (("right" in target) ? target.right : 1));
		y       = target.y + (sticky * image_yscale);
		visible = target.visible;
		depth   = target.depth - 1;
		
		 // Target In Water:
		if("wading" in target && target.wading != 0){
			visible = true;
		}
		
		 // Z-Axis Support:
		if("z" in target){
			y -= abs(target.z);
		}
	}
	else{
		visible = true;
		depth   = -8;
	}
	
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)
	/*
		Returns a random weapon that spawns within the given difficulties
		Takes standard weapon chest spawning conditions into account
		
		Ex:
			wep = weapon_decide(0, GameCont.hard, false, [wep, bwep]);
	*/
	
	 // Robot:
	for(var i = 0; i < maxp; i++) if(player_get_race(i) == "robot") _hardMax++;
	_hardMin += (5 * ultra_get("robot", 1));
	
	 // Just in Case:
	_hardMax = max(0, _hardMax);
	_hardMin = min(_hardMin, _hardMax);
	
	 // Default:
	var _wepDecide = wep_screwdriver;
	if(_gold != 0){
		_wepDecide = choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);
		if(GameCont.loops > 0 && random(2) < 1){
			_wepDecide = choose(wep_golden_screwdriver, wep_golden_assault_rifle, wep_golden_slugger, wep_golden_splinter_gun, wep_golden_bazooka, wep_golden_plasma_gun);
		}
	}
	
	 // Decide:
	var	_list    = ds_list_create(),
		_listMax = weapon_get_list(_list, _hardMin, _hardMax);
		
	ds_list_shuffle(_list);
	
	for(var i = 0; i < _listMax; i++){
		var	_wep    = ds_list_find_value(_list, i),
			_canWep = true;
			
		 // Weapon Exceptions:
		if(_wep == _noWep || (is_array(_noWep) && array_find_index(_noWep, _wep) >= 0)){
			_canWep = false;
		}
		
		 // Gold Check:
		else if((_gold > 0 && !weapon_get_gold(_wep)) || (_gold < 0 && weapon_get_gold(_wep) == 0)){
			_canWep = false;
		}
		
		 // Specific Spawn Conditions:
		else switch(_wep){
			case wep_super_disc_gun       : if("curse" not in self || curse <= 0) _canWep = false; break;
			case wep_golden_nuke_launcher : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_golden_disc_gun      : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_gun_gun              : if(crown_current != crwn_guns)        _canWep = false; break;
		}
		
		 // Success:
		if(_canWep){
			_wepDecide = _wep;
			break;
		}
	}
	
	ds_list_destroy(_list);
	
	return _wepDecide;
	
#define instance_budge(_objAvoid)
	/*
		Moves the current instance to the nearest space within the given distance that isn't touching the given object
		Also avoids moving an instance outside of the level if they were touching a Floor
		Returns 'true' if the instance was moved to an open space, 'false' otherwise
		
		Args:
			objAvoid - The object(s) or instance(s) to avoid
			disMax   - The maximum distance that the current instance can be moved
			           Use -1 to automatically determine the distance using the bounding boxes of the current instance and objAvoid
	*/
	
	var	_isArray  = is_array(_objAvoid),
		_inLevel  = !place_meeting(xprevious, yprevious, Floor),
		_disAdd   = 4,
		_dirStart = 0,
		_disMax   = 0;
		
	var	_w = 0,
		_h = 0;
		
	with(_isArray ? _objAvoid : [_objAvoid]){
		if(object_exists(self)){
			var _mask = object_get_mask(self);
			if(_mask < 0){
				_mask = object_get_sprite(self);
			}
			_w = max(_w, (sprite_get_bbox_right(_mask)  + 1) - sprite_get_bbox_left(_mask));
			_h = max(_h, (sprite_get_bbox_bottom(_mask) + 1) - sprite_get_bbox_top(_mask));
		}
		else{
			_w = max(_w, sprite_width);
			_h = max(_h, sprite_height);
		}
	}
	
	_disMax = sqrt(sqr(sprite_width + _w) + sqr(sprite_height + _h)) + _disAdd;
	
	 // Starting Direction:
	if(x != xprevious || y != yprevious){
		_dirStart = point_direction(x, y, xprevious, yprevious);
	}
	else{
		_dirStart = point_direction(hspeed, vspeed, 0, 0);
	}
	
	 // Search for Open Space:
	var _dis = 0;
	while(_dis <= _disMax){
		 // Look Around:
		var _dirAdd = 360 / max(1, 4 * _dis);
		for(var _dir = _dirStart; _dir < _dirStart + 360; _dir += _dirAdd){
			var	_x = x + lengthdir_x(_dis, _dir),
				_y = y + lengthdir_y(_dis, _dir);
				
			if(_isArray ? !array_length(instances_meeting(_x, _y, _objAvoid)) : !place_meeting(_x, _y, _objAvoid)){
				if(_inLevel || (place_free(_x, _y) && (position_meeting(_x, _y, Floor) || place_meeting(_x, _y, Floor)))){
					x = _x;
					y = _y;
					xprevious = x;
					yprevious = y;
					
					return true;
				}
			}
		}
		
		 // Go Outward:
		if(_dis >= _disMax) break;
		_dis = min(_dis + clamp(_dis, 1, _disAdd), _disMax);
	}
	
	return false;
	
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

//Taken from 700,000 Mutations by Squiddy
#define sprites_add_merged
/// sprites_add_merged(_dir, _angle, _sprite1, _sprite2, ...)
var _dir = argument[0], _angle = argument[1], _sprite1 = argument[2], _sprite2 = argument[3];

var _width = 1;
var _height = 1;
var _xoffset = 0;
var _yoffset = 0;
var _number = 1;

var i = 0;
var j = 0;

for (i = 2; argument_count > i; i ++){
	var _spr = argument[i];
	
	_width = max(_width, sprite_get_width(_spr));
	_height = max(_height, sprite_get_height(_spr));
	_xoffset = max(_xoffset, sprite_get_xoffset(_spr));
	_yoffset = max(_yoffset, sprite_get_yoffset(_spr));
	_number = max(_number, sprite_get_number(_spr));
}

var _surface = surface_create(_width * _number, _height);

if (surface_exists(_surface)){
	surface_set_target(_surface);
	
	draw_clear_alpha(c_white, 0);
	
	for (i = 2; argument_count > i; i ++){
		var _spr = argument[i];
		var _images = sprite_get_number(_spr);
		var _pieces = [];
		
		for (j = 0; _images > j; j ++){
			array_push(_pieces, sprite_get_piece(_spr, j, argument_count - 2, i, _dir, _angle, c_white, 1));
		}
		
		surface_set_target(_surface);
		
		for (j = 0; _number > j; j ++){
			draw_surface(_pieces[j % _images], _width * j + _xoffset - sprite_get_xoffset(_spr), _yoffset - sprite_get_yoffset(_spr));
		}
		
		for (j = 0; _images > j; j ++){
			surface_free(_pieces[j]);
		}
	}
	
	surface_reset_target();
	
	surface_save(_surface, "merged.png");
	
	surface_free(_surface);
}

// return `../${mod_current}.mod/merged.png`;
return sprite_add("merged.png", _number, _xoffset, _yoffset);

#define sprite_get_piece(_spr, _img, _count, _piece, _dir, _angle, _color, _alpha)
_dir = sign(_dir) * -1;
_dir = (_dir != 0 ? _dir : -1);

var _width = sprite_get_width(_spr);
var _height = sprite_get_height(_spr);
var _xoffset = sprite_get_xoffset(_spr);
var _yoffset = sprite_get_yoffset(_spr);

var _me = surface_create(_width, _height);

if (surface_exists(_me)){
	surface_set_target(_me);
	
	draw_clear_alpha(c_white, 0);
	draw_sprite(_spr, _img, _xoffset, _yoffset);
	
	surface_reset_target();
	
	if (_count <= 1){
		return _me;
	}
	
	var piece_size = 360 / _count;
	var _half = piece_size * 0.5;
	var i = _angle + piece_size * _piece * _dir;
	
	var _left = i + _half;
	var _right = i - _half;
	var _coord = [0, 0, 1, 1];
	var _pos = [0, 0, _width, _height];
	var _middle = [_width * 0.5, _height * 0.5, 0.5, 0.5];
	
	var _surface = surface_create(_width, _height);
	
	if (surface_exists(_surface)){
		surface_set_target(_surface);
		
		draw_primitive_begin_texture(pr_trianglefan, surface_get_texture(_me));
		
		surface_set_target(_surface);
		
		draw_clear_alpha(c_white, 0);
		
		draw_vertex_texture_color(_middle[0], _middle[1], _middle[2], _middle[3], _color, _alpha);
		
		var _vx1 = dcos(_left);
		var _vy1 = dsin(_left) * -1;
		
		var _vl1 = max(abs(_vx1), abs(_vy1));
		
		if (_vl1 < 1){
			_vx1 /= _vl1;
			_vy1 /= _vl1;
		}
		
		var _pos1 = [_middle[0] + _vx1 * (_pos[2] - _pos[0]) * 0.5, _middle[1] + _vy1 * (_pos[3] - _pos[1]) * 0.5];
		var _coord1 = [_middle[2] + _vx1 * (_coord[2] - _coord[0]) * 0.5, _middle[3] + _vy1 * (_coord[3] - _coord[1]) * 0.5];
		
		var _vx2 = dcos(_right);
		var _vy2 = dsin(_right) * -1;
		
		var _vl2 = max(abs(_vx2), abs(_vy2));
		
		if (_vl2 < 1){
			_vx2 /= _vl2;
			_vy2 /= _vl2;
		}
		
		var _pos2 = [_middle[0] + _vx2 * (_pos[2] - _pos[0]) * 0.5, _middle[1] + _vy2 * (_pos[3] - _pos[1]) * 0.5];
		var _coord2 = [_middle[2] + _vx2 * (_coord[2] - _coord[0]) * 0.5, _middle[3] + _vy2 * (_coord[3] - _coord[1]) * 0.5];
		
		draw_vertex_texture_color(_pos2[0], _pos2[1], _coord2[0], _coord2[1], _color, _alpha);
		
		var _start = round(_right / 90) * 90;
		var j = (_start + 360) % 360;
		j -= 45;
		
		repeat(4){
			if (angle_difference(j, _left) <= 0 && angle_difference(j, _right) >= 0){
				switch(j){
					case 45: draw_vertex_texture_color(_pos[2], _pos[1], _coord[2], _coord[1], _color, _alpha); break;
					case 135: draw_vertex_texture_color(_pos[0], _pos[1], _coord[0], _coord[1], _color, _alpha); break;
					case 225: draw_vertex_texture_color(_pos[0], _pos[3], _coord[0], _coord[3], _color, _alpha); break;
					case 315: draw_vertex_texture_color(_pos[2], _pos[3], _coord[2], _coord[3], _color, _alpha); break;
				}
			}
			
			j += 90;
			j = (j + 360) % 360;
		}
		
		draw_vertex_texture_color(_pos1[0], _pos1[1], _coord1[0], _coord1[1], _color, _alpha);
		
		draw_primitive_end();
		
		surface_reset_target();
		
		surface_free(_me);
		
		return _surface;
	}
}