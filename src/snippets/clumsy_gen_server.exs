defmodule ClumsyGenServer do
  def start(module, state) do
    spawn(__MODULE__, :init, [module, state])
  end

  def init(module, state) do
    {:ok, state} = module.init(state)
    loop(module, state)
  end

  ...
end
