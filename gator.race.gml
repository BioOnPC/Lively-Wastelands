#define init
global.spr_charselect  = sprite_add("sprites/races/gator/charselect.png", 1, 0, 0);
global.spr_portrait[0] = sprite_add("sprites/races/gator/portrait.png", 1, 20, 237);
global.spr_portrait[1] = sprite_add("sprites/races/gator/portrait.png", 1, 20, 237);
global.spr_mapicon[0]  = sprite_add("sprites/races/gator/mapicon1.png", 1, 10, 10);
global.spr_mapicon[1]  = sprite_add("sprites/races/gator/mapicon2.png", 1, 10, 10);
global.spr_skinicon[0] = sprite_add("sprites/races/gator/skinicon1.png", 1, 16, 16);
global.spr_skinicon[1] = sprite_add("sprites/races/gator/skinicon2.png", 1, 16, 16);

global.spr_ultport[1] = sprite_add("sprites/races/gator/ultra1.png", 1, 12, 16);
global.spr_ultport[2] = sprite_add("sprites/races/gator/ultra2.png", 1, 12, 16);
global.spr_ulticon[1] = sprite_add("sprites/races/gator/ultraicon1.png", 1, 9, 9);
global.spr_ulticon[2] = sprite_add("sprites/races/gator/ultraicon2.png", 1, 9, 9);

global.spr_idle[0]  = sprite_add("sprites/races/gator/gatoridle.png", 8, 12, 12);
global.spr_walk[0]  = sprite_add("sprites/races/gator/gatorwalk.png", 6, 12, 12);
global.spr_hurt[0]  = sprite_add("sprites/races/gator/gatorhurt.png", 3, 12, 12);
global.spr_dead[0]  = sprite_add("sprites/races/gator/gatordead.png", 6, 12, 12);
global.spr_sit[0]   = sprite_add("sprites/races/gator/gatorsit.png", 1, 12, 12);
global.spr_gosit[0] = sprite_add("sprites/races/gator/gatorgosit.png", 3, 12, 12);

global.spr_idle[1]  = sprite_add("sprites/races/gator/bgatoridle.png", 8, 12, 12);
global.spr_walk[1]  = sprite_add("sprites/races/gator/bgatorwalk.png", 6, 12, 12);
global.spr_hurt[1]  = sprite_add("sprites/races/gator/bgatorhurt.png", 3, 12, 12);
global.spr_dead[1]  = sprite_add("sprites/races/gator/bgatordead.png", 6, 12, 12);
global.spr_sit[1]   = sprite_add("sprites/races/gator/bgatorsit.png", 1, 12, 12);
global.spr_gosit[1] = sprite_add("sprites/races/gator/bgatorgosit.png", 3, 12, 12);

#define race_name
return "GATOR";

#define race_text
return "@rTOUGHER@w#INACCURATE, SLOWER RELOAD#@rRUSHED RELOAD";

#define race_tb_text
return "@rRUSHED OFFHAND RELOAD";

#define race_skins
return 2;

#define race_portrait
return global.spr_portrait[argument1];
	
#define race_menu_button
sprite_index = global.spr_charselect;

#define race_skin_button
sprite_index = global.spr_skinicon[argument0];

#define race_mapicon
return global.spr_mapicon[argument1];

#define race_swep
return wep_shotgun;

#define race_ultra_name
switch(argument0)
{
	case 1: return "DISCHARGE"; break;
	case 2: return "IMPENETRABLE SCALES"; break;
}

#define race_ultra_text
switch(argument0)
{
	case 1: return "FIRE @yALL REMAINING AMMO@s IN#YOUR WEAPON ON ACTIVE USE";
	case 2: return "@rEVEN TOUGHER@s";
}

#define race_ttip
if(GameCont.level = 10 and random(5) < 1)
{
	return ["THE SMELL OF NAPALM", "TAKE NO PRISONERS", "ROUGH AND TUMBLE", "SCALY, SCALY SCALES", "YOU'LL FIGURE IT OUT", "ONE DAY"];
}
else
{
	return ["THIS ISN'T GOOD FOR US", "HEAD HONCHO", "SMUGGLING IS A FINE ART", "DRUGS AREN'T COOL", "NICE SCALES", "FALLOUT", "THEY MISS YOU"];
}

#define race_ultra_button
sprite_index = global.spr_ultport[argument0];
	
#define race_ultra_icon
return global.spr_ulticon[argument0];

#define race_soundbank
return "steroids";

#define create
spr_idle = global.spr_idle[bskin];
spr_walk = global.spr_walk[bskin];
spr_hurt = global.spr_hurt[bskin];
spr_dead = global.spr_dead[bskin];
spr_sit1 = global.spr_sit[bskin];
spr_sit2 = global.spr_gosit[bskin];

snd_hurt = sndRhinoFreakHurt;
snd_dead = sndRhinoFreakDead;
snd_wrld = sndRhinoFreakMelee;
snd_lowa = sndRatKingHit;
snd_lowh = sndRatKingHit;

accuracy += 0.2; // inaccurate
reloadspeed -= 0.2; // slower reload
discharge = 0; // for making sure you cant go into the negatives

#define step
{ // PASSIVE //
    // tougher
    with(instances_matching_ne(enemy, "meleedamage", 0)) { // some enemies melee damage changes (e.g. snowbot) so i gotta make a weird thing around it
        if("cdmg" not in self or cdmg != meleedamage) {
            var t;
            t = 1 + (ultra_get(mod_current, 2)); // makes shit easier to calculate for ultra B
            
            if(meleedamage - t > 0) { // makin sure you dont get 0 damage
                meleedamage -= t;
            } else if(meleedamage != 0){ // bandits were hurting me while debugging
                meleedamage = 1;
            }
            
            cdmg = meleedamage;
        }
    }
    
    with(instances_matching(projectile, "gatordmg", null)) { // making sure it only does this once, since gatordmg isnt adjusted again
        gatordmg = 1;
        
        if(("creator" in self and instance_exists(creator) and object_get_parent(creator) = enemy) or team != other.team) { // making sure things like pvp work with it
            var t;
            t = 1 + (ultra_get(mod_current, 2)); // makes shit easier to calculate for ultra B
            
            if(damage - t > 0) { // makin sure you dont get 0 damage
                damage -= 1;
            } else {
                damage = 1;
            }
        }
    }
}

{ // ACTIVE //
    if(usespec or (canspec and button_pressed(index, "spec"))) { // usin the active
        var typ = weapon_get_type(wep);
        
        if(my_health > 1 and (reload > 0 or (breload > 0 and skill_get(mut_throne_butt)))) {
            projectile_hit_raw(self, 1, snd_hurt); // hurt the player
            
            if(ultra_get(mod_current, 1) and discharge = 0) { // ultra A
                if(typ != 0 and ammo[typ] > weapon_get_cost(wep)) { // makin sure you cant do this with too little ammo or with melee (esword is funny to me so im leaving it)
                    var r;
                    r = floor(ammo[typ]/weapon_get_cost(wep)); // gettin the amount the player can fire based on the current ammo
                    canswap = 0;
                    if(fork()) {
                        var f = floor(r/4) // make sure the bursts have the amount of projectiles they should
                        var o = 0; // to make sure theres only 4 bursts
                        
                        if(f > 0) { // there was a bug that put you at negative ammo
                            do { // repeatedly fire
                                discharge = 1;
                                repeat(f) { // fire the burst
                                    player_fire(aimDirection);
                                }
                                o++
                                wait 2;
                                
                            } until (o = 4);
                        }
                        
                        r = floor(ammo[typ]/weapon_get_cost(wep));
                        if(r > 0)
                        repeat(r) player_fire(gunangle); // make sure the weapon uses up the last of its ammo
                        reload = 0; // makes sure your gun still reloads itself
                        discharge = 0;
                        canswap = 1;
                        exit;
                    }
                } else {
                    wkick += 4;
                    sound_play(sndClick);
                }
            }
            
            reload = 0;
            sound_play_pitch(sndSwapShotgun, 0.5 + random(0.2));
            
            if(skill_get(mut_throne_butt)) { // throne butt
                breload = 0;
                sound_play_pitch(sndSwapExplosive, 0.5 + random(0.2));
            }
        }
    }
}