--Check+Init globals
if GuildMessageRemoverEnabled == nil then
    GuildMessageRemoverEnabled = true;
end

GuildMessageRemover = {};
local _, L = ...;

print("loaded");

-- Checks if the message is destroyable
function GuildMessageRemover:CanDestroyMessage(clubId, streamId, messageId)
    local messageInfo = C_Club.GetMessageInfo(clubId, streamId, messageId);
    if not messageInfo or messageInfo.destroyed then
        return false;
    end
    
    local privileges = C_Club.GetClubPrivileges(clubId);
    if not messageInfo.author.isSelf and not privileges.canDestroyOtherMessage then
        return false;
    elseif messageInfo.author.isSelf and not privileges.canDestroyOwnMessage then
        return false;
    end
    
    return true;
end


-- Allows for toggling on and off
function GuildMessageRemover:Enable(enabled)
    print("x");
    if enabled then
        print("y");
        GuildMessageRemover.frame:RegisterEvent("CLUB_MESSAGE_ADDED");
    else 
        print("z");
        GuildMessageRemover.frame:UnregisterEvent("CLUB_MESSAGE_ADDED");
    end
end

-- Triggers on new message in guild chat
local function GuildMessageRemoverEventHandler(self, event, ...)
    if event == "ADDON_LOADED" then
        GuildMessageRemover:Enable(GuildMessageRemoverEnabled);
    end

    local arg1, arg2, arg3 = ...;
    if GuildMessageRemover:CanDestroyMessage(arg1, arg2, arg3) then
        retOK, ret1 = pcall (C_Club.DestroyMessage, arg1, arg2, arg3);
    end
end

GuildMessageRemover.frame = CreateFrame("FRAME", "GuildMessageRemoverFrame");
GuildMessageRemover.frame:SetScript("OnEvent", GuildMessageRemoverEventHandler);