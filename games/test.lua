local httpService = game:GetService("HttpService")

local InterfaceManager = {}
do
	function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

	function InterfaceManager:BuildInterfaceSection(tab)
		assert(self.Library, "Must set Library")
		local Library = self.Library

		local gamesection = tab:Section({
			Side = "Right",
		})

		local world = workspace:FindFirstChild("world")
		local npcs = world:FindFirstChild("npcs")
		local links = game.ReplicatedStorage:FindFirstChild("Link")
			or #game.ReplicatedStorage:GetChildren() > 2 and game.ReplicatedStorage
			or game.ReplicatedStorage:GetChildren()[1]

		local locations = {
			spots = {
				["ice puzzle"] = CFrame.new(19233, 396, 6010),
				["roslit bay"] = CFrame.new(
					-1663.73889,
					149.234116,
					495.498016,
					0.0380855016,
					4.08820178e-08,
					-0.999274492,
					5.74658472e-08,
					1,
					4.3101906e-08,
					0.999274492,
					-5.90657123e-08,
					0.0380855016
				),
				["ocean"] = CFrame.new(
					7665.104,
					125.444443,
					2601.59351,
					0.999966085,
					-0.000609769544,
					-0.00821684115,
					0.000612694537,
					0.999999762,
					0.000353460142,
					0.00821662322,
					-0.000358482561,
					0.999966204
				),
				["snowcap pond"] = CFrame.new(
					2778.09009,
					283.283783,
					2580.323,
					1,
					7.17688531e-09,
					-2.22843701e-05,
					-7.17796267e-09,
					1,
					-4.83369114e-08,
					2.22843701e-05,
					4.83370712e-08,
					1
				),
				["the depths obby"] = CFrame.new(76, -703, 1231),
				["moosewood docks"] = CFrame.new(343.2359924316406, 133.61595153808594, 267.0580139160156),
				["deep ocean"] = CFrame.new(
					3569.07153,
					125.480949,
					6697.12695,
					0.999980748,
					-0.00188910461,
					-0.00591362361,
					0.00193980196,
					0.999961317,
					0.00857902411,
					0.00589718809,
					-0.00859032944,
					0.9999457
				),
				["vertigo"] = CFrame.new(
					-137.697098,
					-736.86377,
					1233.15271,
					1,
					-1.61821543e-08,
					-2.01375751e-05,
					1.6184277e-08,
					1,
					1.05423091e-07,
					2.01375751e-05,
					-1.0542341e-07,
					1
				),
				["snowcap ocean"] = CFrame.new(
					3088.66699,
					131.534332,
					2587.11304,
					1,
					4.30694858e-09,
					-1.19097813e-14,
					-4.30694858e-09,
					1,
					-2.80603398e-08,
					1.17889275e-14,
					2.80603398e-08,
					1
				),
				["harvesters spike"] = CFrame.new(
					-1234.61523,
					139.215805,
					2371.79785,
					-0.0548323762,
					-0.000290813087,
					-0.998509467,
					-0.000294948401,
					1,
					0.000527389327,
					0.998509467,
					-0.000535545505,
					-0.0548323762
				),
				["lake"] = CFrame.new(
					1987.99133,
					129.176041,
					2314.32251,
					1,
					1.62168402e-08,
					-4.9495875e-05,
					-1.62169019e-08,
					1,
					-3.71273558e-08,
					4.9495875e-05,
					3.71274965e-08,
					1
				),
				["forsaken shores"] = CFrame.new(-2533, 135, 1553),
				["grand reef"] = CFrame.new(-3602, 142, 543),
				["altar"] = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
				["arch"] = CFrame.new(998.966796875, 126.6849365234375, -1237.1434326171875),
				["birch"] = CFrame.new(1742.3203125, 138.25787353515625, -2502.23779296875),
				["brine"] = CFrame.new(
					-1794.10596,
					-145.849701,
					-3302.92358,
					-5.16176224e-05,
					3.10316682e-06,
					0.99999994,
					0.119907647,
					0.992785037,
					3.10316682e-06,
					-0.992785037,
					0.119907647,
					-5.16176224e-05
				),
				["deep"] = CFrame.new(
					-1510.88672,
					-237.695053,
					-2852.90674,
					0.573604643,
					0.000580655003,
					0.81913209,
					-0.000340352941,
					0.999999762,
					-0.000470530824,
					-0.819132209,
					-8.89541116e-06,
					0.573604763
				),
				["deepshop"] = CFrame.new(
					-979.196411,
					-247.910156,
					-2699.87207,
					0.587748766,
					0,
					0.809043527,
					0,
					1,
					0,
					-0.809043527,
					0,
					0.587748766
				),
				["goldfish"] = CFrame.new(-2693, 165, 1732),
				["ancient isle"] = CFrame.new(6048, 195, 287),
				["enchant"] = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
				["executive"] = CFrame.new(-29.836761474609375, -250.48486328125, 199.11614990234375),
				["keepers"] = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
				["mod house"] = CFrame.new(-30.205902099609375, -249.40594482421875, 204.0529022216797),
				["moosewood"] = CFrame.new(383.10113525390625, 131.2406005859375, 243.93385314941406),
				["mushgrove"] = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
				["roslit"] = CFrame.new(-1476.511474609375, 130.16842651367188, 671.685302734375),
				["snow"] = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
				["snowcap"] = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
				["spike"] = CFrame.new(-1254.800537109375, 133.88555908203125, 1554.2021484375),
				["statue"] = CFrame.new(72.8836669921875, 138.6964874267578, -1028.4193115234375),
				["sunstone"] = CFrame.new(
					-933.259705,
					128.143951,
					-1119.52063,
					-0.342042685,
					0,
					-0.939684391,
					0,
					1,
					0,
					0.939684391,
					0,
					-0.342042685
				),
				["swamp"] = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
				["terrapin"] = CFrame.new(-143.875244140625, 141.1676025390625, 1909.6070556640625),
				["trident"] = CFrame.new(
					-1479.48987,
					-228.710632,
					-2391.39307,
					0.0435845852,
					0,
					0.999049723,
					0,
					1,
					0,
					-0.999049723,
					0,
					0.0435845852
				),
				["volcano"] = CFrame.new(-1888.52319, 163.847565, 329.238281, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				["wilson"] = CFrame.new(
					2938.80591,
					277.474762,
					2567.13379,
					0.4648332,
					0,
					0.885398269,
					0,
					1,
					0,
					-0.885398269,
					0,
					0.4648332
				),
			},
			rods = {
				["heavens rod"] = CFrame.new(19965, 1139, 5348),
				["wilsons rod"] = CFrame.new(2879, 135, 2723),
			},
		}

		_G.autoshake = _G.autoshake or false
		_G.autoreel = _G.autoreel or false
		_G.autocast = _G.autocast or false
		_G.autosell = _G.autosell or false
		_G.autoselltime = _G.autoselltime or 1
		_G.antidrown = _G.antidrown or false
		_G.antiafk = _G.antiafk or false
		_G.scriptconnec = nil

		local lastCastPos

		local function generateDropdownTable(locationTable)
			local dropdownTable = {}
			for spotname in pairs(locationTable) do
				table.insert(dropdownTable, spotname)
			end
			return dropdownTable
		end

		local spotsDropdownTable = generateDropdownTable(locations.spots)
		local rodsDropdownTable = generateDropdownTable(locations.rods)

		local function moveToLocation(chosenCFrame)
			local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
			local rootPart = character:WaitForChild("HumanoidRootPart")
			rootPart.CFrame = chosenCFrame
		end

		local function createDropdown(name, options, locations)
			return gamesection:Dropdown({
				Name = name,
				Search = true,
				Multi = false,
				Required = false,
				Options = options,
				Default = { "none" },
				Callback = function(val)
					local chosenCFrame = locations[val]
					if chosenCFrame then
						moveToLocation(chosenCFrame)
					else
					end
				end,
			})
		end

		createDropdown("locations", spotsDropdownTable, locations.spots)
		createDropdown("rods", rodsDropdownTable, locations.rods)

		gamesection:Divider()

		local sellFishes = gamesection:Button({
			Name = "sell all fishes",
			Callback = function()
				--[[local originalPos = player.Character.HumanoidRootPart.CFrame
		player.Character.HumanoidRootPart.CFrame = CFrame.new(465, 151, 232)
		task.wait()


		win:Notify({
			Title = "zensploit",
			Description = "wait a few secs, you will be tp'd back",
			Lifetime = 2,
		})

		task.wait(math.random(2, 3))
		player.Character.HumanoidRootPart.CFrame = originalPos
		
		]]
				game:GetService("ReplicatedStorage").events.SellAll:InvokeServer()
			end,
		})

		local sellFish = gamesection:Button({
			Name = "sell holding fish",
			Callback = function()
				game:GetService("ReplicatedStorage").events.Sell:InvokeServer()
			end,
		})

		local appraiseFish = gamesection:Button({
			Name = "appraise",
			Callback = function()
				workspace.world.npcs.Appraiser.appraiser.appraise:InvokeServer()
			end,
		})

		gamesection:Divider()

		local antiAFK = gamesection:Toggle({
			Name = "anti afk",
			Default = _G.antiafk,
			Callback = function(val)
				_G.antiafk = val
			end,
		})

		local antiDrownToggle = gamesection:Toggle({
			Name = "anti drown",
			Default = _G.antidrown,
			Callback = function(val)
				_G.antidrown = val
				task.wait(0.1)
				task.spawn(function()
					repeat
						task.wait(0.1)
						player.Character.client.oxygen.Enabled = _G.antidrown
					until _G.antidrown == false
				end)
			end,
		})

		gamesection:Divider()

		local autoShakeToggle = gamesection:Toggle({
			Name = "auto shake",
			Default = _G.autoshake,
			Callback = function(val)
				_G.autoshake = val
			end,
		})

		local autoReelToggle = gamesection:Toggle({
			Name = "auto reel",
			Default = _G.autoreel,
			Callback = function(val)
				_G.autoreel = val
			end,
		})

		local autoCastToggle = gamesection:Toggle({
			Name = "auto cast",
			Default = _G.autocast,
			Callback = function(val)
				_G.autocast = val
			end,
		})

		gamesection:Divider()

		local autoSellToggle = gamesection:Toggle({
			Name = "auto sell",
			Default = _G.autosell,
			Callback = function(val)
				_G.autosell = val

				if not _G.autoSellTaskRunning then
					_G.autoSellTaskRunning = true

					task.spawn(function()
						while _G.autosell do
							task.wait(_G.autoselltime * 60)

							game:GetService("ReplicatedStorage").events.SellAll:InvokeServer()

							if _G.autosell == false then
								break
							end
						end
					end)
				end
			end,
		})

		local autoSellDuration = gamesection:Slider({
			Name = "auto sell every ? minutes",
			Default = _G.autoselltime,
			DisplayMethod = "Value",
			Precision = 0,
			Minimum = 1,
			Maximum = 30,
			Callback = function(val)
				_G.autoselltime = val
			end,
		})

		--<>----<>----<>----< HANDLERS >----<>----<>----<>--

		if _G.scriptconnec ~= nil then
			_G.scriptconnec:Disconnect()
			_G.scriptconnec = nil
		end

		_G.scriptconnec = nil
		_G.scriptconnec = game:GetService("RunService").RenderStepped:Connect(function()
			if _G.autocast == false then
			else
				task.wait(0.2)

				local tool = player.Character:FindFirstChildWhichIsA("Tool")
				if tool then
					local hasBobber = tool:FindFirstChild("bobber")

					if not hasBobber then
						local castEvent = tool:FindFirstChild("events") and tool.events:FindFirstChild("cast")

						_G.lastCastPos = player.Character.HumanoidRootPart.CFrame
						player.Character.HumanoidRootPart.CFrame = _G.lastCastPos

						if castEvent then
							castEvent:FireServer(100)
						end
					end
				end
			end
		end)

		player.PlayerGui.ChildAdded:Connect(function(child)
			if child:IsA("ScreenGui") then
				if child.Name == "shakeui" and child:FindFirstChild("safezone") then
					child.safezone.ChildAdded:Connect(function(btn)
						if btn:IsA("ImageButton") and btn.Name == "button" then
							if not _G.autoshake then
								return
							end

							btn.Selectable = true
							local guiService = game:GetService("GuiService")
							guiService.AutoSelectGuiEnabled = false
							guiService.GuiNavigationEnabled = true

							if btn.Visible then
								guiService.SelectedObject = btn
								if guiService.SelectedObject == btn then
									local virtualInput = game:GetService("VirtualInputManager")
									virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
									virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
								end
							end
						end
					end)
					return
				end

				if child.Name == "reel" and _G.autoreel then
					local eventsFolder = links:WaitForChild("events")
					local reelfinishedEvent = eventsFolder:FindFirstChild("reelfinished")

					if reelfinishedEvent then
						task.spawn(function()
							while child and _G.autoreel do
								task.wait(2)
								reelfinishedEvent:FireServer(100, true)
							end
						end)
					end
				end
			end
		end)
	end
end

return InterfaceManager
