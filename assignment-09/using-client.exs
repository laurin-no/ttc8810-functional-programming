Process.sleep(1000)

socket = ChatClient.connect('localhost', 4040)

spawn_link(fn -> ChatClient.listen(socket) end)
Process.sleep(1000)

ChatClient.set_name("Bob", socket)
Process.sleep(1000)


ChatClient.send_msg("Hello", socket)
Process.sleep(1000)
ChatClient.send_msg("How are you?", socket)
Process.sleep(1000)
ChatClient.send_msg("I'm fine", socket)
Process.sleep(1000)
ChatClient.send_msg("Goodbye", socket)
Process.sleep(1000)
Process.sleep(10000)
