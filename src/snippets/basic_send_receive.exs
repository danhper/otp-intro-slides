pid = spawn fn ->
  receive do
    {:ping, sender} -> send(sender, :pong)
  end
end
:timer.sleep(10)
Process.alive?(pid) # true
send(pid, {:ping, self()})
flush() # :pong
Process.alive?(pid) # false
