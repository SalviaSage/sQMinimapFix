--- Initialize locals
local zoomInHandler = MinimapZoomIn:GetScript("OnClick") --- Original minimap button handler
local zoomOutHandler = MinimapZoomOut:GetScript("OnClick")

local function updateMinimapButtonState(zoom)
	if not zoom then
    return
  end
	if zoom >= Minimap:GetZoomLevels()-1 then
		--- Disable zoom in, enable zoom out
		MinimapZoomIn:Disable()
		MinimapZoomOut:Enable()
	elseif (zoom <= 0) then
		--- Disable zoom out, enable zoom in
		MinimapZoomIn:Enable()
		MinimapZoomOut:Disable()
	else
		--- Enable both zoom in and zoom out
		MinimapZoomIn:Enable()
		MinimapZoomOut:Enable()
	end
end
--- Main code
local function eventHandler()
	if event == "MINIMAP_UPDATE_ZOOM" then --- Force minimap zoom level
		--print(event)
		if Minimap:GetZoom() ~= GetCVar("minimapZoom") then
			Minimap:SetZoom(GetCVar("minimapZoom"))
		end
		updateMinimapButtonState(Minimap:GetZoom())
		--print(GetCVar("minimapZoom"))
	else
		if (this:GetName() == "MinimapZoomIn") then --- Update when user adjusts zoom level
			--print(this:GetName())
			zoomInHandler()
		elseif (this:GetName() == "MinimapZoomOut") then
			--print(this:GetName())
			zoomOutHandler()
		end
		local currentZoom = Minimap:GetZoom()
		--print(currentZoom)
		SetCVar("minimapZoom", currentZoom)
	end
	SetCVar("minimapInsideZoom", currentZoom)
end
--- Event registration
local eFrame = CreateFrame("Frame", "sQMinimapFix", UIParent)
local f = CreateFrame("Frame")

f:SetScript("OnEvent", function()
	FCF_SelectDockFrame(DEFAULT_CHAT_FRAME)
end)

Minimap:SetZoom(0)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

eFrame:Hide()
eFrame:RegisterEvent("MINIMAP_UPDATE_ZOOM") --- Capture minimap zoom update events
eFrame:SetScript("OnEvent", eventHandler)

MinimapZoomIn:SetScript("OnClick", eventHandler) --- Capture user clicks on minimap zoom in and out buttons
MinimapZoomOut:SetScript("OnClick", eventHandler)
