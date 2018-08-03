defmodule IP2Country do
  @moduledoc """
  IP2Country is a simple geolocating module (IP -> Country Code) with built-in database.

  Database is provided by https://db-ip.com, and it is compiled into the module. Compilation time is about
  20 seconds on 2-core machine. Searching time is about 4µs.

  To update the database, download it from https://db-ip.com/db/download/country, unzip and replace the file
  located in `lib/db`.
  """

  @db "db/dbip-country.csv.gz"
  @external_resource @db

  import IP2Country.Converters

  IO.puts "Compiling DBIP database, please be patient"
  dbip_list = File.stream!(Path.join([__DIR__, @db]), [:compressed], :line)
      |> Stream.filter(&String.contains?(&1, ".")) # check if it is a line with IPv4
      |> Stream.map(&decode_line/1)
      |> Stream.map(fn [ip1, ip2, country] -> {ip2integer(ip1), ip2integer(ip2), String.to_atom(country)} end)
      |> Enum.sort()
      |> List.to_tuple
  @dbip_list dbip_list

  @doc """
  Retrieves country code based on the IP address.

  Expects string with a proper IP as an argument. Currently works only with IPv4.

  Returns atom with the Country Code, uppercased, or `:ZZ` for private addresses.

  ## Examples

      iex> IP2Country.whereis("51.254.116.38")
      :FR

      iex> IP2Country.whereis("176.9.20.99")
      :DE

      iex> IP2Country.whereis("83.144.118.166")
      :PL

      iex> IP2Country.whereis("0.0.0.0")
      :ZZ

      iex> IP2Country.whereis("255.255.255.255")
      :ZZ

      iex> IP2Country.whereis("148.81.83.81")
      :PL
  """
  @spec whereis(String.t) :: atom
  def whereis(ip) when is_binary(ip) do
    ipint = ip2integer(ip)
    # {_, country} = Enum.find(@dbip_list, fn {ip2, _} -> ipint <= ip2 end)
    t = @dbip_list
    {:ok, country} = bsearch(ipint, t, 0, tuple_size(t))
    country
  end

  def whereis({a, b, c, d}) do
    whereis("#{a}.#{b}.#{c}.#{d}")
  end

  # bsearch borrowed from microcrawler:
  # https://github.com/ApolloCrawler/microcrawler-webapp/blob/master/lib/microcrawler_webapp/ip_info.ex
  defp bsearch(ip, ranges, low, high) do
    mid = div(low + high, 2)
    {start, stop, code} = elem(ranges, mid)
    case {ip >= start, ip <= stop} do
      {true, true}  -> {:ok, code}
      {true, false} -> bsearch(ip, ranges, mid + 1, high)
      {false, true} -> bsearch(ip, ranges, low, mid - 1)
    end
  end

end
