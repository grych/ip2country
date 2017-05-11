
defmodule IP2Country.Converters do
  @moduledoc false

  # very basic check! only for pasing dbip file
  @doc false
  def is_ipv4?(line) do
    [ip1, _, _] = line
    String.contains?(ip1, ".") # && String.contains?(ip2, ".")
  end

  @doc false
  def decode_line(line) do
    line 
      |> String.trim() 
      |> String.split(",") 
      |> Enum.map(&String.trim(&1, "\""))
  end

  # converts ip list to the corresponding integer
  # 192.168.1.1 == 256*256*256*192 + 256*256*168 + 256*1 + 1
  @doc false
  def ip2integer(ip), do: do_ip2integer(3, ip_components(ip))

  defp do_ip2integer(0, [segment]), do: segment
  defp do_ip2integer(exponent, [segment | rest]) do
    powa(256, exponent) * segment + do_ip2integer(exponent - 1, rest)
  end

  # stupid, but fast ;)
  defp powa(_, 0), do: 1
  defp powa(256, 1), do: 256
  defp powa(256, 2), do: 65536
  defp powa(256, 3), do: 16777216

  defp ip_components(ip), do: String.split(ip, ".") |> Enum.map(&String.to_integer(&1))
end
