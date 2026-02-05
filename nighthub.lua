--// NIGHT STYLE UI LIBRARY
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local NightUI = {}

--================= UTILS =================
local function round(px)
	local u = Instance.new("UICorner")
	u.CornerRadius = UDim.new(0, px)
	return u
end

local function tween(obj,t,props)
	TweenService:Create(obj,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

--================= WINDOW =================
function NightUI:CreateWindow(title)
	local gui = Instance.new("ScreenGui", Player.PlayerGui)
	gui.Name = "NightHubUI"
	gui.ResetOnSpawn = false

	local Main = Instance.new("Frame", gui)
	Main.Size = UDim2.fromOffset(640,420)
	Main.Position = UDim2.fromScale(0.5,0.5)
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
	round(18).Parent = Main

	local Stroke = Instance.new("UIStroke", Main)
	Stroke.Color = Color3.fromRGB(60,60,70)
	Stroke.Thickness = 1

	local Top = Instance.new("TextLabel", Main)
	Top.Size = UDim2.new(1,0,0,50)
	Top.Text = title
	Top.Font = Enum.Font.GothamBold
	Top.TextSize = 18
	Top.TextColor3 = Color3.new(1,1,1)
	Top.BackgroundTransparency = 1

	local Tabs = Instance.new("Frame", Main)
	Tabs.Position = UDim2.fromOffset(10,60)
	Tabs.Size = UDim2.fromOffset(160,350)
	Tabs.BackgroundTransparency = 1

	local TabLayout = Instance.new("UIListLayout", Tabs)
	TabLayout.Padding = UDim.new(0,6)

	local Pages = Instance.new("Frame", Main)
	Pages.Position = UDim2.fromOffset(180,60)
	Pages.Size = UDim2.fromOffset(450,350)
	Pages.BackgroundTransparency = 1

	local Window = {}
	Window.Tabs = {}

	--================= TAB =================
	function Window:CreateTab(name)
		local TabBtn = Instance.new("TextButton", Tabs)
		TabBtn.Size = UDim2.new(1,0,0,36)
		TabBtn.Text = name
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.TextSize = 14
		TabBtn.TextColor3 = Color3.fromRGB(220,220,220)
		TabBtn.BackgroundColor3 = Color3.fromRGB(28,28,34)
		round(10).Parent = TabBtn

		local Page = Instance.new("ScrollingFrame", Pages)
		Page.Size = UDim2.fromScale(1,1)
		Page.CanvasSize = UDim2.new(0,0,0,0)
		Page.ScrollBarImageTransparency = 1
		Page.Visible = false

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0,10)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _,t in pairs(Window.Tabs) do
				t.Page.Visible = false
			end
			Page.Visible = true
		end)

		if #Window.Tabs == 0 then
			Page.Visible = true
		end

		local Tab = {}
		Tab.Page = Page

		--================= SECTION =================
		function Tab:CreateSection(title)
			local Sec = Instance.new("Frame", Page)
			Sec.Size = UDim2.new(1,0,0,40)
			Sec.BackgroundColor3 = Color3.fromRGB(24,24,30)
			round(14).Parent = Sec

			local STitle = Instance.new("TextLabel", Sec)
			STitle.Text = title
			STitle.Font = Enum.Font.GothamBold
			STitle.TextSize = 14
			STitle.TextColor3 = Color3.new(1,1,1)
			STitle.Size = UDim2.new(1,-20,0,30)
			STitle.Position = UDim2.fromOffset(10,5)
			STitle.BackgroundTransparency = 1

			local Holder = Instance.new("Frame", Sec)
			Holder.Position = UDim2.fromOffset(10,35)
			Holder.Size = UDim2.new(1,-20,0,0)
			Holder.BackgroundTransparency = 1

			local HLayout = Instance.new("UIListLayout", Holder)
			HLayout.Padding = UDim.new(0,8)

			HLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Holder.Size = UDim2.new(1,-20,0,HLayout.AbsoluteContentSize.Y)
				Sec.Size = UDim2.new(1,0,0,Holder.AbsoluteSize.Y + 45)
			end)

			local Section = {}

			-- TOGGLE
			function Section:AddToggle(name, def, cb)
				local T = Instance.new("TextButton", Holder)
				T.Size = UDim2.new(1,0,0,34)
				T.Text = name
				T.Font = Enum.Font.Gotham
				T.TextSize = 13
				T.TextColor3 = Color3.new(1,1,1)
				T.BackgroundColor3 = def and Color3.fromRGB(60,120,255) or Color3.fromRGB(40,40,50)
				round(10).Parent = T

				local state = def
				T.MouseButton1Click:Connect(function()
					state = not state
					tween(T,0.2,{
						BackgroundColor3 = state and Color3.fromRGB(60,120,255) or Color3.fromRGB(40,40,50)
					})
					cb(state)
				end)
			end

			-- BUTTON
			function Section:AddButton(name, cb)
				local B = Instance.new("TextButton", Holder)
				B.Size = UDim2.new(1,0,0,34)
				B.Text = name
				B.Font = Enum.Font.GothamBold
				B.TextSize = 13
				B.TextColor3 = Color3.new(1,1,1)
				B.BackgroundColor3 = Color3.fromRGB(70,70,90)
				round(10).Parent = B
				B.MouseButton1Click:Connect(cb)
			end

			-- SLIDER
			function Section:AddSlider(name,min,max,def,cb)
				local F = Instance.new("Frame", Holder)
				F.Size = UDim2.new(1,0,0,40)
				F.BackgroundTransparency = 1

				local L = Instance.new("TextLabel", F)
				L.Text = name
				L.Size = UDim2.new(1,0,0,18)
				L.TextColor3 = Color3.new(1,1,1)
				L.Font = Enum.Font.Gotham
				L.TextSize = 13
				L.BackgroundTransparency = 1

				local Bar = Instance.new("Frame", F)
				Bar.Position = UDim2.fromOffset(0,22)
				Bar.Size = UDim2.new(1,0,0,8)
				Bar.BackgroundColor3 = Color3.fromRGB(40,40,50)
				round(8).Parent = Bar

				local Fill = Instance.new("Frame", Bar)
				Fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
				Fill.BackgroundColor3 = Color3.fromRGB(80,150,255)
				round(8).Parent = Fill

				Bar.InputBegan:Connect(function(i)
					if i.UserInputType==Enum.UserInputType.MouseButton1 then
						local x = (i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X
						x = math.clamp(x,0,1)
						Fill.Size = UDim2.new(x,0,1,0)
						cb(math.floor(min + (max-min)*x))
					end
				end)
			end

			-- DROPDOWN SINGLE
			function Section:AddDropdown(name,list,def,cb)
				local B = Instance.new("TextButton", Holder)
				B.Size = UDim2.new(1,0,0,34)
				B.Text = name..": "..def
				B.Font = Enum.Font.Gotham
				B.TextSize = 13
				B.TextColor3 = Color3.new(1,1,1)
				B.BackgroundColor3 = Color3.fromRGB(40,40,50)
				round(10).Parent = B

				B.MouseButton1Click:Connect(function()
					local v = list[math.random(#list)]
					B.Text = name..": "..v
					cb(v)
				end)
			end

			-- DROPDOWN MULTI
			function Section:AddDropdownMulti(name,list,cb)
				local selected = {}
				local B = Instance.new("TextButton", Holder)
				B.Size = UDim2.new(1,0,0,34)
				B.Text = name
				B.Font = Enum.Font.Gotham
				B.TextSize = 13
				B.TextColor3 = Color3.new(1,1,1)
				B.BackgroundColor3 = Color3.fromRGB(40,40,50)
				round(10).Parent = B

				B.MouseButton1Click:Connect(function()
					local v = list[math.random(#list)]
					selected[v] = not selected[v]
					cb(selected)
				end)
			end

			return Section
		end

		table.insert(Window.Tabs,{Page=Page})
		return Tab
	end

	return Window
end

return NightUI
