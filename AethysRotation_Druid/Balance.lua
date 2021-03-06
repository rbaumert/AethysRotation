--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- AethysCore
local AC = AethysCore;
local Cache = AethysCache;
local Unit = AC.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = AC.Spell;
local Item = AC.Item;
-- AethysRotation
local AR = AethysRotation;
-- Lua


--- APL Local Vars
-- Spells
  if not Spell.Druid then Spell.Druid = {}; end
  Spell.Druid.Balance = {
    -- Racials
		ArcaneTorrent			= Spell(25046),
		Berserking				= Spell(26297),
		BloodFury				= Spell(20572),
		GiftoftheNaaru			= Spell(59547),
		Shadowmeld           	= Spell(58984),
	-- Forms
		MoonkinForm 			= Spell(24858),
		BearForm 				= Spell(5487),
		CatForm 				= Spell(768),
		TravelForm 				= Spell(783),
    -- Abilities
		CelestialAlignment 		= Spell(194223),
		LunarStrike 			= Spell(194153),
		SolarWrath 				= Spell(190984),
		MoonFire 				= Spell(8921),
		MoonFireDebuff 			= Spell(164812),
		SunFire 				= Spell(93402),
		SunFireDebuff 			= Spell(164815),
		Starsurge 				= Spell(78674),
		Starfall 				= Spell(191034),
    -- Talents
		ForceofNature  			= Spell(205636),
		WarriorofElune  		= Spell(202425),
		Starlord  				= Spell(202345),
		
		Renewal  				= Spell(108235),
		DisplacerBeast  		= Spell(102280),
		WildCharge  			= Spell(102401),
		
		FeralAffinity 			= Spell(202157),
		GuardianAffinity  		= Spell(197491),
		RestorationAffinity  	= Spell(197492),
		
		SoulOfTheForest  		= Spell(114107),
		IncarnationChosenOfElune= Spell(102560),
		StellarFlare  			= Spell(202347),
		
		ShootingStars  			= Spell(202342),
		AstralCommunion  		= Spell(202359),
		BlessingofTheAncients  	= Spell(202360),
		BlessingofElune  		= Spell(202737),
		BlessingofAnshe  		= Spell(202739),
		
		FuryofElune  			= Spell(202770),
		StellarDrift  			= Spell(202354),
		NaturesBalance  		= Spell(202430),
    -- Artifact
		NewMoon 				= Spell(202767),
		HalfMoon 				= Spell(202768),
		FullMoon 				= Spell(202771),
    -- Defensive
		Barskin 				= Spell(22812),
		FrenziedRegeneration 	= Spell(22842),
		Ironfur 				= Spell(192081),
		Regrowth 				= Spell(8936),
		Rejuvenation 			= Spell(774),
		Swiftmend 				= Spell(18562),
		HealingTouch 			= Spell(5185),
    -- Utility
		Innervate 				= Spell(29166),
		SolarBeam 				= Spell(78675),
    -- Legendaries
		OnethsIntuition			= Spell(209405),
    -- Misc
		SolarEmpowerment		= Spell(164545),
		LunarEmpowerment		= Spell(164547),
  };
  local S = Spell.Druid.Balance;
-- Items
  if not Item.Druid then Item.Druid = {}; end
  Item.Druid.Balance = {
    -- Legendaries
		EmeraldDreamcatcher		= Item(137062), --1
	
		--the_emerald_dreamcatcher
  };
  local I = Item.Druid.Balance;
-- Rotation Var
  local ShouldReturn; -- Used to get the return string
  local BestUnit, BestUnitTTD; -- Used for cycling
-- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Balance = AR.GUISettings.APL.Druid.Balance
  };

  
local function FuryOfElune ()
	-- actions.fury_of_elune=incarnation,if=astral_power>=95&cooldown.fury_of_elune.remains<=gcd
	-- actions.fury_of_elune+=/fury_of_elune,if=astral_power>=95
	-- actions.fury_of_elune+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=90))
	-- actions.fury_of_elune+=/half_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=80))
	-- actions.fury_of_elune+=/full_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=60))
	-- actions.fury_of_elune+=/astral_communion,if=buff.fury_of_elune_up.up&astral_power<=25
	-- actions.fury_of_elune+=/warrior_of_elune,if=buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.up)
	-- actions.fury_of_elune+=/lunar_strike,if=buff.warrior_of_elune.up&(astral_power<=90|(astral_power<=85&buff.incarnation.up))
	-- actions.fury_of_elune+=/new_moon,if=astral_power<=90&buff.fury_of_elune_up.up
	-- actions.fury_of_elune+=/half_moon,if=astral_power<=80&buff.fury_of_elune_up.up&astral_power>cast_time*12
	-- actions.fury_of_elune+=/full_moon,if=astral_power<=60&buff.fury_of_elune_up.up&astral_power>cast_time*12
	-- actions.fury_of_elune+=/moonfire,if=buff.fury_of_elune_up.down&remains<=6.6
	-- actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
	-- actions.fury_of_elune+=/stellar_flare,if=remains<7.2&active_enemies=1
	-- actions.fury_of_elune+=/starfall,if=(active_enemies>=2&talent.stellar_flare.enabled|active_enemies>=3)&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>10
	-- actions.fury_of_elune+=/starsurge,if=active_enemies<=2&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>7
	-- actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
	-- actions.fury_of_elune+=/solar_wrath,if=buff.solar_empowerment.up
	-- actions.fury_of_elune+=/lunar_strike,if=buff.lunar_empowerment.stack=3|(buff.lunar_empowerment.remains<5&buff.lunar_empowerment.up)|active_enemies>=2
	-- actions.fury_of_elune+=/solar_wrath
end 
  
local function Dreamcatcher ()
	-- actions.ed=astral_communion,if=astral_power.deficit>=75&buff.the_emerald_dreamcatcher.up
	-- actions.ed+=/incarnation,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up|buff.bloodlust.up
	-- actions.ed+=/celestial_alignment,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up
	-- actions.ed+=/starsurge,if=(buff.celestial_alignment.up&buff.celestial_alignment.remains<(10))|(buff.incarnation.up&buff.incarnation.remains<(3*execute_time)&astral_power>78)|(buff.incarnation.up&buff.incarnation.remains<(2*execute_time)&astral_power>52)|(buff.incarnation.up&buff.incarnation.remains<execute_time&astral_power>26)
	-- actions.ed+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
	-- actions.ed+=/moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
	-- actions.ed+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
	-- actions.ed+=/starfall,if=buff.oneths_overconfidence.up&buff.the_emerald_dreamcatcher.remains>execute_time&remains<2
	-- actions.ed+=/half_moon,if=astral_power<=80&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=6
	-- actions.ed+=/full_moon,if=astral_power<=60&buff.the_emerald_dreamcatcher.remains>execute_time
	-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.stack>1&buff.the_emerald_dreamcatcher.remains>2*execute_time&astral_power>=6&(dot.moonfire.remains>5|(dot.sunfire.remains<5.4&dot.moonfire.remains>6.6))&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
	-- actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=11&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=77.5)
	-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
	-- actions.ed+=/starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>90|((buff.celestial_alignment.up|buff.incarnation.up)&astral_power>=85)|(buff.the_emerald_dreamcatcher.up&astral_power>=77.5&(buff.celestial_alignment.up|buff.incarnation.up))
	-- actions.ed+=/starfall,if=buff.oneths_overconfidence.up&remains<2
	-- actions.ed+=/new_moon,if=astral_power<=90
	-- actions.ed+=/half_moon,if=astral_power<=80
	-- actions.ed+=/full_moon,if=astral_power<=60&((cooldown.incarnation.remains>65&cooldown.full_moon.charges>0)|(cooldown.incarnation.remains>50&cooldown.full_moon.charges>1)|(cooldown.incarnation.remains>25&cooldown.full_moon.charges>2))
	-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.up
	-- actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up
	-- actions.ed+=/solar_wrath
end  

local function CelestialAlignmentPhase ()
	-- actions.celestial_alignment_phase=starfall,if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
	-- actions.celestial_alignment_phase+=/starsurge,if=active_enemies<=2
	-- actions.celestial_alignment_phase+=/warrior_of_elune
	-- actions.celestial_alignment_phase+=/lunar_strike,if=buff.warrior_of_elune.up
	-- actions.celestial_alignment_phase+=/solar_wrath,if=buff.solar_empowerment.up
	-- actions.celestial_alignment_phase+=/lunar_strike,if=buff.lunar_empowerment.up
	-- actions.celestial_alignment_phase+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
	-- actions.celestial_alignment_phase+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
	-- actions.celestial_alignment_phase+=/solar_wrath
end

local function SingleTarget ()
	-- actions.single_target=new_moon,if=astral_power<=90
	-- actions.single_target+=/half_moon,if=astral_power<=80
	-- actions.single_target+=/full_moon,if=astral_power<=60
	-- actions.single_target+=/starfall,if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
	-- actions.single_target+=/starsurge,if=active_enemies<=2
	-- actions.single_target+=/warrior_of_elune
	-- actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
	-- actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
	-- actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
	-- actions.single_target+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
	-- actions.single_target+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
	-- actions.single_target+=/solar_wrath
end

local function CDs ()
	-- actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
	-- actions+=/blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
	-- actions+=/berserking,if=buff.celestial_alignment.up|buff.incarnation.up
	-- actions+=/arcane_torrent,if=buff.celestial_alignment.up|buff.incarnation.up
	-- actions+=/incarnation,if=astral_power>=40
	-- actions+=/celestial_alignment,if=astral_power>=40
	-- actions+=/astral_communion,if=astral_power.deficit>=75
	if S.AstralCommunion:IsAvailable() and Player:AstralPowerDeficit()>=75 then
		if AR.Cast(S.AstralCommunion, Settings.Balance.GCDasOffGCD.AstralCommunion) then return "Cast"; end
	end
end
  
-- APL Main
local function APL ()
	-- Unit Update
    AC.GetEnemies(40);
	
	--Buffs
	if not Player:Buff(S.MoonkinForm) then
		if AR.Cast(S.MoonkinForm, Settings.Balance.GCDasOffGCD.MoonkinForm) then return "Cast"; end
	end
	

	
	-- Out of Combat
    if not Player:AffectingCombat() then
		if S.BlessingofTheAncients:IsAvailable() and not Player:Buff(S.BlessingofElune) then
			if AR.Cast(S.BlessingofElune, Settings.Balance.OffGCDasOffGCD.BlessingofElune) then return "Cast"; end
		end
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ DBM Count
      -- Opener
		if AR.Commons.TargetIsValid() and Target:IsInRange(40) then
			if S.NewMoon:IsAvailable() and S.NewMoon:IsCastable() then
				if AR.Cast(S.NewMoon) then return "Cast"; end
				return
			end
			if S.NewMoon:IsAvailable() and S.HalfMoon:IsCastable() then
				if AR.Cast(S.HalfMoon) then return "Cast"; end
				return
			end
			if S.NewMoon:IsAvailable() and S.FullMoon:IsCastable() then
				if AR.Cast(S.FullMoon) then return "Cast"; end
				return
			end
			
			if AR.Cast(S.SolarWrath) then return "Cast"; end
		end
		
		return;
    end
	
	-- In Combat
    if AR.Commons.TargetIsValid() then
		if Target:IsInRange(40) then --in range
			--CD usage
			if AR.CDsON() then
				ShouldReturn = CDs();
				if ShouldReturn then return ShouldReturn; end
			end
		
			-- actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
			-- actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
			if (Cache.EnemiesCount[40]<=2 and S.BlessingofTheAncients:IsAvailable() and S.BlessingofTheAncients:IsCastable() and not Player:Buff(S.BlessingofElune) )
				or (Cache.EnemiesCount[40]>=3 and S.BlessingofTheAncients:IsAvailable() and S.BlessingofTheAncients:IsCastable() and not Player:Buff(S.BlessingofAnshe)) then
				if AR.Cast(S.BlessingofElune, Settings.Balance.OffGCDasOffGCD.BlessingofElune) then return "Cast"; end
			end
			
			-- actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
			if S.FuryofElune:IsAvailable() and S.FuryofElune:Cooldown()<Target:TimeToDie() then
				-- TODO : FoE
				--ShouldReturn = FuryOfElune();
				if ShouldReturn then return ShouldReturn; end
			end
			
			-- actions+=/call_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=2
			if (I.EmeraldDreamcatcher:IsEquipped(1) and 1 or 0) and Cache.EnemiesCount[40]<=2 then
				-- TODO : ED
				--ShouldReturn = Dreamcatcher ();
				if ShouldReturn then return ShouldReturn; end
			end
			
			-- actions+=/new_moon,if=(charges=2&recharge_time<5)|charges=3
			if S.NewMoon:IsCastable() and ((S.NewMoon:Charges()==2 and S.NewMoon:Recharge()<5 ) or S.NewMoon:Charges()==3) then
				if AR.Cast(S.NewMoon) then return "Cast"; end
			end
			
			-- actions+=/half_moon,if=(charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2)
			if S.HalfMoon:IsCastable() and ((S.NewMoon:Charges()==2 and S.NewMoon:Recharge()<5 ) or S.NewMoon:Charges()==3 or (S.NewMoon:Charges()==2 and Target:TimeToDie()<15)) then
				if AR.Cast(S.HalfMoon) then return "Cast"; end
			end
			
			-- actions+=/full_moon,if=(charges=2&recharge_time<5)|charges=3|target.time_to_die<15
			if S.FullMoon:IsCastable() and ((S.NewMoon:Charges()==2 and S.NewMoon:Recharge()<5 ) or S.NewMoon:Charges()==3 or (Target:TimeToDie()<15)) then
				if AR.Cast(S.FullMoon) then return "Cast"; end
			end
			
			-- actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
			--TODO : AOE
			if S.StellarFlare:IsAvailable() and Cache.EnemiesCount[40]<4 and Player:AstralPower()>=15 and Target:DebuffRemains(S.StellarFlare) < 7.2 then
				if AR.Cast(S.StellarFlare) then return "Cast"; end
			end
			
			-- actions+=/moonfire,cycle_targets=1,if=(talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled)
			--TODO : AOE
			if (S.NaturesBalance:IsAvailable() and Target:DebuffRemains(S.MoonFireDebuff) < 3) or (not S.NaturesBalance:IsAvailable() and Target:DebuffRemains(S.MoonFireDebuff) < 6.6) then
				if AR.Cast(S.MoonFire) then return "Cast"; end
			end
			
			-- actions+=/sunfire,if=(talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled)
			--TODO : AOE
			if (S.NaturesBalance:IsAvailable() and Target:DebuffRemains(S.SunFireDebuff) < 3) or (not S.NaturesBalance:IsAvailable() and Target:DebuffRemains(S.SunFireDebuff) < 5.4) then
				if AR.Cast(S.SunFire) then return "Cast"; end
			end
			
			-- actions+=/starfall,if=buff.oneths_overconfidence.up
			if Player:Buff(S.OnethsIntuition) then
				if AR.Cast(S.Starfall) then return "Cast"; end
			end
			
			-- actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
			if Player:BuffStack(S.SolarEmpowerment)==3 then
				if AR.Cast(S.SolarWrath) then return "Cast"; end
			end
			
			-- actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
			if Player:BuffStack(S.LunarEmpowerment)==3 then
				if AR.Cast(S.LunarStrike) then return "Cast"; end
			end
			
			-- actions+=/call_action_list,name=celestial_alignment_phase,if=buff.celestial_alignment.up|buff.incarnation.up
			if Player:Buff(S.CelestialAlignment) or Player:Buff(S.IncarnationChosenOfElune) then
				--ShouldReturn = CelestialAlignmentPhase();
				if ShouldReturn then return ShouldReturn; end
			end
			
			-- actions+=/call_action_list,name=single_target
			ShouldReturn = SingleTarget();
			if ShouldReturn then return ShouldReturn; end
		else
			
		end
	end
end
AR.SetAPL(102, APL);

-- # Executed before combat begins. Accepts non-harmful actions only.
-- actions.precombat=flask,type=flask_of_the_whispered_pact
-- actions.precombat+=/food,type=azshari_salad
-- actions.precombat+=/augmentation,type=defiled
-- actions.precombat+=/moonkin_form
-- actions.precombat+=/blessing_of_elune
-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/potion,name=deadly_grace
-- actions.precombat+=/new_moon

-- # Executed every time the actor is available.
-- actions=potion,name=deadly_grace,if=buff.celestial_alignment.up|buff.incarnation.up
-- actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
-- actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
-- actions+=/blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
-- actions+=/berserking,if=buff.celestial_alignment.up|buff.incarnation.up
-- actions+=/arcane_torrent,if=buff.celestial_alignment.up|buff.incarnation.up
-- actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
-- actions+=/call_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=2
-- actions+=/new_moon,if=(charges=2&recharge_time<5)|charges=3
-- actions+=/half_moon,if=(charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2)
-- actions+=/full_moon,if=(charges=2&recharge_time<5)|charges=3|target.time_to_die<15
-- actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
-- actions+=/moonfire,cycle_targets=1,if=(talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled)
-- actions+=/sunfire,if=(talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled)
-- actions+=/astral_communion,if=astral_power.deficit>=75
-- actions+=/incarnation,if=astral_power>=40
-- actions+=/celestial_alignment,if=astral_power>=40
-- actions+=/starfall,if=buff.oneths_overconfidence.up
-- actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
-- actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
-- actions+=/call_action_list,name=celestial_alignment_phase,if=buff.celestial_alignment.up|buff.incarnation.up
-- actions+=/call_action_list,name=single_target

-- actions.celestial_alignment_phase=starfall,if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
-- actions.celestial_alignment_phase+=/starsurge,if=active_enemies<=2
-- actions.celestial_alignment_phase+=/warrior_of_elune
-- actions.celestial_alignment_phase+=/lunar_strike,if=buff.warrior_of_elune.up
-- actions.celestial_alignment_phase+=/solar_wrath,if=buff.solar_empowerment.up
-- actions.celestial_alignment_phase+=/lunar_strike,if=buff.lunar_empowerment.up
-- actions.celestial_alignment_phase+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
-- actions.celestial_alignment_phase+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
-- actions.celestial_alignment_phase+=/solar_wrath

-- actions.ed=astral_communion,if=astral_power.deficit>=75&buff.the_emerald_dreamcatcher.up
-- actions.ed+=/incarnation,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up|buff.bloodlust.up
-- actions.ed+=/celestial_alignment,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up
-- actions.ed+=/starsurge,if=(buff.celestial_alignment.up&buff.celestial_alignment.remains<(10))|(buff.incarnation.up&buff.incarnation.remains<(3*execute_time)&astral_power>78)|(buff.incarnation.up&buff.incarnation.remains<(2*execute_time)&astral_power>52)|(buff.incarnation.up&buff.incarnation.remains<execute_time&astral_power>26)
-- actions.ed+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
-- actions.ed+=/moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
-- actions.ed+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
-- actions.ed+=/starfall,if=buff.oneths_overconfidence.up&buff.the_emerald_dreamcatcher.remains>execute_time&remains<2
-- actions.ed+=/half_moon,if=astral_power<=80&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=6
-- actions.ed+=/full_moon,if=astral_power<=60&buff.the_emerald_dreamcatcher.remains>execute_time
-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.stack>1&buff.the_emerald_dreamcatcher.remains>2*execute_time&astral_power>=6&(dot.moonfire.remains>5|(dot.sunfire.remains<5.4&dot.moonfire.remains>6.6))&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
-- actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=11&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=77.5)
-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
-- actions.ed+=/starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>90|((buff.celestial_alignment.up|buff.incarnation.up)&astral_power>=85)|(buff.the_emerald_dreamcatcher.up&astral_power>=77.5&(buff.celestial_alignment.up|buff.incarnation.up))
-- actions.ed+=/starfall,if=buff.oneths_overconfidence.up&remains<2
-- actions.ed+=/new_moon,if=astral_power<=90
-- actions.ed+=/half_moon,if=astral_power<=80
-- actions.ed+=/full_moon,if=astral_power<=60&((cooldown.incarnation.remains>65&cooldown.full_moon.charges>0)|(cooldown.incarnation.remains>50&cooldown.full_moon.charges>1)|(cooldown.incarnation.remains>25&cooldown.full_moon.charges>2))
-- actions.ed+=/solar_wrath,if=buff.solar_empowerment.up
-- actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up
-- actions.ed+=/solar_wrath

-- actions.fury_of_elune=incarnation,if=astral_power>=95&cooldown.fury_of_elune.remains<=gcd
-- actions.fury_of_elune+=/fury_of_elune,if=astral_power>=95
-- actions.fury_of_elune+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=90))
-- actions.fury_of_elune+=/half_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=80))
-- actions.fury_of_elune+=/full_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=60))
-- actions.fury_of_elune+=/astral_communion,if=buff.fury_of_elune_up.up&astral_power<=25
-- actions.fury_of_elune+=/warrior_of_elune,if=buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.up)
-- actions.fury_of_elune+=/lunar_strike,if=buff.warrior_of_elune.up&(astral_power<=90|(astral_power<=85&buff.incarnation.up))
-- actions.fury_of_elune+=/new_moon,if=astral_power<=90&buff.fury_of_elune_up.up
-- actions.fury_of_elune+=/half_moon,if=astral_power<=80&buff.fury_of_elune_up.up&astral_power>cast_time*12
-- actions.fury_of_elune+=/full_moon,if=astral_power<=60&buff.fury_of_elune_up.up&astral_power>cast_time*12
-- actions.fury_of_elune+=/moonfire,if=buff.fury_of_elune_up.down&remains<=6.6
-- actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
-- actions.fury_of_elune+=/stellar_flare,if=remains<7.2&active_enemies=1
-- actions.fury_of_elune+=/starfall,if=(active_enemies>=2&talent.stellar_flare.enabled|active_enemies>=3)&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>10
-- actions.fury_of_elune+=/starsurge,if=active_enemies<=2&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>7
-- actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
-- actions.fury_of_elune+=/solar_wrath,if=buff.solar_empowerment.up
-- actions.fury_of_elune+=/lunar_strike,if=buff.lunar_empowerment.stack=3|(buff.lunar_empowerment.remains<5&buff.lunar_empowerment.up)|active_enemies>=2
-- actions.fury_of_elune+=/solar_wrath

-- actions.single_target=new_moon,if=astral_power<=90
-- actions.single_target+=/half_moon,if=astral_power<=80
-- actions.single_target+=/full_moon,if=astral_power<=60
-- actions.single_target+=/starfall,if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
-- actions.single_target+=/starsurge,if=active_enemies<=2
-- actions.single_target+=/warrior_of_elune
-- actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
-- actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
-- actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
-- actions.single_target+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
-- actions.single_target+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
-- actions.single_target+=/solar_wrath
