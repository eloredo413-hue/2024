-- [[ 2024 / 2023 / 2021 / 2019 / 2017 / 2013 MOBILE HOOKS + PLACEHOLDERS ]]
-- Run AFTER the main Bloxy Paradox script.
--
-- "2023 new" is now "2024": it loads the 2024 GUI (2024-gui.lua), which
-- sets the 2023 new GUI's fast flags, rejoins like it did, then loads the
-- 2024 top bar (Old Chrome 2024) and the 2023 new GUI's chat. The 2023
-- new GUI's chat icon (LegacyChatIcon) is not part of it.

------------------------------------------------------------
-- PART 1: LOADSTRING HOOK
------------------------------------------------------------
local _ORIG_LS = getgenv().BP_TrueLS
if not _ORIG_LS then
	_ORIG_LS = getgenv().loadstring or loadstring
	getgenv().BP_TrueLS = _ORIG_LS
end

do
	local URL_2024      = "https://raw.githubusercontent.com/eloredo413-hue/2024/main/bloxy-paradox/2024-gui.lua"
	local URL_2023_OLD  = "https://gist.githubusercontent.com/eloredo413-hue/820f4614fccf5cadbd8d84b18ee1635c/raw/6adda6838d3df2e8bd7533c1161eb0585093c2bd/2023%2520old"
	local URL_2021      = "https://gist.githubusercontent.com/eloredo413-hue/46ee252aa3b7420b76431369e2d5e091/raw/02e4c126aecb5efa720a257e005aa319ac7fe43b/2021%2520gui"
	local URL_2019      = "https://gist.githubusercontent.com/eloredo413-hue/2c867970649c45c8bf1eef42c7463787/raw/06e46c2ece7121a20c45728a86644d1d1e7b1e9d/2019%2520gui"
	local URL_2017      = "https://gist.githubusercontent.com/eloredo413-hue/495540d2bae5557547d36718dd46bc95/raw/79c95e9a5b1733dd6d2cdb3d2731c04db41faa76/2017%2520gui"
	local URL_2013MOB   = "https://gist.githubusercontent.com/eloredo413-hue/99a0d6ea7379928e9b14e8d7ead442b3/raw/7d14ea60bf0fbeac7d3e0a450ab632929efb3048/2013%2520Mobile%2520gui"
	local SIG_2023      = "111872120766790"
	local SIG_2013      = "Year = 2013"

	local function fetchURL(url, label)
		print("[" .. label .. "] Fetching...")
		local ok, src = pcall(function()
			return game:HttpGet(url, true)
		end)
		if not ok then
			warn("[" .. label .. "] HTTP fetch failed: " .. tostring(src))
			return nil
		end
		if type(src) ~= "string" or #src < 50 then
			warn("[" .. label .. "] Bad response (" .. tostring(#src) .. " bytes)")
			return nil
		end
		print("[" .. label .. "] Fetched " .. #src .. " bytes.")
		return src
	end

	-- Any other top bar replaces the 2024 one: take the 2024 bar down
	-- first (it gives the native top bar back) so two never overlap.
	local function unload2024()
		local unload = getgenv().OldChrome2024Unload
		if type(unload) == "function" then
			pcall(unload)
		end
	end

	local function patched(code, name)
		if type(code) ~= "string" then
			return _ORIG_LS(code, name)
		end

		local pending = getgenv().BP_PendingTopbar
		local variant = getgenv().BP_2023Variant

		if pending then
			if pending == "2021" and code:find(SIG_2023, 1, true) then
				getgenv().BP_PendingTopbar = nil
				getgenv().BP_2023Variant = nil
				local src = fetchURL(URL_2021, "2021")
				if src then unload2024() return _ORIG_LS(src, name) end
				return _ORIG_LS("-- [Hook] 2021 fetch failed", name)

			elseif pending == "2019" and code:find(SIG_2023, 1, true) then
				getgenv().BP_PendingTopbar = nil
				getgenv().BP_2023Variant = nil
				local src = fetchURL(URL_2019, "2019")
				if src then unload2024() return _ORIG_LS(src, name) end
				return _ORIG_LS("-- [Hook] 2019 fetch failed", name)

			elseif pending == "2017" and code:find(SIG_2023, 1, true) then
				getgenv().BP_PendingTopbar = nil
				getgenv().BP_2023Variant = nil
				local src = fetchURL(URL_2017, "2017")
				if src then unload2024() return _ORIG_LS(src, name) end
				return _ORIG_LS("-- [Hook] 2017 fetch failed", name)

			elseif pending == "2013mobile" and code:find(SIG_2013, 1, true) then
				getgenv().BP_PendingTopbar = nil
				getgenv().BP_2023Variant = nil
				local src = fetchURL(URL_2013MOB, "2013 mobile")
				if src then unload2024() return _ORIG_LS(src, name) end
				return _ORIG_LS("-- [Hook] 2013 mobile fetch failed", name)
			end
		end

		if variant and code:find(SIG_2023, 1, true) then
			getgenv().BP_2023Variant = nil

			-- "new" is what the old "2023 new" button set.
			if variant == "2024" or variant == "new" then
				print("[2024 Hook] Loading the 2024 GUI (2023 flags, rejoin, 2024 top bar, 2023 chat)...")
				local src = fetchURL(URL_2024, "2024")
				if src then return _ORIG_LS(src, name) end
				warn("[2024 Hook] Fetch failed — falling back to base 2023.")
			elseif variant == "old" then
				print("[2023 Hook] Loading OLD 2023 GUI...")
				local src = fetchURL(URL_2023_OLD, "2023 old")
				if src then unload2024() return _ORIG_LS(src, name) end
				warn("[2023 Hook] OLD fetch failed — falling back to base 2023.")
			end
		end

		return _ORIG_LS(code, name)
	end

	pcall(function() getgenv().loadstring = patched end)
	pcall(function() _G.loadstring = patched end)
	print("[Hooks] Installed.")
end

------------------------------------------------------------
-- PART 2: WIZARD DROPDOWN REWIRING
------------------------------------------------------------
task.spawn(function()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")

	local player = Players.LocalPlayer
	local pg = player:WaitForChild("PlayerGui")
	local sg = pg:WaitForChild("BloxyParadoxProject", 30)
	if not sg then
		warn("[Topbar Addon] GUI never appeared.")
		return
	end

	local handled = setmetatable({}, {__mode = "k"})

	local CLICK_ID = "rbxassetid://12221967"
	local soundCache = nil

	local function playClick()
		if not soundCache then
			local SoundService = game:GetService("SoundService")
			soundCache = SoundService:FindFirstChild("BloxyParadoxClick")
			if not soundCache then
				soundCache = Instance.new("Sound")
				soundCache.Name = "BloxyParadoxClick"
				soundCache.SoundId = CLICK_ID
				soundCache.Volume = 0.6
				soundCache.Parent = SoundService
			end
		end
		soundCache:Stop()
		soundCache:Play()
	end

	local function addHover(btn)
		btn.MouseEnter:Connect(function()
			if btn.Active then
				btn.BackgroundColor3 = Color3.fromRGB(44, 179, 255)
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
			end
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextColor3 = Color3.fromRGB(0, 0, 0)
			btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
		end)
	end

	local function addClickSound(btn)
		btn.MouseButton1Click:Connect(function()
			playClick()
		end)
	end

	local function findButton(slider, text)
		for _, child in ipairs(slider:GetChildren()) do
			if child:IsA("TextButton") and child.Text == text then
				return child
			end
		end
		return nil
	end

	local function shiftDown(slider, aboveY, amount, exclude)
		for _, child in ipairs(slider:GetChildren()) do
			if child:IsA("TextButton")
			   and child ~= exclude
			   and child.Position.Y.Offset > aboveY then
				child.Position = UDim2.new(0, 0, 0, child.Position.Y.Offset + amount)
			end
		end
		slider.CanvasSize = UDim2.new(0, 0, 0, slider.CanvasSize.Y.Offset + amount)
	end

	local function findToggle(frame)
		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("TextButton")
			   and (child.Text:find("▼", 1, true) or child.Text:find("▲", 1, true)) then
				return child
			end
		end
		return nil
	end

	local function updateToggle(frame, text)
		task.defer(function()
			local toggle = findToggle(frame)
			if toggle then toggle.Text = text .. "  ▼" end
		end)
	end

	local function wipeHandlers(btn)
		if not getconnections then return end
		local ok, conns = pcall(getconnections, btn.MouseButton1Click)
		if not ok or type(conns) ~= "table" then return end
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
	end

	local function fireOriginal(btn)
		if not btn or not getconnections then return end
		local ok, conns = pcall(getconnections, btn.MouseButton1Click)
		if not ok or type(conns) ~= "table" then return end
		for _, conn in ipairs(conns) do
			if conn.Function then
				pcall(conn.Function)
				return
			end
		end
	end

	RunService.RenderStepped:Connect(function()
		if not sg or not sg.Parent then return end

		for _, frame in ipairs(sg:GetChildren()) do
			if frame:IsA("Frame") and not handled[frame] then
				local slider = nil
				for _, d in ipairs(frame:GetDescendants()) do
					if d:IsA("ScrollingFrame") then
						for _, opt in ipairs(d:GetChildren()) do
							if opt:IsA("TextButton") and opt.Text:find("2023", 1, true) then
								slider = d
								break
							end
						end
					end
					if slider then break end
				end

				if slider then
					handled[frame] = true
					print("[Topbar Addon] Dropdown detected.")

					task.wait(0.1)

					-- STEP 1: Split 2023 into 2024 and 2023 old
					if not findButton(slider, "2023 old") then
						local btn2023 = findButton(slider, "2023(w.i.p)")
							or findButton(slider, "2023 new")
							or findButton(slider, "2023")

						if btn2023 then
							local originalHandler = nil
							if getconnections then
								local ok, conns = pcall(getconnections, btn2023.MouseButton1Click)
								if ok and type(conns) == "table" then
									for _, conn in ipairs(conns) do
										if conn.Function then
											originalHandler = conn.Function
											break
										end
									end
									for _, conn in ipairs(conns) do
										pcall(function() conn:Disconnect() end)
									end
								end
							end

							btn2023.Text = "2024"
							btn2023.MouseButton1Click:Connect(function()
								playClick()
								getgenv().Force2008BubbleChat = false
								getgenv().BP_PendingTopbar = nil
								getgenv().BP_2023Variant = "2024"
								print("[2024] Selected — will load the 2024 top bar on confirm.")
								if originalHandler then pcall(originalHandler) end
								updateToggle(frame, "2024")
							end)

							local btn2023Old = btn2023:Clone()
							btn2023Old.Name = "Topbar2023OldButton"
							btn2023Old.Text = "2023 old"
							btn2023Old.Position = UDim2.new(0, 0, 0, btn2023.Position.Y.Offset + 35)
							btn2023Old.Parent = slider

							wipeHandlers(btn2023Old)
							addHover(btn2023Old)

							btn2023Old.MouseButton1Click:Connect(function()
								playClick()
								getgenv().Force2008BubbleChat = false
								getgenv().BP_PendingTopbar = nil
								getgenv().BP_2023Variant = "old"
								print("[2023 old] Selected.")
								if originalHandler then pcall(originalHandler) end
								updateToggle(frame, "2023 old")
							end)

							shiftDown(slider, btn2023.Position.Y.Offset, 35, btn2023Old)
							print("[Topbar Addon] 2024 / 2023 old split done.")
						end
					end

					task.wait(0.1)

					-- STEP 2: Insert 2021
					if not findButton(slider, "2021") then
						local anchor = findButton(slider, "2023 old")
						if anchor then
							local clone = anchor:Clone()
							clone.Name = "Topbar2021Button"
							clone.Text = "2021"
							clone.Position = UDim2.new(0, 0, 0, anchor.Position.Y.Offset + 35)
							clone.Parent = slider

							wipeHandlers(clone)
							addHover(clone)

							clone.MouseButton1Click:Connect(function()
								playClick()
								fireOriginal(anchor)
								getgenv().Force2008BubbleChat = false
								getgenv().BP_PendingTopbar = "2021"
								getgenv().BP_2023Variant = nil
								print("[2021] Selected — will load on confirm.")
								updateToggle(frame, "2021")
							end)

							shiftDown(slider, anchor.Position.Y.Offset, 35, clone)
						end
					end

					task.wait(0.1)

					-- STEP 3: Insert 2019
					if not findButton(slider, "2019") then
						local anchor = findButton(slider, "2021") or findButton(slider, "2023 old")
						if anchor then
							local clone = anchor:Clone()
							clone.Name = "Topbar2019Button"
							clone.Text = "2019"
							clone.Position = UDim2.new(0, 0, 0, anchor.Position.Y.Offset + 35)
							clone.Parent = slider

							wipeHandlers(clone)
							addHover(clone)

							clone.MouseButton1Click:Connect(function()
								playClick()
								local btn2023Old = findButton(slider, "2023 old")
								if btn2023Old then fireOriginal(btn2023Old) end
								getgenv().Force2008BubbleChat = false
								getgenv().BP_PendingTopbar = "2019"
								getgenv().BP_2023Variant = nil
								print("[2019] Selected — will load on confirm.")
								updateToggle(frame, "2019")
							end)

							shiftDown(slider, anchor.Position.Y.Offset, 35, clone)
						end
					end

					task.wait(0.1)

					-- STEP 4: Insert 2017
					if not findButton(slider, "2017") then
						local anchor = findButton(slider, "2019")
						if anchor then
							local clone = anchor:Clone()
							clone.Name = "Topbar2017Button"
							clone.Text = "2017"
							clone.Position = UDim2.new(0, 0, 0, anchor.Position.Y.Offset + 35)
							clone.Parent = slider

							wipeHandlers(clone)
							addHover(clone)

							clone.MouseButton1Click:Connect(function()
								playClick()
								local btn2023Old = findButton(slider, "2023 old")
								if btn2023Old then fireOriginal(btn2023Old) end
								getgenv().Force2008BubbleChat = false
								getgenv().BP_PendingTopbar = "2017"
								getgenv().BP_2023Variant = nil
								print("[2017] Selected — will load on confirm.")
								updateToggle(frame, "2017")
							end)

							shiftDown(slider, anchor.Position.Y.Offset, 35, clone)
						end
					end

					task.wait(0.1)

					-- STEP 5: Insert 2013 mobile
					if not findButton(slider, "2013 mobile") then
						local anchor = findButton(slider, "2013")
						if anchor then
							local clone = anchor:Clone()
							clone.Name = "Topbar2013MobileButton"
							clone.Text = "2013 mobile"
							clone.Position = UDim2.new(0, 0, 0, anchor.Position.Y.Offset + 35)
							clone.Parent = slider

							wipeHandlers(clone)
							addHover(clone)

							clone.MouseButton1Click:Connect(function()
								playClick()
								fireOriginal(anchor)
								getgenv().Force2008BubbleChat = true
								getgenv().BP_PendingTopbar = "2013mobile"
								getgenv().BP_2023Variant = nil
								print("[2013 mobile] Selected — will load mobile GUI on confirm.")
								updateToggle(frame, "2013 mobile")
							end)

							shiftDown(slider, anchor.Position.Y.Offset, 35, clone)
						end
					end

					print("[Topbar Addon] Done. Dropdown rebuilt.")
				end
			end
		end
	end)

	print("[Topbar Addon] Watching.")
end)

------------------------------------------------------------
-- PART 3: REPORT BUTTON DEDUPE (fixes 2017 double report)
------------------------------------------------------------
task.spawn(function()
	local Players = game:GetService("Players")
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

	local REPORT_MATCHERS = { "report" }

	local function isReportButton(obj)
		if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
			return false
		end
		local hay = (obj.Name or ""):lower()
		if obj:IsA("TextButton") then
			hay = hay .. " " .. (obj.Text or ""):lower()
		end
		for _, needle in ipairs(REPORT_MATCHERS) do
			if hay:find(needle, 1, true) then
				return true
			end
		end
		return false
	end

	local function getBloxyRoot()
		for _, c in ipairs(pg:GetChildren()) do
			if c:IsA("ScreenGui") and c.Name:find("Bloxy", 1, true) then
				return c
			end
		end
		return nil
	end

	local firstSeen = setmetatable({}, { __mode = "k" })

	local function dedupe()
		local root = getBloxyRoot()
		if not root then return end

		local reports = {}
		for _, d in ipairs(root:GetDescendants()) do
			if isReportButton(d) and d.Parent then
				if not firstSeen[d] then
					firstSeen[d] = os.clock()
				end
				table.insert(reports, d)
			end
		end

		if #reports <= 1 then return end

		table.sort(reports, function(a, b)
			return firstSeen[a] < firstSeen[b]
		end)

		for i = 1, #reports - 1 do
			local btn = reports[i]
			if btn and btn.Parent then
				print("[Dedupe] Removing older report button: " .. btn:GetFullName())
				pcall(function() btn:Destroy() end)
			end
		end
	end

	while true do
		task.wait(0.2)
		pcall(dedupe)
	end
end)