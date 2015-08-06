defmodule Phoenix.Endpoint.Metrics do
    @moduledoc """
    A plug for tracking basic request metrics

    To use it, just plug it into the desired module.

    plug Phoenix.Endpoint.Metrics
    """

    @behaviour Plug

    def init(_opts) do
      get_metrics_module()
    end

    def call(conn, mod) do
      mod.increment_counter([:phoenix, :total_requests]) 
      mod.increment_counter([:phoenix, :running_requests]) 
      mod.increment_counter([:phoenix, :request, conn.method, conn.request_path]) 

      before_time = :os.timestamp()

      conn
      |> Conn.register_before_send(fn conn ->
        after_time = :os.timestamp()
        diff = :timer.now_diff(after_time, before_time) div 1000

        mod.update_histogram([:phoenix, :request_time, conn.method, conn.request_pat], diff)
        mod.decrement_counter([:phoenix, :request, conn.method, conn.request_path]) 
        mod.decrement_counter([:phoenix, :running_requests]) 
        mod.increment_counter([:phoenix, :finished_requests]) 
        conn
      end)
    end
  end

  def get_metrics_module() do
      case Application.get_env(:phoenix, :mod_metrics) do
        {:ok, :exometer} -> Phoenix.Metrics.Exometer,
        {:ok, mod} -> mod
        _ -> Phoenix.Metrics.DummyMetrics
      end
  end
end
