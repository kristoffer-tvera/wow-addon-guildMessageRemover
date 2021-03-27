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

if GuildMessageRemoverOfficer == nil then
    GuildMessageRemoverOfficer = false;
end

if GuildMessageRemoverOfficerEverything == nil then
    GuildMessageRemoverOfficerEverything = false;
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
    local guild = C_Club.GetGuildClubId();

    -- Deletes your own messages (if you can) in any non-guild channel
    if clubId ~= guild and messageInfo.author.isSelf and privileges.canDestroyOwnMessage and GuildMessageRemoverGlobal then
        return true;
    end

    -- Deletes everyones messages (if you can) in any non-guild channel
    if clubId ~= guild and privileges.canDestroyOtherMessage and GuildMessageRemoverGlobal and GuildMessageRemoverEverything then
        return true;
    end

    -- Deletes your own messages (if you can) in guild-chats
    if clubId == guild and streamId ~= 2 and messageInfo.author.isSelf and privileges.canDestroyOwnMessage and GuildMessageRemoverEnabled then
        return true;
    end

    -- Deletes everyones messages (if you can) in guild-chats
    if clubId == guild and streamId ~= 2 and privileges.canDestroyOtherMessage and GuildMessageRemoverEverything then
        return true;
    end

    -- Deletes your own messages (if you can) in officer-chat
    if clubId == guild and streamId == 2 and messageInfo.author.isSelf and privileges.canDestroyOwnMessage and GuildMessageRemoverOfficer then
        return true;
    end

    -- Deletes everyones messages (if you can) in officer-chat
    if clubId == guild and streamId == 2 and privileges.canDestroyOtherMessage and GuildMessageRemoverOfficerEverything then
        return true;
    end

    return false;
end

-- Allows for toggling on and off
function GuildMessageRemover:Enable(enabled)
    if enabled then
        GuildMessageRemover.frame:RegisterEvent("CLUB_MESSAGE_ADDED");
    else 
        GuildMessageRemover.frame:UnregisterEvent("CLUB_MESSAGE_ADDED");
    end
end

function GuildMessageRemover:WipeLastMessages(count, streamid)
    local guildClubId = C_Club.GetGuildClubId();
    local lastMessageId = C_Club.GetMessageRanges(guildClubId, streamid)[1].newestMessageId;

	local lastMessages = C_Club.GetMessagesBefore(guildClubId, streamid, lastMessageId, count);
    for key,message in pairs(lastMessages) do
        if not message.destroyed then
            pcall (C_Club.DestroyMessage, guildClubId, streamid, message.messageId);
        end
    end
end

-- Triggers on new message in guild chat
local function GuildMessageRemoverEventHandler(self, event, ...)
    local clubId, streamId, messageId = ...;

    if GuildMessageRemover:CanDestroyMessage(clubId, streamId, messageId) then
        retOK, ret1 = pcall (C_Club.DestroyMessage, clubId, streamId, messageId);
    end

end

GuildMessageRemover.frame = CreateFrame("FRAME", "GuildMessageRemoverFrame");
GuildMessageRemover.frame:SetScript("OnEvent", GuildMessageRemoverEventHandler);
