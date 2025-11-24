defmodule ElixirSense.Log do
  @moduledoc """
  A simple logger for the project that allows it to be muted via application config
  """
  require Logger

  def enabled? do
    Application.get_env(:elixir_sense, :logging_enabled, true)
  end

  defmacro info(message) do
    quote do
      require Logger

      if ElixirSense.Log.enabled?() do
        Logger.info(unquote(message))
      end
    end
  end

  defmacro warn(message) do
    quote do
      require Logger

      if ElixirSense.Log.enabled?() do
        Logger.warning(unquote(message))
      end
    end
  end

  defmacro error(message) when is_binary(message) do
    quote do
      require Logger

      if ElixirSense.Log.enabled?() do
        Logger.error(unquote(message))
      end
    end
  end

  @doc """
  Times the execution of a function and logs the duration with a descriptive label.

  ## Examples

      ElixirSense.Log.time("database query", fn -> fetch_users() end)
    
  """
  def time(label, fun) when is_function(fun, 0) do
    start_time = System.monotonic_time(:microsecond)
    result = fun.()
    end_time = System.monotonic_time(:microsecond)
    duration = end_time - start_time
  
    formatted_duration = format_duration(duration)
    info("⏱️  #{label}: #{formatted_duration}")
  
    result
  end

  # Format duration with appropriate units
  defp format_duration(microseconds) when microseconds < 1000, do: "#{microseconds}μs"
  defp format_duration(microseconds) when microseconds < 1_000_000 do
    ms = Float.round(microseconds / 1000, 2)
    "#{ms}ms"
  end
  defp format_duration(microseconds) do
    s = Float.round(microseconds / 1_000_000, 3)
    "#{s}s"
  end
end
