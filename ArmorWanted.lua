--------------------------------------------------------------------------------------------------
--  
--  $Workfile: ArmorWanted.lua$
--
--  Project:      Armor Wanted
--
--                           Copyright (c) 2025
--                              James A Wright
--                            All Rights Reserved
--
--  File Description:
--      This is the main code for the Armor Wanted addon.
--  
--------------------------------------------------------------------------------------------------

SLASH_ARMORW1     = "/armorw";

--------------------------------------------------------------------------------------------------
--  Function: Armor_Wanted_SlashCommand
--
--  Desc:  Show the main frame when the slash command is used.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_SlashCommand()
    ShowUIPanel(Armor_Wanted_Main_Frame);
  end

--------------------------------------------------------------------------------------------------
--  Function: Armor_Wanted_OnShow
--
--  Desc:  Do this right after the main frame is shown.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnShow(self)
    if(nil ~= Armor_Wanted_DB[MAIN_SELECTION]) then
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
--  Function: Armor_Wanted_OnLoad
--
--  Desc:  Do the stuff that needs to be done when the addon is loaded.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnLoad(self)
    local function IsSelectedTrue(minute)
        return true;
    end
    
    SlashCmdList["ARMORW"] = Armor_Wanted_SlashCommand;
  
    if( DEFAULT_CHAT_FRAME ) then
        DEFAULT_CHAT_FRAME:AddMessage("Armor Wanted Loaded -- Go get 'em, use /armorw panels");
    end

    tinsert(UISpecialFrames,"Armor_Wanted_Main_Frame");    

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

    self.FirstSelectionDropdown:SetDefaultText("Select Item");

    Armor_Wanted_Main_Frame:RegisterEvent("VARIABLES_LOADED");
    Armor_Wanted_Main_Frame:RegisterEvent("LOOT_CLOSED");

end

--------------------------------------------------------------------------------------------------
--  Function: InitFilterDropdown
--
--  Desc:  Setup the filter dropdown menu.
--
--------------------------------------------------------------------------------------------------
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
--  Function: Armor_Wanted_OnEvent
--
--  Desc:  Handle the events for the main frame.
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnEvent(self, event,...)

    if ("VARIABLES_LOADED" == event) then
        Armor_Wanted_DB[SEARCH_TEXT] = "";
    end

    if ("LOOT_CLOSED" == event) then
        ChangeAWFilter();
    end

end