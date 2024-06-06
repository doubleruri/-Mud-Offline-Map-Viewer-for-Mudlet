--Original by doubleruri
--IMPORTMANT Notice:
--Need function and variable of generic_mapper:
--getRoomName() getRoomUserData() getRoomExits() getSpecialExits()
--map.currentRoom
c
----Working flow----
--1. Set where to start explorer offline world.
--   You can choise a room ID from map or where you are now.
--2. Get All Data to construstion offline world.
--3. Find out all exits, there are to pattern to show
--   pattern 1: show in a line
--   pattern 2: show line by line
--4. There are 2 method to move in offline world:
--   [1] click exits
--   [2][Todo]type command to move
--5. If you want to back to Reality,just type look or use OfflineMapViewer.Logout()

----Function LIST----
--[Done]OfflineMapViewer.echo(what,err)
--[Done]OfflineMapViewer.Login(RoomID)
--[Done]OfflineMapViewer.DataLoad(RoomID)
--[Done]OfflineMapViewer.Logout()
--[Working]OfflineMapViewer.config()
----key Variable----
--OfflineMapViewer.currentRoom
--OfflineMapViewer.previousRoom
--OfflineMapViewer.recallPoint

--table.save("C:/Users/doubl/OneDrive/圖片/MudletUI/MapSetting.lua", Offline_MAP.setting)
--table.save("C:/Users/doubl/OneDrive/圖片/MudletUI/MapSetting.lua", Offline_MAP.setting)
--table.load
OfflineMapViewer = OfflineMapViewer or {}
OfflineMapViewer.setting = {}
OfflineMapViewer.setting.pattern = 2
OfflineMapViewer.setting.movemethod = "1"
OfflineMapViewer.setting.ClearWindow = false
OfflineMapViewer.currentRoom = ""
OfflineMapViewer.previousRoom = ""
OfflineMapViewer.whatInRoom = {"description","NPC","OBJ","Notes"}

--播報員的function
local MapperVoice = "<112,229,0>[Offline_MAP]: "
local ErrorVoice = "<255,0,0>[<178,34,34>Offline_MAP<255,0,0>]: "
function OfflineMapViewer.echo(what,err)
  if err then decho("Offline_World",ErrorVoice) else decho("Offline_World",MapperVoice) end
  echo("Offline_World",tostring(what).."\n")
  --echo("Offline_World","\n")
end
----------
--設定離線區要用的位置
function OfflineMapViewer.Login(RoomID)
  if not RoomID then
    if not  map.currentRoom then 
      OfflineMapViewer.echo("Offline_World","請找出現在的房間號或指定要去的地方",1)
    return
    else OfflineMapViewer.currentRoom = tonumber(map.currentRoom)
    end
  else
    OfflineMapViewer.currentRoom = RoomID
  end
    OfflineMapViewer.recallPoint = tonumber(OfflineMapViewer.currentRoom)
    echo("Offline_World","Login point is Here you are : #"..OfflineMapViewer.currentRoom.."  "..getRoomName(OfflineMapViewer.currentRoom).."\n")
	decho("Offline_World",MapperVoice)
	echo("Offline_World","Do you want to START HERE??  ")
	dechoLink("Offline_World","<34,139,34>[<u> YES </u>]",[[centerview(OfflineMapViewer.currentRoom) OfflineMapViewer.DataLoad(OfflineMapViewer.currentRoom)]],"", true)
	echo("Offline_World","  ")
  dechoLink("Offline_World","<255,0,255>[<u> NO </u>]\n",[[OfflineMapViewer.echo("Please RE-SELECT START point\n")]],"", true)
    centerview(OfflineMapViewer.currentRoom)
end

function OfflineMapViewer.DataLoad(RoomID)
if OfflineMapViewer.setting.ClearWindow then clearWindow() end
echo("Offline_World","\n") 
decho("Offline_World","<255,255,0>"..getRoomName(RoomID).."\n")
--顯示RoomUserData,依照offlineMapViewer.whatInRoom裡的順序
--Show RoomUserData order by OfflineMapViewer.whatInRoom
for k,v in ipairs (OfflineMapViewer.whatInRoom) do
  local results = getRoomUserData(RoomID,v,true)
  if  results then echo("Offline_World",results.."\n") end
end
--顯示出口，有兩種顯示方式
--Show exits and special exits,two display pattern
local exits, special_exits = getRoomExits(RoomID),getSpecialExits(RoomID)
decho("Offline_World","<255,255,0>出口：\n")
if table.is_empty(exits) and table.is_empty(special_exits)
  then decho("Offline_World","<230,0,0:154,205,50>  No Exits!!  \n")
       decho("Offline_World",MapperVoice)
       dechoLink("Offline_World","<34,139,34> Click to previous room\n",function()
                  														  centerview(OfflineMapViewer.previousRoom)
																		  OfflineMapViewer.DataLoad(OfflineMapViewer.previousRoom)
																		end,"")
end
if OfflineMapViewer.setting.pattern == 2 then
  for dir,id in pairs (exits) do
   	dechoLink("Offline_World","<34,139,34>"..dir.."<192,192,192>－"..getRoomName(id).."\n", function() OfflineMapViewer.previousRoom = tonumber(RoomID)
                                                                                                       centerview(id)
                                                                                                       OfflineMapViewer.DataLoad(id)
																							end,"", true)
  end
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      dechoLink("Offline_World","<34,139,34>"..command.."<192,192,192>－"..getRoomName(goRoom).."\n", function() OfflineMapViewer.previousRoom = tonumber(RoomID)
                                                                                                                 centerview(goRoom)
                                                                                                                 OfflineMapViewer.DataLoad(goRoom)
																									  end,"", true)
    end
  end
else
  local numberOfExits = 1
  for dir,id in pairs (exits) do
    if numberOfExits >2 then echo("Offline_World"," , ") end
    dechoLink("Offline_World","<34,139,34>"..dir.."<192,192,192>", function()
	                                                                 OfflineMapViewer.previousRoom = tonumber(RoomID)
																	 centerview(id)
																	 OfflineMapViewer.DataLoad(id)
																   end,getRoomName(id), true)
    numberOfExits = numberOfExits + 1
  end
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      echo("Offline_World"," , ")
      dechoLink("Offline_World","<34,139,34>"..command.."<192,192,192>", function()
	                                                                       OfflineMapViewer.previousRoom = tonumber(RoomID)
																		   centerview(goRoom)
																		   OfflineMapViewer.DataLoad(goRoom)
																		 end,getRoomName(goRoom), true)
    end
  end
end
echo("Offline_World","\n\n")
end

function OfflineMapViewer.Logout()
  send("look")
end

function OfflineMapViewer.config(var,set)
echo("Offline_World","Setting :\n")
echo("Offline_World","ClearWindow : "..OfflineMapViewer.ClearWindow.."\n")
echo("Offline_World","Show userRoomData : "..OfflineMapViewer.whatInRoom.."\n")
echo("Offline_World","Exits Pattern : "..OfflineMapViewer.pattern.."\n")
echo("Offline_World","movemethod : "..OfflineMapViewer.movemethod.."\n")
echo("Offline_World","1 -- Click     2 --command (NotWorking)\n")
OfflineMapViewer.echo("SavePath : ".."\n")
OfflineMapViewer.echo("SAVE to File??\n")
dechoLink("Offline_World","<112,220,0>[YES]","","",true)
dechoLink("Offline_World","<112,220,0>[No]",[[OfflineMapViewer.config()]]),"",true)

end