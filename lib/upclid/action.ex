defmodule Upclid.Action do

  defmacro __using__(_) do
    quote([]) do
      @behaviour Upclid.Action
      def do_reboot(), do: System.cmd("sudo", ["systemctl", "reboot"])
      defoverridable([do_reboot: 0])
    end
  end

  @callback do_reboot() :: {Collectable.t, non_neg_integer()}
  @callback do_update() :: {Collectable.t, non_neg_integer()}
  @callback do_lock(String.t) :: {Collectable.t, non_neg_integer()}
  @callback do_unlock(String.t) :: {Collectable.t, non_neg_integer()}

  def reboot do
    os = Upclid.Os.osdetect()
    os_impl = Upclid.Os.impl_for_os! os["id"]
    os_impl.do_reboot
  end

  def update do
    os = Upclid.Os.osdetect()
    os_impl = Upclid.Os.impl_for_os! os["id"]
    os_impl.do_update
  end

  def lock(pkg) do
    os = Upclid.Os.osdetect()
    os_impl = Upclid.Os.impl_for_os! os["id"]
    os_impl.do_lock pkg
  end

  def unlock(pkg) do
    os = Upclid.Os.osdetect()
    os_impl = Upclid.Os.impl_for_os! os["id"]
    os_impl.do_unlock pkg
  end
end
