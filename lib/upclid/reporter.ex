defmodule Upclid.Reporter do
  use GenServer
  require Logger

  def init(args) do
    schedule(:report, 5)
    {:ok, args}
  end

  def start_link(_) do
    config = %{
      "hostname" => System.cmd("hostname", ["-f"]) |> elem(0) |> String.trim(),
      "url" => Application.get_env(:upclid, :url, "http://upman:4000/api"),
      "every" => Application.get_env(:upclid, :every, 600)
    }
    Logger.info("initialized with " <> inspect(config))
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def handle_info(:report, state) do
    schedule :report, state["every"]
    report Upclid.Collector.collect(), state["hostname"], state["url"]
    clearance state["hostname"], state["url"]
    {:noreply, state}
  end

  def schedule(msg, seconds) do
    Process.send_after(self(), msg, seconds * 1000)
  end

  def report(data, name, url) do
    {:ok, _} = HTTPoison.post "#{url}/server/#{name}",
      Poison.encode!(data),
      [{"Content-Type", "application/json"}]
  end

  def clearance(name, url) do
    clearances = HTTPoison.get!("#{url}/clearance/#{name}")
    |> Map.get(:body)
    |> Poison.decode!()

    clearances
    |> inspect()
    |> Logger.info()

    if Map.get(clearances, "update", "false") == "true" do
      Logger.info "update authorized"
      Upclid.Action.update()
    end
    upkg = Map.get(clearances, "unlock", "")
    if upkg != "" do
      Logger.info("unlock authorized: " <> upkg)
      Upclid.Action.unlock(upkg)
    end
    lpkg = Map.get(clearances, "lock", "")
    if lpkg != "" do
      Logger.info("lock authorized: " <> lpkg)
      Upclid.Action.lock(lpkg)
    end
    if Map.get(clearances, "reboot", "false") == "true" do
      Logger.info "reboot authorized"
      Upclid.Action.reboot()
    end

  end


end
