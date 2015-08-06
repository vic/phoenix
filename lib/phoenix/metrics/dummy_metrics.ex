defmodule Phoenix.Metrics.Dummy do
  @spec new(atom(), any()) :: :ok 
  def new(_type, _name) do
    :ok
  end

  def delete(_name) do
    :ok
  end

  def increment_counter(_name, _value \\ 1) do
    :ok
  end

  def decrement_counter(_name, _value \\ -1) do
    :ok
  end

  def update_histogram(_name, _fn) do
    :ok
  end

  def updage_gauge(_name, _value) do
    :ok
  end

  def update_meter(_name, _value) do
    :ok
  end
end
