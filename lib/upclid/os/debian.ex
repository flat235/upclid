defmodule Upclid.Os.Debian do
  use Upclid.Collector
  use Upclid.Action

  # Collector implementation

  def updates() do
    System.cmd("apt-get", ["-s", "dist-upgrade"])
    |> elem(0)
    |> String.split("\n")
    |> Enum.filter(fn(x) -> String.starts_with?(x, "Inst") end)
    |> Enum.map(fn(x) -> String.replace_leading(x, "Inst ", "") end)
    |> Enum.map(fn(x) -> debian_helper(x) end)
  end

  defp debian_helper(s) do
    current = if String.match?(s, ~r/\] \(/) do
      String.split(s, ~r/\[|\]/) |> List.pop_at(1) |> elem(0)
    else
      "-"
    end
    %{
      "package" => String.split(s) |> List.first(),
      "current" => current,
      "new" => String.split(s, ~r/\(|\)/) |> List.pop_at(1) |> elem(0)
    }
  end

  def locked() do
    System.cmd("apt-mark", ["showhold"])
    |> elem(0)
    |> String.split("\n")
    |> Enum.filter(fn (line) -> line != "" end)
  end

  def reboot_needed() do
    File.exists?("/var/run/reboot-required")
  end

  # Action implementation

  def do_update do
    System.cmd("sudo", ["apt-get", "-y", "-o", "Dpkg::Options::=\"--force-confdef\"", "-o", "Dpkg::Options::=\"--force-confold\"" ,"dist-upgrade"])
  end

  def do_lock(pkg) do
    System.cmd("sudo", ["apt-mark", "hold", pkg])
  end

  def do_unlock(pkg) do
    System.cmd("sudo", ["apt-mark", "unhold", pkg])
  end
end
