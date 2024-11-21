-- Function to get MCM setting values
function MCMGet(settingID)
    return Mods.BG3MCM.MCMAPI:GetSettingValue(settingID, ModuleUUID)
end

local function OnSessionLoaded()
    print("Champions - MCM Version")
    Vars = {
        EnableChampions = MCMGet("EnableChampions"),
        ChampionsHealth = MCMGet("ChampionsHealth"),
        ChampionsChance = MCMGet("ChampionsChance"),
        OnlyChampionClones = MCMGet("OnlyChampionClones"),
        RandomizedClassless = MCMGet("RandomizedClassless"),
        Debug = MCMGet("Debug"),
        Timer = MCMGet("Timer"),
        EnableGoldenChampion = MCMGet("EnableGoldenChampion"),
        GoldenChampionChance = MCMGet("GoldenChampionChance"),
        GoldenChampionHealth = MCMGet("GoldenChampionHealth"),
        EnablePyromancer = MCMGet("EnablePyromancer"),  
        EnableCryomancer = MCMGet("EnableCryomancer"),  
        EnableStormcaller = MCMGet("EnableStormcaller"),  
        EnableStoneskin = MCMGet("EnableStoneskin"),  
        EnableBerserker = MCMGet("EnableBerserker"),  
        EnableBloodthirsty = MCMGet("EnableBloodthirsty"),  
        EnableAssassin = MCMGet("EnableAssassin"),  
        EnableIllusionist = MCMGet("EnableIllusionist"),  
        EnableTrickster = MCMGet("EnableTrickster"),  
        EnablePaladin = MCMGet("EnablePaladin"),  
        EnableHealer = MCMGet("EnableHealer"),  
        EnablePriest = MCMGet("EnablePriest"),  
        EnableWebweaver = MCMGet("EnableWebweaver"),  
        EnableDruid = MCMGet("EnableDruid"),  
        EnableShaman = MCMGet("EnableShaman"),  
        EnableNecromancer = MCMGet("EnableNecromancer"),  
        EnableOathbreaker = MCMGet("EnableOathbreaker"),  
        EnableHeretic = MCMGet("EnableHeretic"),
        TimerCeremorph = MCMGet("TimerCeremorph"),
        EnableCeremorph = MCMGet("EnableCeremorph")
    }
    timerCeremorphDuration = Vars.TimerCeremorph * 6
    timerDuration = Vars.Timer * 6
    Current_combat = ""
    Party = {}
    Enemies = {}
end
Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)

ExcludedNPCs= 
{
    "S_Player_Karlach_2c76687d-93a2-477b-8b18-8a14b549304c",
    "S_Player_Minsc_0de603c5-42e2-4811-9dad-f652de080eba",
    "S_GOB_DrowCommander_25721313-0c15-4935-8176-9f134385451b",
    "S_GLO_Halsin_7628bc0e-52b8-42a7-856a-13a6fd413323",
    "S_Player_Jaheira_91b6b200-7d00-4d62-8dc9-99e8339dfa1a",
    "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604",
    "S_Player_Astarion_c7c13742-bacd-460a-8f65-f864fe41f255",
    "S_Player_Laezel_58a69333-40bf-8358-1d17-fff240d7fb12",
    "S_Player_Wyll_c774d764-4a17-48dc-b470-32ace9ce447d",
    "S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679",
    "S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255",
    "S_WYR_SkeletalDragon_67770922-5e0a-40c5-b3f0-67e8eb50493a",
    "S_HAG_ForestIllusion_Redcap_04_30a871b1-9df3-42bb-87cb-c284cafd32eb",
    "S_HAG_ForestIllusion_Redcap_03_14026955-2546-4d31-bc0c-4bfe0c34bd8a",
    "S_HAG_ForestIllusion_Redcap_02_2b08981e-5cb0-496d-98cf-15e6a92121ec",
    "S_HAG_ForestIllusion_Redcap_01_ff840420-d46a-4837-868b-ac02f45e4586",
    "S_END_MindBrain_f8bb04a3-22e5-41b0-aed7-5dcf852343d1",
    "S_GLO_Monitor_f65becd6-5cd7-4c88-b85e-6dd06b60f7b8",
    "S_HAG_Hag_c457d064-83fb-4ec6-b74d-1f30dfafd12d"
}


function CheckIfOrigin(target)
    for i=#ExcludedNPCs,1,-1 do
        if (ExcludedNPCs[i] == target) then
            return 1
        end
    end
    return 0
end

local function GetHighestAbilityScore(target)
    local abilities = {"Strength", "Dexterity", "Intelligence", "Wisdom", "Charisma", "Constitution"}
    local highestScore = 0
    local highestAbility = nil
    for _, ability in ipairs(abilities) do
        local score = Osi.GetAbility(target, ability)
        if score > highestScore then
            highestScore = score
            highestAbility = ability
        end
    end
    return highestAbility, highestScore
end

local function ApplyHexOnHighestAbility(target)
    local highestAbility, _ = GetHighestAbilityScore(target)
    local hexSpellMap = {
        Strength = "Target_Hex_Strength",
        Dexterity = "Target_Hex_Dexterity",
        Intelligence = "Target_Hex_Intelligence",
        Wisdom = "Target_Hex_Wisdom",
        Charisma = "Target_Hex_Charisma",
        Constitution = "Target_Hex_Constitution"
    }

    local hexSpell = hexSpellMap[highestAbility]
    if hexSpell then
        UseSpell(target, hexSpell, GetHostCharacter())
    end
end

local statusToPrefixMap = {
    STONESKIN = "Stoneskin",
    GOLDEN = "Golden",
    BERSERKER = "Berserker",
    BLOODTHIRSTY = "Bloodthirsty",
    PYROMANCER = "Pyromancer",
    CRYOMANCER = "Cryomancer",
    STORMCALLER = "Stormcaller",
    NECROMANCER = "Necromancer",
    ASSASSIN = "Assassin",
    ILLUSIONIST = "Illusionist",
    TRICKSTER = "Trickster",
    DRUID = "Druidic",
    WEBWEAVER = "Webweaver",
    SHAMAN = "Shaman",
    PALADIN = "Paladin",
    HEALER = "Healer",
    PRIEST = "Priest",
    OATHBREAKER = "Oathbreaker",
    HERETIC = "Heretic",
    CEREMORPH = "Ceremorph"
}

local function UpdateEntityDisplayName(entity, prefix)
    local entityObject = Ext.Entity.Get(entity)
    local handle = entityObject.DisplayName.NameKey.Handle.Handle  -- Extracting the handle
    if handle then
        local displayName = Ext.Loca.GetTranslatedString(handle)
        if not displayName:find(prefix) then
            local updatedName = prefix .. " " .. displayName
            Ext.Loca.UpdateTranslatedString(handle, updatedName)
        end
    end
end

local function RemovePrefixFromDisplayName(entity, prefix)
    local entityObject = Ext.Entity.Get(entity)
    local handle = entityObject.DisplayName.NameKey.Handle.Handle  -- Extracting the handle
    if handle then
        local displayName = Ext.Loca.GetTranslatedString(handle)
        local updatedName = displayName:gsub("^" .. prefix .. " ", "")
        Ext.Loca.UpdateTranslatedString(handle, updatedName)
    end
end

local function RemoveAllPrefixesFromDisplayName(entity)
    local entityObject = Ext.Entity.Get(entity)
    local handle = entityObject.DisplayName.NameKey.Handle.Handle  -- Extracting the handle
    if handle then
        local displayName = Ext.Loca.GetTranslatedString(handle)
        for _, prefix in pairs(statusToPrefixMap) do
            displayName = displayName:gsub("^" .. prefix .. " ", "")
        end
        Ext.Loca.UpdateTranslatedString(handle, displayName)
    end
end

-- Golden
local function ApplyGoldenChampionBuffs(entity)
    ApplyStatus(entity, "GOLDEN", timerDuration)
    UpdateEntityDisplayName(entity, "Golden")
    AddBoosts(entity, "TemporaryHP(" .. math.ceil(0.30 * Ext.Entity.Get(entity).Health.MaxHp) .. ")", "", "")
    if math.random(100) <= 50 then TemplateAddTo("7d78f227-e8d4-486d-8121-25cf0bee751d", entity, 1) end -- Potion of Supreme Healing
    if math.random(100) <= 50 then TemplateAddTo("c3236e6e-21e4-4e39-a5b4-fda105d8ce3f", entity, 1) end -- Hearthlight Bomb
end

-- Fighter
local function ApplyStoneSkinBuffs(entity)
    ApplyStatus(entity, "STONESKIN", timerDuration)
    UseSpell(entity, "Target_StoneChampion", entity)
    AddBoosts(entity, "ScaleMultiplier(1.33)", "1", "1")
    UpdateEntityDisplayName(entity, "Stoneskin")
    AddBoosts(entity, "TemporaryHP(" .. math.ceil(0.15 * Ext.Entity.Get(entity).Health.MaxHp) .. ")", "", "")
    if math.random(100) <= 50 then TemplateAddTo("249ff64e-818b-4dc8-919b-7f297f64a2a3", entity, 2) end -- Spiked Bulb
end

-- Berserker
local function ApplyBerserkerBuffs(entity)
    ApplyStatus(entity, "BERSERKER", timerDuration)
    UseSpell(entity, "Shout_Enrage", entity)
    AddBoosts(entity, "ScaleMultiplier(1.2)", "1", "1")
    UpdateEntityDisplayName(entity, "Berserker")
    if math.random(100) <= 50 then TemplateAddTo("b09296f1-2bc3-422e-8735-c13e83ac8801", entity, 1) end -- Haste Spore Flask
    if math.random(100) <= 50 then TemplateAddTo("0b1aa718-fe45-4e4c-8811-ced51c581075", entity, 1) end -- Alchemist's Fire
end

-- Bloodthirsty
local function ApplyBloodthirstyBuffs(entity)
    ApplyStatus(entity, "BLOODTHIRSTY", timerDuration)
    UseSpell(entity, "Target_Rage_Sahuagin", entity)
    UpdateEntityDisplayName(entity, "Bloodthirsty")
    if math.random(100) <= 50 then TemplateAddTo("b09296f1-2bc3-422e-8735-c13e83ac8801", entity, 1) end -- Haste Spore Flask
end

-- Wizard
local function ApplyStormcallerBuffs(entity)
    ApplyStatus(entity, "STORMCALLER", timerDuration)
    UseSpell(entity, "Target_CallLightning", entity)
    ApplyStatus(entity, "TEMPESTUOUS_MAGIC", timerDuration)
    UpdateEntityDisplayName(entity, "Stormcaller")
    if math.random(100) <= 50 then TemplateAddTo("8c7656f5-507a-4cee-8e15-320c968539f0", entity, 1) end -- Greater Elixir of Arcane Cultivation
    if math.random(100) <= 50 then TemplateAddTo("83600284-8f78-409f-a0e0-d262b2bdea64", entity, 1) end -- Scroll of Lightning Bolt
end

-- Necromancer
local function ApplyNecromancerBuffs(entity)
    ApplyStatus(entity, "NECROMANCER", timerDuration)
    UseSpell(entity, "Projectile_RayOfSickness", GetHostCharacter())
    UseSpell(entity, "Target_AnimateDead_Zombie", entity)
    UpdateEntityDisplayName(entity, "Necromancer")
    if math.random(100) <= 50 then TemplateAddTo("8b9b4657-93f3-4382-b6e0-a587902abcba", entity, 1) end -- Scroll of Animate Dead
end

-- Pyromancer
local function ApplyPyromancerBuffs(entity)
    ApplyStatus(entity, "PYROMANCER", timerDuration)
    UseSpell(entity, "Shout_Pyromancer", entity)
    UseSpell(entity, "Projectile_FireBolt", GetHostCharacter())
    UpdateEntityDisplayName(entity, "Pyromancer")
    if math.random(100) <= 50 then TemplateAddTo("79d2bb95-53fc-4e41-a004-5e1b83db8de7", entity, 1) end -- Scroll of Fireball
end

-- Cryomancer
local function ApplyCryomancerBuffs(entity)
    ApplyStatus(entity, "CRYOMANCER", timerDuration)
    UseSpell(entity, "Projectile_RayOfFrost", GetHostCharacter())
    UpdateEntityDisplayName(entity, "Cryomancer")
    if math.random(100) <= 50 then TemplateAddTo("ce8a15ef-be30-4af1-9ecb-ebfcf8b637a9", entity, 1) end -- Elixir of Cold Resistance
    if math.random(100) <= 50 then TemplateAddTo("e81e7b31-8e7a-4fc1-977d-9a9a58fdd4a0", entity, 1) end -- Scroll of Cone of Cold
end

-- Assassin
local function ApplyAssassinBuffs(entity)
    UseSpell(entity, "Target_Invisibility", entity)
    ApplyStatus(entity, "ASSASSIN", timerDuration)
    AddBoosts(entity, "ScaleMultiplier(0.9)", "1", "1")
    UpdateEntityDisplayName(entity, "Assassin")
    if math.random(100) <= 50 then TemplateAddTo("809d5026-4896-4b3a-986e-95da58da77e2", entity, 1) end -- Potion of Invisibility
    if math.random(100) <= 50 then TemplateAddTo("5e282d02-6a10-44cb-9737-9d52aab0701c", entity, 1) end -- Flashblinder
    if math.random(100) <= 50 then TemplateAddTo("a9ced623-a25d-4d2b-bca5-644b7230c869", entity, 1) end -- Scroll of Shocking Grasp
end

-- Illusionist
local function ApplyIllusionistBuffs(entity)
    ApplyStatus(entity, "ILLUSIONIST", timerDuration)
    UseSpell(entity, "Shout_MirrorImage", entity)
    UpdateEntityDisplayName(entity, "Illusionist")
    if math.random(100) <= 50 then TemplateAddTo("0138e3a4-4576-45a8-8592-85fa9adaee59", entity, 1) end -- Potion of Gaseous Form
    if math.random(100) <= 50 then TemplateAddTo("278271f9-3fbc-4cf7-a5dc-b36527f521b2", entity, 1) end -- Smokepowder Bomb
end

-- Trickster
local function ApplyTricksterBuffs(entity)
    ApplyStatus(entity, "TRICKSTER", timerDuration)
    UpdateEntityDisplayName(entity, "Trickster")
    if math.random(100) <= 50 then TemplateAddTo("b8a2f9e4-3b5e-4418-af05-5ca3cd40dd71", entity, 1) end -- Elixir of Guileful Movement
    if math.random(100) <= 50 then TemplateAddTo("9320005f-18c6-4c2b-be7f-e168d3b15573", entity, 1) end -- Noxious Spore Grenade
    if math.random(100) <= 50 then TemplateAddTo("8bc1a0d8-af28-45b2-b1ca-1f15e3c47b1b", entity, 1) end -- Scroll of Tasha's Hideous Laughter
end

-- Druid
local function ApplyDruidBuffs(entity)
    ApplyStatus(entity, "DRUID", timerDuration)
    UpdateEntityDisplayName(entity, "Druidic")
    UseSpell(entity, "Target_NaturesWrath", GetHostCharacter())
    Ext.Timer.WaitFor(3000, function()
        UseSpell(entity, "Shout_WildShape_Bear_NPC", entity)
    end)
    if math.random(100) <= 50 then TemplateAddTo("0aacb1f9-116a-45ec-9b0c-cb436301d4b2", entity, 1) end -- Elixir of the Colossus
    if math.random(100) <= 50 then TemplateAddTo("e296f1a-dc83-4d50-99ef-39ce78d2d630", entity, 1) end -- Grease Bottle
end

-- Webweaver
local function ApplyWebweaverBuffs(entity)
    ApplyStatus(entity, "WEBWEAVER", timerDuration)
    Ext.Timer.WaitFor(3000, function()
        UseSpell(entity, "Shout_WildShape_Spider_NPC", entity)
    end)
    UpdateEntityDisplayName(entity, "Webweaver")
    if math.random(100) <= 50 then TemplateAddTo("a4d98266-948b-4467-96cd-6a316f37ceda", entity, 1) end -- Web Grenade
end

-- Shaman
local function ApplyShamanBuffs(entity)
    ApplyStatus(entity, "SHAMAN", timerDuration)
    UseSpell(entity, "Shout_SymbioticEntity", entity)
    UpdateEntityDisplayName(entity, "Shaman")
    if math.random(100) <= 50 then TemplateAddTo("cbc47f2b-b88a-4bd8-99cd-aacc2dc2ea44", entity, 1) end -- Fungal Bamboozler
    if math.random(100) <= 50 then TemplateAddTo("6fd2d3d4-801c-4591-9c05-db8a68e51808", entity, 1) end -- Scroll of Vampiric Touch
end

-- Paladin
local function ApplyPaladinBuffs(entity)
    ApplyStatus(entity, "PALADIN", timerDuration)
    UpdateEntityDisplayName(entity, "Paladin")
    if math.random(100) <= 50 then TemplateAddTo("bb27cc17-5af9-4d53-818b-3e620f3f59f2", entity, 1) end -- Elixir of Heroism
    if math.random(100) <= 50 then TemplateAddTo("b878380f-7248-4b06-83f8-2d26055497c8", entity, 1) end -- Holy Water
end

-- Healer
local function ApplyHealerBuffs(entity)
    ApplyStatus(entity, "HEALER", timerDuration)
    UseSpell(entity, "Target_HealingWord", entity)
    UpdateEntityDisplayName(entity, "Healer")
    if math.random(100) <= 50 then TemplateAddTo("d47006e9-8a51-453d-b200-9e0d42e9bbab", entity, 3) end -- Potion of Healing
end

-- Priest
local function ApplyPriestBuffs(entity)
    ApplyStatus(entity, "PRIEST", timerDuration)
    UseSpell(entity, "Shout_TurnUndead", entity)
    UpdateEntityDisplayName(entity, "Priest")
    if math.random(100) <= 50 then TemplateAddTo("d106106a-3905-4acb-a24a-764940b61d9c", entity, 1) end -- Elixir of See Invisibility
end

-- Oathbreaker
local function ApplyOathbreakerBuffs(entity)
    ApplyStatus(entity, "OATHBREAKER", timerDuration)
    ApplyHexOnHighestAbility(GetHostCharacter())
    UpdateEntityDisplayName(entity, "Oathbreaker")
    if math.random(100) <= 50 then TemplateAddTo("58142e85-57d4-4bdf-b7f1-04f5804bcce6", entity, 1) end -- Elixir of Radiant Resistance
    if math.random(100) <= 50 then TemplateAddTo("9220d896-4ff3-430f-9523-00d2a4dfbc17", entity, 1) end -- Runepowder Vial
    if math.random(100) <= 50 then TemplateAddTo("48fbab09-ede1-4093-9223-38c9e172c061", entity, 1) end -- Scroll of Bestow Curse
end

-- Heretic
local function ApplyHereticBuffs(entity)
    ApplyStatus(entity, "HERETIC", timerDuration)
    UseSpell(entity, "Target_Bane", GetHostCharacter())
    UpdateEntityDisplayName(entity, "Heretic")
    if math.random(100) <= 50 then TemplateAddTo("3b447e07-3e73-4906-9f7e-63a87e2da909", entity, 1) end -- Scroll of Dominate Person
end

-- Ceremorph
local function ApplyCeremorphBuffs(entity)
    ApplyStatus(entity, "CEREMORPH", timerCeremorphDuration)
    UpdateEntityDisplayName(entity, "Ceremorph")
    if math.random(100) <= 50 then TemplateAddTo("10b6acda-aa4e-46b1-aa9a-e45ab914a28d", entity, 2) end -- Void Bulb
    if math.random(100) <= 50 then TemplateAddTo("d44a454c-3a09-4b93-b982-79f7ee019703", entity, 1) end -- Tadpole Elixir
end

function GetCharacterId(rawId)
    -- Assume some characters might be prefixed that need to be stripped out
    return rawId:match(".*_(.*)") or rawId
end

-- Function to calculate distance between two entities
local function CalculateDistance(uuid1, uuid2)
    local x1, y1, z1 = Osi.GetPosition(uuid1)
    local x2, y2, z2 = Osi.GetPosition(uuid2)
    return Ext.Math.Distance({x1, y1, z1}, {x2, y2, z2})
end

local function GetLowestHPAlly(enemyEntity)
    local lowestHPAlly = nil
    local lowestHP = math.huge

    for _, allyEntity in ipairs(Enemies) do
        if allyEntity ~= enemyEntity then
            local allyHP = Ext.Entity.Get(allyEntity).Health.Hp
            if IsDead(allyEntity) == 0 and allyHP < lowestHP then
                lowestHP = allyHP
                lowestHPAlly = allyEntity
            end
        end
    end

    return lowestHPAlly or enemyEntity
end

local function GetLowestHPPlayer()
    local lowestHPPlayer = nil
    local lowestHP = math.huge

    for _, playerEntity in ipairs(Party) do
        local playerHP = Ext.Entity.Get(playerEntity).Health.Hp
        if playerHP < lowestHP and IsDead(playerEntity) == 0 then
            lowestHP = playerHP
            lowestHPPlayer = playerEntity
        end
    end

    return lowestHPPlayer
end

local function FindNearestPlayer(enemyEntity)
    local nearestPlayer = nil
    local smallestDistance = math.huge

    for _, playerEntity in ipairs(Party) do
        local currentDistance = CalculateDistance(enemyEntity, playerEntity)
        if currentDistance < smallestDistance and IsDead(playerEntity) == 0 then
            smallestDistance = currentDistance
            nearestPlayer = playerEntity
        end
    end

    return nearestPlayer 
end

local function FindNearestAlly(enemyEntity)
    local nearestAlly = nil
    local smallestDistance = math.huge

    for _, allyEntity in ipairs(Enemies) do
        if allyEntity ~= enemyEntity then
            local currentDistance = CalculateDistance(enemyEntity, allyEntity)
            if currentDistance < smallestDistance and IsDead(allyEntity) == 0 then
                smallestDistance = currentDistance
                nearestAlly = allyEntity
            end
        end
    end

    return nearestAlly or enemyEntity
end

local function CountPartyMembersInRadius(entity, radius)
    local count = 0

    for _, playerEntity in ipairs(Party) do
        if IsDead(playerEntity) == 0 and CalculateDistance(entity, playerEntity) <= radius then
            count = count + 1
        end
    end

    return count
end

local function CountAlliesInRadius(entity, radius)
    local count = 0

    for _, allyEntity in ipairs(Enemies) do
        if allyEntity ~= entity and IsEnemy(entity, allyEntity) == 0 and IsDead(allyEntity) == 0 and CalculateDistance(entity, allyEntity) <= radius then
            count = count + 1
        end
    end

    return count
end

local function GetFurthestPlayerInRadius(entity, radius)
    local furthestPlayer = nil
    local largestDistance = 0

    for _, playerEntity in ipairs(Party) do
        local currentDistance = CalculateDistance(entity, playerEntity)
        if IsDead(playerEntity) == 0 and currentDistance <= radius and currentDistance > largestDistance then
            largestDistance = currentDistance
            furthestPlayer = playerEntity
        end
    end

    return furthestPlayer
end

local function GetNearestPlayerInRadius(entity, radius)
    local nearestPlayer = nil
    local smallestDistance = radius

    for _, playerEntity in ipairs(Party) do
        local currentDistance = CalculateDistance(entity, playerEntity)
        if IsDead(playerEntity) == 0 and currentDistance <= radius and currentDistance < smallestDistance then
            smallestDistance = currentDistance
            nearestPlayer = playerEntity
        end
    end

    return nearestPlayer
end

local function GetNextNearestPlayer(entity, status)
    local checkedPlayers = {}

    while #checkedPlayers < #Party do
        local nearestPlayer = nil
        local smallestDistance = math.huge

        for _, playerEntity in ipairs(Party) do
            if not checkedPlayers[playerEntity] then
                local currentDistance = CalculateDistance(entity, playerEntity)
                if IsDead(playerEntity) == 0 and currentDistance < smallestDistance then
                    smallestDistance = currentDistance
                    nearestPlayer = playerEntity
                end
            end
        end

        if nearestPlayer and HasActiveStatus(nearestPlayer, status) == 0 then
            return nearestPlayer
        end

        checkedPlayers[nearestPlayer] = true
    end

    return nil  -- Return nil if all players have the status
end

local function CastHealingSpell(object, spell, target)
    local targetHP = Ext.Entity.Get(target).Health.Hp
    local targetMaxHP = Ext.Entity.Get(target).Health.MaxHp
    
    if targetHP < targetMaxHP then
        UseSpell(object, spell, target)
        if Vars["Debug"] then print(spell .. " used on " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(target).DisplayName.NameKey.Handle.Handle)) end
    else
        if Vars["Debug"] then print(spell .. " not used on " .. Ext.Loca.GetTranslatedString(Ext.Entity.Get(target).DisplayName.NameKey.Handle.Handle) .. " (HP is full)") end
    end
end

function ExistsInEnemiesList(target)
    for i = #Enemies, 1, -1 do
        if target == Enemies[i] then
            return 1
        end
    end
    return 0
end

function RemoveFromEnemiesTable(target)
    for k, v in pairs(Enemies) do
        for i, v in ipairs(Enemies) do
            if v == target then
                --print("removing from table " .. Enemies[i])
                return table.remove(Enemies, i)
            end
        end
    end
end

local function GetResources(entity)
    if entity then
        local resources = entity.ActionResources.Resources 
        if resources then
            return resources
        end
    else
        return
    end
end

local function DetermineClassByResources(entity)
    local cleanCharacterId = GetCharacterId(entity)
    local entityObject = Ext.Entity.Get(cleanCharacterId)
    local resources = GetResources(entityObject)
    
    -- Define mappings from resource names to classes
    local resourceClassMappings = {
        SuperiorityDie = "Fighter",
        SneakAttack_Charge = "Rogue",
        ChannelDivinity = "Cleric",
        ChannelOath = "Paladin",
        Rage = "Fighter",
        SpellSlot = "Wizard" 
    }

    if resources then
        for UUID, entity_data in pairs(resources) do
            local resourceName = Ext.StaticData.Get(UUID, "ActionResource").Name

            -- Check if the resource is associated with a class and if it's active (MaxAmount > 0)
            if entity_data[1].MaxAmount > 0 then
                local class = resourceClassMappings[resourceName]
                if class then
                    return class
                end
            end
        end
    end

    return "Unknown"
end

Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", function(object, combatGuid)
    -- Set the current combat ID
    Current_combat = combatGuid


    -- Check if the object is a character, not a party member, is an enemy, and is not an origin character
    if IsCharacter(object) == 1 and IsPartyMember(object,1) == 0 and IsEnemy(object, GetHostCharacter()) == 1 and CheckIfOrigin(object) == 0 then
        -- Insert the character into the Enemies table
        table.insert(Enemies, object)
        if Vars["Debug"] then print(Ext.Loca.GetTranslatedString(Ext.Entity.Get(object).DisplayName.NameKey.Handle.Handle) .. " added to Enemies table") end
    end
end)

local entityBuffs = {}
local processedEntities = {}  -- Track entities that have been processed

Ext.Osiris.RegisterListener("HitpointsChanged", 2, "after", function(entity, percentage)
    if Vars["EnableChampions"] and IsEnemy(entity, GetHostCharacter()) == 1 and IsPartyMember(entity, 1) == 0 and IsInCombat(entity) == 1 and CheckIfOrigin(object) == 0 then
        if Vars["OnlyChampionClones"] and (HasActiveStatus(entity, "SAVAGE_CLONE") == 0 and HasActiveStatus(entity, "SAVAGE_CLONE2") == 0) then
            return  -- Skip processing if the entity does not have either clone status
        end
        if not processedEntities[entity] then  -- Check if the entity has already been processed
            local chance, healthLimit = tonumber(Vars["ChampionsChance"]), tonumber(Vars["ChampionsHealth"])
            if percentage and percentage <= healthLimit then
                processedEntities[entity] = true
                if math.random(100) <= chance then
                    Ext.Timer.WaitFor(500, function()
                        if IsDead(entity) == 0 and not entityBuffs[entity] and HasActiveStatus(entity,"KNOCKED_DOWN") == 0 then
                            local class = DetermineClassByResources(entity)
                            local charName = Ext.Loca.GetTranslatedString(Ext.Entity.Get(entity).DisplayName.NameKey.Handle.Handle)

                            if Vars["Debug"] then
                                print(charName .. " has been identified as class: " .. (class or "Unknown"))
                            end

                            local buffs = {
                                Wizard = {},
                                Fighter = {},
                                Rogue = {},
                                Cleric = {},
                                Paladin = {},
                                Druid = {},
                                RandomizedClassless = {}
                            }

                            if Vars["EnablePyromancer"] then table.insert(buffs.Wizard, "PYROMANCER") end
                            if Vars["EnableCryomancer"] then table.insert(buffs.Wizard, "CRYOMANCER") end
                            if Vars["EnableStormcaller"] then table.insert(buffs.Wizard, "STORMCALLER") end
                            if Vars["EnableNecromancer"] then table.insert(buffs.Wizard, "NECROMANCER") end
                            if Vars["EnableStoneskin"] then table.insert(buffs.Fighter, "STONESKIN") end
                            if Vars["EnableBerserker"] then table.insert(buffs.Fighter, "BERSERKER") end
                            if Vars["EnableBloodthirsty"] then table.insert(buffs.Fighter, "BLOODTHIRSTY") end
                            if Vars["EnableAssassin"] then table.insert(buffs.Rogue, "ASSASSIN") end
                            if Vars["EnableIllusionist"] then table.insert(buffs.Rogue, "ILLUSIONIST") end
                            if Vars["EnableTrickster"] then table.insert(buffs.Rogue, "TRICKSTER") end
                            if Vars["EnablePaladin"] then table.insert(buffs.Cleric, "PALADIN") end
                            if Vars["EnableHealer"] then table.insert(buffs.Cleric, "HEALER") end
                            if Vars["EnablePriest"] then table.insert(buffs.Cleric, "PRIEST") end
                            if Vars["EnablePaladin"] then table.insert(buffs.Paladin, "PALADIN") end
                            if Vars["EnableOathbreaker"] then table.insert(buffs.Paladin, "OATHBREAKER") end
                            if Vars["EnableHeretic"] then table.insert(buffs.Paladin, "HERETIC") end
                            if Vars["EnableWebweaver"] then table.insert(buffs.Druid, "WEBWEAVER") end
                            if Vars["EnableDruid"] then table.insert(buffs.Druid, "DRUID") end
                            if Vars["EnableShaman"] then table.insert(buffs.Druid, "SHAMAN") end
                            if Vars["EnableCeremorph"] then table.insert(buffs.Wizard, "CEREMORPH") end

                            for _, buff in ipairs(buffs.Wizard) do table.insert(buffs.RandomizedClassless, buff) end
                            for _, buff in ipairs(buffs.Fighter) do table.insert(buffs.RandomizedClassless, buff) end
                            for _, buff in ipairs(buffs.Rogue) do table.insert(buffs.RandomizedClassless, buff) end
                            for _, buff in ipairs(buffs.Cleric) do table.insert(buffs.RandomizedClassless, buff) end
                            for _, buff in ipairs(buffs.Paladin) do table.insert(buffs.RandomizedClassless, buff) end
                            for _, buff in ipairs(buffs.Druid) do table.insert(buffs.RandomizedClassless, buff) end

                            local applyBuffs = {
                                PYROMANCER = ApplyPyromancerBuffs,
                                CRYOMANCER = ApplyCryomancerBuffs,
                                STORMCALLER = ApplyStormcallerBuffs,
                                STONESKIN = ApplyStoneSkinBuffs,
                                BERSERKER = ApplyBerserkerBuffs,
                                BLOODTHIRSTY = ApplyBloodthirstyBuffs,
                                ASSASSIN = ApplyAssassinBuffs,
                                ILLUSIONIST = ApplyIllusionistBuffs,
                                TRICKSTER = ApplyTricksterBuffs,
                                PALADIN = ApplyPaladinBuffs,
                                HEALER = ApplyHealerBuffs,
                                PRIEST = ApplyPriestBuffs,
                                WEBWEAVER = ApplyWebweaverBuffs,
                                SHAMAN = ApplyShamanBuffs,
                                NECROMANCER = ApplyNecromancerBuffs,
                                DRUID = ApplyDruidBuffs,
                                OATHBREAKER = ApplyOathbreakerBuffs,
                                HERETIC = ApplyHereticBuffs,
                                CEREMORPH = ApplyCeremorphBuffs
                            }

                            local selectedMode
                            if class ~= "Unknown" and buffs[class] and #buffs[class] > 0 then
                                selectedMode = buffs[class][math.random(#buffs[class])]
                            elseif class == "Unknown" and Vars["RandomizedClassless"] and #buffs.RandomizedClassless > 0 then
                                selectedMode = buffs.RandomizedClassless[math.random(#buffs.RandomizedClassless)]
                            end

                            if selectedMode then
                                if Vars["Debug"] then
                                    print(Ext.Loca.GetTranslatedString(Ext.Entity.Get(entity).DisplayName.NameKey.Handle.Handle) .. " will become a " .. selectedMode)
                                end
                                applyBuffs[selectedMode](entity)
                                entityBuffs[entity] = selectedMode
                            end
                        end

                        if HasActiveStatus(entity,"KNOCKED_DOWN") == 0 and IsDead(entity) == 0 and entityBuffs[entity] and Vars["EnableGoldenChampion"] and percentage <= Vars["GoldenChampionHealth"] and math.random(100) <= Vars["GoldenChampionChance"] and HasActiveStatus(entity,"GOLDEN") == 0 and HasActiveStatus(entity,"KNOCKED_DOWN") == 0 then
                            ApplyGoldenChampionBuffs(entity)
                        end
                    end)
                end
            end
        end
    end
end)


Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function(object)
    -- Check and update display name based on status
    for status, prefix in pairs(statusToPrefixMap) do
        if HasActiveStatus(object, status) == 1 then
            UpdateEntityDisplayName(object, prefix)
        end
    end
    
    if entityBuffs[object] then
        local mode = entityBuffs[object]
        local lowestHPPlayer = GetLowestHPPlayer()
        local nearestPlayer = FindNearestPlayer(object)
        local lowestHPAlly = GetLowestHPAlly(object)
        local nearestAlly = FindNearestAlly(object)
        local countPartyMembersInRadius = CountPartyMembersInRadius(object, 3)
        local countAlliesInRadius = CountAlliesInRadius(object, 3)

        if mode == "PYROMANCER" then
            CreateSurface(object, "SurfaceFire", 1, 12)
            UseSpell(object, "Projectile_FireBolt", nearestPlayer)
        elseif mode == "CRYOMANCER" then
            CreateSurface(object, "SurfaceWaterFrozen", 1, 12)
            UseSpell(object, "Projectile_RayOfFrost", lowestHPPlayer)
        elseif mode == "STORMCALLER" then
            CreateSurface(object, "SurfaceWaterElectrified", 1, 12)
            if countPartyMembersInRadius >= 2 then
                UseSpell(object, "Target_CallLightning", nearestPlayer)
            else
                UseSpell(object, "Target_Projectile_LightningArrow", lowestHPPlayer)
            end
        elseif mode == "STONESKIN" then
        elseif mode == "BERSERKER" then
            CreateSurface(object, "SurfaceBlood", 1, 12)
            if countPartyMembersInRadius >= 2 then
                UseSpell(object, "Zone_Thunderwave", nearestPlayer)
            end
        elseif mode == "BLOODTHIRSTY" then
            CreateSurface(object, "SurfaceBlood", 1, 12)
            UseSpell(object, "Target_VampiricTouch", lowestHPPlayer)
        elseif mode == "ASSASSIN" then
            UseSpell(object, "Target_Assassinate", lowestHPPlayer)
        elseif mode == "ILLUSIONIST" then
            UseSpell(object, "Target_Hallucination", nearestPlayer)
        elseif mode == "TRICKSTER" then
            local targetPlayer = nearestPlayer
            if HasActiveStatus(targetPlayer, "HIDEOUS_LAUGHTER") == 1 then
                targetPlayer = GetNextNearestPlayer(object, "HIDEOUS_LAUGHTER")
            end
            if targetPlayer then
                UseSpell(object, "Target_HideousLaughter", targetPlayer)
            end
        elseif mode == "PALADIN" then
            CreateSurface(object, "SurfaceHolyFire", 1, 12)
            UseSpell(object, "Target_SacredFlame", lowestHPPlayer)
        elseif mode == "HEALER" then
            if countAlliesInRadius >= 2 then
                CastHealingSpell(object, "Target_MassHealing", nearestHPAlly)
            else
                CastHealingSpell(object, "Target_HealingTouch", lowestHPAlly)
            end
        elseif mode == "PRIEST" then
            UseSpell(object, "Target_Bless", lowestHPAlly)
        elseif mode == "WEBWEAVER" then
            CreateSurface(object, "SurfaceWeb", 2, 10)
            UseSpell(object, "Target_Ensnare", nearestPlayer)
        elseif mode == "DRUID" then
            CreateSurface(object, "SurfaceVines", 1, 12)
            UseSpell(object, "Target_Entangle", nearestPlayer)
        elseif mode == "SHAMAN" then
            UseSpell(object, "Target_HaloOfSpores", nearestPlayer)
        elseif mode == "NECROMANCER" then
            UseSpell(object, "Projectile_RayOfSickness", nearestPlayer)
        elseif mode == "HERETIC" then
            UseSpell(object, "Target_PhantasmalKiller", nearestPlayer)
        end
    end
end)

Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function(object) 
    if entityBuffs[object] then
        local mode = entityBuffs[object]
        local lowestHPPlayer = GetLowestHPPlayer()
        local nearestPlayer = FindNearestPlayer(object)
        local lowestHPAlly = GetLowestHPAlly(object)
        local nearestAlly = FindNearestAlly(object)
        if mode == "ASSASSIN" and HasActiveStatus(object, "INVISIBILITY") == 0 then 
            UseSpell(object,"Target_Invisibility", object)
        end
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, applyStoryActionID)
    if entityBuffs[object] and entityBuffs[object] == status then

        for _, prefix in pairs(statusToPrefixMap) do
            RemovePrefixFromDisplayName(object, prefix)
        end

        Ext.Timer.WaitFor(1000, function()
            if IsDead(object) == 0 and HasActiveStatus(object,"KNOCKED_DOWN") == 0 then
                local mode = status
                local lowestHPPlayer = GetLowestHPPlayer()
                local nearestPlayer = FindNearestPlayer(object)
                local lowestHPAlly = GetLowestHPAlly(object)
                local nearestAlly = FindNearestAlly(object)

                if mode == "PYROMANCER" then
                    UseSpell(object, "Projectile_Fireball", nearestPlayer)
                elseif mode == "CRYOMANCER" then
                    UseSpell(object, "Target_IceStorm", lowestHPPlayer)
                elseif mode == "STORMCALLER" then
                    UseSpell(object, "Projectile_LightningArrow", nearestPlayer)
                elseif mode == "STONESKIN" then
                    UseSpell(object, "Target_Stoneskin", object)
                elseif mode == "BERSERKER" then
                    UseSpell(object, "Rush_Rush_DeepRothe_NPC", lowestHPPlayer)
                elseif mode == "BLOODTHIRSTY" then
                    UseSpell(object, "Target_VampiricTouch", nearestPlayer)
                elseif mode == "ASSASSIN" then
                    UseSpell(object, "Target_ShadowStep", nearestPlayer)
                elseif mode == "ILLUSIONIST" then
                    UseSpell(object, "Target_PhantasmalKiller", lowestHPPlayer)
                elseif mode == "TRICKSTER" then
                    UseSpell(object, "Target_CrownOfMadness", nearestPlayer)
                elseif mode == "PALADIN" then
                    UseSpell(object, "Shout_HealingRadiance", object)
                elseif mode == "HEALER" then
                    UseSpell(object, "Shout_PreserveLife", object)
                elseif mode == "PRIEST" then
                    UseSpell(object, "Target_DivineGuardian", lowestHPAlly)
                elseif mode == "WEBWEAVER" then
                    UseSpell(object, "Projectile_SpiderlingSpawning", nearestPlayer)
                elseif mode == "DRUID" then
                    UseSpell(object, "Shout_WildShape_Badger_NPC", object)
                elseif mode == "SHAMAN" then
                    UseSpell(object, "Target_SporeCloud", lowestHPPlayer)
                elseif mode == "NECROMANCER" then
                    UseSpell(object, "Target_DrainLife", lowestHPPlayer)
                elseif mode == "CEREMORPH" then
                    UseSpell(object, "Shout_MindFlayerForm", object)
                end 
            end
        end)
        
    end
end)

Ext.Osiris.RegisterListener("Dying", 1, "after", function(entity)
    -- Check and remove prefix based on status
    for _, prefix in pairs(statusToPrefixMap) do
        RemoveAllPrefixesFromDisplayName(entity)
    end

    -- Remove character from Enemies table when they die
    if ExistsInEnemiesList(entity) == 1 then
        RemoveFromEnemiesTable(entity)
        if Vars["Debug"] then print(Ext.Loca.GetTranslatedString(Ext.Entity.Get(entity).DisplayName.NameKey.Handle.Handle) .. " removed from Enemies table") end
    end

    -- Create surfaces based on mode if entity has buffs
    if entityBuffs[entity] then
        local mode = entityBuffs[entity]

        if mode == "PYROMANCER" then
            CreateSurface(entity, "SurfaceFire", 2, 18)
        elseif mode == "CRYOMANCER" then
            CreateSurface(entity, "SurfaceWaterFrozen", 2, 18)
        elseif mode == "STORMCALLER" then
            CreateSurface(entity, "SurfaceWaterElectrified", 2, 18)
        elseif mode == "STONESKIN" then
            CreateSurface(entity, "SurfaceMud", 2, 18)
        elseif mode == "BERSERKER" then
            CreateSurface(entity, "SurfaceCausticBrine", 2, 18)
        elseif mode == "BLOODTHIRSTY" then
            CreateSurface(entity, "SurfaceBlood", 2, 18)
        elseif mode == "ASSASSIN" then
            CreateSurface(entity, "SurfaceDarknessCloud", 2, 18)
        elseif mode == "ILLUSIONIST" then
            CreateSurface(entity, "SurfaceNarcolepticCloud", 2, 18)
        elseif mode == "TRICKSTER" then
            CreateSurface(entity, "SurfaceMaliceCloud", 2, 18)
        elseif mode == "PALADIN" then
            CreateSurface(entity, "SurfaceHolyFire", 2, 18)
        elseif mode == "HEALER" then
            CreateSurface(entity, "SurfaceSporePinkCloud", 2, 18)
        elseif mode == "PRIEST" then
            CreateSurface(entity, "SurfaceSporeWhiteCloud", 2, 18)
        elseif mode == "WEBWEAVER" then
            CreateSurface(entity, "SurfaceWeb", 2, 18)
        elseif mode == "DRUID" then
            CreateSurface(entity, "SurfaceVines", 2, 18)
        elseif mode == "SHAMAN" then
            CreateSurface(entity, "SurfaceSporeBlackCloud", 2, 18)
        elseif mode == "NECROMANCER" then
            CreateSurface(entity, "SurfaceShadowCursedVines", 2, 18)
        elseif mode == "CEREMORPH" then
            CreateSurface(entity, "SurfaceBlackTentacles", 2, 18)
        end
    end
    -- Clear the entity from tracking tables
    entityBuffs[entity] = nil
    processedEntities[entity] = nil
end)


-- Register a listener for when combat ends
Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
    -- Iterate through the Enemies table and remove prefixes from their display names
    for _, entity in ipairs(Enemies) do
        RemoveAllPrefixesFromDisplayName(entity)
    end

    -- Clear the Enemies, entityBuffs, and processedEntities tables
    Enemies = {}
    entityBuffs = {}
    processedEntities = {}

    -- Optionally, print debug information
    if Vars["Debug"] then
        print("Combat ended, all entities cleared from tracking tables.")
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode) 
    -- Populate the Party table with party member IDs
    for k, d in ipairs(Osi.DB_PartyMembers:Get(nil)) do
        table.insert(Party, d[1])
    end
end)

Ext.Osiris.RegisterListener("CharacterLeftParty", 1, "after", function(character) 
    Party = {}
    for k, d in ipairs(Osi.DB_PartyMembers:Get(nil)) do
        table.insert(Party, d[1])
    end
end)

Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
    Party = {}
    for k, d in ipairs(Osi.DB_PartyMembers:Get(nil)) do
        table.insert(Party, d[1])
    end
end)


Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end
    
    if Vars[payload.settingId] ~= nil then
        Vars[payload.settingId] = payload.value
    end
end)