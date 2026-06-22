local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("!KRT") then return end

local _G = _G
local ipairs = ipairs
local select = select
local unpack = unpack

-- !KRT (Kader Raid Tools) 0.5.6b
-- https://github.com/bkader/KRT

local applied = false

local function ApplySkin()
	if applied then return end
	if not E.private.addOnSkins.KRT then return end
	applied = true

	local function SkinFrame(frame)
		if not frame then return end
		frame:StripTextures()
		frame:SetTemplate("Transparent")
		local closeBtn = _G[frame:GetName().."CloseButton"]
		if closeBtn then S:HandleCloseButton(closeBtn) end
	end

	-- KRTMaster: Loot Manager
	if KRTMaster then
		SkinFrame(KRTMaster)

		local itemBtn = KRTMasterItemBtn
		if itemBtn then
			itemBtn:SetTemplate()
			itemBtn:StyleButton(nil, true, true)
			local tex = itemBtn:GetNormalTexture()
			if tex then
				tex:SetTexCoord(unpack(E.TexCoords))
				tex:SetInside()
			end
		end

		if KRTMasterHighestRoll then S:HandleCheckBox(KRTMasterHighestRoll) end
		if KRTMasterItemCount then S:HandleEditBox(KRTMasterItemCount) end
		if KRTMasterScrollFrameScrollBar then S:HandleScrollBar(KRTMasterScrollFrameScrollBar) end

		S:HandleButton(KRTMasterConfigBtn)
		S:HandleButton(KRTMasterSelectItemBtn)
		S:HandleButton(KRTMasterSpamLootBtn)
		S:HandleButton(KRTMasterMSBtn)
		S:HandleButton(KRTMasterOSBtn)
		S:HandleButton(KRTMasterFreeBtn)
		S:HandleButton(KRTMasterCountdownBtn)
		S:HandleButton(KRTMasterAwardBtn)
		S:HandleButton(KRTMasterRollBtn)
		S:HandleButton(KRTMasterClearBtn)
		S:HandleButton(KRTMasterHoldBtn)
		S:HandleButton(KRTMasterBankBtn)
		S:HandleButton(KRTMasterDisenchantBtn)

		if KRTMasterHoldDropDown then S:HandleDropDownBox(KRTMasterHoldDropDown) end
		if KRTMasterBankDropDown then S:HandleDropDownBox(KRTMasterBankDropDown) end
		if KRTMasterDisenchantDropDown then S:HandleDropDownBox(KRTMasterDisenchantDropDown) end
	end

	-- KRTConfig: Settings
	if KRTConfig then
		SkinFrame(KRTConfig)
		if KRTConfigcountdownDuration then S:HandleSliderFrame(KRTConfigcountdownDuration) end
		S:HandleButton(KRTConfigDefaultsBtn)
		S:HandleButton(KRTConfigCloseBtn)
		for _, cbName in ipairs({
			"sortAscending", "useRaidWarning", "announceOnWin", "announceOnHold",
			"announceOnBank", "announceOnDisenchant", "lootWhispers",
			"countdownRollsBlock", "screenReminder", "showTooltips", "minimapButton",
		}) do
			local cb = _G["KRTConfig"..cbName]
			if cb then S:HandleCheckBox(cb) end
		end
	end

	-- KRTSpammer: LFM Spam
	if KRTSpammer then
		SkinFrame(KRTSpammer)
		S:HandleButton(KRTSpammerClearBtn)
		S:HandleButton(KRTSpammerStartBtn)
		for _, ebName in ipairs({
			"Name", "Duration", "Tank", "TankClass", "Healer", "HealerClass",
			"Melee", "MeleeClass", "Ranged", "RangedClass", "MinGS", "Message",
		}) do
			local eb = _G["KRTSpammer"..ebName]
			if eb then S:HandleEditBox(eb) end
		end
		-- Chat1-8/ChatGuild/ChatYell are 15x15 SendMailRadioButtonTemplate buttons.
		-- HandleCheckBox's sub-frame backdrop would be 7x7 at 15px (nearly invisible),
		-- and the noBackdrop path overflows the check texture outside the frame, corrupting
		-- neighbouring labels. Manual skin: strip radio textures, apply ElvUI border at
		-- native 15px size so positions don't shift, fit check mark neatly inside.
		local function SkinRadioCheckBox(cb)
			if not cb then return end
			cb:StripTextures()
			cb:SetTemplate()
			if cb.SetCheckedTexture then
				if E.private.skins.checkBoxSkin then
					cb:SetCheckedTexture(E.Media.Textures.Melli)
					local t = cb:GetCheckedTexture()
					if t then
						t:SetVertexColor(1, 0.82, 0, 0.8)
						t:SetInside(cb)
					end
				else
					cb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
					local t = cb:GetCheckedTexture()
					if t then t:SetInside(cb) end
				end
			end
		end
		for i = 1, 8 do
			local cb = _G["KRTSpammerChat"..i]
			if cb then
				SkinRadioCheckBox(cb)
				cb:SetHitRectInsets(0, -20, 0, 0)
			end
		end
		for _, cbName in ipairs({"ChatGuild", "ChatYell"}) do
			local cb = _G["KRTSpammer"..cbName]
			if cb then
				SkinRadioCheckBox(cb)
				cb:SetHitRectInsets(0, -35, 0, 0)
			end
		end
		if KRTSpammerShowSlots then
			S:HandleCheckBox(KRTSpammerShowSlots)
			KRTSpammerShowSlots:ClearAllPoints()
			KRTSpammerShowSlots:SetPoint("TOPLEFT", KRTSpammer, "TOPLEFT", 15, -345)
		end
		if KRTSpammerGsAchNeeded then
			S:HandleCheckBox(KRTSpammerGsAchNeeded)
			KRTSpammerGsAchNeeded:ClearAllPoints()
			KRTSpammerGsAchNeeded:SetPoint("TOPLEFT", KRTSpammer, "TOPLEFT", 15, -369)
		end
	end

	-- KRTWarnings: Raid Warnings
	if KRTWarnings then
		SkinFrame(KRTWarnings)
		if KRTWarningsScrollFrameScrollBar then S:HandleScrollBar(KRTWarningsScrollFrameScrollBar) end
		if KRTWarningsName then S:HandleEditBox(KRTWarningsName) end
		if KRTWarningsContent then S:HandleEditBox(KRTWarningsContent) end
		S:HandleButton(KRTWarningsEditBtn)
		S:HandleButton(KRTWarningsDeleteBtn)
		S:HandleButton(KRTWarningsAnnounceBtn)
	end

	-- KRTChanges: MS Changes
	if KRTChanges then
		SkinFrame(KRTChanges)
		if KRTChangesName then S:HandleEditBox(KRTChangesName) end
		if KRTChangesSpec then S:HandleEditBox(KRTChangesSpec) end
		if KRTChangesScrollFrameScrollBar then S:HandleScrollBar(KRTChangesScrollFrameScrollBar) end
		S:HandleButton(KRTChangesClearBtn)
		S:HandleButton(KRTChangesAddBtn)
		S:HandleButton(KRTChangesEditBtn)
		S:HandleButton(KRTChangesDemandBtn)
		S:HandleButton(KRTChangesAnnounceBtn)
	end

	-- KRTLogger: Loot History
	if KRTLogger then
		SkinFrame(KRTLogger)

		-- Sub-panel frames inherit KRTLoggerFrameTemplate (backdrop only, no textures)
		local loggerPanels = {
			KRTLoggerRaids, KRTLoggerBosses, KRTLoggerBossAttendees,
			KRTLoggerRaidAttendees, KRTLoggerLoot,
		}
		for _, panel in ipairs(loggerPanels) do
			if panel then panel:SetTemplate("Transparent") end
		end

		-- Raids panel
		S:HandleButton(KRTLoggerRaidsCurrentBtn)
		S:HandleButton(KRTLoggerRaidsExportBtn)
		S:HandleButton(KRTLoggerRaidsDeleteBtn)
		S:HandleButton(KRTLoggerRaidsClearAllBtn)
		if KRTLoggerRaidsScrollFrameScrollBar then S:HandleScrollBar(KRTLoggerRaidsScrollFrameScrollBar) end

		-- Bosses panel
		S:HandleButton(KRTLoggerBossesAddBtn)
		S:HandleButton(KRTLoggerBossesEditBtn)
		S:HandleButton(KRTLoggerBossesDeleteBtn)
		if KRTLoggerBossesScrollFrameScrollBar then S:HandleScrollBar(KRTLoggerBossesScrollFrameScrollBar) end

		-- Boss Attendees panel
		S:HandleButton(KRTLoggerBossAttendeesAddBtn)
		S:HandleButton(KRTLoggerBossAttendeesRemoveBtn)
		if KRTLoggerBossAttendeesScrollFrameScrollBar then S:HandleScrollBar(KRTLoggerBossAttendeesScrollFrameScrollBar) end

		-- Raid Attendees panel
		S:HandleButton(KRTLoggerRaidAttendeesAddBtn)
		S:HandleButton(KRTLoggerRaidAttendeesDeleteBtn)
		if KRTLoggerRaidAttendeesScrollFrameScrollBar then S:HandleScrollBar(KRTLoggerRaidAttendeesScrollFrameScrollBar) end

		-- Loot panel
		S:HandleButton(KRTLoggerLootExportBtn)
		S:HandleButton(KRTLoggerLootClearBtn)
		S:HandleButton(KRTLoggerLootAddBtn)
		S:HandleButton(KRTLoggerLootEditBtn)
		S:HandleButton(KRTLoggerLootDeleteBtn)
		if KRTLoggerLootScrollFrameScrollBar then S:HandleScrollBar(KRTLoggerLootScrollFrameScrollBar) end

		-- Boss add/edit popup (KRTSimpleFrameTemplate — backdrop only)
		if KRTLoggerBossBox then
			KRTLoggerBossBox:SetTemplate("Transparent")
			if KRTLoggerBossBoxName then S:HandleEditBox(KRTLoggerBossBoxName) end
			if KRTLoggerBossBoxDifficulty then S:HandleEditBox(KRTLoggerBossBoxDifficulty) end
			if KRTLoggerBossBoxTime then S:HandleEditBox(KRTLoggerBossBoxTime) end
			if KRTLoggerBossBoxSaveBtn then S:HandleButton(KRTLoggerBossBoxSaveBtn) end
		end

		-- Player add popup
		if KRTLoggerPlayerBox then
			KRTLoggerPlayerBox:SetTemplate("Transparent")
			if KRTLoggerPlayerBoxName then S:HandleEditBox(KRTLoggerPlayerBoxName) end
			if KRTLoggerPlayerBoxAddBtn then S:HandleButton(KRTLoggerPlayerBoxAddBtn) end
		end
	end

	-- KRT_MINIMAP_GUI: Minimap Button
	if KRT_MINIMAP_GUI then
		local btn = KRT_MINIMAP_GUI
		local icon = _G["KRT_MINIMAP_GUIIcon"]

		btn:SetTemplate("Default")
		btn:StyleButton(nil, true)
		btn:Size(32, 32)

		if icon then
			icon:Show()
			icon:ClearAllPoints()
			icon:SetInside(btn)
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:SetDrawLayer("ARTWORK")
		end

		for i = 1, btn:GetNumRegions() do
			local region = select(i, btn:GetRegions())
			if region and region:IsObjectType("Texture") and region ~= icon then
				region:Hide()
			end
		end
	end
end

-- !KRT loads before ElvUI so its ADDON_LOADED has already fired.
-- AddCallbackForAddon is kept as a no-op-safe call in case this ElvUI build
-- checks IsAddOnLoaded and fires immediately.
-- The hooksecurefunc on AS:Initialize guarantees the skin fires at PLAYER_LOGIN
-- after all modules are ready, which is the correct time for already-loaded addons.
S:AddCallbackForAddon("!KRT", "!KRT", ApplySkin)
hooksecurefunc(AS, "Initialize", ApplySkin)
