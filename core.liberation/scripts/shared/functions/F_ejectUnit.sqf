params ["_unit", ["_slow", true]];
if (isNull _unit) exitWith {};
if ((vehicle _unit) iskindof "Steerable_Parachute_F") exitWith {};
if (isNull objectParent _unit) exitWith {};

if (!local _unit) exitWith {
	if (isServer) then {
		[_unit] remoteExec ["F_ejectUnit", owner _unit];
	} else {
		[_unit] remoteExec ["F_ejectUnit", 2];
	};
};

if (side group _unit == GRLIB_side_enemy) then { _unit allowDamage false };
unAssignVehicle _unit;
[_unit] orderGetIn false;

if (_slow) then { sleep 2 };
moveOut _unit;
sleep 1;
if (!alive _unit) exitWith {};

if (getPos _unit select 2 >= 50) then {
	_unit setPos (getPos _unit vectorAdd [([[-10,0,10], 3] call F_getRND), ([[-10,0,10], 3] call F_getRND), 0]);
	
	private _backpack = backpack _unit;
	if (_backpack != "B_Parachute") then {
		private _para = createVehicle ["Steerable_Parachute_F",(getPos _unit),[],0,'none'];
		_unit moveInDriver _para;
		sleep 2;
		if (!alive _unit) then { deleteVehicle _para };
	};

	[_unit] spawn {
		params ["_unit"];
		waituntil {sleep 2; !(alive _unit) || (isTouchingGround _unit)};
		if (!(alive _unit)) exitWith {};

		private _backpack = _unit getVariable ["GRLIB_para_backpack", ""];
		if (_backpack != "") then {
			_unit addBackpack _backpack;
			clearAllItemsFromBackpack _unit;
			{_unit addItemToBackpack _x} foreach (_unit getVariable ["GRLIB_para_backpack_contents", []]);
			_unit setVariable ["GRLIB_para_backpack", nil];
			_unit setVariable ["GRLIB_para_backpack_contents", nil];
		};
	};
	sleep 5;
};

if (side group _unit == GRLIB_side_enemy) then { sleep 3; _unit allowDamage true };
