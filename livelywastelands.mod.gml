#define init
	global.curchar = instance_number(CharSelect);

#define step
     // STOLE THIS FROM YOKIN, GO CHECK OUT HIS BALLMOM RACE TO GET A BETTER IDEA OF HOW THIS WORKS
	if(instance_exists(CharSelect)) {
    	var _race = [];
		 // Character Selection Sound:
		for(var i = 0; i < maxp; i++){
		    _race[i] = player_get_race(i);
		    if(fork()) {
		    	wait 1;
		    	
				var r = player_get_race(i);
				if(_race[i] != r) switch(r) {
				    case "yc": sound_play(sndCuzGreet); break;
				    case "gator": sound_play(sndBuffGatorHit); break;
				    case "thief": sound_play(sndBanditHit); break;
				}
				_race[i] = r;
				
				exit;
		    }
		}
		
		if(global.curchar != instance_number(CharSelect)) {
			//with(instances_matching_ne(instances_matching(CharSelect, "race", "yc"), "index", 7)) index = 0;      FIGURE OUT A BETTER SOLUTION LATER
		}
		
		with(instances_matching_ne(instances_matching(CharSelect, "race", "yc"), "index", 7)) {
		    global.curchar = instance_number(CharSelect);
		    
		    var n = instances_matching(CharSelect, "index", 7);
		    xstart = n[0].xstart;
		    ystart = n[0].ystart;
		    
		    for(i = 7; i < instance_number(CharSelect) - 1; i++) {
			    with(instances_matching(CharSelect, "index", i)) {
		    		var n = instances_matching(CharSelect, "index", index + 1);
		    		if(array_length(n) = 1) {
		    			if(race != "yc") {
		    				if(n[0].race = "yc") {
		    					xstart += 20;
		    				}
		    				
		    				else {
		    					xstart = n[0].xstart;
			    				ystart = n[0].ystart;
		    				}
		    			}
		    		}
		    		
		    		else {
		    			xstart += 20;
		    		}
			    }
		    }
		    
		    with(instances_matching_ge(CharSelect, "index", 7)) if(index < other.index) index++;
		    with(instances_matching_gt(CharSelect, "index", index)) index--;
		    
		    index = 7;
		    
		    exit;
		}
	}