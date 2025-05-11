--------------------------------------------------------------------------------------------------
--  
--  $Workfile: ArmorWantedGUI.lua$
--
--  Project:      Armor Wanted
--
--                           Copyright (c) 2025
--                              James A Wright
--                            All Rights Reserved
--
--  File Description:
--      This file contains all of the functions needed do GUI stuff for the Armor Wanted mod.
--  
--------------------------------------------------------------------------------------------------

MAIN_SELECTION      = "main";
CLASS_SELECTION     = "class";
EXPAND_SELECTION    = "expand";
FILTER_PVP          = "PVP";
FILTER_PVE          = "PVE";
FILTER_100          = "Full";
FILTER_90           = "Almost";
FILTER_0            = "None";
FILTER_OTHER        = "Other";
FILTER_STANDARD     = "Standard";
FILTER_ATTIRE       = "Attire";
FILTER_GROUPS       = "Groups";
SEARCH_TEXT		    = "SearchText";

FILTER_PVE_ID = 1;
FILTER_PVP_ID = 2;
FILTER_100_ID = 3;
FILTER_90_ID = 4;
FILTER_OTHER_ID = 5;
FILTER_NONE_ID  = 6;
FILTER_STANDARD_ID = 7;
FILTER_ATTIRE_ID = 8;
FILTER_GROUPS_ID = 9;

FilterNames = {FILTER_PVE,  FILTER_PVP, FILTER_100, FILTER_90, FILTER_OTHER, FILTER_0, FILTER_STANDARD, FILTER_ATTIRE, FILTER_GROUPS}

Armor_Wanted_DB  = {};
BaseSets = {};

PVP_Values = { "Gladiator", "Challenger", "Duelist", "Rival", "Elite", "Honor", "PVP Rare", "Combatant I", "Warfront", "Aspirant" };

local ROW_HEIGHT = 20 -- Matches Armor_Wanted_Line_Template height
local DISPLAYING_NOTHING = 0;
local DISPLAYING_CLASS = 1;
local DISPLAYING_EXPAND = 2;

local MAX_LINES_FOR_MAIN = 20
local PIXELS_PER_LINE = 20
STRING_MAIN_LINE           = "ArmorWantedScrollLine";

local whatAreWeDisplaying = DISPLAYING_NOTHING;

-- Declare the global variable at the top level of the file
ArmorWanted_SecondDropdownFrame = nil;
ArmorWanted_FirstDropdownFrame = nil;
ArmorWanted_FilterDropdown = nil;

EngExpandToNumberMask = {
	["Classic"] = 0,
	["The Burning Crusade"] = 1,
	["Wrath of the Lich King"] = 2,
	["Cataclysm"] = 3,
	["Mists of Pandaria"] = 4,
	["Warlords of Draenor"] = 5,
	["Legion"] = 6,
	["Battle for Azeroth"] = 7,
	["Shadowlands"] = 8,
	["Dragonflight"] = 9,
	["The War Within"] = 10
}

EngClassToNameMask = {
	["Warrior"] =      1,
	["Paladin"] =      2,
	["Hunter"] =       4,
	["Rogue"] =        8,
	["Priest"] =       16,
	["Death Knight"] = 32,
	["Shaman"] =       64,
	["Mage"] =         128,
	["Warlock"] =      256,
	["Monk"] =         512,
	["Druid"] =        1024,
	["Demon Hunter"] = 2048,
	["Evoker"] =       4096,
  }

MaskToEngClass = {
	[1] = "Warrior",
	[2] = "Paladin",
	[4] = "Hunter",
	[8] = "Rogue",
	[16] = "Priest",
	[32] = "Death Knight",
	[64] = "Shaman",
	[128] = "Mage",
	[256] = "Warlock",
	[512] = "Monk",
	[1024] = "Druid",
	[2048] = "Demon Hunter",
	[4096] = "Evoker",
}

  InvTypeToCol = {
    ["INVTYPE_HEAD"] = "Head",
    ["INVTYPE_SHOULDER"] = "Shoulder",
    ["INVTYPE_CHEST"] = "Chest",
    ["INVTYPE_ROBE"] = "Chest",
    ["INVTYPE_WRIST"] = "Wrist",
    ["INVTYPE_HAND"] = "Hand",
    ["INVTYPE_WAIST"] = "Waist",
    ["INVTYPE_LEGS"] = "Legs",
    ["INVTYPE_FEET"] = "Feet",
    ["INVTYPE_CLOAK"] = "Back",
    ["INVTYPE_TABARD"] = "Tabard"
}

ClassGot = {
	[-1] = " ",
	[0] = "N",
	[1] = "Y"
}


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  Add to the combo boxes
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_FirstSelectionDropdown_Initialize
--
--  Desc:  Init the main Class/Expansion dropdown menu items.
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_FirstSelectionDropdown_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo();

	-- Example: Populate with WoW classes
	local items = {"Expansion", "Class"};
	for _, ItemName in ipairs(items) do
		info.text = ItemName;
		info.value = ItemName;
		info.func = Armor_Wanted_FirstSelectionDropdown_OnClick;
		UIDropDownMenu_AddButton(info, level);
	end
end

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_SecondSelectionClassDropdown_Initialize
--
--  Desc:  Fill the second dropdown with the class names.
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_SecondSelectionClassDropdown_Initialize()

	ArmorWanted_SecondDropdownFrame:SetupMenu(function(dropdown, rootDescription)
		local classes = {"Warrior",
			"Paladin",
			"Hunter",
			"Rogue",
			"Priest",
			"Death Knight",
			"Shaman",
			"Mage",
			"Warlock",
			"Monk",
			"Druid",
			"Demon Hunter",
			"Evoker"};

			for _, name in ipairs(classes) do
				rootDescription:CreateButton(name, Armor_Wanted_SecondSelectionClassDropdown_OnClick, name);
			end
	end);
	if(nil ~= Armor_Wanted_DB[CLASS_SELECTION]) then
		ArmorWanted_SecondDropdownFrame:SetDefaultText(Armor_Wanted_DB[CLASS_SELECTION]);
	end
end

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_SecondSelectionExpansionDropdown_Initialize
--
--  Desc:  Fill the second dropdown with the Expansion names.
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_SecondSelectionExpansionDropdown_Initialize()
	ArmorWanted_SecondDropdownFrame:SetupMenu(function(dropdown, rootDescription)
		local expansions = {  "Classic", -- Often referred to as Vanilla or the base game
			"The Burning Crusade",
			"Wrath of the Lich King",
			"Cataclysm",
			"Mists of Pandaria",
			"Warlords of Draenor",
			"Legion",
			"Battle for Azeroth",
			"Shadowlands",
			"Dragonflight",
			"The War Within" };

			for _, name in ipairs(expansions) do
				rootDescription:CreateButton(name, Armor_Wanted_SecondSelectionExpansionDropdown_OnClick, name);
			end
	end);

	if(nil ~= Armor_Wanted_DB[EXPAND_SELECTION]) then
		ArmorWanted_SecondDropdownFrame:SetDefaultText(Armor_Wanted_DB[EXPAND_SELECTION]);
	end
end

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  The Filtering functions
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: ChangeAWFilter
--
--  Desc:  Do the main work to display the data in the list.
--
--------------------------------------------------------------------------------------------------
function ChangeAWFilter()

	if(nil == Armor_Wanted_DB[MAIN_SELECTION]) then
		return;
	end

	ArmorWanted_FirstDropdownFrame:SetDefaultText(Armor_Wanted_DB[MAIN_SELECTION]);

	if Armor_Wanted_DB[MAIN_SELECTION] == "Class" then
		ArmorWanted_SecondSelectionClassDropdown_Initialize();

		if(nil == Armor_Wanted_DB[CLASS_SELECTION]) then
			return
		end

		BuildClassList(EngClassToNameMask[Armor_Wanted_DB[CLASS_SELECTION]]);
		FilterNumber();
		FilterAttire();
		FilterPVPPVE();
		FilterSearch();
		ArmorWanted_ScrollUpdate();
		ArmorWanted_SecondDropdownFrame:SetDefaultText(Armor_Wanted_DB[CLASS_SELECTION]);
	end

	if Armor_Wanted_DB[MAIN_SELECTION] == "Expansion" then
		ArmorWanted_SecondSelectionExpansionDropdown_Initialize();	

		if(nil == Armor_Wanted_DB[EXPAND_SELECTION]) then
			return
		end

		BuildExpansionList(EngExpandToNumberMask[Armor_Wanted_DB[EXPAND_SELECTION]]);
		FilterNumber();
		FilterAttire();
		FilterPVPPVE();
		FilterSearch();
		ArmorWanted_ScrollUpdate();
		ArmorWanted_SecondDropdownFrame:SetDefaultText(Armor_Wanted_DB[EXPAND_SELECTION]);
	end
	InitFilterDropdown();
end

-------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  Change the combo boxes / checkboxes
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: Armor_Wanted_FirstSelectionDropdown_OnClick
--
--  Desc:  User clicks on something in the first dropdown menu.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_FirstSelectionDropdown_OnClick(thing)
	ArmorWanted_FirstDropdownFrame:SetDefaultText(thing);
	Armor_Wanted_DB[MAIN_SELECTION]=thing;
	ChangeAWFilter()
end

--------------------------------------------------------------------------------------------------
--  Function: Armor_Wanted_SecondSelectionClassDropdown_OnClick
--
--  Desc:  User clicks on something in the second dropdown menu.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_SecondSelectionClassDropdown_OnClick(thing)
	ArmorWanted_SecondDropdownFrame:SetDefaultText(thing);
	Armor_Wanted_DB[CLASS_SELECTION] = thing;
	ChangeAWFilter();
end

--------------------------------------------------------------------------------------------------
--  Function: Armor_Wanted_SecondSelectionExpansionDropdown_OnClick
--
--  Desc:  User clicks on something in the second dropdown menu.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_SecondSelectionExpansionDropdown_OnClick(thing)
	ArmorWanted_SecondDropdownFrame:SetDefaultText(thing);
	Armor_Wanted_DB[EXPAND_SELECTION] = thing;
	ChangeAWFilter();
end

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_Search
--
--  Desc:  Set the seatch item and search  
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_Search(text)
	Armor_Wanted_DB[SEARCH_TEXT] = text;
	ChangeAWFilter();
end

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  Build the lists
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: compareListOfSets
--
--  Desc:  Sort the list by the Blizzard order
--
--------------------------------------------------------------------------------------------------
function compareListOfSets(a,b)
	return a["uiOrder"] < b["uiOrder"]
end

--------------------------------------------------------------------------------------------------
--  Function: compareExpandListOfSets
--
--  Desc:  Sort the list by the name of the insance and then the description
--
--------------------------------------------------------------------------------------------------
function compareExpandListOfSets(a,b)
	if(nil == a["label"]) then
		return false;
	end
	if(nil == b["label"]) then
		return true;
	end

	if(a["label"] == b["label"]) then
		return a["description"] < b["description"]
	else
		return a["label"] < b["label"]
	end
end


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  Build the lists
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: BuildClassList
--
--  Desc:  Build the list for a class selection
--
--------------------------------------------------------------------------------------------------
function BuildClassList(classMask)
	CurrentListOfSets = {};
	
	for _,data in ipairs(_G['BaseSets']) do
		local curRow  = {};
		if (nil ~= data.description) then
			local shouldInclude = false;

			if(0 == data.classMask) then
			 	shouldInclude = true;
			else
				if(bit.band(data.classMask, classMask) > 0) then
					shouldInclude = true;
				end
			end
			
			if(true == shouldInclude) then

				if(nil == data.label) then
					curRow["label"] = data.name;
				else
					curRow["label"] = data.label .. " (" .. data.name .. ")";
				end

				curRow["classMask"] = data.classMask;
				curRow["description"] = data.description;
				curRow["uiOrder"] = data.uiOrder;

				local setRow = GetSetStatus(data.setID);

				for key, value in pairs(setRow) do
					curRow[key] = value;
				end            

				table.insert(CurrentListOfSets, curRow);
			end
		end
	end	

	table.sort(CurrentListOfSets, compareListOfSets)
end

--------------------------------------------------------------------------------------------------
--  Function: BuildExpansionList
--
--  Desc:  Build the list for a expansion selection
--
--------------------------------------------------------------------------------------------------
function BuildExpansionList(expansionID)
	CurrentListOfSets = {};
	TempListOfSets = {};

	for _,data in ipairs(_G['BaseSets']) do
		local curRow  = {};
		if (data.expansionID == expansionID) and (nil ~= data.description)  then
			local theClassMask = data.classMask;

			curRow["label"] = data.label;
			curRow["description"] = data.description;
			curRow["uiOrder"] = data.uiOrder;
			curRow["classMask"] = theClassMask;

			local setRow = GetSetStatus(data.setID);

            for key, value in pairs(setRow) do
                curRow[key] = value;
            end            

			table.insert(TempListOfSets, curRow);
		end
	end	

	table.sort(TempListOfSets, compareExpandListOfSets)

	label = "";
	description = "";
	first = true;
	curRow  = {};

	for _,data in ipairs(TempListOfSets) do
		if(label ~= data.label) or (description ~= data.description) then
			if(true ~= first) then
				table.insert(CurrentListOfSets, curRow);
			end
			curRow  = {};
			label = data.label;
			description = data.description;
			curRow["label"] = data.label;
			curRow["description"] = data.description;
			curRow["uiOrder"] = data.uiOrder;
			curRow["classMask"] = data.classMask;
			curRow["total"] = 0;
			curRow["collected"] = 0;

        	for _, value in pairs(MaskToEngClass) do
				curRow[value] = {};
				curRow[value]["total"] = -1;
				curRow[value]["collected"] = -1;
        	end            
			first = false;
		end

		curRow["class"] = data.classMask;

		for key, value in pairs(MaskToEngClass) do
			local shouldInclude = false;
			if(0 == data.classMask) then
				shouldInclude = true;
			else
				if(bit.band(data.classMask, key) > 0) then
					shouldInclude = true;
				end	
			end

			if(true == shouldInclude) then
				curRow["total"] = curRow["total"] + data.total;
				curRow["collected"] = curRow["collected"] + data.collected;
	
				curRow[value]["total"] = data.total;
				curRow[value]["collected"] = data.collected;
			end
		end            
	end
	table.insert(CurrentListOfSets, curRow);
end

--------------------------------------------------------------------------------------------------
--  Function: FilterNumber
--
--  Desc:  Include items on how many have been collected
--
--------------------------------------------------------------------------------------------------
function FilterNumber()
	NewListOfSets = {};

	for _, value in ipairs(CurrentListOfSets) do
		local inserted = false;
		if(value.collected == value.total) then
			inserted = true;
			if(true == Armor_Wanted_DB[FILTER_100]) then
				table.insert(NewListOfSets, value);
			end
		else
			if(Armor_Wanted_DB[MAIN_SELECTION] == "Class") then
				if((value.collected / value.total) > .8) then
					inserted = true;
					if(true == Armor_Wanted_DB[FILTER_90]) then
						table.insert(NewListOfSets, value);
					end
				end
			else
				if((value.collected / value.total) > .9) then
					inserted = true;
					if(true == Armor_Wanted_DB[FILTER_90]) then
						table.insert(NewListOfSets, value);
					end
				end
			end	
		end

		if (false == inserted) then
			if(value.collected == 0) then
				if(true == Armor_Wanted_DB[FILTER_0]) then
					table.insert(NewListOfSets, value);
				end
			else
				if(true == Armor_Wanted_DB[FILTER_OTHER]) then
					table.insert(NewListOfSets, value);
				end
			end
		end
	end

	CurrentListOfSets = NewListOfSets
end

--------------------------------------------------------------------------------------------------
--  Function: FilterAttire
--
--  Desc:  Include items on what type of set it is
--
--------------------------------------------------------------------------------------------------
function FilterAttire()
	NewListOfSets = {};

	for _, value in ipairs(CurrentListOfSets) do
		if (value.classMask == 0) then
			if(true == Armor_Wanted_DB[FILTER_ATTIRE]) then
				table.insert(NewListOfSets, value);
			end
		else
			found = false;
			for key, value2 in pairs(EngClassToNameMask) do
				-- If it's a simple class then it;s standard
				if(value.classMask == value2) then
					found = true;
					if(true == Armor_Wanted_DB[FILTER_STANDARD]) then
						table.insert(NewListOfSets, value);
					end
					break;
				end
			end

			if(false == found) then
				if(true == Armor_Wanted_DB[FILTER_GROUPS]) then
					table.insert(NewListOfSets, value);
				end
			end
		end
	end

	CurrentListOfSets = NewListOfSets
end

--------------------------------------------------------------------------------------------------
--  Function: isPVP
--
--  Desc:  Test what the description is to see if it is a PVP item
--
--------------------------------------------------------------------------------------------------
function isPVP(data)
	for _, value in ipairs(PVP_Values) do
		if(value == data.description) then
			return true;
		end
	end

	return false;
end

--------------------------------------------------------------------------------------------------
--  Function: FilterPVPPVE
--
--  Desc:  Only include things in in the PVP/PVE filter
--
--------------------------------------------------------------------------------------------------
function FilterPVPPVE()
	NewListOfSets = {};

	for _, value in ipairs(CurrentListOfSets) do
		if(false == isPVP(value)) then
			if(true == Armor_Wanted_DB[FILTER_PVE]) then
				table.insert(NewListOfSets, value);
			end
		else
			if(true == Armor_Wanted_DB[FILTER_PVP]) then
				table.insert(NewListOfSets, value);
			end
		end
	end

	CurrentListOfSets = NewListOfSets
end

--------------------------------------------------------------------------------------------------
--  Function: FilterSearch
--
--  Desc:  Only include things in the search
--
--------------------------------------------------------------------------------------------------
function FilterSearch()

	if("" ~= Armor_Wanted_DB[SEARCH_TEXT]) then
		searchForText = string.upper(Armor_Wanted_DB[SEARCH_TEXT]);
		NewListOfSets = {};
		for _, value in ipairs(CurrentListOfSets) do
			searchingText = string.upper(value.label);

			if(string.find(searchingText, searchForText, 1, true)) then
				table.insert(NewListOfSets, value);
			end
		end
		CurrentListOfSets = NewListOfSets
	end
end

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--  
--  Display
--  
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_ScrollUpdate
--
--  Desc:  Change the second dropdown menu to the class or expansion names.
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_ScrollUpdate()
	if(Armor_Wanted_DB[MAIN_SELECTION] == "Class") then
		ArmorWanted_Class_ScrollUpdate();
	end
	if(Armor_Wanted_DB[MAIN_SELECTION] == "Expansion") then
		ArmorWanted_Expand_ScrollUpdate();
	end
end

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_Class_ScrollUpdate
--
--  Desc:  Handle scrolling for the class selection
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_Class_ScrollUpdate()
	local total_lines;

	FauxScrollFrame_Update(ArmorWanted_ScrollFrame, getn(CurrentListOfSets), MAX_LINES_FOR_MAIN, PIXELS_PER_LINE);
  
	  -- Hide the party lines in case we have less than 12
	for i = 1, MAX_LINES_FOR_MAIN, 1 do
	  local button = getglobal("ArmorWantedScrollLine" .. i);
	  button:Hide();
	end
  
	  -- Get the number of lines, if less than 12 set it to that number if not then display all 12 lines
	if(getn(CurrentListOfSets)<MAX_LINES_FOR_MAIN) then
	  total_lines = getn(CurrentListOfSets);
	else
	  total_lines = MAX_LINES_FOR_MAIN;
	end
  
	getglobal("ArmorWanted_TitleBarCol1"):SetText("Name");
	getglobal("ArmorWanted_TitleBarCol1"):SetWidth(300);

	getglobal("ArmorWanted_TitleBarCol2"):SetText("Level");
	getglobal("ArmorWanted_TitleBarCol3"):SetText("HD");
	getglobal("ArmorWanted_TitleBar" .. "Col1"):SetWidth(35);
	getglobal("ArmorWanted_TitleBarCol4"):SetText("SH");
	getglobal("ArmorWanted_TitleBarCol5"):SetText("CH");
	getglobal("ArmorWanted_TitleBarCol6"):SetText("WR");
	getglobal("ArmorWanted_TitleBarCol7"):SetText("HD");
	getglobal("ArmorWanted_TitleBarCol8"):SetText("WA");
	getglobal("ArmorWanted_TitleBarCol9"):SetText("LG");
	getglobal("ArmorWanted_TitleBarCol10"):SetText("FT");
	getglobal("ArmorWanted_TitleBarCol11"):SetText("BK");
	getglobal("ArmorWanted_TitleBarCol12"):SetText("TA");
	getglobal("ArmorWanted_TitleBarCol13"):SetText(" ");
	getglobal("ArmorWanted_TitleBarCol14"):SetText(" ");
	getglobal("ArmorWanted_TitleBarCol15"):SetText(" ");
	getglobal("ArmorWanted_TitleBarCol16"):SetText(" ");

	for i = 1, total_lines, 1 do
		local index = i + FauxScrollFrame_GetOffset(ArmorWanted_ScrollFrame);
		local button = getglobal("ArmorWantedScrollLine" .. i);
		button:Show();

		getglobal(button:GetName() .. "Col1"):SetWidth(300);


		if(nil ~= CurrentListOfSets[index].label) then
			getglobal(button:GetName() .. "Col1"):SetText(CurrentListOfSets[index].label);
		else
			getglobal(button:GetName() .. "Col1"):SetText(" ");
		end

		if(nil ~= CurrentListOfSets[index].description) then
			getglobal(button:GetName() .. "Col2"):SetText(CurrentListOfSets[index].description);
		else
			getglobal(button:GetName() .. "Col2"):SetText(" ");
		end

		getglobal(button:GetName() .. "Col1"):SetTextColor(0.95,0.95,0.95);	
		getglobal(button:GetName() .. "Col2"):SetTextColor(0.95,0.95,0.95);	


		if(CurrentListOfSets[index].collected == 0) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.95,0.05,0.05);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.95,0.05,0.05);	
		end

		if((CurrentListOfSets[index].collected / CurrentListOfSets[index].total) > .8) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.05,0.95,0.95);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.05,0.95,0.95);	
		end

		if(CurrentListOfSets[index].collected == CurrentListOfSets[index].total) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.05,0.95,0.05);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.05,0.95,0.05);	
		end

	  SetClassValue(getglobal(button:GetName() .. "Col3"),ClassGot[CurrentListOfSets[index].Head]);
	  getglobal(button:GetName() .. "Col3"):SetWidth(35);
	  SetClassValue(getglobal(button:GetName() .. "Col4"),ClassGot[CurrentListOfSets[index].Shoulder]);
	  SetClassValue(getglobal(button:GetName() .. "Col5"),ClassGot[CurrentListOfSets[index].Chest]);
	  SetClassValue(getglobal(button:GetName() .. "Col6"),ClassGot[CurrentListOfSets[index].Wrist]);
	  SetClassValue(getglobal(button:GetName() .. "Col7"),ClassGot[CurrentListOfSets[index].Hand]);
	  SetClassValue(getglobal(button:GetName() .. "Col8"),ClassGot[CurrentListOfSets[index].Waist]);
	  SetClassValue(getglobal(button:GetName() .. "Col9"),ClassGot[CurrentListOfSets[index].Legs]);
	  SetClassValue(getglobal(button:GetName() .. "Col10"),ClassGot[CurrentListOfSets[index].Feet]);
	  SetClassValue(getglobal(button:GetName() .. "Col11"),ClassGot[CurrentListOfSets[index].Back]);
	  SetClassValue(getglobal(button:GetName() .. "Col12"),ClassGot[CurrentListOfSets[index].Tabard]);

	  getglobal(button:GetName() .. "Col13"):SetText(" ");
	  getglobal(button:GetName() .. "Col14"):SetText(" ");
	  getglobal(button:GetName() .. "Col15"):SetText(" ");
	  getglobal(button:GetName() .. "Col16"):SetText(" ");

	end	    
end

--------------------------------------------------------------------------------------------------
--  Function: ArmorWanted_Expand_ScrollUpdate
--
--  Desc:  Handle scrolling for the expansions selection
--
--------------------------------------------------------------------------------------------------
function ArmorWanted_Expand_ScrollUpdate()
	local total_lines;

	FauxScrollFrame_Update(ArmorWanted_ScrollFrame, getn(CurrentListOfSets), MAX_LINES_FOR_MAIN, PIXELS_PER_LINE);
  
	  -- Hide the party lines in case we have less than max rows
	for i = 1, MAX_LINES_FOR_MAIN, 1 do
	  local button = getglobal("ArmorWantedScrollLine" .. i);
	  button:Hide();
	end
  
	  -- Get the number of lines, if less than 12 set it to that number if not then display all 12 lines
	if(getn(CurrentListOfSets)<MAX_LINES_FOR_MAIN) then
	  total_lines = getn(CurrentListOfSets);
	else
	  total_lines = MAX_LINES_FOR_MAIN;
	end
  
	getglobal("ArmorWanted_TitleBar" .. "Col1"):SetText("Name");
	getglobal("ArmorWanted_TitleBar" .. "Col1"):SetWidth(180);
	getglobal("ArmorWanted_TitleBar" .. "Col2"):SetText("Level");
	getglobal("ArmorWanted_TitleBar" .. "Col3"):SetText("#");
	getglobal("ArmorWanted_TitleBar" .. "Col3"):SetWidth(80);
	getglobal("ArmorWanted_TitleBar" .. "Col4"):SetText("WR");
	getglobal("ArmorWanted_TitleBar" .. "Col5"):SetText("PA");
	getglobal("ArmorWanted_TitleBar" .. "Col6"):SetText("HU");
	getglobal("ArmorWanted_TitleBar" .. "Col7"):SetText("RO");
	getglobal("ArmorWanted_TitleBar" .. "Col8"):SetText("PR");
	getglobal("ArmorWanted_TitleBar" .. "Col9"):SetText("DK");
	getglobal("ArmorWanted_TitleBar" .. "Col10"):SetText("SH");
	getglobal("ArmorWanted_TitleBar" .. "Col11"):SetText("MA");
	getglobal("ArmorWanted_TitleBar" .. "Col12"):SetText("WL");
	getglobal("ArmorWanted_TitleBar" .. "Col13"):SetText("MO");
	getglobal("ArmorWanted_TitleBar" .. "Col14"):SetText("DR");
	getglobal("ArmorWanted_TitleBar" .. "Col15"):SetText("DH");
	getglobal("ArmorWanted_TitleBar" .. "Col16"):SetText("EV");

	for i = 1, total_lines, 1 do
	 	local index = i + FauxScrollFrame_GetOffset(ArmorWanted_ScrollFrame);
	 	local button = getglobal("ArmorWantedScrollLine" .. i);
	 	button:Show();

		if(nil == CurrentListOfSets[index]) then
			break;
		end

		getglobal(button:GetName() .. "Col1"):SetWidth(180);

		if(nil ~= CurrentListOfSets[index].label) then
			getglobal(button:GetName() .. "Col1"):SetText(CurrentListOfSets[index].label);
		else
			getglobal(button:GetName() .. "Col1"):SetText(" ");
		end

		if(nil ~= CurrentListOfSets[index].description) then
			getglobal(button:GetName() .. "Col2"):SetText(CurrentListOfSets[index].description);
		else
			getglobal(button:GetName() .. "Col2"):SetText(" ");
		end

		getglobal(button:GetName() .. "Col3"):SetText((CurrentListOfSets[index].total).."/"..tostring(CurrentListOfSets[index].collected));
		getglobal(button:GetName() .. "Col3"):SetWidth(80);

		getglobal(button:GetName() .. "Col1"):SetTextColor(0.95,0.95,0.95);	
		getglobal(button:GetName() .. "Col2"):SetTextColor(0.95,0.95,0.95);	
		getglobal(button:GetName() .. "Col3"):SetTextColor(0.95,0.95,0.95);	


		if(CurrentListOfSets[index].collected == 0) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.95,0.05,0.05);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.95,0.05,0.05);	
			getglobal(button:GetName() .. "Col3"):SetTextColor(0.95,0.05,0.05);	
		end

		if((CurrentListOfSets[index].collected / CurrentListOfSets[index].total) > .9) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.05,0.95,0.95);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.05,0.95,0.95);	
			getglobal(button:GetName() .. "Col3"):SetTextColor(0.05,0.95,0.95);	
		end

		if(CurrentListOfSets[index].collected == CurrentListOfSets[index].total) then
			getglobal(button:GetName() .. "Col1"):SetTextColor(0.05,0.95,0.05);	
			getglobal(button:GetName() .. "Col2"):SetTextColor(0.05,0.95,0.05);	
			getglobal(button:GetName() .. "Col3"):SetTextColor(0.05,0.95,0.05);	
		end

		SetExpandValue(getglobal(button:GetName() .. "Col4"),CurrentListOfSets[index]["Warrior"]);
		SetExpandValue(getglobal(button:GetName() .. "Col5"),CurrentListOfSets[index]["Paladin"]);
		SetExpandValue(getglobal(button:GetName() .. "Col6"),CurrentListOfSets[index]["Hunter"]);
		SetExpandValue(getglobal(button:GetName() .. "Col7"),CurrentListOfSets[index]["Rogue"]);
		SetExpandValue(getglobal(button:GetName() .. "Col8"),CurrentListOfSets[index]["Priest"]);
		SetExpandValue(getglobal(button:GetName() .. "Col9"),CurrentListOfSets[index]["Death Knight"]);
		SetExpandValue(getglobal(button:GetName() .. "Col10"),CurrentListOfSets[index]["Shaman"]);
		SetExpandValue(getglobal(button:GetName() .. "Col11"),CurrentListOfSets[index]["Mage"]);
		SetExpandValue(getglobal(button:GetName() .. "Col12"),CurrentListOfSets[index]["Warlock"]);
		SetExpandValue(getglobal(button:GetName() .. "Col13"),CurrentListOfSets[index]["Monk"]);
		SetExpandValue(getglobal(button:GetName() .. "Col14"),CurrentListOfSets[index]["Druid"]);
		SetExpandValue(getglobal(button:GetName() .. "Col15"),CurrentListOfSets[index]["Demon Hunter"]);
		SetExpandValue(getglobal(button:GetName() .. "Col16"),CurrentListOfSets[index]["Evoker"]);
	end	    
end

--------------------------------------------------------------------------------------------------
--  Function: SetClassValue
--
--  Desc:  Handle displaying and changing the color of the class values
--
--------------------------------------------------------------------------------------------------
function SetClassValue(button, value)
	button:SetText(value);

	if(value == "Y") then
		button:SetTextColor(0.05,0.95,0.05);
	end
		
	if(value == "N") then
		button:SetTextColor(0.95,0.95,0.05);
	end
end

--------------------------------------------------------------------------------------------------
--  Function: SetExpandValue
--
--  Desc:  Handle displaying and changing the color of the expansion values
--
--------------------------------------------------------------------------------------------------
function SetExpandValue(button, value)

	if(-1 ~= value["total"]) then
		button:SetText(tostring(value["total"]).."/"..tostring(value["collected"]));

		button:SetTextColor(0.95,0.95,0.95);	

	 	if(value["collected"] == 0) then
			button:SetTextColor(0.95,0.05,0.05);
	 	end

	 	if(value["total"] - value["collected"] < 3) then
			button:SetTextColor(0.05,0.95,0.95);	
	 	end

	 	if(value["total"] == value["collected"]) then
			button:SetTextColor(0.05,0.95,0.05);	
	 	end
	else
		button:SetText(" ");
	end
end


--------------------------------------------------------------------------------------------------
--  Function: Grouper_MainUpdate
--
--  Desc:  Update the party screen
--
--------------------------------------------------------------------------------------------------
function GetSetStatus(setID)

	local returnList = {};
	local collectedItems = {}; 

	returnList["Head"] = -1;
	returnList["Shoulder"] = -1;
	returnList["Chest"] = -1;
	returnList["Wrist"] = -1;
	returnList["Hand"] = -1;
	returnList["Waist"] = -1;
	returnList["Legs"] = -1;
	returnList["Feet"] = -1;
	returnList["Back"] = -1;
	returnList["Tabard"] = -1;

	local theSet = C_TransmogSets.GetSetPrimaryAppearances(setID)
	for _,setdata in pairs(theSet) do
		table.insert(collectedItems, setdata)
	end

	local theSet = C_Transmog.GetAllSetAppearancesByID(setID)
	for _,setdata in pairs(theSet) do
		for _,checkdata in pairs(collectedItems) do
			if setdata.itemModifiedAppearanceID == checkdata.appearanceID then
				local invType = InvTypeToCol[setdata.invType];	

				if nil ~= invType then
					if(true == checkdata.collected) then
						returnList[invType] = 1;
					else
						returnList[invType] = 0;
					end
				else
					print("Weird invtype in GetSetStatus:", setdata.invType)
				end
				break;
			end
		end    
	end

	local total = 0;
	local collected = 0;

	for key, value in pairs(returnList) do
		if(value == 1) then
			collected = collected + 1;
		end
		if(value ~= -1) then
			total = total + 1;
		end
	end

	returnList["collected"] = collected;
	returnList["total"] = total;

	return returnList;
end
