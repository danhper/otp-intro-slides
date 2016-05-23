pid = spawn fn ->
  IO.puts "Hello from #{inspect(self())}"
end
:timer.sleep(10)
Process.alive?(pid) |> IO.inspect # false
