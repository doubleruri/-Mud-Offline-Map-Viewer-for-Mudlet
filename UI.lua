--Offline Mode Window UI--
--另一個用來呈現資料的視窗，避免影響原來頁面
--放置在一個adjustable.container讓使用者自行移動位置
-- Put World into an adjustable container
--Buttons for :
--  1. View your room
--  2. Go back
--  3. Recall
--  4. Login
--  5. Logout
--  6. config

--UI initical size adjust with window resolution,user y_factor
local DesignX,DesignY = 1440,960
local ActureX,ActureY = getMainWindowSize()
local x_Factor,y_Factor = ActureX/DesignX, ActureY/DesignY
local OfflineMapViewer.UIgfx_path = getMudletHomeDir().."/OfflineMapViewer/"
--利用setClickCallback() 後面接function/lua code/luacode store in string的特性
--建立table去方便管理
OfflineMapViewer.ButtonClick =
{
--View your room
onClickButton_1 =
  function()
    OfflineMapViewer.DataLoad(OfflineMapViewer.currentRoom)
  end,
--Go back
onClickButton_2 =
  function()
	OfflineMapViewer.currentRoom = tonumber(OfflineMapViewer.previousRoom)
	centerview(OfflineMapViewer.currentRoom)
    OfflineMapViewer.DataLoad(OfflineMapViewer.currentRoom)
  end,
--Recall
onClickButton_3 =
  function()
	OfflineMapViewer.previousRoom = tonumber(OfflineMapViewer.currentRoom)
	OfflineMapViewer.currentRoom = tonumber(OfflineMapViewer.recallPoint)
	centerview(OfflineMapViewer.currentRoom)
    OfflineMapViewer.DataLoad(OfflineMapViewer.currentRoom)
  end,
--Login
onClickButton_4 =
  function()
    local startpoint = getCmdLine()
	if type(startpoint) == number
      then 
        OfflineMapViewer.Login(startpoint)
      else
        OfflineMapViewer.echo(OfflineMapViewer.Message.Set2,1)
    end
  end,
--Logout
onClickButton_5 =
  function()
    clearWindow("Offline_World")
    OfflineMapViewer.currentRoom = nil
    OfflineMapViewer.previousRoom = nil
    OfflineMapViewer.recallPoint = nil
    decho("Offline_World","      Clear World\n      Clear currentRoom...")
    tempTimer(0.5,[[decho("Offline_World","done\n            previousRoom....")]])
    tempTimer(1,[[decho("Offline_World","done\n            recallPoint....")]])
    tempTimer(1.5,[[decho("Offline_World","done\n\n<255,202,229>        Fairy<192,192,192>: See you next time!\n")]])
    tempTimer(3,[[OfflineMapViewer.OffLineWindow:hide()]])
    if map.currentRoom
	  then
        centerview(map.currentRoom)
	  else
        send("look",false)
    end
  end,

onClickButton_6 =
  function()
    OfflineMapViewer.config()
  end,

}

OfflineMapViewer.OffLineWindow = Adjustable.Container:new({
  name="Offline_Mode",
  width = "75%" ,height = "70%" ,
  x = 10, y = 10,
  titleText = "Welcom to the WORLD",
  titleFormat = "16",
  buttonFontSize = 30,
  buttonsize = 60,
  buttonstyle=[[
                QLabel{ border-radius: 20px; background-color: rgba(140,140,140,100%);}
                QLabel::hover{ background-color: rgba(160,160,160,50%);}
              ]],
})
OfflineMapViewer.OffLineWindow:hide()

----Menu----
OfflineMapViewer.OffLineMenuBar = Geyser.Container:new({
  name = "OffLineMenuBar",
  x = 10, y =60,
  width = "90%", height = 32*y_Factor,
  color = "<192,192,192,0>",
},OfflineMapViewer.OffLineWindow)

OfflineMapViewer.OffLineMenuBar_1 = Geyser.Label:new({
  name = "SeeAroundButton",
  x = 10+35*0*y_Factor ,y = 0,
  width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."SeeAroundButton.png)",
  },OfflineMapViewer.OffLineMenuBar)

OfflineMapViewer.OffLineMenuBar_2 = Geyser.Label:new({
  name = "BackStepButton",
  x = 10+35*1*y_Factor ,y = 0,
   width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."Backstepbutton.png)",
  },OfflineMapViewer.OffLineMenuBar)

OfflineMapViewer.OffLineMenuBar_3 = Geyser.Label:new({
  name = "RecallButton",
  x = 10+35*2*y_Factor ,y = 0,
  width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."Recall.png)",
  },OfflineMapViewer.OffLineMenuBar)
                                
OfflineMapViewer.OffLineMenuBar_4 = Geyser.Label:new({
  name = "LoginButton",
  x = 10+35*3*y_Factor ,y = 0,
  width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."LoginButton.png)",
  --message = "⚙",
  },OfflineMapViewer.OffLineMenuBar)

OfflineMapViewer.OffLineMenuBar_5 = Geyser.Label:new({
  name = "LogoutButton",
  x = 10+35*4*y_Factor ,y = 0,
  width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."LogoutButton.png)",
  --message = "⚙",
  },OfflineMapViewer.OffLineMenuBar)

OfflineMapViewer.OffLineMenuBar_6 = Geyser.Label:new({
  name = "OffLineWorld_ConfigButton",
  x = 10+35*5*y_Factor ,y = 0,
  width = 32*y_Factor, height = "100%",
  stylesheet = "border-image : url("..OfflineMapViewer.UIgfx_path.."Setting.png)",
  --message = "⚙",
  },OfflineMapViewer.OffLineMenuBar)

OfflineMapViewer.OffLineMenuBar_1:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_2:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_3:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_4:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_5:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_6:setCursor("PointingHand")

OfflineMapViewer.OffLineMenuBar_1:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_1")
OfflineMapViewer.OffLineMenuBar_2:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_2")
OfflineMapViewer.OffLineMenuBar_3:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_3")
OfflineMapViewer.OffLineMenuBar_4:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_4")
OfflineMapViewer.OffLineMenuBar_5:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_5")
OfflineMapViewer.OffLineMenuBar_6:setClickCallback("OfflineMapViewer.ButtonClick.onClickButton_6")



OfflineMapViewer.OffLineWorld = Geyser.MiniConsole:new({
  name="Offline_World",
  x="0%", y="20%",
  width="100%", height="70%",
  color = "black",
  font = "細明體", -- speiclized your world word
  fontSize = 16,
  scrollBar = true,
  autoWrap = true,
  commandLine = true, --false it if you don't need
  scrolling = true,
},OfflineMapViewer.OffLineWindow)

--[[ Consider if needed
OfflineMapViewer.OffLineHint = Geyser.Label:new({
  name = "MoveHint",
  x = "10%",y = "90%",
  width = "80%", height = "10%",
  --color = "<>",
},OfflineMapViewer.OffLineWindow)
]]
