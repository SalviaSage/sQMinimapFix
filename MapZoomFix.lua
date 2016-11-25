-- Initialize locals
local currentZoom = Minimap:GetZoom()
local zoomInHandler = MinimapZoomIn:GetScript("OnClick")	-- Original minimap button handler
local zoomOutHandler = MinimapZoomOut:GetScript("OnClick")

-- Helpers --
local function updateMinimapButtonState()
	-- print(currentZoom .. "/" .. Minimap:GetZoomLevels())
	if (currentZoom >= Minimap:GetZoomLevels()-1) then
		-- Disable zoom in, enable zoom out
		MinimapZoomIn:Disable()
		MinimapZoomOut:Enable()
	elseif (currentZoom <= 0) then
		-- Disable zoom out, enable zoom in
		MinimapZoomIn:Enable()
		MinimapZoomOut:Disable()
	else
		-- Enable both zoom in and zoom out
		MinimapZoomIn:Enable()
		MinimapZoomOut:Enable()
	end
end

-- Main code -- 
local function eventHandler()
	if (event == "ZONE_CHANGED") or 
			(event == "ZONE_CHANGED_INDOORS") or
			(event == "ZONE_CHANGED_NEW_AREA") then		-- Set zoom level when changing zone
		Minimap:SetZoom(currentZoom)
		updateMinimapButtonState()
		-- print(this:GetName() .. ":\n" .. event .. ", zoom: " .. currentZoom)
	elseif (this:GetName() == "MinimapZoomIn") then		-- Get new zoom level when user adjusts zoom
		zoomInHandler()
		currentZoom = Minimap:GetZoom()
		-- print(this:GetName() .. ":\n" .. "zoom: " .. currentZoom)
	elseif (this:GetName() == "MinimapZoomOut") then
		zoomOutHandler()
		currentZoom = Minimap:GetZoom()
		-- print(this:GetName() .. ":\n" .. "zoom: " .. currentZoom)
	end
end

-- Event registration -- 
local eFrame = CreateFrame("Frame", "MZF event frame", UIParent)
eFrame:Hide()
eFrame:RegisterEvent("ZONE_CHANGED")
eFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
eFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")		-- Zone change events

eFrame:SetScript("OnEvent", eventHandler)
MinimapZoomIn:SetScript("OnClick", eventHandler)
MinimapZoomOut:SetScript("OnClick", eventHandler)	-- Minimap zoom in and out buttons