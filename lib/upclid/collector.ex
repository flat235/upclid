defmodule Upclid.Collector do

  defmacro __using__(_) do
    quote([]) do
      @behaviour Upclid.Collector
      def customfacts(), do: []
      defoverridable [customfacts: 0]
    end
  end

  @callback updates() :: [%{package: String.t, current: String.t, new: String.t}]
  @callback locked() :: [String.t]
  @callback reboot_needed() :: true | false
  @callback customfacts() :: [Map.t]

  def collect do
    os = Upclid.Os.osdetect()
    os_impl = Upclid.Os.impl_for_os! os["id"]
    %{
      "os" => os,
      "updates" => os_impl.updates(),
      "locked" => os_impl.locked(),
      "customfacts" => os_impl.customfacts(),
      "reboot_needed" => os_impl.reboot_needed()
    }
  end
end
