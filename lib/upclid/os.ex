defmodule Upclid.Os do

  def osdetect do
    if not File.exists?("/etc/os-release") do
      {:error, "/etc/os-release not found"}
    else
      File.read!("/etc/os-release")
      |> String.split("\n")
      |> Enum.filter(fn (line) -> line != "" end)
      |> Enum.map(fn (line) -> String.split(line, "=") end)
      |> Enum.map(fn ([key, val]) -> %{String.downcase(key) => String.replace(val, "\"", "")} end)
      |> Enum.reduce(fn(cur, acc) -> Map.merge(acc, cur) end)
    end
  end

  def impl_for_os!(os) do
    case os do
      "debian" -> Upclid.Os.Debian
      "ubuntu" -> Upclid.Os.Debian
      "centos" -> Upclid.Os.CentOS
      _ -> throw({:error, "no implementation for #{os}"})
    end
  end
end
