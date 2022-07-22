extends Control

onready var peer = NetworkedMultiplayerENet.new()

func _ready():
	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	
	# 信号 收到新的数据
	get_tree().multiplayer.connect("network_peer_packet", self, "_rec_packet")


# 启动服务
func _on_On_Off_pressed():
	$Text.bbcode_text = "启动服务器中。。。\n"
	var error = peer.create_server(5010, 100)
	if error == OK:
		$Text.bbcode_text += "服务器 --- 成功\n"
		get_tree().network_peer = peer
	else:
		$Text.bbcode_text += "服务器 --- 失败\n"
	

func _client_connected(id):
	$Text.bbcode_text += "有新的连接 --- ID:"+str(id)+"\n"

func _client_disconnected(id):
	$Text.bbcode_text += "ID:"+str(id)+" --- 断开连接"+"\n"

func _rec_packet(id, data):
	# 将收到的信息广播出去
	get_tree().multiplayer.send_bytes(data, 0)
	
	var _data = parse_json(data.get_string_from_utf8())
	$Text.bbcode_text += "收到 %s:"%[_data["name"]]+" 的消息: "+_data["content"]+"\n"
	pass

# 广播
func _on_Send_More_pressed():
#	var data = $LineEdit.text
	var data = {"action": "systom", "name": "系统管理员", "content": $LineEdit.text}
	# id 0 广播 1服务器
	get_tree().multiplayer.send_bytes(to_json(data).to_utf8(), 0)
	$Text.bbcode_text += "服务器 --- 发送数据成功\n"
