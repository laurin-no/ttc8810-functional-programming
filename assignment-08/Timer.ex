# Use a GenServer to produce general purpose periodical timer

# An interface to start periodical timer with period in milliseconds and function to be called when timer triggers.
# Option to cancel the timer per return value (:ok or :cancel) of the passed function.
# Option to cancel the timer via public interface.

defmodule Timer do
  use GenServer

  ## Client API
  def start_link(_state \\ %{}, _opts \\ []) do
    GenServer.start_link(__MODULE__, %{timer: nil, callback: nil, interval: 4000},
      name: __MODULE__
    )
  end

  def set_timer(callback, interval) do
    GenServer.call(__MODULE__, {:set_timer, %{callback: callback, interval: interval}})
  end

  def cancel_timer() do
    GenServer.call(__MODULE__, :cancel_timer)
  end

  ## GenServer Implementation
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:set_timer, extra_state}, _from, state) do
    {:reply, :ok, state |> Map.merge(extra_state) |> schedule_work()}
  end

  @impl true
  def handle_call(:cancel_timer, _from, state) do
    if state[:timer] do
      Process.cancel_timer(state[:timer])
    end

    {:reply, :ok, Map.merge(state, %{timer: nil})}
  end

  @impl true
  def handle_info(:run, state) do
    {:noreply, run(state)}
  end

  # Private API
  defp schedule_work(state) do
    if state[:timer] do
      Process.cancel_timer(state.timer)
    end

    timer = Process.send_after(self(), :run, state[:interval])
    Map.merge(state, %{timer: timer})
  end

  defp run(state) do
    case state.callback.() do
      :ok ->
        schedule_work(state)

      :cancel ->
        Map.merge(state, %{timer: nil})
    end
  end
end
