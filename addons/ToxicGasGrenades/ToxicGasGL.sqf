//	@file Name: ToxicGasGL.sqf
//  @file Author: Mokey
//	@file Description: Toxic Gas addon for A3W
//	@web: http://www.fractured-gaming.com
//	@Special Thanks to Pitoucc, CREAMPIE, and Izzer

#include "definitions.sqf"

setNoGasStatus = {
  "dynamicBlur" ppEffectEnable true;                  // enables ppeffect
  "dynamicBlur" ppEffectAdjust [0];                   // enables normal vision
  "dynamicBlur" ppEffectCommit 10;                    // time it takes to go back to normal vision
  resetCamShake;                                      // resets the shake
  20 fadeSound 1;                                     // fades the sound back to normal
};

setGasStatus = {                                      // Settings for player with NO PROTECTION from gas
  "dynamicBlur" ppEffectEnable true;              	  // enables ppeffect
  "dynamicBlur" ppEffectAdjust [12];             	  	// intensity of blur
  "dynamicBlur" ppEffectCommit 5;               	    // time till vision is fully blurred
};

gasDamage = {
	player setDamage (damage player + 0.15);     	     	//damage per tick
	sleep 3;                                 		        // Timer damage is assigned "seconds"
  enableCamShake true;                           	    // enables camera shake
  addCamShake [10, 45, 10];                          	// sets shakevalues
//	player setFatigue 1;                               // sets the fatigue to 100%
  5 fadeSound 0.1;                                    // fades the sound to 10% in 5 seconds
};

While{true} do{

	call setNoGasStatus;

	waituntil{
        _smokeShell = nearestObject [getPosATL player, "G_40mm_SmokeYellow"];
	    _curPlayerInvulnState = player getVariable ["isAdminInvulnerable", false];
		_smokeShell distance player < 7
		&&
	    velocity _smokeShell isEqualTo [ 0, 0, 0 ]
	    &&
	    !_curPlayerInvulnState
	};

  if ((headgear player in _gasMaskFull) || ((typeOf vehicle player) in _exemptVehicles)) then
  {
	  call setNoGasStatus;
	}
    else
    {
      if (headgear player in _gasMaskEyes) then
      {
        call gasDamage;
      }
      else
      {
        if (headgear player in _gasMaskMouth) then
        {
          call setGasStatus;
        }
      }
    }
    else
	{
		call setGasStatus;
		call gasDamage;
	};
};
