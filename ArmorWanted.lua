
MAIN_SELECTION   = "main";
CLASS_SELECTION  = "class";
EXPAND_SELECTION      = "expand";
PVP_SELECTED     = "pvp";
PVE_SELECTED     = "evp";
FILTER_100 = "100";
FILTER_90       = "90";
FILTER_0           = "0";
FILTER_OTHER       = "other";

Armor_Wanted_DB  = {};

BaseSets = {};

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
function Armor_Wanted_OnEvent(self, event,...)
    if( DEFAULT_CHAT_FRAME ) then
        DEFAULT_CHAT_FRAME:AddMessage("Event:"..event);
    end
end

--------------------------------------------------------------------------------------------------
--  Function: Grouper_OnLoad
--
--  Desc:  The load function of grouper
--
--------------------------------------------------------------------------------------------------
function Armor_Wanted_OnLoad()

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
  end
  