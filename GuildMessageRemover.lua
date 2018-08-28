--Check+Init globals
if GuildMessageRemoverEnabled == nil then
    GuildMessageRemoverEnabled = true;
end

if GuildMessageRemoverGlobal == nil then
    GuildMessageRemoverGlobal = false;
end

if GuildMessageRemoverEverything == nil then
    GuildMessageRemoverEverything = false;
end

GuildMessageRemover = {};
local _, L = ...;

-- Checks if the message is destroyable
function GuildMessageRemover:CanDestroyMessage(clubId, streamId, messageId)
    local messageInfo = C_Club.GetMessageInfo(clubId, streamId, messageId);
    if not messageInfo or messageInfo.destroyed then
        return false;
    end
    
    local privileges = C_Club.GetClubPrivileges(clubId);

    if messageInfo.author.isSelf and privileges.canDestroyOwnMessage then
        return true;
    elseif privileges.canDestroyOtherMessage and GuildMessageRemoverEverything then
        return true;
    end
    return false;


    -- if not messageInfo.author.isSelf and not privileges.canDestroyOtherMessage then
    --     return false;
    -- elseif messageInfo.author.isSelf and not privileges.canDestroyOwnMessage then
    --     return false;
    -- end
    
    -- return true;
end

-- Allows for toggling on and off
function GuildMessageRemover:Enable(enabled)
    if enabled then
        GuildMessageRemover.frame:RegisterEvent("CLUB_MESSAGE_ADDED");
    else 
        GuildMessageRemover.frame:UnregisterEvent("CLUB_MESSAGE_ADDED");
    end
end

-- Triggers on new message in guild chat
local function GuildMessageRemoverEventHandler(self, event, ...)
    local arg1, arg2, arg3 = ...;

    if GuildMessageRemoverGlobal then
        if GuildMessageRemover:CanDestroyMessage(arg1, arg2, arg3) then
            retOK, ret1 = pcall (C_Club.DestroyMessage, arg1, arg2, arg3);
        end
    else 
        if arg1 == C_Club.GetGuildClubId() then 
            if GuildMessageRemover:CanDestroyMessage(arg1, arg2, arg3) then
                retOK, ret1 = pcall (C_Club.DestroyMessage, arg1, arg2, arg3);
            end
        end
    end

    
end

GuildMessageRemover.frame = CreateFrame("FRAME", "GuildMessageRemoverFrame");
GuildMessageRemover.frame:SetScript("OnEvent", GuildMessageRemoverEventHandler);
