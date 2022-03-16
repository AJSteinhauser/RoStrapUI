
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextService = game:GetService("TextService");
local Resources = require(ReplicatedStorage:WaitForChild("Resources"));

local Color = Resources:LoadLibrary("Color");
local Tween = Resources:LoadLibrary("Tween");
local Typer = Resources:LoadLibrary("Typer");
local Enumeration = Resources:LoadLibrary("Enumeration");
local PseudoInstance = Resources:LoadLibrary("PseudoInstance");


local GREY_NO_COLOR = Color.Grey[500];
local ERROR_RED_COLOR = Color.Red[500];
local APPROVAL_GREEN_COLOR = Color.Green[500]

local Left = Enum.TextXAlignment.Left.Value;
local SourceSansSemibold = Enum.Font.SourceSansSemibold.Value;

local OutQuad = Enumeration.EasingFunction.Linear.Value

local DISMISS_TIME = 75 / 1000 * 2;
local ENTER_TIME = .2;

local LocalPlayer, PlayerGui do
	if RunService:IsClient() then
		if RunService:IsServer() then
			PlayerGui = game:GetService("CoreGui");
		else
			repeat LocalPlayer = Players.LocalPlayer until LocalPlayer or not wait();
			repeat PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") until PlayerGui or not wait();
		end
	end
end


local Frame do
	Frame = Instance.new("Frame");
	Frame.BackgroundTransparency = 1;
	Frame.Size = UDim2.new(0, 200, 0, 50);
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
	Frame.AnchorPoint = Vector2.new(0.5, 0.5);
	Frame.Name = "Frame";
	Frame.ZIndex = 2
	

	
	local SizingFrame = Instance.new("Frame",Frame);
	SizingFrame.BackgroundTransparency = 1;
	SizingFrame.ZIndex = 2
	SizingFrame.Size = UDim2.new(1,0,1,0);
	SizingFrame.Name = "SizingFrame"
	
	local Background = Instance.new("ImageButton")
	Background.BackgroundTransparency = 1
	Background.ScaleType = Enum.ScaleType.Slice
	Background.ImageColor3 = GREY_NO_COLOR;
	Background.SliceCenter = Rect.new(4, 4, 256 - 4, 256 - 4)
	Background.Image = "rbxassetid://1934624205"
	Background.Size = UDim2.new(1,0, 1, 0)
	Background.Name = "Background"
	Background.ZIndex = 2
	Background.Parent = SizingFrame;
	Background.ClipsDescendants = false;
	
	local ErrorMessage = Instance.new("TextLabel",Frame)
	ErrorMessage.BackgroundTransparency = 1;
	ErrorMessage.Size = UDim2.new(1,10,.3,0);
	ErrorMessage.Position = UDim2.new(0,5,1,1)
	ErrorMessage.TextColor3 = ERROR_RED_COLOR;
	ErrorMessage.TextSize = 13
	ErrorMessage.TextXAlignment = Enum.TextXAlignment.Left;
	ErrorMessage.TextYAlignment = Enum.TextYAlignment.Top;
	ErrorMessage.Font = Enum.Font.SourceSansItalic.Value;
	ErrorMessage.Text = "Testing"
	ErrorMessage.TextTransparency = 1;
	ErrorMessage.Name = "Error";
	ErrorMessage.ZIndex = 3
	
	local Mask = Background:Clone()
	Mask.Parent = Background
	Mask.ImageColor3 = Color.Grey[50]
	Mask.Name = "Mask"
	Mask.Position = UDim2.new(.5,0,.5,0);
	Mask.AnchorPoint = Vector2.new(.5,.5)
	Mask.Size = UDim2.new(1,-2,1,-2)
	Mask.ZIndex = 3
	
	local TextField = Instance.new("TextBox")
	TextField.Size = UDim2.new(.8,0,1,.8)
	TextField.AnchorPoint = Vector2.new(.5,.5)
	TextField.Position = UDim2.new(.5,0,.5,0);
	TextField.BackgroundTransparency = 1;
	TextField.Parent = Mask;
	TextField.Font = SourceSansSemibold
	TextField.TextSize = 20
	TextField.ZIndex = 4;
	TextField.TextTransparency = 0.13
	TextField.Text = "";
	TextField.Name = "TextBox"
	TextField.ClipsDescendants = true;
	TextField.Selectable = true;
	TextField.TextColor3 = Color.Black;
	TextField.TextXAlignment = Enum.TextXAlignment.Left
	

	local Header = Instance.new("TextLabel")
	Header.Font = SourceSansSemibold
	Header.TextScaled = true;
	Header.AnchorPoint = Vector2.new(0,.5);
	Header.Size = UDim2.new(.4, 0, 0.6, 0)
	Header.Position = UDim2.new(0.1, 0, .5, 0)
	Header.BackgroundColor3 = Color3.new(1,1,1)
	Header.BorderSizePixel = 0
	Header.BackgroundTransparency = 1;
	Header.TextXAlignment = Left
	Header.TextTransparency = 0.13
	Header.TextColor3 = Color.Grey[800]
	Header.Name = "Header"
	Header.ZIndex = 3
	Header.Parent = Background
	
	local Buffer = Instance.new("Frame",Header)
	Buffer.Size = UDim2.new(1,10,1,0);
	Buffer.Position = UDim2.new(0,-5,0,0);
	Buffer.BackgroundColor3 = Color.Grey[50];
	Buffer.ZIndex = 2
	Buffer.BorderSizePixel = 0
	
	local HeaderSize = TextService:GetTextSize(
		"Label",
		20,
		SourceSansSemibold,
		Vector2.new(500,500)
	);
	
	Header.Size = UDim2.new(0,HeaderSize.X,0,HeaderSize.Y);
	
	local SizeLimiter = Instance.new("UITextSizeConstraint",Header)
	SizeLimiter.MaxTextSize = 20
	

	
end


local function HeaderSizes(self)
	local Header = self.Object:FindFirstChild("Header",true);
	local Big = TextService:GetTextSize(
		Header.Text,
		20,
		SourceSansSemibold,
		Vector2.new(500,500)
	);
	local Small = TextService:GetTextSize(
		Header.Text,
		18,
		SourceSansSemibold,
		Vector2.new(500,500)
	)
	return {Small,Big}
end

return PseudoInstance:Register("TextField", {
	Storage = {};
	
	WrappedProperties = {
		Object = {"AnchorPoint", "Active", "Name", "Size", "Position", "LayoutOrder", "NextSelectionDown", "NextSelectionLeft", "NextSelectionRight", "NextSelectionUp", "Parent"};
		
		TextField = {"Text"}
	};

	Internals = {"Object", "Header", "TextField","Mask","Background","HeaderSizes", "ErrorMessage";
		ToggleLabelPos = function(self,Down)
			if Down then
				if self.Text == "" then
					Tween(self.Mask, "Size", UDim2.new(1, -4, 1, -4), OutQuad, ENTER_TIME, true);
					Tween(self.Background, "ImageColor3", self.PrimaryColor3, OutQuad, ENTER_TIME, true);
					Tween(self.Header, "Size", UDim2.new(0,self.HeaderSizes[1].X * 3/4,0, self.HeaderSizes[1].Y),OutQuad, ENTER_TIME, true);
					Tween(self.Header, "Position" , UDim2.new(.1,0,0,0), OutQuad, ENTER_TIME, true);
					Tween(self.Header, "TextColor3" , self.PrimaryColor3, OutQuad, ENTER_TIME, true);
					--Header.Position = UDim2.new(0.1, 0, .5, 0)
				end
			else
				Tween(self.Mask, "Size", UDim2.new(1, -2, 1, -2), OutQuad, ENTER_TIME, true);
				Tween(self.Background, "ImageColor3", GREY_NO_COLOR, OutQuad, ENTER_TIME, true);
				if self.TextField.Text == "" then
					Tween(self.Header, "Size", UDim2.new(0,self.HeaderSizes[2].X ,0, self.HeaderSizes[2].Y),OutQuad, ENTER_TIME, true);
					Tween(self.Header, "Position" , UDim2.new(.1,0,.5,0), OutQuad, ENTER_TIME, true);
					Tween(self.Header, "TextColor3" , self.SecondaryColor3:Lerp(Color3.new(0,0,0),.3), OutQuad, ENTER_TIME, true);
				else
					Tween(self.Header, "TextColor3" , self.SecondaryColor3:Lerp(Color3.new(0,0,0),.3), OutQuad, ENTER_TIME, true)
				end
			end
			if self.ErrorMessage.TextTransparency ~= 1 then
				Tween(self.ErrorMessage, "TextTransparency", 1, OutQuad, ENTER_TIME, true)
			end
		end
	};	

	Events = {"TypingStopped","TypingStarted"};

	Methods = {
		ThrowError = function(self,Message)
			local Error = self.ErrorMessage;
			if Message then
				Error.Text = Message
			    Tween(Error, "TextTransparency", 0, OutQuad, ENTER_TIME, true)
			else
				Error.Text = "";
			end
			Tween(self.Header, "TextColor3" , ERROR_RED_COLOR, OutQuad, ENTER_TIME, true);
			Tween(self.Background, "ImageColor3", ERROR_RED_COLOR, OutQuad, ENTER_TIME, true);
		end;
		
		Approval = function(self)
			Tween(self.Header, "TextColor3" , APPROVAL_GREEN_COLOR, OutQuad, ENTER_TIME, true);
			Tween(self.Background, "ImageColor3", APPROVAL_GREEN_COLOR, OutQuad, ENTER_TIME, true);
		end;
		
		GetText = function(self)
			return self.TextField.Text;
		end;

		GetTextFieldObject = function(self)
			return self.TextField;
		end;
	};

	Properties = {
		PrimaryColor3 = Typer.AssignSignature(2, Typer.Color3, function(self, PrimaryColor3)
			if self.Text ~= "" then
				self.Object.Header.TextColor3 = PrimaryColor3;
				self.Object:FindFirstChild("Background",true).ImageColor3 = PrimaryColor3;
			end
			self:rawset("PrimaryColor3",PrimaryColor3)
		end);
		
		SecondaryColor3 = Typer.AssignSignature(2, Typer.Color3, function(self, SecondaryColor3)
			self:rawset("SecondaryColor3",SecondaryColor3)
		end);
		
		HeaderText = Typer.AssignSignature(2, Typer.String, function(self, String)
			self:rawset("HeaderText", String);
			self.Header.Text = String;
			self.HeaderSizes = HeaderSizes(self);
		end)
		
		
		
	};

	Init = function(self, ...)
		self.Object = Frame:Clone();
		self.Header = self.Object:FindFirstChild("Header",true);
		self.TextField = self.Object:FindFirstChild("TextBox",true);
		self.Mask = self.Object:FindFirstChild("Mask",true);
		self.Background = self.Object:FindFirstChild("Background",true)
		self.ErrorMessage = self.Object:FindFirstChild("Error",true)
		
		self.HeaderText = "Label"
	
		self:rawset("PrimaryColor3", Color.Purple[500])
		self:rawset("SecondaryColor3", GREY_NO_COLOR)
		
		self.Janitor:Add(
			self.TextField.Focused:Connect(function()
				self:ToggleLabelPos(true);
				self.TypingStarted:Fire();
			end),
			"Disconnect"
		);
		
		self.Janitor:Add(
			self.TextField.FocusLost:Connect(function()
				self:ToggleLabelPos(false);
				if self.TextField.Text == "TESTING" then
					self:ThrowError("No Testing Allowed");
				end
				self.TypingStopped:Fire(self.TextField.Text);
			end),
			"Disconnect"
		)
		
		
		
		self.Janitor:Add(self.Object, "Destroy")
		self:superinit(...)
	end;
})
