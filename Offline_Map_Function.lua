--Thinking flow--

--設定離線區要用的位置，用另一個變數記憶
--讀取房間的資料: 名字、出口、在roomuserdata裡讀descriptin、NPC、OBJ、store、sector、indoor、和Note
--房間移動方式1 點連結
--房間移動方式2 輸入特定指令
--
--ok播報員的function
--現在位置用的function
--秀資料用的function
--房間移動方式的function(也許用個參數好切換)
--回到現實世界地圖的function
Offline_MAP = {}
Offline_MAP.setting = ""
Offline_MAP.currentRoom = ""

--播報員的function
local MapperVoice = "<112,229,0>[Offline_MAP]: <255,255,255>"
local ErrorVoice = "<255,0,0>[<178,34,34>Offline_MAP<255,0,0>]: <255,255,255>"
function Offline_MAP.echo(what,err)
  if err then decho(ErrorVoice) else decho(MapperVoice) end
  echo(tostring(what))
  echo("\n")
end
----------
function LoginOffLine(RoomID)
  if not RoomID then
    if not  map.currentRoom then 
      Offline_MAP.echo("請找出現在的房間號或指定要去的地方",1)
    return
    else Offline_MAP.currentRoom = tonumber(map.currentRoom)
    end
  else
    Offline_MAP.currentRoom = RoomID
  end
    Offline_MAP.echo("Default Room is Here you are : "..Offline_MAP.currentRoom)
    centerview(Offline_MAP.currentRoom)
end
