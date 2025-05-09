

BaseSets = {};


local CalendarConstants =
{
	Tables =
	{
		{
			Name = "CalendarFilterFlags",
			Type = "Enumeration",
			NumValues = 7,
			MinValue = 1,
			MaxValue = 64,
			Fields =
			{
				{ Name = "PVE", Type = "CalendarFilterFlags", EnumValue = 1 },
				{ Name = "PVP", Type = "CalendarFilterFlags", EnumValue = 2 },
				{ Name = "100%", Type = "CalendarFilterFlags", EnumValue = 4 },
				{ Name = "90%", Type = "CalendarFilterFlags", EnumValue = 8 },
				{ Name = "Other", Type = "CalendarFilterFlags", EnumValue = 16 },
				{ Name = "None", Type = "CalendarFilterFlags", EnumValue = 32 },
				{ Name = "Attire", Type = "CalendarFilterFlags", EnumValue = 64 },
			},
		},
	},
};

ClassMaskMap = {
    [1] = {1, 2, 32, 35}, -- Plate Wearer
    [2] = {1, 2, 32, 35}, -- Plate Wearer
    [3] = {4, 64, 4096, 4164, 68},    -- Mail Wearer
    [4] = {8, 512, 1024, 2048, 3592, 11784}, -- Leather Wearer
    [5] = {16, 128, 256, 400}, -- Cloth Wearer
    [6] = {1, 2, 32, 35}, -- Plate Wearer
    [7] = {4, 64, 4096, 4164, 68},    -- Mail Wearer
    [8] = {16, 128, 256, 400}, -- Cloth Wearer
    [9] = {16, 128, 256, 400}, -- Cloth Wearer
    [10] = {8, 512, 1024, 2048, 3592, 11784}, -- Leather Wearer
    [11] = {8, 512, 1024, 2048, 3592, 11784}, -- Leather Wearer
    [12] = {8, 512, 1024, 2048, 3592, 11784}, -- Leather Wearer
    [13] = {4, 64, 4096, 4164, 68},    -- Mail Wearer
}

ClassNameMask = {
    [400] = "Cloth",
    [35] = "Plate",
    [68] = "Mail",
    [4164] = "Mail",
    [11784] = "Leather",
    [3592] = "Leather",
--    [1] = "Warrior",
--    [2] = "Paladin",
--    [4] = "Hunter",
--    [8] = "Rogue",
--    [16] = "Priest",
--    [32] = "Death Knight",
--    [64] = "Shaman",
--    [128] = "Mage",
--    [256] = "Warlock",
--    [512]  = "Monk",
--    [1024] = "Druid",
--    [2048] = "Demon Hunter",
--    [4096] = "Evoker",
}

ClassNameLookupMask = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [4] = "HUNTER",
    [8] = "ROGUE",
    [16] = "PRIEST",
    [32] = "DEATHKNIGHT",
    [64] = "SHAMAN",
    [128] = "MAGE",
    [256] = "WARLOCK",
    [512] = "MONK",
    [1024] = "DRUID",
    [2048] = "DEMONHUNTER",
    [4096] = "EVOKER",
}

ClassToMask = {
    [1] = 1,
    [2] = 2,
    [3] = 4,
    [4] = 8,
    [5] = 16,
    [6] = 32,
    [7] = 64,
    [8] = 128,
    [9] = 256,
    [10] = 512,
    [11] = 1024,
    [12] = 2048,
    [13] = 4096,
}

ClassArmorType = {
    [1]  = 4, --[1]  = 1, --[1] =    
    [2]  = 4, --[2]  = 1, --[2] =    
    [3]  = 3, --[3]  = 2, --[4] =    
    [4]  = 2, --[4]  = 3, --[8] =    
    [5]  = 1, --[5]  = 4, --[16] =   
    [6]  = 4, --[6]  = 1, --[32] =   
    [7]  = 3, --[7]  = 2, --[64] =   
    [8]  = 1, --[8]  = 4, --[128] =  
    [9]  = 1, --[9]  = 4, --[256] =  
    [10] = 2, --[10] = 3, --[512] =  
    [11] = 2, --[11] = 3, --[1024] = 
    [12] = 2, --[12] = 3, --[2048] = 
    [13] = 3,
}

ClassArmorMask = {
    [1]  = {1, 35},
    [2]  = {2, 35},
    [3]  = {4, 4164},
    [4]  = {8, 3592, 11784},
    [5]  = {16, 400},
    [6]  = {32, 35},
    [7]  = {64, 4164},
    [8]  = {128, 400},
    [9]  = {256, 400},
    [10] = {512, 3592, 11784},
    [11] = {1024, 3592, 11784},
    [12] = {2048, 3592, 11784},
    [13] = {4096, 4164},
}

SLASH_ARMORW1     = "/armorw";

--------------------------------------------------------------------------------------------------
--  Function: Grouper_SlashCommand
--
--  Desc:  The slash command was typed for grouper
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_SlashCommand()
    ShowUIPanel(Armor_Wanted_Main_Frame);
  end
  


--------------------------------------------------------------------------------------------------
--  Function: Grouper_OnEvent
--
--  Desc:  Event Switch board
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnShow(self)
    if(nil == Armor_Wanted_DB[MAIN_SELECTION]) then
--        self.FirstSelectionDropdown:SetDefaultText("Item");
--        self.SecondSelectionDropdown:SetDefaultText("Select Item");
    else
        self.FirstSelectionDropdown:SetDefaultText(Armor_Wanted_DB[MAIN_SELECTION]);
        Armor_Wanted_FirstSelectionDropdown_OnClick(Armor_Wanted_DB[MAIN_SELECTION]);
        if("Class" == Armor_Wanted_DB[MAIN_SELECTION]) then
            self.SecondSelectionDropdown:SetDefaultText(Armor_Wanted_DB[CLASS_SELECTION]);
        elseif("Expansion" == Armor_Wanted_DB[MAIN_SELECTION]) then
            self.SecondSelectionDropdown:SetDefaultText(Armor_Wanted_DB[EXPAND_SELECTION]);
        end
    end
    InitFilterDropdown();

    self.SearchBox:SetText(Armor_Wanted_DB[SEARCH_TEXT]);
end

--------------------------------------------------------------------------------------------------
--  Function: Grouper_OnLoad
--
--  Desc:  The load function of grouper
--
--------------------------------------------------------------------------------------------------
local function IsSelected(minute)
    return true;
end

--------------------------------------------------------------------------------------------------
--  Function: Grouper_OnLoad
--
--  Desc:  The load function of grouper
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnLoad(self)
    SlashCmdList["ARMORW"] = Armor_Wanted_SlashCommand;
  
    if( DEFAULT_CHAT_FRAME ) then
        DEFAULT_CHAT_FRAME:AddMessage("Armor Wanted Loaded -- Go get 'em, use /armorw panels");
    end
  
    local sets = C_TransmogSets.GetAllSets();
    for _,data in pairs(sets) do

        table.insert(BaseSets, data)

        -- if data.name == "Bloodfang Armor" then
        --     for key, value in pairs(data) do
        --         print(key, value)
        --     end


        --     --        if data.name == "Flamewaker's Battlegear" then
        --     local setRow = GetSetStatus(data.setID) ;
                       
        --     for key, value in pairs(setRow) do
        --         print(">>", key, value)
        --     end            
        -- end
    end

    ArmorWanted_FirstDropdownFrame = self.FirstSelectionDropdown;
    ArmorWanted_SecondDropdownFrame = self.SecondSelectionDropdown;
    ArmorWanted_FilterDropdown = self.FilterDropdown;

    self.FirstSelectionDropdown:SetWidth(100);
    self.SecondSelectionDropdown:SetWidth(200);
	self.FirstSelectionDropdown:SetupMenu(function(dropdown, rootDescription)
    	rootDescription:CreateButton("Expansion", Armor_Wanted_FirstSelectionDropdown_OnClick, "Expansion");
	    rootDescription:CreateButton("Class", Armor_Wanted_FirstSelectionDropdown_OnClick, "Class");
	end);

    self.FilterDropdown:SetupMenu(function(dropdown, rootDescription)

        rootDescription:CreateTitle("Filter");

        ArmorWanted_Check_PVE = rootDescription:CreateCheckbox("PVE", IsSelected, Armor_Wanted_SetFilter, "PVE");
        ArmorWanted_Check_PVP = rootDescription:CreateCheckbox("PVP", IsSelected, Armor_Wanted_SetFilter, "PVP");

        ArmorWanted_Check_100 = rootDescription:CreateCheckbox("100%", IsSelected, Armor_Wanted_SetFilter, "PERCENT_100");
        ArmorWanted_Check_90 = rootDescription:CreateCheckbox("90%", IsSelected, Armor_Wanted_SetFilter, "PERCENT_90");
        ArmorWanted_Check_Other = rootDescription:CreateCheckbox("Other", IsSelected, Armor_Wanted_SetFilter, "PERCENT_OTHER");
        ArmorWanted_Check_0 = rootDescription:CreateCheckbox("0%", IsSelected, Armor_Wanted_SetFilter, "PERCENT_0");

        ArmorWanted_Check_Attire = rootDescription:CreateCheckbox("Attire", IsSelected, Armor_Wanted_SetFilter, "ATTIRE");

    end);

    self.FirstSelectionDropdown:SetDefaultText("Select Item");

    Armor_Wanted_Main_Frame:RegisterEvent("VARIABLES_LOADED");
    Armor_Wanted_Main_Frame:RegisterEvent("LOOT_CLOSED");

end

function InitFilterDropdown()
    local function IsSelected(data)
        return Armor_Wanted_DB[data];
    end

    local function SetSelected(data)
        Armor_Wanted_DB[data] = not Armor_Wanted_DB[data];
        ChangeAWFilter();
    end

    for _, value in pairs(FilterNames) do
        if (nil == Armor_Wanted_DB[value]) then
            Armor_Wanted_DB[value] = true;
        end
    end

    ArmorWanted_FilterDropdown:SetWidth(100);
    ArmorWanted_FilterDropdown:SetupMenu(function(dropdown, rootDescription)

        rootDescription:CreateTitle("Filter");

        rootDescription:CreateCheckbox(FilterNames[FILTER_PVE_ID], IsSelected, SetSelected, FilterNames[FILTER_PVE_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_PVP_ID], IsSelected, SetSelected, FilterNames[FILTER_PVP_ID]);
        rootDescription:CreateSpacer();       
        rootDescription:CreateCheckbox(FilterNames[FILTER_100_ID], IsSelected, SetSelected, FilterNames[FILTER_100_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_90_ID], IsSelected, SetSelected, FilterNames[FILTER_90_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_OTHER_ID], IsSelected, SetSelected, FilterNames[FILTER_OTHER_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_NONE_ID], IsSelected, SetSelected, FilterNames[FILTER_NONE_ID]);
        rootDescription:CreateSpacer();
        rootDescription:CreateCheckbox(FilterNames[FILTER_STANDARD_ID], IsSelected, SetSelected, FilterNames[FILTER_STANDARD_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_ATTIRE_ID], IsSelected, SetSelected, FilterNames[FILTER_ATTIRE_ID]);
        rootDescription:CreateCheckbox(FilterNames[FILTER_GROUPS_ID], IsSelected, SetSelected, FilterNames[FILTER_GROUPS_ID]);
    end);
end

--------------------------------------------------------------------------------------------------
--  Function: Grouper_OnEvent
--
--  Desc:  Event Switch board
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnEvent(self, event,...)

    if ("VARIABLES_LOADED" == event) then
          
    end

    if ("LOOT_CLOSED" == event) then
        ChangeAWFilter();
    end

end