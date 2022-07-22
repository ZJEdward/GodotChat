extends Control

onready var peer = NetworkedMultiplayerENet.new()

var mName = "haha"

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	# 信号 收到新的数据
	get_tree().multiplayer.connect("network_peer_packet", self, "_rec_packet")


# 启动服务
func _on_On_Off_pressed():
	peer.create_client("127.0.0.1", 5010)
	get_tree().network_peer = peer
	
	$Text.bbcode_text = "连接服务器中。。。\n"

func _connected_ok():
	$Text.bbcode_text += "连接服务器 --- 成功！\n"
	
func _connected_fail():
	$Text.bbcode_text += "连接服务器 --- 失败！\n"

func _server_disconnected():
	$Text.bbcode_text += "连接服务器 --- 断开连接！\n"

func _rec_packet(id, data):
	var _data = parse_json(data.get_string_from_utf8())
	
	match _data["action"]:
		"chat":
			if _data["name"] != mName:
				$Text.bbcode_text += "[color=#3defff]%s:\n[/color]%s\n"%[_data["name"], _data["content"]]
				pass
			pass
		"systom":
			$Text.bbcode_text += "[color=#ff3131]%s:\n[/color]%s\n"%[_data["name"], _data["content"]]
			pass
		"write":
			pass
		"read":
			pass
	
#	$Text.bbcode_text += "收到ID:"+str(id)+" --- 数据为:"+_data+"\n"
	pass

func _on_Send_One_pressed():
#	var data = $LineEdit.text
	
	var data = {"action": "chat", "name": mName, "content": $LineEdit.text}
	
	# id 0 广播 1服务器
#	get_tree().multiplayer.send_bytes(data.to_utf8(), 1)
#	$Text.bbcode_text += "客户端 --- 发送数据成功\n"
	$Text.bbcode_text += "[right][color=#73ff61]%s:\n[/color]%s[/right]\n"%[data["name"], data["content"]]
	
	get_tree().multiplayer.send_bytes(to_json(data).to_utf8(), 1)


func _on_Sure_pressed():
	if  len($"Panel/LineEdit".text)>1:
		self.mName = $"Panel/LineEdit".text
		$Panel.visible = false    
