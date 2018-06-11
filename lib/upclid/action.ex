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
end
