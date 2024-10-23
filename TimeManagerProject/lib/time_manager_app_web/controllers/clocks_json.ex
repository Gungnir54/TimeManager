defmodule TimeManagerWeb.ClocksJSON do
  alias TimeManager.Clocking.Clocks

  @doc """
  Renders a list of clock.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clocks <- clocks, do: data(clocks))}
  end

  @doc """
  Renders a single clocks.
  """
  def show(%{clocks: clocks}) do
    %{data: data(clocks)}
  end

  defp data(%Clocks{} = clocks) do
    %{
      clock_id: clocks.id,
      time: clocks.time,
      status: clocks.status
    }
  end
end