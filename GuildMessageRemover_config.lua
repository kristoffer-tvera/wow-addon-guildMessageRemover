GuildMessageRemover_config = {};
local _, L = ...;
local addonName = L["guildmessageremover"];
local capitalizedAddonName = string.gsub(addonName, "(%w)", string.upper, 1); --Capitalize
local y_increment = -25;
local x_indentation = 5;
local unique = 1;

function GuildMessageRemover_config:createCheckbutton(parent, displayname, tooltip)
    
	local checkbutton = CreateFrame("CheckButton", "GuildMessageRemoverConfigFrameCheckbox" .. unique, parent, "ChatConfigCheckButtonTemplate");
    checkbutton:SetPoint("TOPLEFT", x_indentation, (y_increment * unique));
    -- checkbutton_GlobalNameText:SetText(displayname);
    getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);
    checkbutton.tooltip = tooltip;
    
    unique = unique + 1;
	return checkbutton;
end

function GuildMessageRemover_config:createTextFrame(parent, text, fontsize, heightMultiplier)
    local fontFrame = CreateFrame("Frame", "GuildMessageRemoverConfigFrameTextbox" .. unique, parent);
    fontFrame:SetSize(600, fontsize * heightMultiplier);
    fontFrame:SetPoint("TOPLEFT", x_indentation, (y_increment * unique));
    fontFrame.text =
    fontFrame:CreateFontString(nil,"ARTWORK");
    fontFrame.text:SetAllPoints(true);
    fontFrame.text:SetFont("Fonts\\FRIZQT__.TTF", fontsize);
    fontFrame.text:SetText(text);

    unique = unique + 1;
    return fontFrame;
end


GuildMessageRemover_config.panel = CreateFrame( "Frame", "GuildMessageRemoverConfigFrame", UIParent );
GuildMessageRemover_config.panel.name = capitalizedAddonName;
InterfaceOptions_AddCategory(GuildMessageRemover_config.panel);

local function LoadSettingsAndConfig()
    GuildMessageRemover_config.panel:UnregisterEvent("ADDON_LOADED");
    GuildMessageRemover_config.introFrame = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, "-->> " .. capitalizedAddonName .. " <<--", 25, 1);

    GuildMessageRemover_config.enableCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enabled"] , L["Instantly delete your guild-messages from the new Communities window"]);
    GuildMessageRemover_config.enableCheckbox:SetChecked(GuildMessageRemoverEnabled);
    GuildMessageRemover_config.enableCheckbox:SetScript("OnClick", 
        function()
            GuildMessageRemoverEnabled = GuildMessageRemover_config.enableCheckbox:GetChecked();
            GuildMessageRemover:Enable(GuildMessageRemoverEnabled);
        end
    );

    GuildMessageRemover_config.enableGlobalCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enabled for ALL channels"] , L["Instantly delete your messages from  all of the new Communities windows"]);
    GuildMessageRemover_config.enableGlobalCheckbox:SetChecked(GuildMessageRemoverGlobal);
    GuildMessageRemover_config.enableGlobalCheckbox:SetScript("OnClick", 
        function()
            GuildMessageRemoverGlobal = GuildMessageRemover_config.enableGlobalCheckbox:GetChecked();
            --GuildMessageRemover:Enable(GuildMessageRemoverEnabled);
        end
    );
    
    local githubUrl = 'https://github.com/kristoffer-tvera/wow-addon-borderless';
    
    GuildMessageRemover_config.credits = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, "Made by bzl#2429", 16, 1);
    GuildMessageRemover_config.help = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, "For ideas, suggestions, issues, or help with translations, " .. githubUrl, 14, 3);
    
    GuildMessageRemover:Enable(GuildMessageRemoverEnabled);
end

GuildMessageRemover_config.panel:RegisterEvent("ADDON_LOADED");
GuildMessageRemover_config.panel:SetScript("OnEvent", LoadSettingsAndConfig);


-- Register a slashcommand to quickly modify settings
SLASH_GUILDMESSAGEREMOVER1 = '/'..addonName;
SLASH_GUILDMESSAGEREMOVER2 = '/gmr';
SlashCmdList["GUILDMESSAGEREMOVER"] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(GuildMessageRemover_config.panel);
    InterfaceOptionsFrame_OpenToCategory(GuildMessageRemover_config.panel);
end 
