defmodule Pusher.IsAHelper do
  def is_a_map?(%{}) do
    true
  end

  def is_a_map?(_) do
    false
  end
end
