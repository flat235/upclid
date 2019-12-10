defmodule Upclid.Os.CentOS do
  use Upclid.Collector
  use Upclid.Action

  # Collector implementation

  def updates() do
    System.cmd("yum", ["list", "updates", "-q"])
    |> elem(0)
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.filter(fn (line) -> line != "" end)
    |> Enum.map(fn (line) -> String.split(line) end)
    |> Enum.map(fn ([pkg, version, _repo]) -> %{"package" => String.split(pkg, ".") |> List.first(), "new" => version, "current" => "?"} end)
  end

  def reboot_needed() do
    if not File.exists?("/usr/bin/needs-restarting") do
      throw {:error, "needs-restarting executable not found"}
    else
      System.cmd("needs-restarting", ["-r"]) |> elem(1) != 0
    end
  end

  def locked() do
    if not File.exists?("/etc/yum/pluginconf.d/versionlock.list") do
      []
    else
      File.read!("/etc/yum/pluginconf.d/versionlock.list")
      |> String.split("\n")
      |> Enum.filter(fn (line) -> not String.starts_with?(line, "#") end)
      |> Enum.filter(fn (line) -> line != "" end)
    end
  end

  # Action implementation

  def do_update do
    :os.cmd('sudo yum -y update')
  end

  def do_lock(pkg) do
    System.cmd("sudo", ["yum", "versionlock", "add", pkg])
  end

  def do_unlock(pkg) do
    System.cmd("sudo", ["yum", "versionlock", "delete", pkg])
  end
end
