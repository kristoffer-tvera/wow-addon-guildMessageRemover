GuildMessageRemover_config = {};
local _, L = ...;
local addonName = L["guildmessageremover"];
local capitalizedAddonName = string.gsub(addonName, "(%w)", string.upper, 1); --Capitalize
local y_increment = -30;
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

function GuildMessageRemover_config:createButton(parent, displayname, tooltip)
	local button = CreateFrame("Button", "GuildMessageRemoverConfigFrameButton" .. unique, parent, "UIPanelButtonTemplate");
    button:SetPoint("TOPLEFT", x_indentation, (y_increment * unique));
    button:SetText(displayname);
    button:SetWidth(250)
	button:SetHeight(25)
    button.tooltip = tooltip;
    
    unique = unique + 1;
	return button;
end

GuildMessageRemover_config.panel = CreateFrame( "Frame", "GuildMessageRemoverConfigFrame", UIParent );
GuildMessageRemover_config.panel.name = capitalizedAddonName;

category, layout = Settings.RegisterCanvasLayoutCategory(GuildMessageRemover_config.panel, GuildMessageRemover_config.panel.name,
    GuildMessageRemover_config.panel.name);
category.ID = GuildMessageRemover_config.panel.name
Settings.RegisterAddOnCategory(category);

local function LoadSettingsAndConfig()
    GuildMessageRemover_config.panel:UnregisterEvent("ADDON_LOADED");
    GuildMessageRemover_config.introFrame = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, capitalizedAddonName , 25, 1);

    GuildMessageRemover_config.enableCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enabled"] , L["Instantly delete your guild-messages from the new Communities window"]);
    GuildMessageRemover_config.enableCheckbox:SetChecked(GuildMessageRemoverEnabled);
    GuildMessageRemover_config.enableCheckbox:SetScript("OnClick", 
        function()
            GuildMessageRemoverEnabled = GuildMessageRemover_config.enableCheckbox:GetChecked();
            GuildMessageRemover:Enable(GuildMessageRemoverEnabled);
        end
    );

    GuildMessageRemover_config.enableEverythingCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Delete everyones messages"] , L["Requires that you actually have permission to delete other peoples messages"]);
    GuildMessageRemover_config.enableEverythingCheckbox:SetChecked(GuildMessageRemoverEverything);
    GuildMessageRemover_config.enableEverythingCheckbox:SetScript("OnClick", 
        function()
            local isChecked = GuildMessageRemover_config.enableEverythingCheckbox:GetChecked();
            GuildMessageRemoverEverything = isChecked;
        end
    );

    GuildMessageRemover_config.enableOfficerCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enable for Officer Chat (guild)"] , L["Requires that you actually have permission to delete other peoples messages"]);
    GuildMessageRemover_config.enableOfficerCheckbox:SetChecked(GuildMessageRemoverOfficer);
    GuildMessageRemover_config.enableOfficerCheckbox:SetScript("OnClick", 
        function()
            local isChecked = GuildMessageRemover_config.enableOfficerCheckbox:GetChecked();
            GuildMessageRemoverOfficer = isChecked;

            if GuildMessageRemover_config.enableOfficerEverythingCheckbox:GetChecked() then
                GuildMessageRemover_config.enableOfficerEverythingCheckbox:SetChecked(false);
                GuildMessageRemoverOfficerEverything = false;
            end
            
        end
    );

    GuildMessageRemover_config.enableOfficerEverythingCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enable for everyones messages in Officer Chat (guild)"] , L["Requires that you actually have permission to delete other peoples messages"]);
    GuildMessageRemover_config.enableOfficerEverythingCheckbox:SetChecked(GuildMessageRemoverOfficerEverything);
    GuildMessageRemover_config.enableOfficerEverythingCheckbox:SetScript("OnClick", 
        function()
            local isChecked = GuildMessageRemover_config.enableOfficerEverythingCheckbox:GetChecked();
            GuildMessageRemoverOfficerEverything = isChecked;

            if GuildMessageRemover_config.enableOfficerCheckbox:GetChecked() then
                GuildMessageRemover_config.enableOfficerCheckbox:SetChecked(false);
                GuildMessageRemoverOfficer = false;
            end
        end
    );

    GuildMessageRemover_config.enableGlobalCheckbox = GuildMessageRemover_config:createCheckbutton(GuildMessageRemover_config.panel, L["Enabled for ALL channels"] , L["Instantly delete your messages from  all of the new Communities windows"]);
    GuildMessageRemover_config.enableGlobalCheckbox:SetChecked(GuildMessageRemoverGlobal);
    GuildMessageRemover_config.enableGlobalCheckbox:SetScript("OnClick", 
        function()
            GuildMessageRemoverGlobal = GuildMessageRemover_config.enableGlobalCheckbox:GetChecked();
        end
    );

    GuildMessageRemover_config.last10 = GuildMessageRemover_config:createButton(GuildMessageRemover_config.panel, "Last 10 messages" , "Remove last 10 messages");
    GuildMessageRemover_config.last10:SetScript("OnClick", 
        function()
            GuildMessageRemover:WipeLastMessages(10);
        end 
    );

    GuildMessageRemover_config.last50 = GuildMessageRemover_config:createButton(GuildMessageRemover_config.panel, "Last 50 messages" , "Remove last 50 messages");
    GuildMessageRemover_config.last50:SetScript("OnClick", 
        function()
            GuildMessageRemover:WipeLastMessages(50);
        end 
    );

    GuildMessageRemover_config.last100 = GuildMessageRemover_config:createButton(GuildMessageRemover_config.panel, "Last 100 messages" , "Remove last 100 messages");
    GuildMessageRemover_config.last100:SetScript("OnClick", 
        function()
            GuildMessageRemover:WipeLastMessages(100);
        end 
    );

    GuildMessageRemover_config.last200 = GuildMessageRemover_config:createButton(GuildMessageRemover_config.panel, "Last 200 messages" , "Remove last 200 messages");
    GuildMessageRemover_config.last200:SetScript("OnClick", 
        function()
            GuildMessageRemover:WipeLastMessages(200);
        end 
    );

    local githubUrl = 'https://github.com/kristoffer-tvera/wow-addon-guildMessageRemover';
    
    GuildMessageRemover_config.credits = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, "Made by bzl#2429 (EU)", 16, 1);
    GuildMessageRemover_config.help = GuildMessageRemover_config:createTextFrame(GuildMessageRemover_config.panel, githubUrl, 14, 3);
    
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
